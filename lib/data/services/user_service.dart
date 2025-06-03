import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentzy/data/models/app_user.dart';
import 'package:fluentzy/data/models/quiz_progress.dart';
import 'package:fluentzy/data/models/speaking_progress.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  Future<String> createAppUser(User user) async {
    final userRef = _db.collection('users').doc(user.uid);
    final docRef = await userRef.get();
    if (!docRef.exists) {
      final appUser = AppUser(
        id: user.uid,
        name: user.displayName ?? 'New User',
        email: user.email ?? '',
        plan: 'free',
        nativeLangCode: 'vi',
      );

      await userRef.set(appUser.toJson());
      _currentUser = appUser;
      return appUser.id;
    } else {
      return '';
    }
  }

  Future<void> fetchAppUser(String userId) async {
    final docSnapshot = await _db.collection('users').doc(userId).get();
    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id; // Ensure the ID is included
        _currentUser = AppUser.fromJson(data);
      }
    }
  }

  Future<void> updateUserName(String userId, String newName) async {
    final userRef = _db.collection('users').doc(userId);

    try {
      await userRef.update({'name': newName});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updatePlanById(String userId, String newPlan) async {
    final userRef = _db.collection('users').doc(userId);

    try {
      await userRef.update({'plan': newPlan});
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveSpeakingProgress({
    required String userId,
    required String lessonId,
    required int lastDoneIndex,
  }) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('speaking_progress')
        .doc(lessonId);

    try {
      await docRef.set({
        'lastDoneIndex': lastDoneIndex,
      }, SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveQuizProgress({
    required String userId,
    required QuizProgress quizProgress,
  }) async {
    final docRef = _db
        .collection('users')
        .doc(userId)
        .collection('quiz_progress')
        .doc(quizProgress.quizId);

    try {
      await docRef.set(quizProgress.toJson(), SetOptions(merge: true));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<SpeakingProgress>> fetchSpeakingProgresses({
    required String userId,
  }) async {
    final snapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('speaking_progress')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['lessonId'] = doc.id; // Ensure the lessonId is included
      return SpeakingProgress.fromJson(data);
    }).toList();
  }

  Future<SpeakingProgress?> fetchSpeakingProgressById({
    required String userId,
    required String lessonId,
  }) async {
    final docSnapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('speaking_progress')
            .doc(lessonId)
            .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['lessonId'] = docSnapshot.id; // Ensure the lessonId is included
        return SpeakingProgress.fromJson(data);
      }
    }
    return null;
  }

  Future<List<QuizProgress>> fetchQuizProgresses({
    required String userId,
  }) async {
    final snapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('quiz_progress')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['quizId'] = doc.id;
      return QuizProgress.fromJson(data);
    }).toList();
  }

  Future<QuizProgress?> fetchQuizProgressById({
    required String userId,
    required String quizId,
  }) async {
    final docSnapshot =
        await _db
            .collection('users')
            .doc(userId)
            .collection('quiz_progress')
            .doc(quizId)
            .get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['quizId'] = docSnapshot.id; // Ensure the quizId is included
        return QuizProgress.fromJson(data);
      }
    }
    return null;
  }

  void dispose() {
    _currentUser = null;
  }
}
