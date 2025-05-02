import 'package:fluentzy/data/models/listening_lesson.dart';
import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/services/listening_service.dart';
import 'package:fluentzy/data/services/speaking_service.dart';

class LessonRepository {
  final SpeakingService _speakingService;
  final ListeningService _listeningService;
  LessonRepository(this._speakingService, this._listeningService);

  Future<List<SpeakingLesson>> fetchSpeakingLessons() async {
    return await _speakingService.fetchLessons();
  }

  Future<List<ListeningLesson>> fetchListeningLessons() async {
    return await _listeningService.fetchLessons();
  }

  Future<SpeakingLesson?> fetchSpeakingLessonById(String id) async {
    return await _speakingService.fetchSpeakingLessonById(id);
  }

  Future<ListeningLesson?> fetchListeningLessonById(String id) async {
    return await _listeningService.fetchListeningLessonById(id);
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
