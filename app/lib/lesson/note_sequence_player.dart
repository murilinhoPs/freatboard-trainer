import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:fretboard_core/fretboard_core.dart';

import 'note_pitch.dart';

/// Plays lesson notes in order. Implementations must not throw: a missing
/// device leaves the lesson usable.
abstract interface class NoteSequencePlayer {
  Future<void> play(List<Position> positions);
}

/// Plays [positions] in order by pitching the bundled A2 pluck.
///
/// Init or device failures are swallowed. ADR 0002: the app stays usable
/// when audio is unavailable.
final class SoloudNoteSequencePlayer implements NoteSequencePlayer {
  AudioSource? _source;

  @override
  Future<void> play(List<Position> positions) async {
    try {
      final source = await _load();
      for (final position in positions) {
        SoLoud.instance.play(source, scale: playbackScaleFor(position));
        await Future<void>.delayed(const Duration(milliseconds: 320));
      }
    } on Object {
      // Missing backend, asset, or device. Ouvir stays silent.
    }
  }

  Future<AudioSource> _load() async {
    final cached = _source;
    if (cached != null) return cached;
    if (!SoLoud.instance.isInitialized) {
      await SoLoud.instance.init();
    }
    final source = await SoLoud.instance.loadAsset('assets/audio/pluck-a2.wav');
    _source = source;
    return source;
  }
}
