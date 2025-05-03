import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentzy/data/models/flash_card_set.dart';

class FlashCardService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<FlashCardSet>> fetchFlashCardSets() async {
    final snapshot = await _db.collection('flash_card_sets').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return FlashCardSet.fromJson(data);
    }).toList();
  }

  Future<FlashCardSet?> fetchFlashCardSetById(String id) async {
    final docSnapshot = await _db.collection('flash_card_sets').doc(id).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();
      if (data != null) {
        data['id'] = docSnapshot.id;
        return FlashCardSet.fromJson(data);
      }
    }
    return null;
  }

  Future<String> createFlashCardSet(FlashCardSet cardSet) async {
    final docRef = await _db.collection('flash_card_sets').add(cardSet.toJson());
    return docRef.id;
  }

  Future<String> updateFlashCardSet(FlashCardSet cardSet) async {
    await _db.collection('flash_card_sets').doc(cardSet.id).set(cardSet.toJson());
    return cardSet.id;
  }

  Future<void> deleteFlashCardSet(String id) async {
      await _db.collection('flash_card_sets').doc(id).delete();
  }
}
