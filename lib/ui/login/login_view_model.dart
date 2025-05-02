import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  LoginViewModel(this._authRepository) {
    _authRepository.setAuthStateListener((user) {
      if (user != null) {
        _isLoggedIn = true;
        notifyListeners();
      } else {
        _isLoggedIn = false;
        notifyListeners();
      }
    });
  }

  void login(String email, String password) async {
    await _authRepository.loginByEmail(
      email: email,
      password: password,
    );
    notifyListeners();
  }
}
