import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentzy/data/models/listening_lesson.dart';

class ListeningService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ListeningLesson>> fetchLessons() async {
    final snapshot = await _db.collection('listen_lessons').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return ListeningLesson.fromJson(data);
    }).toList();
  }

  Future<ListeningLesson?> fetchListeningLessonById(String id) async {
    final docSnapshot = await _db.collection('listen_lessons').doc(id).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id;
        return ListeningLesson.fromJson(data);
      }
    }
    return null;
  }
}
