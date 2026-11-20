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
}
