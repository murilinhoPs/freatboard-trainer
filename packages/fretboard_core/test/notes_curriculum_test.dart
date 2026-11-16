import 'package:fretboard_core/fretboard_core.dart';
import 'package:test/test.dart';

const _naturalPitches = {
  PitchClass.c,
  PitchClass.d,
  PitchClass.e,
  PitchClass.f,
  PitchClass.g,
  PitchClass.a,
  PitchClass.b,
};

const _sharpPitches = {
  PitchClass.cs,
  PitchClass.ds,
  PitchClass.fs,
  PitchClass.gs,
  PitchClass.as_,
};

void main() {
  group('notes curriculum 0..12', () {
    test('defines 18 ordered lessons across strings 0..5', () {
      expect(notesCurriculum, hasLength(18));
      expect(notesCurriculumFretRange.start, 0);
      expect(notesCurriculumFretRange.end, 12);

      final ids = <String>{};
      for (var i = 0; i < notesCurriculum.length; i++) {
        final lesson = notesCurriculum[i];
        expect(ids.add(lesson.id), isTrue, reason: 'Duplicate id ${lesson.id}');
        expect(lesson.skill, Skill.notes);
        expect(lesson.order, i + 1);
        expect(lesson.string, i ~/ 3);
        expect(lesson.title, isNotEmpty);
        expect(lesson.hint, isNotEmpty);
        expect(lesson.steps, isNotEmpty);
      }
    });

    test('covers all 78 positions in 0..12 exactly once without out-of-range notes', () {
      final covered = <Position>{};

      for (final lesson in notesCurriculum) {
        for (final pos in lesson.targets) {
          expect(pos.string, inInclusiveRange(0, 5));
          expect(pos.string, lesson.string);
          expect(pos.fret, inInclusiveRange(0, 12));
          expect(
            covered.add(pos),
            isTrue,
            reason: 'Duplicate target $pos in ${lesson.id}',
          );
        }
      }

      expect(covered, hasLength(6 * 13));
      for (var string = 0; string < 6; string++) {
        for (var fret = 0; fret <= 12; fret++) {
          expect(
            covered.contains(Position(string: string, fret: fret)),
            isTrue,
            reason: 'Missing Position(string: $string, fret: $fret)',
          );
        }
      }
    });

    test('separates natural lessons and sharp lessons accurately per string', () {
      for (var string = 0; string < 6; string++) {
        final stringLessons = notesCurriculum
            .where((l) => l.string == string)
            .toList();
        expect(stringLessons, hasLength(3));

        // First two lessons: naturals only, ordered by fret, totaling 8 positions.
        final nat1 = stringLessons[0];
        final nat2 = stringLessons[1];
        final sharps = stringLessons[2];

        expect(nat1.includesAccidentals, isFalse);
        expect(nat2.includesAccidentals, isFalse);
        expect(sharps.includesAccidentals, isTrue);

        expect(nat1.targets, hasLength(4));
        expect(nat2.targets, hasLength(4));
        expect(sharps.targets, hasLength(5));

        for (final pos in [...nat1.targets, ...nat2.targets]) {
          expect(_naturalPitches.contains(noteAt(standardGuitar, pos)), isTrue);
        }
        for (final pos in sharps.targets) {
          expect(_sharpPitches.contains(noteAt(standardGuitar, pos)), isTrue);
        }

        // Progression within a string moves from lower frets to higher frets.
        expect(
          nat1.targets.last.fret,
          lessThan(nat2.targets.first.fret),
        );
        expect(nat2.targets.last.fret, 12);
      }
    });

    test('keeps learn steps and references within 0..12 and valid strings', () {
      for (final lesson in notesCurriculum) {
        for (final ref in lesson.referencePositions) {
          expect(ref.string, inInclusiveRange(0, 5));
          expect(ref.fret, inInclusiveRange(0, 12));
        }
        for (final step in lesson.steps) {
          expect(step.title, isNotEmpty);
          expect(step.description, isNotEmpty);
          expect(step.highlightedPositions, isNotEmpty);
          for (final pos in [
            ...step.highlightedPositions,
            ...step.referencePositions,
          ]) {
            expect(pos.string, inInclusiveRange(0, 5));
            expect(pos.fret, inInclusiveRange(0, 12));
          }
        }
      }
    });

    test('supports lookup by id and enforces immutability', () {
      final lesson = findNotesLessonById('notes-a-sharp');
      expect(lesson, isNotNull);
      expect(lesson!.order, 6);
      expect(lesson.string, 1);
      expect(lesson.includesAccidentals, isTrue);

      expect(findNotesLessonById('unknown-lesson'), isNull);
      expect(() => notesCurriculum.removeLast(), throwsUnsupportedError);
    });

    test('uses accurate theory phrasing for B-C semitone and D unison reference', () {
      final eLowNat2 = findNotesLessonById('notes-e-low-nat-2')!;
      expect(eLowNat2.steps.first.description, contains('um semitom'));
      expect(
        eLowNat2.steps.first.description.toLowerCase(),
        isNot(contains('dois semitons')),
      );

      final dNat1 = findNotesLessonById('notes-d-nat-1')!;
      expect(dNat1.steps.first.description, contains('mesma nota'));
      expect(dNat1.steps.first.description, contains('mesma oitava'));
      expect(
        dNat1.steps.first.description.toLowerCase(),
        isNot(contains('é a oitava')),
      );
    });
  });
}
