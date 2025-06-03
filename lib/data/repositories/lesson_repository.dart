import 'package:fluentzy/data/models/listening_lesson.dart';
import 'package:fluentzy/data/models/quiz_lesson.dart';
import 'package:fluentzy/data/models/quiz_progress.dart';
import 'package:fluentzy/data/models/speaking_lesson.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';
import 'package:fluentzy/data/services/listening_service.dart';
import 'package:fluentzy/data/services/quiz_service.dart';
import 'package:fluentzy/data/services/speaking_service.dart';
import 'package:fluentzy/data/services/user_service.dart';
import 'package:fluentzy/utils/logger.dart';

class LessonRepository {
  final UserService _userService;
  final SpeakingService _speakingService;
  final ListeningService _listeningService;
  final QuizService _quizService;

  LessonRepository(
    this._userService,
    this._speakingService,
    this._listeningService,
    this._quizService,
  );

  Future<List<SpeakingLesson>> fetchSpeakingLessons() async {
    return await _speakingService.fetchLessons();
  }

  Future<List<ListeningLesson>> fetchListeningLessons() async {
    return await _listeningService.fetchLessons();
  }

  Future<List<QuizLesson>> fetchQuizLessons() async {
    return await _quizService.fetchLessons();
  }

  Future<SpeakingLesson?> fetchSpeakingLessonById(String id) async {
    return await _speakingService.fetchSpeakingLessonById(id);
  }

  Future<ListeningLesson?> fetchListeningLessonById(String id) async {
    return await _listeningService.fetchListeningLessonById(id);
  }

  Future<QuizLesson?> fetchQuizLessonById(String id) async {
    return await _quizService.fetchQuizLessonById(id);
  }

  Future<bool> saveSpeakingProgress({
    required SpeakingProgress speakingProgress,
  }) async {
    try {
      await _userService.saveSpeakingProgress(
        userId: _userService.currentUser?.id ?? "",
        lessonId: speakingProgress.lessonId,
        lastDoneIndex: speakingProgress.lastDoneIndex,
      );
      return true;
    } catch (e) {
      Logger.error('Failed to save speaking progress: $e');
      return false;
    }
  }

  Future<bool> saveQuizProgress({required QuizProgress quizProgress}) async {
    try {
      await _userService.saveQuizProgress(
        userId: _userService.currentUser?.id ?? "",
        quizProgress: quizProgress,
      );
      return true;
    } catch (e) {
      Logger.error('Failed to save quiz progress $e');
      return false;
    }
  }

  Future<List<SpeakingProgress>> fetchSpeakingProgresses() async {
    try {
      return await _userService.fetchSpeakingProgresses(
        userId: _userService.currentUser?.id ?? "",
      );
    } catch (e) {
      Logger.error('Failed to get quiz progresses: $e');
      return [];
    }
  }

  Future<SpeakingProgress?> fetchSpeakingProgressById({
    required String lessonId,
  }) async {
    try {
      return await _userService.fetchSpeakingProgressById(
        userId: _userService.currentUser?.id ?? "",
        lessonId: lessonId,
      );
    } catch (e) {
      Logger.error('Failed to get quiz progress by id: $e');
      return null;
    }
  }

  Future<List<QuizProgress>> fetchQuizProgresses() async {
    try {
      return await _userService.fetchQuizProgresses(
        userId: _userService.currentUser?.id ?? "",
      );
    } catch (e) {
      Logger.error('Failed to get quiz progresses: $e');
      return [];
    }
  }

  Future<QuizProgress?> fetchQuizProgressById({required String quizId}) async {
    try {
      return await _userService.fetchQuizProgressById(
        userId: _userService.currentUser?.id ?? "",
        quizId: quizId,
      );
    } catch (e) {
      Logger.error('Failed to get quiz progress by id: $e');
      return null;
    }
  }
}
