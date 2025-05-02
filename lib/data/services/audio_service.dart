import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _audioPlayer;
  AudioPlayer get audioPlayer => _audioPlayer;
  AudioService() : _audioPlayer = AudioPlayer();

  void dispose() {
    _audioPlayer.dispose();
  }
}