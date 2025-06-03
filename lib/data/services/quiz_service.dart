import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentzy/data/models/quiz_lesson.dart';

class QuizService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<QuizLesson>> fetchLessons() async {
    final snapshot = await _db.collection('quiz_lessons').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return QuizLesson.fromJson(data);
    }).toList();
  }

  Future<QuizLesson?> fetchQuizLessonById(String id) async {
    final docSnapshot = await _db.collection('quiz_lessons').doc(id).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id;
        return QuizLesson.fromJson(data);
      }
    }

    return null;
  }
}
