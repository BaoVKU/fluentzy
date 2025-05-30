import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:flutter/foundation.dart';

class SpeakingLessonViewModel extends ChangeNotifier {
  final LessonRepository _lessonRepository;

  List<SpeakingLesson> _lessons = [];
  List<SpeakingLesson> get lessons => _lessons;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SpeakingLessonViewModel(this._lessonRepository) {
    _fetchLessons();
  }

  void _fetchLessons() async {
    _isLoading = true;
    notifyListeners();
    _lessons = await _lessonRepository.fetchSpeakingLessons();
    _isLoading = false;
    notifyListeners();
  }
}
