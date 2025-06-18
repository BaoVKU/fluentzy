import 'package:fluentzy/data/models/app_user.dart';
import 'package:fluentzy/data/repositories/auth_repository.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:flutter/material.dart';
import 'package:language_code/language_code.dart';

class ProfileViewModel extends ChangeNotifier {
  final PreferenceService _preferenceService;
  final AuthRepository _authRepository;
  AppUser? get user => _authRepository.user;
  String? _currentLanguageName;
  String? get currentLanguageName => _currentLanguageName;

  ProfileViewModel(this._preferenceService, this._authRepository) {
    _initCurrentLanguage();
    _authRepository.setAuthStateListener((user) {
      if (user != null) {
        notifyListeners();
      } else {
        notifyListeners();
      }
    });
  }

  Future<void> _initCurrentLanguage() async {
    final languageCode = _preferenceService.fetchAppLanguageCode();
    _currentLanguageName = LanguageCodes.fromCode(languageCode).nativeName;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authRepository.logout();
  }

  Future<void> updateUserName(String newName) async {
    await _authRepository.updateUserName(newName);
    notifyListeners();
  }
}
