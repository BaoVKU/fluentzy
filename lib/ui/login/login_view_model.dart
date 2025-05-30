import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/extensions/string_ext.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

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

  Future<void> login(String email, String password) async {
    final result = await _authRepository.loginByEmail(
      email: email,
      password: password,
    );
    if (result != "success") {
      _errorMessage = result.getAuthErrorMessage();
      notifyListeners();
    }
  }
}
