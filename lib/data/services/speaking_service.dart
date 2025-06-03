import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentzy/data/models/speaking_lesson.dart';

class SpeakingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<SpeakingLesson>> fetchLessons() async {
    final snapshot = await _db.collection('speak_lessons').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return SpeakingLesson.fromJson(data);
    }).toList();
  }

  Future<SpeakingLesson?> fetchSpeakingLessonById(String id) async {
    final docSnapshot = await _db.collection('speak_lessons').doc(id).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id;
        return SpeakingLesson.fromJson(data);
      }
    }

    return null;
  }
}
