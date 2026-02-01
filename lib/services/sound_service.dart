import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final SoundService _instance = SoundService._internal();
  late final AudioPlayer _audioPlayer;

  factory SoundService() {
    return _instance;
  }

  SoundService._internal() {
    _audioPlayer = AudioPlayer();
  }

  Future<void> playPopSound() async {
    try {
      // Son de pop corn explosif
      await _audioPlayer.play(AssetSource('sounds/pop.mp3')).catchError((_) {
        // Fallback si le fichier n'existe pas
        return Future.value();
      });
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> playCrunchSound() async {
    try {
      // Son de grain qui se détache
      await _audioPlayer.play(AssetSource('sounds/crunch.mp3')).catchError((_) {
        return Future.value();
      });
    } catch (e) {
      // Silent fail
    }
  }

  Future<void> playSuccessSound() async {
    try {
      // Son de victoire/récompense
      await _audioPlayer.play(AssetSource('sounds/success.mp3')).catchError((_) {
        return Future.value();
      });
    } catch (e) {
      // Silent fail
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
