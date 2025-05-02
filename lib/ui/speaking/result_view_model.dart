import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_response.dart';
import 'package:fluentzy/data/models/response_state.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class ResultViewModel extends ChangeNotifier {
  final TtsRepository _ttsRepository;
  final AiRepository _aiRepository;
  final LessonRepository  _lessonRepository;
  bool get isSpeaking => _ttsRepository.isSpeaking;
  ResponseState _responseState = Initial();
  ResponseState get responseState => _responseState;
  late String sentence;
  late String lessonId;
  late int lastDone;
  late SpeakingLesson _lesson;
  ResultViewModel(this._ttsRepository, this._aiRepository, this._lessonRepository,_extra) {
    _lesson = _extra["lesson"];
    final String userSaid = _extra["said"];
    lessonId = _lesson.id;
    lastDone = _lesson.lastDone;
    sentence = _lesson.sentences[lastDone + 1];
    _checkPronunciation(said: userSaid, actual: sentence);
  }

  Future<void> playSpeaker({required String text}) async {
    await _ttsRepository.playSpeaker(text: text);
    notifyListeners();
  }

  Future<void> stopSpeaker() async {
    await _ttsRepository.stopSpeaker();
    notifyListeners();
  }

  Future<void> _checkPronunciation({required said, required actual}) async {
    _responseState = Loading();
    SpeakingResponse? res = await _aiRepository.checkPronunciation(
      said: said,
      actual: actual,
    );
    if (res != null) {
      _responseState = Success(res);
    } else {
      _responseState = Error("Error occurred while checking pronunciation.");
    }
    if (_responseState is Success) {
      final successState = _responseState as Success;
      final data = successState.data as SpeakingResponse;
      Logger.errorWithTag(
        "ResultViewModel",
        "Rate: ${data.rate}% - Feedback: ${data.feedback} - ipa: ${data.ipa}",
      );
    }
    notifyListeners();
  }

  Future<void> increaseLastDone(Function() onLastDoneUpdated) async {
    // Logger.error("increaseLastDone: ${_lesson.id} ${_lesson.lastDone} ${_lesson.sentences}");
    await _lessonRepository.updateSpeakingLessonLastDone(id: lessonId, newIndex: _lesson.lastDone + 1);
    onLastDoneUpdated();
    notifyListeners();
  }
}
