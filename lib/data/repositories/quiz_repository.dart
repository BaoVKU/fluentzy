import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

class QuizRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Quiz>> getQuizzes() async {
    try {
      final snapshot = await _firestore.collection('quizzes').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Quiz(
          question: data['question'] as String,
          options: List<String>.from(data['options']),
          correctOptionIndex: data['correctOptionIndex'] as int,
        );
      }).toList();
    } catch (e) {
      print('Error fetching quizzes: $e');
      return [];
    }
  }
}
