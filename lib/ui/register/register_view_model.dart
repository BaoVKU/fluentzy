import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/extensions/string_ext.dart';
import 'package:flutter/foundation.dart';

class RegisterViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isSignedUp = false;
  bool get isSignedUp => _isSignedUp;
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RegisterViewModel(this._authRepository) {
    _authRepository.setAuthStateListener((user) {
      if (user != null) {
        _isSignedUp = true;
        notifyListeners();
      } else {
        _isSignedUp = false;
        notifyListeners();
      }
    });
  }

  Future<void> register(String email, String password) async {
    final result = await _authRepository.registerByEmail(
      email: email,
      password: password,
    );
    if (result != "success") {
      _errorMessage = result.getAuthErrorMessage();
      notifyListeners();
    }
  }
}
