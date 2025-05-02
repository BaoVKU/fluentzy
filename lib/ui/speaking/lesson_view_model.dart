import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';

class LessonViewModel extends ChangeNotifier {
  LessonRepository _lessonRepository;
  List<SpeakingLesson> _lessons = [];
  List<SpeakingLesson> get lessons => _lessons;
  LessonViewModel(this._lessonRepository){
    fetchLessons();
  }

  void fetchLessons() async {
    _lessons = await _lessonRepository.fetchSpeakingLessons();
    for (var lesson in _lessons) {
      Logger.error(lesson.id);
    }
    notifyListeners();
  }
}
