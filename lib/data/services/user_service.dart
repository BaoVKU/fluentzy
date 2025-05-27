import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentzy/data/models/app_user.dart';

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
        nativeLangCode: 'vi'
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

  Future<void> updatePlanById(String userId, String newPlan) async {
    final userRef = _db.collection('users').doc(userId);

    try {
      await userRef.update({'plan': newPlan});
    } catch (e) {
      rethrow;
    }
  }

  void dispose() {
    _currentUser = null;
  }
}