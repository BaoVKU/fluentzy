import 'package:fluentzy/data/services/tts_service.dart';

class TtsRepository {
  final TtsService _ttsService;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  TtsRepository(this._ttsService) {
    _ttsService.setOnSpeakFinished(() {
      _isSpeaking = false;
    });
  }

  Future<void> playSpeaker({
    required String text,
    String langCode = "en",
  }) async {
    _isSpeaking = true;
    final String localeId;
    switch (langCode) {
      case "en":
        localeId = "en-US";
        break;
      case "vi":
        localeId = "vi-VN";
        break;
      default:
        localeId = "en-US"; // Default to English if unsupported language
    }
    await _ttsService.playSpeaker(text: text, localeId: localeId);
  }

  Future<void> stopSpeaker() async {
    _isSpeaking = false;
    await _ttsService.stopSpeaker();
  }
}
