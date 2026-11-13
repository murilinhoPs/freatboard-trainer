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

    test('returns nearest octave across strings and null when unavailable', () {
      expect(
        octaveOf(standardGuitar, const Position(string: 0, fret: 0)),
        const Position(string: 1, fret: 7),
      );
      expect(
        octaveOf(standardGuitar, const Position(string: 4, fret: 12)),
        isNull,
      );
      expect(
        octaveOf(standardGuitar, const Position(string: 3, fret: 0)),
        const Position(string: 4, fret: 8),
      );
      // Prefer nearest string; within that string, exact octave is unique.
      expect(
        octaveOf(standardGuitar, const Position(string: 2, fret: 0)),
        const Position(string: 3, fret: 7),
      );
      expect(
        octaveOf(standardGuitar, const Position(string: 5, fret: 22)),
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

    test('generates stable count, octave, and inlay explanation snapshots', () {
      expect(
        explainPosition(
          standardGuitar,
          const Position(string: 3, fret: 2),
          anchor: const Position(string: 3, fret: 0),
        ),
        const Explanation(
          ExplanationKind.count,
          'Count up from G on fret 0: G → G♯ → A',
        ),
      );
      expect(
        explainPosition(standardGuitar, const Position(string: 3, fret: 0)),
        const Explanation(
          ExplanationKind.octave,
          "It's the octave of G on the G string (fret 0): 1 string up, 8 frets higher.",
        ),
      );
      expect(
        explainPosition(standardGuitar, const Position(string: 5, fret: 5)),
        const Explanation(
          ExplanationKind.inlay,
          'A sits on the first dot of the high E string, fret 5.',
        ),
      );
    });

    test('explains adjacent semitones without intermediate note', () {
      expect(
        explainPosition(
          standardGuitar,
          const Position(string: 0, fret: 1),
          anchor: const Position(string: 0, fret: 0),
        ).text,
        'E and F have no note between them',
      );
      expect(
        explainPosition(
          standardGuitar,
          const Position(string: 0, fret: 0),
          anchor: const Position(string: 0, fret: 12),
        ).text,
        'Both positions are E.',
      );
      expect(
        explainPosition(
          standardGuitar,
          const Position(string: 0, fret: 11),
          anchor: const Position(string: 0, fret: 0),
        ).text,
        'E and D♯ have no note between them',
      );
    });
  });
}
