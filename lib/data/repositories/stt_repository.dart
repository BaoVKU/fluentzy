import 'dart:async';
import 'package:fluentzy/data/services/stt_service.dart';

class SttRepository {
  final SttService _sttService;
  bool _isListening = false;
  bool get isListening => _isListening;
  String _listenedResult = "";
  String get listenedResult => _listenedResult;

  Timer? _timeoutTimer;

  SttRepository(this._sttService);

  Future<void> startRecording({
    required void Function(bool) onFinalResult,
    String langCode = "en",
    Function(String)? onResult,
    Function? onTimeout,
  }) async {
    if (_isListening) return;
    _isListening = true;
    _listenedResult = "";

    // Start timeout timer
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 6), () {
      if (_listenedResult.isEmpty) {
        _isListening = false;
        onTimeout?.call();
      }
    });

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

    await _sttService.startRecording(
      localeId: localeId,
      onSpeechResult: (result) {
        if (result.finalResult) {
          _listenedResult = result.recognizedWords;
          _isListening = false;
          _timeoutTimer?.cancel();
          onFinalResult(true);
        }
        onResult?.call(result.recognizedWords);
      },
    );
  }

  Future<void> stopRecording() async {
    if (!_isListening) return;
    _isListening = false;
    _timeoutTimer?.cancel();
    await _sttService.stopRecording();
  }

  Future<void> reset() async {
    _isListening = false;
    _listenedResult = "";
    _timeoutTimer?.cancel();
    await _sttService.dispose();
  }

  Future<void> dispose() async {
    _isListening = false;
    _listenedResult = "";
    _timeoutTimer?.cancel();
    await _sttService.dispose();
  }
}
