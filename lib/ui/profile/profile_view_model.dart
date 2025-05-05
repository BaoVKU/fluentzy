import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  User? get user => _authRepository.user;
  
  ProfileViewModel(this._authRepository) {
    _authRepository.setAuthStateListener((user) {
      if (user != null) {
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
