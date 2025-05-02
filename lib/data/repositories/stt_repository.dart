import 'package:fluentzy/data/services/stt_service.dart';

class SttRepository {
  final SttService _sttService;
  bool _isListening = false;
  bool get isListening => _isListening;
  String _listenedResult = "";
  String get listenedResult => _listenedResult;

  SttRepository(this._sttService);

  Future<void> startRecording({
    required void Function(bool) onFinalResult,
  }) async {
    if (_isListening) return;
    _isListening = true;
    _listenedResult = "";
    await _sttService.startRecording(
      onSpeechResult: (result) {
        if (result.finalResult) {
          _listenedResult = result.recognizedWords;
          _isListening = false;
          onFinalResult(true);
        }
      },
    );
  }

  Future<void> stopRecording() async {
    if (!_isListening) return;
    _isListening = false;
    await _sttService.stopRecording();
  }
}
