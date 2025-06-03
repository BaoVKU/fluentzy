import 'package:collection/collection.dart';
import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';

class SpeakingLessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  List<SpeakingLesson> _lessons = [];
  List<SpeakingLesson> get lessons => _lessons;

  List<SpeakingProgress> _progresses = [];
  List<SpeakingProgress> get progresses => _progresses;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SpeakingLessonViewModel(this._lessonRepository) {
    _fetchLessons();
  }

  void _fetchLessons() async {
    _isLoading = true;
    notifyListeners();
    _lessons = await _lessonRepository.fetchSpeakingLessons();
    _progresses = await _lessonRepository.fetchSpeakingProgresses();
    _isLoading = false;
    notifyListeners();
  }

  int getProgressPercent(SpeakingLesson ls) {
    SpeakingProgress? progress = _progresses.firstWhereOrNull(
      (p) => p.lessonId == ls.id,
    );
    if (progress == null || progress.lastDoneIndex < 0) return 0;
    Logger.error(
      "lastDoneIndex: ${progress.lastDoneIndex}, totalLessons: ${ls.sentences.length}",
    );
    Logger.error(
      "Progress percent: ${((progress.lastDoneIndex + 1) / ls.sentences.length * 100).round()}",
    );
    return ((progress.lastDoneIndex + 1) / ls.sentences.length * 100).round();
  }

  bool checkIfLessonCompleted(SpeakingLesson ls) {
    SpeakingProgress? progress = _progresses.firstWhereOrNull(
      (p) => p.lessonId == ls.id,
    );
    return progress != null &&
        progress.lastDoneIndex >= ls.sentences.length - 1;
  }
}
