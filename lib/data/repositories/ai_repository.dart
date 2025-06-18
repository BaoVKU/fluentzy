import 'dart:convert';

import 'package:fluentzy/data/models/chat_message.dart';
import 'package:fluentzy/data/models/flash_card.dart';
import 'package:fluentzy/data/models/speaking_response.dart';
import 'package:fluentzy/data/services/ai_service.dart';
import 'package:fluentzy/data/services/preference_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:language_code/language_code.dart';

class AiRepository {
  final PreferenceService _preferenceService;
  final AiService _aiService;

  AiRepository(this._preferenceService, this._aiService);

  Future<SpeakingResponse?> checkPronunciation({
    required said,
    required actual,
  }) async {
    final languageCode = _preferenceService.fetchAppLanguageCode();
    final language = LanguageCodes.fromCode(languageCode).englishName;

    GenerateContentResponse response = await _aiService.checkPronunciation(
      said: said,
      actual: actual,
      language: language,
    );

    if (response.text == null) {
      return null;
    }
    Logger.error("Response: ${response.text}");

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
    Logger.error("Response: ${response.text}");

    final Map<String, dynamic> jsonMap = json.decode(response.text!);

    return jsonMap['name'];
  }

  void startChatSession(List<ChatMessage>? messages) {
    final List<Content>? history;
    if (messages != null && messages.isNotEmpty) {
      history =
          messages.map((message) {
            return Content.text(message.text);
          }).toList();
    } else {
      history = null;
    }
    _aiService.startChatSession(history);
  }

  void endChatSession() {
    _aiService.endChatSession();
  }

  Future<String?> sendMessage({required String text}) async {
    GenerateContentResponse response = await _aiService.sendMessage(text: text);

    if (response.text == null) {
      return null;
    }

    return response.text;
  }

  Future<List<FlashCard>> suggestFlashCards({required String topic}) async {
    final languageCode = _preferenceService.fetchAppLanguageCode();
    final language = LanguageCodes.fromCode(languageCode).englishName;

    GenerateContentResponse response = await _aiService.suggestFlashCards(
      topic: topic,
      language: language,
    );

    if (response.text == null) {
      return [];
    }

    final List<dynamic> jsonList = json.decode(response.text!);
    return jsonList.map((json) => FlashCard.fromJson(json)).toList();
  }
}
