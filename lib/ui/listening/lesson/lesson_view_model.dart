import 'package:fluentzy/data/models/listening_lesson.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:flutter/material.dart';

class ListeningLessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  List<ListeningLesson> _lessons = [];
  List<ListeningLesson> get lessons => _lessons;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  ListeningLessonViewModel(this._lessonRepository) {
    _fetchLessons();
  }

  void _fetchLessons() async {
    _isLoading = true;
    notifyListeners();
    _lessons = await _lessonRepository.fetchListeningLessons();
    _isLoading = false;
    notifyListeners();
  }
}
