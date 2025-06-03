import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class RecordViewModel extends ChangeNotifier {
  final String _lessonId;
  final SttRepository _sttRepository;
  final LessonRepository _lessonRepository;

  bool get isListening => _sttRepository.isListening;

  SpeakingLesson? _lesson;
  SpeakingLesson? get lesson => _lesson;

  SpeakingProgress? _progress;
  SpeakingProgress? get progress => _progress;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasFinalResult = false;
  bool get hasFinalResult => _hasFinalResult;

  String get listenedResult => _sttRepository.listenedResult;

  RecordViewModel(this._sttRepository, this._lessonRepository, this._lessonId) {
    _fetchLessonById(id: _lessonId);
  }

  void _fetchLessonById({required id}) async {
    if (_lesson != null) return;
    _isLoading = true;
    notifyListeners();
    _lesson = await _lessonRepository.fetchSpeakingLessonById(id);
    _progress = await _lessonRepository.fetchSpeakingProgressById(lessonId: id);
    if (progress == null) {
      _progress = SpeakingProgress(lessonId: id, lastDoneIndex: -1);
    }
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _sttRepository.dispose();
    super.dispose();
  }

  void startRecording() async {
    await _sttRepository.startRecording(
      onFinalResult: (isFinal) {
        _hasFinalResult = isFinal;
        Logger.error("said: $listenedResult");
        notifyListeners();
      },
      onTimeout: () {
        _hasFinalResult = false;
        Logger.error("Recording timed out");
        stopRecording();
      },
    );
    notifyListeners();
  }

  void stopRecording() async {
    await _sttRepository.stopRecording();
    notifyListeners();
  }
}
