import 'package:fluentzy/data/schemas/ai_response_schemas.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static const String _apiKey = "";
  late GenerativeModel _model;
  ChatSession? chatSession;

  AiService() {
    _init();
  }

  void _init() {
    _model = GenerativeModel(model: "gemini-1.5-flash", apiKey: _apiKey);
  }

  Future<GenerateContentResponse> checkPronunciation({
    required said,
    required actual,
    String language = "English",
  }) async {
    final prompt = '''
                Compare the pronunciation accuracy between:

                Target sentence/word: "$actual"
                User said: "$said"

                Give a percentage score, feedback in $language, and right ipa of that sentence/word.
          ''';

    final promptIterable = [Content.text(prompt.trim())];

    return await _model.generateContent(
      promptIterable,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: AiResponseSchemas.pronunciationChecking,
      ),
    );
  }

  Future<GenerateContentResponse> detectObject(Uint8List imageBytes) async {
    final prompt = TextPart(
      '''
                Detect the object at center of the image and give name of that object by English in ONLY ONE word excluding its brand.
          '''.trim(),
    );
    final image = DataPart('image/jpeg', imageBytes);
    final promptIterable = [
      Content.multi([prompt, image]),
    ];

    return await _model.generateContent(
      promptIterable,
      generationConfig: GenerationConfig(
        responseMimeType: "application/json",
        responseSchema: AiResponseSchemas.objectDetection,
      ),
    );
  }

  void startChatSession(List<Content>? history) {
    chatSession = _model.startChat(history: history);
  }

  void endChatSession() {
    chatSession = null;
  }

  Future<GenerateContentResponse> sendMessage({required String text}) async {
    if (chatSession == null) {
      throw Exception("Chat session is not started.");
    }

    final prompt = '''
              Prompt: $text
              Keep response simple, don't use markdown or code block but can use keyboard symbols like "-", "+", etc. for highlighting.
          ''';

    return await chatSession!.sendMessage(Content.text(prompt.trim()));
  }
}
