import 'package:fluentzy/data/enums/support_language.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class LanguageViewModel extends ChangeNotifier {
  final PreferenceService _preferenceService;

  SupportLanguage _selectedLanguage = SupportLanguage.english;
  SupportLanguage get selectedLanguage => _selectedLanguage;

  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  LanguageViewModel(this._preferenceService) {
    _init();
  }

  void _init() async {
    await _preferenceService.initialize();
    final languageCode = _preferenceService.fetchAppLanguageCode();
    Logger.error("Fetched language code: $languageCode");
    _locale = Locale(languageCode);
    _selectedLanguage = SupportLanguage.values.firstWhere(
      (language) => language.languageCode.code == languageCode,
      orElse: () => SupportLanguage.english,
    );
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await _preferenceService.updateAppLanguageCode(locale.languageCode);
    notifyListeners();
  }

  void selectLanguage(SupportLanguage language) {
    _selectedLanguage = language;
    notifyListeners();
  }
}
