import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_core/fretboard_core.dart';
import 'package:fretboard_trainer/lesson/learn_board.dart';
import 'package:fretboard_trainer/lesson/note_pitch.dart';

void main() {
  test('a amostra A2 fica na corda A solta e sobe uma oitava na casa 12', () {
    expect(playbackScaleFor(const Position(string: 1, fret: 0)), 1);
    expect(playbackScaleFor(const Position(string: 1, fret: 12)), 2);
    expect(
      playbackScaleFor(const Position(string: 0, fret: 0)),
      closeTo(math.pow(2, -5 / 12), 1e-12),
    );
  });

  test('a janela de 6 casas cobre as notas do passo', () {
    expect(learnFretWindowStart(const [0, 1]), 0);
    expect(learnFretWindowStart(const [1, 3, 5]), 1);
    expect(learnFretWindowStart(const [7, 8, 10, 12]), 7);
  });
}
