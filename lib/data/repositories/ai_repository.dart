import 'dart:convert';

import 'package:fluentzy/data/models/speaking_response.dart';
import 'package:fluentzy/data/services/ai_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:language_code/language_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiRepository {
  final AiService _aiService;
  AiRepository(this._aiService);

  Future<SpeakingResponse?> checkPronunciation({
    required said,
    required actual,
  }) async {
    final pref = await SharedPreferences.getInstance();
    final languageCode = pref.getString('language_code') ?? 'en';
    final language = LanguageCodes.fromCode(languageCode).englishName;

    GenerateContentResponse response = await _aiService.checkPronunciation(
      said: said,
      actual: actual,
      language: language,
    );

    if (response.text == null) {
      return null;
    }

    final Map<String, dynamic> jsonMap = json.decode(response.text!);

    return SpeakingResponse.fromJson(jsonMap);
  }

  Future<String?> detectObject(Uint8List imageBytes) async {
    GenerateContentResponse response = await _aiService.detectObject(
      imageBytes,
    );

    if (response.text == null) {
      return null;
    }

    final Map<String, dynamic> jsonMap = json.decode(response.text!);

    return jsonMap['name'];
  }
}
