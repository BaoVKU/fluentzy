import 'package:fluentzy/utils/logger.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _speechToText = SpeechToText();

  SttService() {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    await _speechToText.initialize(
      onStatus: (status) => Logger.error("STT status: $status"),
      onError: (error) => Logger.error("STT error: $error"),
    );
  }

  Future<void> startRecording({
    String localeId = "en_US",
    required void Function(SpeechRecognitionResult) onSpeechResult,
  }) async {
    await _speechToText.listen(
      onResult: onSpeechResult,
      localeId: localeId,
      listenFor: Duration(seconds: 5),
    );
  }

  Future<void> stopRecording() async {
    await _speechToText.stop();
  }

  Future<void> dispose() async {
    await _speechToText.stop();
    await _speechToText.cancel();
  }
}
