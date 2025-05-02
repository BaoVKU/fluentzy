import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/services/speaking_service.dart';

class LessonRepository {
  final SpeakingService _speakingService;
  LessonRepository(this._speakingService);

  Future<List<SpeakingLesson>> fetchSpeakingLessons() async {
    return await _speakingService.fetchLessons();
  }

  Future<SpeakingLesson?> fetchSpeakingLessonById(String id) async {
    return await _speakingService.fetchSpeakingLessonById(id);
  }

  Future<void> updateSpeakingLessonLastDone({
    required String id,
    required int newIndex,
  }) async {
    await _speakingService.updateSpeakingLessonLastDone(
      id: id,
      newIndex: newIndex,
    );
  }
}
