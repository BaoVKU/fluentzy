import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentzy/data/models/app_user.dart';
import 'package:fluentzy/data/services/auth_service.dart';
import 'package:fluentzy/data/services/user_service.dart';

class AuthRepository {
  final AuthService _authService;

  final UserService _userService;
  AppUser? get user => _userService.currentUser;

  AuthRepository(this._authService, this._userService);

  Future<String> registerByEmail({required email, required password}) async {
    try {
      await _authService.registerByEmail(email: email, password: password);
      await _userService.createAppUser(_authService.user!);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> loginByEmail({required email, required password}) async {
    try {
      await _authService.loginByEmail(email: email, password: password);
      await _userService.fetchAppUser(_authService.user!.uid);
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<String> logout() async {
    try {
      await _authService.logout();
      _userService.dispose();
      return "success";
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  void setAuthStateListener(Function(User?) listener) {
    _authService.setAuthStateListener((user) {
      if (user != null) {
        _userService
            .fetchAppUser(user.uid)
            .then((_) {
              listener(user);
            })
            .catchError((error) {
              listener(null); // Handle error by notifying with null user
            });
      } else {
        listener(null); // Notify with null user if not authenticated
      }
    });
  }

  Future<void> updateUserName(String newName) async {
    if (_userService.currentUser != null) {
      await _userService.updateUserName(_userService.currentUser!.id, newName);
      await _userService.fetchAppUser(_userService.currentUser!.id);
    }
  }
}
