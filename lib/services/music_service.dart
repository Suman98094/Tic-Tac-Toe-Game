import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

class MusicService {
  static final AudioPlayer _player = AudioPlayer();

  static bool get isPlaying => _player.state == PlayerState.playing;
  static bool get isPaused => _player.state == PlayerState.paused;

  static Future<void> playBackgroundMusic() async {
    developer.log(
      'playBackgroundMusic called. Current state: ${_player.state}',
      name: 'MusicService',
    );
    if (!isPlaying) {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.play(AssetSource('sounds/background.mp3'));
      developer.log('Background music started playing', name: 'MusicService');
    }
  }

  static Future<void> pauseMusic() async {
    developer.log(
      'pauseMusic called. Current state: ${_player.state}',
      name: 'MusicService',
    );
    if (isPlaying) {
      await _player.pause();
      developer.log('Music paused', name: 'MusicService');
    }
  }

  static Future<void> resumeMusic() async {
    developer.log(
      'resumeMusic called. Current state: ${_player.state}',
      name: 'MusicService',
    );
    if (isPaused) {
      await _player.resume();
      developer.log('Music resumed', name: 'MusicService');
    }
  }

  static Future<void> stopMusic() async {
    developer.log(
      'stopMusic called. Current state: ${_player.state}',
      name: 'MusicService',
    );
    if (isPlaying || isPaused) {
      await _player.stop();
      developer.log('Music stopped', name: 'MusicService');
      // Don't dispose here to allow resume later
    }
  }

  static Future<void> dispose() async {
    developer.log('dispose called', name: 'MusicService');
    await _player.dispose();
  }
}
