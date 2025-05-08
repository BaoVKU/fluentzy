import 'package:fluentzy/data/models/speaking_lesson.dart';
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
  bool _hasFinalResult = false;
  bool get hasFinalResult => _hasFinalResult;
  String get listenedResult => _sttRepository.listenedResult;
  bool _isStoppedByUser = false;
  bool get isStoppedByUser => _isStoppedByUser;

  RecordViewModel(this._sttRepository, this._lessonRepository, this._lessonId) {
    _fetchLessonById(id: _lessonId);
  }
  void startRecording() async {
    _isStoppedByUser = false;
    await _sttRepository.startRecording(
      onFinalResult: (isFinal) {
        _hasFinalResult = isFinal;
        Logger.error("said: $listenedResult");
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void stopRecording() async {
    await _sttRepository.stopRecording();
    _isStoppedByUser = true;
    notifyListeners();
  }

  void _fetchLessonById({required id}) async {
    if (_lesson != null) return;
    _lesson = await _lessonRepository.fetchSpeakingLessonById(id);
    notifyListeners();
  }

  @override
  void dispose() {
    _sttRepository.dispose();
    super.dispose();
  }
}
