import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_core/fretboard_core.dart';
import 'package:fretboard_trainer/lesson/note_sequence_player.dart';

void main() {
  const first = Position(string: 0, fret: 0);
  const second = Position(string: 0, fret: 1);
  const other = Position(string: 0, fret: 5);

  test('stop corta as notas que ainda não tocaram', () async {
    final gate = NoteSequenceGate();
    final heard = <Position>[];
    final release = Completer<void>();
    final running = playNoteSequence(gate, const [first, second], (
      position,
      still,
    ) async {
      heard.add(position);
      await release.future;
      if (!still()) return;
    });

    expect(heard, [first]);
    gate.stop();
    release.complete();
    await running;
    expect(heard, [first]);
  });

  test('uma sequência nova cancela a anterior', () async {
    final gate = NoteSequenceGate();
    final heard = <Position>[];
    final release = Completer<void>();
    final firstRun = playNoteSequence(gate, const [first, second], (
      position,
      still,
    ) async {
      heard.add(position);
      await release.future;
      if (!still()) return;
    });
    final secondRun = playNoteSequence(gate, const [other], (
      position,
      still,
    ) async {
      heard.add(position);
    });

    release.complete();
    await Future.wait([firstRun, secondRun]);
    expect(heard, [first, other]);
  });

  test('a voz segue ativa depois do intervalo e o stop corta', () async {
    final backend = _HoldingBackend();
    final player = SoloudNoteSequencePlayer(
      backend: backend,
      gap: const Duration(milliseconds: 1),
    );

    await player.play(const [first]);

    expect(backend.active, [0]);
    expect(backend.stopped, isEmpty);
    player.stop();
    expect(backend.active, isEmpty);
    expect(backend.stopped, [0]);
  });

  test('a nota seguinte corta a anterior que ainda soa', () async {
    final backend = _HoldingBackend();
    final player = SoloudNoteSequencePlayer(
      backend: backend,
      gap: const Duration(milliseconds: 1),
    );

    await player.play(const [first, second]);

    expect(backend.stopped, [0]);
    expect(backend.active, [1]);
    player.stop();
    expect(backend.active, isEmpty);
    expect(backend.stopped, [0, 1]);
  });

  test('parar no meio do intervalo corta a voz e não segue a fila', () async {
    final backend = _HoldingBackend();
    final player = SoloudNoteSequencePlayer(
      backend: backend,
      gap: const Duration(hours: 1),
    );

    final running = player.play(const [first, second]);
    await pumpEventQueue();
    expect(backend.active, [0]);

    player.stop();
    await running;

    expect(backend.active, isEmpty);
    expect(backend.stopped, [0]);
    expect(backend.started, 1);
  });

  test('stop durante o corte pendente não inicia a sequência', () async {
    final backend = _PendingStopBackend();
    final player = SoloudNoteSequencePlayer(
      backend: backend,
      gap: Duration.zero,
    );

    await player.play(const [first]);
    expect(backend.started, 1);

    final next = player.play(const [second]);
    await pumpEventQueue();
    expect(backend.pendingStops, 1);
    expect(backend.started, 1);

    player.stop();
    backend.releaseStops();
    await next;

    expect(backend.started, 1);
  });
}

final class _HoldingBackend implements NoteVoiceBackend {
  final active = <int>[];
  final stopped = <int>[];
  int started = 0;

  @override
  Future<Object> start(Position position) async {
    final id = started++;
    active.add(id);
    return id;
  }

  @override
  Future<void> stop(Iterable<Object> voices) async {
    for (final voice in voices) {
      final id = voice as int;
      active.remove(id);
      stopped.add(id);
    }
  }
}

final class _PendingStopBackend implements NoteVoiceBackend {
  final _stops = <Completer<void>>[];
  int started = 0;

  int get pendingStops => _stops.where((stop) => !stop.isCompleted).length;

  @override
  Future<Object> start(Position position) async {
    return started++;
  }

  @override
  Future<void> stop(Iterable<Object> voices) {
    final done = Completer<void>();
    _stops.add(done);
    return done.future;
  }

  void releaseStops() {
    for (final stop in _stops) {
      if (!stop.isCompleted) stop.complete();
    }
  }
}
