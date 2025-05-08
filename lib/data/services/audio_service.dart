import 'package:just_audio/just_audio.dart';

class AudioService {
  AudioPlayer? _audioPlayer;
  AudioPlayer? get audioPlayer => _audioPlayer;

  void initAudioPlayer() {
    if (_audioPlayer != null) {
      _audioPlayer!.dispose();
      _audioPlayer = null;
    }
    _audioPlayer = AudioPlayer();
  }

  Future<void> dispose() async {
    await _audioPlayer?.dispose();
    _audioPlayer = null;
  }
}
