import 'package:fretboard_core/fretboard_core.dart';
import 'package:test/test.dart';

void main() {
  group('standard guitar', () {
    test('calculates all 138 string/fret notes', () {
      final expectedOpen = [
        PitchClass.e,
        PitchClass.a,
        PitchClass.d,
        PitchClass.g,
        PitchClass.b,
        PitchClass.e,
      ];
      for (var string = 0; string < 6; string++) {
        expect(
          noteAt(standardGuitar, Position(string: string, fret: 0)),
          expectedOpen[string],
        );
        for (var fret = 0; fret <= 22; fret++) {
          expect(
            noteAt(standardGuitar, Position(string: string, fret: fret)),
            PitchClass.values[(PitchClass.values.indexOf(expectedOpen[string]) +
                    fret) %
                12],
          );
        }
      }
    });

    test('lists every matching position within inclusive fret range', () {
      expect(
        positionsOf(standardGuitar, PitchClass.e, const FretRange(0, 22)),
        hasLength(12),
      );
      expect(positionsOf(standardGuitar, PitchClass.a, const FretRange(0, 0)), [
        const Position(string: 1, fret: 0),
      ]);
    });

    test('returns octave positions and null when no higher string exists', () {
      expect(
        octaveOf(standardGuitar, const Position(string: 0, fret: 0)),
        const Position(string: 2, fret: 2),
      );
      expect(
        octaveOf(standardGuitar, const Position(string: 4, fret: 12)),
        isNull,
      );
    });

    test('maps single and double inlays', () {
      expect(
        [
          for (final fret in [0, 3, 5, 7, 9, 12, 15, 17, 19, 21, 22])
            inlayIndex(fret),
        ],
        [0, 1, 1, 1, 1, 2, 1, 1, 1, 1, 0],
      );
    });

    test('counts chromatically up to target, excluding start', () {
      expect(countPath(PitchClass.b, PitchClass.d), [
        PitchClass.c,
        PitchClass.cs,
        PitchClass.d,
      ]);
      expect(countPath(PitchClass.g, PitchClass.g), isEmpty);
    });

    test('rejects invalid positions and ranges', () {
      expect(
        () => noteAt(standardGuitar, const Position(string: -1, fret: 0)),
        throwsRangeError,
      );
      expect(
        () => noteAt(standardGuitar, const Position(string: 0, fret: 23)),
        throwsRangeError,
      );
      expect(
        () => positionsOf(standardGuitar, PitchClass.c, const FretRange(0, 23)),
        throwsRangeError,
      );
      expect(() => inlayIndex(-1), throwsRangeError);
    });
  });
}
