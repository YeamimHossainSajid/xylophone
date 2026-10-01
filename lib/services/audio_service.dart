import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import '../models/xylophone_note.dart';

class AudioService {
  AudioService._internal();
  static final AudioService instance = AudioService._internal();

  final Map<int, AudioPlayer> _players = {};
  bool _isMuted = false;

  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
  }

  void initialize() {
    for (final note in XylophoneNote.notes) {
      final player = AudioPlayer();
      player.setPlayerMode(PlayerMode.lowLatency);
      player.setReleaseMode(ReleaseMode.stop);
      _players[note.number] = player;
    }
  }

  Future<void> playNote(XylophoneNote note) async {
    if (_isMuted) return;

    try {
      final player = _players[note.number];
      if (player != null) {
        await player.stop();
        await player.play(AssetSource(note.soundAsset));
      } else {
        final fallbackPlayer = AudioPlayer();
        await fallbackPlayer.play(AssetSource(note.soundAsset));
      }
    } catch (e) {
      debugPrint('Error playing audio note ${note.number}: $e');
    }
  }

  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
