import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';
import 'package:fluentzy/data/models/speaking_response.dart';
import 'package:fluentzy/data/models/response_state.dart';
import 'package:fluentzy/data/repositories/ai_repository.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class SpeakingResultViewModel extends ChangeNotifier {
  final TtsRepository _ttsRepository;
  final AiRepository _aiRepository;
  final LessonRepository _lessonRepository;

  ResponseState _responseState = Initial();
  ResponseState get responseState => _responseState;

  late String sentence;
  late String lessonId;
  late SpeakingLesson _lesson;

  late SpeakingProgress _progress;
  SpeakingProgress get progress => _progress;

  SpeakingResultViewModel(
    this._ttsRepository,
    this._aiRepository,
    this._lessonRepository,
    _extra,
  ) {
    _lesson = _extra["lesson"];
    final String userSaid = _extra["said"];
    _progress = _extra["progress"];
    lessonId = _lesson.id;
    sentence = _lesson.sentences[_progress.lastDoneIndex + 1];
    _checkPronunciation(said: userSaid, actual: sentence);
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

  Future<void> speakOutLoud({required String text}) async {
    if (_ttsRepository.isSpeaking) {
      await _ttsRepository.stopSpeaker();
      notifyListeners();
      return;
    }
    await _ttsRepository.playSpeaker(text: text);
    notifyListeners();
  }
  
  Future<void> saveProgress(Function() onUpdated) async {
    await _lessonRepository.saveSpeakingProgress(
      speakingProgress: _progress.copy(
        newLastDoneIndex: _progress.lastDoneIndex + 1,
      ),
    );
    onUpdated();
  }
}
