import 'package:fluentzy/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  late final SharedPreferences _sharedPreferences;

  Future<void> initialize() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<bool> updateAppLanguageCode(String languageCode) async {
    try {
      return await _sharedPreferences.setString('language_code', languageCode);
    } catch (e) {
      Logger.error('Error updating language code: $e');
      return false;
    }
  }

  String fetchAppLanguageCode() {
    try {
      return _sharedPreferences.getString('language_code') ?? 'en';
    } catch (e) {
      Logger.error('Error fetching language code: $e');
      return 'en'; // Default to English if there's an error
    }
  }

  Future<bool> updateLastActiveDateStr(String dateStr) async {
    try {
      return await _sharedPreferences.setString(
        'last_active_date',
        dateStr,
      );
    } catch (e) {
      Logger.error('Error updating last active date: $e');
      return false;
    }
  }

  String fetchLastActiveDateStr() {
    try {
      return _sharedPreferences.getString('last_active_date') ?? '';
    } catch (e) {
      Logger.error('Error fetching last active date: $e');
      return ''; // Default to empty string if there's an error
    }
  }

  Future<bool> updateLastTipIndex(int index) async {
    try {
      return await _sharedPreferences.setInt('last_tip_index', index);
    } catch (e) {
      Logger.error('Error updating last tip quote index: $e');
      return false;
    }
  }

  int fetchLastTipIndex() {
    try {
      return _sharedPreferences.getInt('last_tip_index') ?? 0;
    } catch (e) {
      Logger.error('Error fetching last tip quote index: $e');
      return 0; // Default to 0 if there's an error
    }
  }
}
