import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentzy/data/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  User? get user => _authService.user;
  AuthRepository(this._authService);
  Future<String> registerByEmail({required email, required password}) async {
    try {
      await _authService.registerByEmail(
        email: email,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> loginByEmail({required email, required password}) async {
    try {
      await _authService.loginByEmail(email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> logout() async {
    try {
      await _authService.logout();
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  void setAuthStateListener(Function(User?) listener) {
    _authService.setAuthStateListener(listener);
  }
}
