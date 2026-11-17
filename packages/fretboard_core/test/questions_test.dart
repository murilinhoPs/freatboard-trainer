import 'package:fretboard_core/fretboard_core.dart';
import 'package:test/test.dart';

const _naturals = [
  PitchClass.c,
  PitchClass.d,
  PitchClass.e,
  PitchClass.f,
  PitchClass.g,
  PitchClass.a,
  PitchClass.b,
];

void main() {
  group('Question generation and evaluation', () {
    test('FindOnString targets note on string and evaluates tapped position', () {
      const target = Position(string: 3, fret: 2); // A on G string
      final question =
          generateQuestionForTarget(
                target: target,
                phase: LessonPhase.practice,
                includesAccidentals: false,
                kind: QuestionKind.findOnString,
              )
              as FindOnString;

      expect(question.target, target);
      expect(question.note, PitchClass.a);
      expect(question.string, 3);
      expect(question.isBoardTapQuestion, isTrue);

      final correct = evaluatePositionAnswer(question, target);
      expect(correct.isCorrect, isTrue);
      expect(correct.target, target);
      expect(correct.targetNote, PitchClass.a);
      expect(correct.tappedPosition, target);
      expect(correct.explanation.text, isNotEmpty);

      final wrongFret = evaluatePositionAnswer(
        question,
        const Position(string: 3, fret: 4),
      );
      expect(wrongFret.isCorrect, isFalse);

      final wrongString = evaluatePositionAnswer(
        question,
        const Position(string: 1, fret: 0),
      );
      expect(wrongString.isCorrect, isFalse);
    });

    test('FindAtFret targets note at fret and evaluates tapped position', () {
      const target = Position(string: 0, fret: 7); // B at 7th fret, low E
      final question =
          generateQuestionForTarget(
                target: target,
                phase: LessonPhase.yourTurn,
                includesAccidentals: false,
                kind: QuestionKind.findAtFret,
              )
              as FindAtFret;

      expect(question.target, target);
      expect(question.note, PitchClass.b);
      expect(question.fret, 7);
      expect(question.isBoardTapQuestion, isTrue);

      expect(evaluatePositionAnswer(question, target).isCorrect, isTrue);
      // Same pitch class B on high e at fret 7 is a different target position.
      expect(
        evaluatePositionAnswer(
          question,
          const Position(string: 5, fret: 7),
        ).isCorrect,
        isFalse,
      );
      expect(
        evaluatePositionAnswer(
          question,
          const Position(string: 4, fret: 0),
        ).isCorrect,
        isFalse,
      );
    });

    test('OpenString targets fret 0 on string and rejects non-zero frets', () {
      const target = Position(string: 4, fret: 0); // open B
      final question =
          generateQuestionForTarget(
                target: target,
                phase: LessonPhase.practice,
                includesAccidentals: false,
                kind: QuestionKind.openString,
              )
              as OpenString;

      expect(question.target, target);
      expect(question.string, 4);
      expect(question.targetNote, PitchClass.b);
      expect(question.isBoardTapQuestion, isTrue);

      expect(evaluatePositionAnswer(question, target).isCorrect, isTrue);
      expect(
        evaluatePositionAnswer(
          question,
          const Position(string: 3, fret: 0),
        ).isCorrect,
        isFalse,
      );
      expect(
        evaluatePositionAnswer(
          question,
          const Position(string: 4, fret: 1),
        ).isCorrect,
        isFalse,
      );

      expect(
        () => generateQuestionForTarget(
          target: const Position(string: 4, fret: 1),
          phase: LessonPhase.practice,
          includesAccidentals: false,
          kind: QuestionKind.openString,
        ),
        throwsArgumentError,
      );
    });

    test('NameNote provides 4 options in Practice (naturals-only when lesson has no accidentals)', () {
      const target = Position(string: 1, fret: 3); // C
      final question =
          generateQuestionForTarget(
                target: target,
                phase: LessonPhase.practice,
                includesAccidentals: false,
                kind: QuestionKind.nameNote,
                seed: 42,
              )
              as NameNote;

      expect(question.isBoardTapQuestion, isFalse);
      expect(question.targetNote, PitchClass.c);
      expect(question.options, hasLength(4));
      expect(question.options.toSet(), hasLength(4));
      expect(question.options, contains(PitchClass.c));
      for (final opt in question.options) {
        expect(_naturals, contains(opt));
      }

      final correct = evaluateNoteAnswer(question, PitchClass.c);
      expect(correct.isCorrect, isTrue);
      expect(correct.selectedNote, PitchClass.c);
      expect(correct.explanation.text, isNotEmpty);

      final distractor = question.options.firstWhere((n) => n != PitchClass.c);
      final wrong = evaluateNoteAnswer(question, distractor);
      expect(wrong.isCorrect, isFalse);
      expect(wrong.selectedNote, distractor);

      // Option not present in this Practice question is rejected.
      expect(
        () => evaluateNoteAnswer(question, PitchClass.cs),
        throwsArgumentError,
      );
    });

    test('NameNote provides 7 natural options or 12 chromatic options in Your Turn', () {
      final naturalQuestion =
          generateQuestionForTarget(
                target: const Position(string: 2, fret: 5), // G
                phase: LessonPhase.yourTurn,
                includesAccidentals: false,
                kind: QuestionKind.nameNote,
              )
              as NameNote;

      expect(naturalQuestion.options, _naturals);
      expect(naturalQuestion.options, hasLength(7));
      expect(
        evaluateNoteAnswer(naturalQuestion, PitchClass.g).isCorrect,
        isTrue,
      );
      expect(
        evaluateNoteAnswer(naturalQuestion, PitchClass.a).isCorrect,
        isFalse,
      );

      final sharpQuestion =
          generateQuestionForTarget(
                target: const Position(string: 1, fret: 4), // C#
                phase: LessonPhase.yourTurn,
                includesAccidentals: true,
                kind: QuestionKind.nameNote,
              )
              as NameNote;

      expect(sharpQuestion.options, PitchClass.values);
      expect(sharpQuestion.options, hasLength(12));
      expect(
        evaluateNoteAnswer(sharpQuestion, PitchClass.cs).isCorrect,
        isTrue,
      );
      expect(
        evaluateNoteAnswer(sharpQuestion, PitchClass.c).isCorrect,
        isFalse,
      );
    });

    test('generates deterministic questions across targets and phases', () {
      final naturalLesson = findNotesLessonById('notes-g-nat-1')!;
      final sharpLesson = findNotesLessonById('notes-a-sharp')!;

      final run1 = generateLessonPhaseQuestions(
        lesson: naturalLesson,
        phase: LessonPhase.practice,
        seed: 7,
      );
      final run2 = generateLessonPhaseQuestions(
        lesson: naturalLesson,
        phase: LessonPhase.practice,
        seed: 7,
      );
      expect(run1, run2);
      expect(run1, hasLength(naturalLesson.targets.length));

      final sharpRun = generateLessonPhaseQuestions(
        lesson: sharpLesson,
        phase: LessonPhase.yourTurn,
        seed: 3,
      );
      expect(sharpRun, hasLength(sharpLesson.targets.length));
      for (final q in sharpRun) {
        expect(q, isNot(isA<OpenString>()));
        if (q is NameNote) {
          expect(q.options, hasLength(12));
        }
      }
    });

    test('rejects invalid phases, mismatched evaluators, and out-of-range taps', () {
      expect(
        () => generateQuestionForTarget(
          target: const Position(string: 0, fret: 0),
          phase: LessonPhase.learn,
          includesAccidentals: false,
        ),
        throwsArgumentError,
      );
      expect(
        () => generateQuestionForTarget(
          target: const Position(string: 0, fret: 2), // F#
          phase: LessonPhase.yourTurn,
          includesAccidentals: false,
        ),
        throwsArgumentError,
      );

      final nameQuestion = generateQuestionForTarget(
        target: const Position(string: 0, fret: 0),
        phase: LessonPhase.practice,
        includesAccidentals: false,
        kind: QuestionKind.nameNote,
      );
      expect(
        () => evaluatePositionAnswer(
          nameQuestion,
          const Position(string: 0, fret: 0),
        ),
        throwsArgumentError,
      );

      final tapQuestion = generateQuestionForTarget(
        target: const Position(string: 0, fret: 0),
        phase: LessonPhase.practice,
        includesAccidentals: false,
        kind: QuestionKind.openString,
      );
      expect(
        () => evaluatePositionAnswer(
          tapQuestion,
          const Position(string: 0, fret: 99),
        ),
        throwsRangeError,
      );
    });
  });
}
