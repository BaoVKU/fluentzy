import 'package:flutter/animation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    _config();
  }

  Future<void> _config() async {
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  Future<void> playSpeaker({
    required String text,
    required String localeId,
  }) async {
    await _tts.setLanguage(localeId);
    await _tts.speak(text);
  }

  Future<void> stopSpeaker() async => await _tts.stop();

  void setOnSpeakFinished(VoidCallback onCompletion) {
    _tts.setCompletionHandler(onCompletion);
  }
}
