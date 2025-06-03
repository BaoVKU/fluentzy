import 'package:fluentzy/data/models/quiz_lesson.dart';
import 'package:fluentzy/data/models/quiz_progress.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class QuizLessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  List<QuizLesson> _lessons = [];
  List<QuizLesson> get lessons => _lessons;

  List<QuizProgress> _progresses = [];
  List<QuizProgress> get progresses => _progresses;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  QuizLessonViewModel(this._lessonRepository) {
    _fetchLessons();
  }

  void _fetchLessons() async {
    _isLoading = true;
    notifyListeners();
    _lessons = await _lessonRepository.fetchQuizLessons();
    _progresses = await _lessonRepository.fetchQuizProgresses();
    _isLoading = false;
    notifyListeners();
  }

  int getAccuracyPercent(String id) {
    final progress = _progresses.firstWhereOrNull((p) => p.quizId == id);
    if (progress == null || progress.answers.isEmpty) return 0;
    final correctCount = progress.answers.where((a) => a.values.first).length;
    return ((correctCount / progress.answers.length) * 100).round();
  }
}
