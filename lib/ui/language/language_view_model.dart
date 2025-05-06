import 'package:fluentzy/data/enums/support_language.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageViewModel extends ChangeNotifier {
  SharedPreferences? pref;
  SupportLanguage _selectedLanguage = SupportLanguage.english;
  SupportLanguage get selectedLanguage => _selectedLanguage;
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LanguageViewModel() {
    init();
  }

  void init() async {
    pref = await SharedPreferences.getInstance();
    final languageCode = pref?.getString('language_code') ?? 'en';
    _locale = Locale(languageCode);
    _selectedLanguage = SupportLanguage.values.firstWhere(
      (language) => language.languageCode.code == languageCode,
      orElse: () => SupportLanguage.english,
    );
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    pref?.setString('language_code', locale.languageCode);
    notifyListeners();
  }

  void selectLanguage(SupportLanguage language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
