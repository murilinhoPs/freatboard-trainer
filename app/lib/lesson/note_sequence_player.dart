import 'dart:async';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:fretboard_core/fretboard_core.dart';

import 'note_pitch.dart';

/// Plays lesson notes in order. Implementations must not throw: a missing
/// device leaves the lesson usable.
abstract interface class NoteSequencePlayer {
  Future<void> play(List<Position> positions);

  /// Drops the sequence that is playing or about to play.
  void stop();
}

/// Invalidates an in-flight [playNoteSequence] when a new one starts or
/// [stop] is called.
final class NoteSequenceGate {
  int _generation = 0;

  int start() => ++_generation;

  void stop() => _generation++;

  bool isCurrent(int generation) => generation == _generation;
}

/// Plays [positions] in order until [gate] is no longer current.
Future<void> playNoteSequence(
  NoteSequenceGate gate,
  List<Position> positions,
  Future<void> Function(Position position, bool Function() stillCurrent)
  playOne,
) async {
  final generation = gate.start();
  bool still() => gate.isCurrent(generation);
  for (final position in positions) {
    if (!still()) return;
    await playOne(position, still);
    if (!still()) return;
  }
}

/// Plays [positions] in order by pitching the bundled A2 pluck.
///
/// Init or device failures are swallowed. ADR 0002: the app stays usable
/// when audio is unavailable.
final class SoloudNoteSequencePlayer implements NoteSequencePlayer {
  final NoteSequenceGate _gate = NoteSequenceGate();
  AudioSource? _source;
  SoundHandle? _handle;

  @override
  void stop() {
    _gate.stop();
    _silence();
  }

  @override
  Future<void> play(List<Position> positions) async {
    _silence();
    try {
      await playNoteSequence(_gate, positions, (position, still) async {
        final source = await _load();
        if (!still()) return;
        final handle = SoLoud.instance.play(
          source,
          scale: playbackScaleFor(position),
        );
        _handle = handle;
        await Future<void>.delayed(const Duration(milliseconds: 320));
        if (!still()) {
          await _silenceHandle(handle);
          return;
        }
        if (_handle == handle) _handle = null;
      });
    } on Object {
      // Missing backend, asset, or device. Ouvir stays silent.
    }
  }

  void _silence() {
    final handle = _handle;
    _handle = null;
    if (handle == null) return;
    unawaited(_silenceHandle(handle));
  }

  Future<void> _silenceHandle(SoundHandle handle) async {
    if (!SoLoud.instance.isInitialized) return;
    try {
      await SoLoud.instance.stop(handle);
    } on Object {
      // The voice may already have ended.
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
