import 'dart:async';

import 'package:fluentzy/data/repositories/stt_repository.dart';
import 'package:fluentzy/data/repositories/translation_repository.dart';
import 'package:fluentzy/data/repositories/tts_repository.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';

class TranslatorViewModel extends ChangeNotifier {
  final TranslationRepository _translationRepository;
  final TtsRepository _ttsRepository;
  final SttRepository _sttRepository;

  String _sourceLangCode = 'en';
  String get sourceLangCode => _sourceLangCode;

  String _targetLangCode = 'vi';
  String get targetLangCode => _targetLangCode;

  bool _isTranslating = false;
  bool get isTranslating => _isTranslating;

  bool _hasFinalResult = false;
  bool get hasFinalResult => _hasFinalResult;

  bool get isListening => _sttRepository.isListening;

  String get listenedResult => _sttRepository.listenedResult;

  bool _isTimeout = false;
  bool get isTimeout => _isTimeout;

  final StreamController<String> _resultStreamController =
      StreamController<String>.broadcast();
  Stream<String> get resultStream => _resultStreamController.stream;

  TranslatorViewModel(
    this._translationRepository,
    this._ttsRepository,
    this._sttRepository,
  );

  @override
  void dispose() {
    _sttRepository.dispose();
    super.dispose();
  }
  
  Future<String> translate(String text) async {
    _isTranslating = true;
    notifyListeners();
    final result = await _translationRepository.translate(
      _sourceLangCode,
      _targetLangCode,
      text,
    );
    _isTranslating = false;
    notifyListeners();
    return result ?? "";
  }

  void swapLanguages() {
    final temp = _sourceLangCode;
    _sourceLangCode = _targetLangCode;
    _targetLangCode = temp;
    notifyListeners();
  }

  Future<void> speakOutLoud({required String text, required langCode}) async {
    if (_ttsRepository.isSpeaking) {
      await _ttsRepository.stopSpeaker();
      notifyListeners();
      return;
    }
    await _ttsRepository.playSpeaker(text: text, langCode: langCode);
    notifyListeners();
  }

  void startRecording() async {
    _isTimeout = false;
    await _sttRepository.startRecording(
      langCode: _sourceLangCode,
      onFinalResult: (isFinal) {
        _hasFinalResult = isFinal;
        Logger.error("translator - said: $listenedResult, isFinal: $isFinal");
        notifyListeners();
      },
      onResult: (result) {
        _resultStreamController.add(result);
        Logger.error("translator - result stream: $result");
        notifyListeners();
      },
      onTimeout: () {
        _hasFinalResult = false;
        _isTimeout = true;
        Logger.error("translator - Recording timed out");
        notifyListeners();
      },
    );
    notifyListeners();
  }

  void stopRecording() async {
    _isTimeout = false;
    await _sttRepository.stopRecording();
    notifyListeners();
  }

  void reset() async {
    _hasFinalResult = false;
    _resultStreamController.add("");
    _isTimeout = false;
    await _sttRepository.reset();
    notifyListeners();
  }

  void resetTimeout() {
    _isTimeout = false;
  }
}
