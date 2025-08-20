import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Play the todo completion sound
  Future<void> playTodoCompleteSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/todo_complete.mp3'));
    } catch (e) {
      // Silently fail if sound can't be played
      print('Error playing todo complete sound: $e');
    }
  }

  /// Play a generic success sound
  Future<void> playSuccessSound() async {
    await playTodoCompleteSound();
  }

  /// Dispose of the audio player
  void dispose() {
    _audioPlayer.dispose();
  }
}
