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

/// Starts one note and later stops voices that are still sounding.
///
/// A voice may outlive the gap between notes. Callers keep every id they
/// receive until [stop].
abstract interface class NoteVoiceBackend {
  Future<Object> start(Position position);

  Future<void> stop(Iterable<Object> voices);
}

/// SoLoud backend. The bundled pluck is about one second long.
final class SoloudVoiceBackend implements NoteVoiceBackend {
  AudioSource? _source;

  @override
  Future<Object> start(Position position) async {
    final source = await _load();
    final handle = SoLoud.instance.play(
      source,
      scale: playbackScaleFor(position),
    );
    return _SoloudVoice(handle);
  }

  @override
  Future<void> stop(Iterable<Object> voices) async {
    if (!SoLoud.instance.isInitialized) return;
    for (final voice in voices) {
      if (voice is! _SoloudVoice) continue;
      try {
        await SoLoud.instance.stop(voice.handle);
      } on Object {
        // The voice may already have ended.
      }
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

/// Plays [positions] in order by pitching the bundled A2 pluck.
///
/// Voices stay tracked after the gap, because the sample is longer than the
/// gap. The next note, [stop], and a new [play] cut every voice still held.
/// Init or device failures are swallowed. ADR 0002: the app stays usable
/// when audio is unavailable.
final class SoloudNoteSequencePlayer implements NoteSequencePlayer {
  SoloudNoteSequencePlayer({
    NoteVoiceBackend? backend,
    this.gap = const Duration(milliseconds: 320),
  }) : _backend = backend ?? SoloudVoiceBackend();

  final NoteVoiceBackend _backend;
  final Duration gap;
  final NoteSequenceGate _gate = NoteSequenceGate();
  final List<Object> _voices = [];
  final List<_Gap> _gaps = [];

  @override
  void stop() {
    _gate.stop();
    unawaited(_cut());
    for (final gap in List<_Gap>.of(_gaps)) {
      gap.cancel();
    }
  }

  @override
  Future<void> play(List<Position> positions) async {
    await _cut();
    try {
      await playNoteSequence(_gate, positions, (position, still) async {
        await _cut();
        if (!still()) return;
        final voice = await _backend.start(position);
        if (!still()) {
          await _backend.stop([voice]);
          return;
        }
        _voices.add(voice);
        await _wait(gap);
      });
    } on Object {
      // Missing backend, asset, or device. Ouvir stays silent.
    }
  }

  Future<void> _cut() {
    if (_voices.isEmpty) return Future<void>.value();
    final voices = List<Object>.of(_voices);
    _voices.clear();
    return _backend.stop(voices);
  }

  Future<void> _wait(Duration duration) {
    if (duration <= Duration.zero) return Future<void>.value();
    final gap = _Gap(duration);
    _gaps.add(gap);
    return gap.done.future.whenComplete(() => _gaps.remove(gap));
  }
}

final class _SoloudVoice {
  _SoloudVoice(this.handle);

  final SoundHandle handle;
}

final class _Gap {
  _Gap(Duration duration) {
    _timer = Timer(duration, _finish);
  }

  final Completer<void> done = Completer<void>();
  late final Timer _timer;

  void cancel() {
    _timer.cancel();
    _finish();
  }

  void _finish() {
    if (!done.isCompleted) done.complete();
  }
}
