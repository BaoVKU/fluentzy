import 'package:fluentzy/data/models/listening_lesson.dart';
import 'package:fluentzy/data/models/transcript_line.dart';
import 'package:fluentzy/data/repositories/lesson_repository.dart';
import 'package:fluentzy/data/services/audio_service.dart';
import 'package:fluentzy/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayViewModel extends ChangeNotifier {
  final AudioService _audioService;
  final LessonRepository _lessonRepository;
  final String _lessonId;
  ListeningLesson? _lesson;
  ListeningLesson? get lesson => _lesson;
  AudioPlayer get audioPlayer => _audioService.audioPlayer!;
  bool _isTranscriptEnabled = false;
  bool get isTranscriptEnabled => _isTranscriptEnabled;
  bool _isDualLanguageEnabled = false;
  bool get isDualLanguageEnabled => _isDualLanguageEnabled;

  PlayViewModel(this._lessonRepository, this._audioService, this._lessonId) {
    _audioService.initAudioPlayer();
    _setupAudioPlayer();
  }

  Future<void> _setupAudioPlayer() async {
    await _fetchLessonById(id: _lessonId);
    if (_lesson == null) return;
    await _audioService.audioPlayer!.setUrl(_lesson!.url);
  }

  Future<void> _fetchLessonById({required id}) async {
    if (_lesson != null) return;
    _lesson = await _lessonRepository.fetchListeningLessonById(id);
    notifyListeners();
  }

  void toggleTranscript() {
    _isTranscriptEnabled = !_isTranscriptEnabled;
    notifyListeners();
  }

  void toggleDualLanguage() {
    _isDualLanguageEnabled = !_isDualLanguageEnabled;
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
