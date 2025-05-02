import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';

class SpeakingLessonViewModel extends ChangeNotifier {
  LessonRepository _lessonRepository;
  List<SpeakingLesson> _lessons = [];
  List<SpeakingLesson> get lessons => _lessons;
  SpeakingLessonViewModel(this._lessonRepository) {
    _fetchLessons();
  }

  void _fetchLessons() async {
    _lessons = await _lessonRepository.fetchSpeakingLessons();
    for (var lesson in _lessons) {
      Logger.error(lesson.id);
    }
    notifyListeners();
  }
}
