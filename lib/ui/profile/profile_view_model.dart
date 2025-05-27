import 'package:fluentzy/data/models/app_user.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:language_code/language_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  AppUser? get user => _authRepository.user;
  String? _currentLanguageName;
  String? get currentLanguageName => _currentLanguageName;

  ProfileViewModel(this._authRepository) {
    _initCurrentLanguage();
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

  Future<void> _initCurrentLanguage() async {
    final pref = await SharedPreferences.getInstance();
    final languageCode = pref.getString('language_code') ?? 'en';
    _currentLanguageName = LanguageCodes.fromCode(languageCode).nativeName;
    notifyListeners();
  }
}
