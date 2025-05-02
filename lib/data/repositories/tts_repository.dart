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

  Future<void> playSpeaker({required String text}) async {
    _isSpeaking = true;
    await _ttsService.playSpeaker(text: text);
  }

  Future<void> stopSpeaker() async {
    _isSpeaking = false;
    await _ttsService.stopSpeaker();
  }
}
