import 'package:fluentzy/data/models/listening_lesson.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class ListeningLessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;
  List<ListeningLesson> _lessons = [];
  List<ListeningLesson> get lessons => _lessons;
  ListeningLessonViewModel(this._lessonRepository){
    _fetchLessons();
  }

  void _fetchLessons() async {
    _lessons = await _lessonRepository.fetchListeningLessons();
    for (var lesson in _lessons) {
      Logger.error(lesson.id);
    }
    notifyListeners();
  }
}
