import 'package:fretboard_core/fretboard_core.dart';
import 'package:test/test.dart';

Lesson _singleTargetLesson() => Lesson(
  id: 'custom-single-target',
  skill: Skill.notes,
  order: 1,
  string: 0,
  title: 'Single target',
  includesAccidentals: false,
  targets: const [Position(string: 0, fret: 0)],
  steps: [
    LearnStep(
      title: 'Step 1',
      description: 'Open E',
      highlightedPositions: const [Position(string: 0, fret: 0)],
    ),
  ],
  hint: 'Open string',
);

void main() {
  group('LessonSession state machine', () {
    test('walks Learn -> Practice -> Your Turn -> Completed in order', () {
      final lesson = findNotesLessonById('notes-e-low-nat-1')!;
      final session = LessonSession(lesson);

      expect(session.phase, LessonPhase.learn);
      expect(session.learnStepIndex, 0);
      expect(session.currentLearnStep, lesson.steps[0]);
      expect(session.currentTarget, isNull);
      expect(session.isCompleted, isFalse);

      // Step 0 -> Step 1
      session.advanceLearn();
      expect(session.phase, LessonPhase.learn);
      expect(session.learnStepIndex, 1);
      expect(session.currentLearnStep, lesson.steps[1]);

      // Step 1 -> Practice
      session.advanceLearn();
      expect(session.phase, LessonPhase.practice);
      expect(session.currentLearnStep, isNull);
      expect(session.pendingTargets, lesson.targets);
      expect(session.currentTarget, lesson.targets.first);

      // Answer all 4 targets correctly in Practice -> Your Turn
      for (var i = 0; i < lesson.targets.length; i++) {
        final expectedTarget = lesson.targets[i];
        final outcome = session.submitAnswer(isCorrect: true);
        expect(outcome.target, expectedTarget);
        expect(outcome.isCorrect, isTrue);
        expect(outcome.previousPhase, LessonPhase.practice);
        expect(outcome.requeued, isFalse);

        final isLast = i == lesson.targets.length - 1;
        expect(
          outcome.nextPhase,
          isLast ? LessonPhase.yourTurn : LessonPhase.practice,
        );
        expect(outcome.isCompleted, isFalse);
      }

      expect(session.phase, LessonPhase.yourTurn);
      expect(session.pendingTargets, lesson.targets);

      // Answer all 4 targets correctly in Your Turn -> Completed
      for (var i = 0; i < lesson.targets.length; i++) {
        final expectedTarget = lesson.targets[i];
        final outcome = session.submitAnswer(isCorrect: true);
        expect(outcome.target, expectedTarget);
        expect(outcome.previousPhase, LessonPhase.yourTurn);

        final isLast = i == lesson.targets.length - 1;
        expect(
          outcome.nextPhase,
          isLast ? LessonPhase.completed : LessonPhase.yourTurn,
        );
        expect(outcome.isCompleted, isLast);
      }

      expect(session.isCompleted, isTrue);
      expect(session.currentTarget, isNull);
      expect(session.pendingTargets, isEmpty);
      expect(session.firstTryCorrectCount, 4);
      expect(session.totalTargets, 4);
      expect(session.firstTryPercentage, 100.0);
    });

    test('transitions straight to Practice when lesson has a single learn step', () {
      final lesson = findNotesLessonById('notes-e-high-nat-1')!;
      expect(lesson.steps, hasLength(1));

      final session = LessonSession(lesson);
      expect(session.phase, LessonPhase.learn);
      session.advanceLearn();
      expect(session.phase, LessonPhase.practice);
      expect(session.pendingTargets, lesson.targets);
    });

    test('requeues wrong answers at the end of the queue until answered correctly', () {
      final lesson = findNotesLessonById('notes-a-nat-1')!;
      final t0 = lesson.targets[0];
      final t1 = lesson.targets[1];
      final t2 = lesson.targets[2];
      final t3 = lesson.targets[3];

      final session = LessonSession(lesson);
      session.advanceLearn();
      session.advanceLearn();
      expect(session.phase, LessonPhase.practice);

      // Wrong on t0 -> moves to end: [t1, t2, t3, t0]
      final wrong1 = session.submitAnswer(isCorrect: false);
      expect(wrong1.target, t0);
      expect(wrong1.requeued, isTrue);
      expect(wrong1.nextPhase, LessonPhase.practice);
      expect(session.pendingTargets, [t1, t2, t3, t0]);

      // Correct on t1, t2, t3 -> only [t0] remains
      expect(session.submitAnswer(isCorrect: true).target, t1);
      expect(session.submitAnswer(isCorrect: true).target, t2);
      expect(session.submitAnswer(isCorrect: true).target, t3);
      expect(session.pendingTargets, [t0]);

      // Repeated error on last remaining target t0 -> stays [t0] in Practice
      final wrongAgain = session.submitAnswer(isCorrect: false);
      expect(wrongAgain.target, t0);
      expect(wrongAgain.requeued, isTrue);
      expect(session.phase, LessonPhase.practice);
      expect(session.pendingTargets, [t0]);

      // Finally correct on t0 -> advances to Your Turn
      final fixed = session.submitAnswer(isCorrect: true);
      expect(fixed.target, t0);
      expect(fixed.requeued, isFalse);
      expect(fixed.nextPhase, LessonPhase.yourTurn);
      expect(session.pendingTargets, [t0, t1, t2, t3]);

      // Wrong on t0 in Your Turn -> moves to end of Your Turn queue: [t1, t2, t3, t0]
      final yourTurnWrong = session.submitAnswer(isCorrect: false);
      expect(yourTurnWrong.previousPhase, LessonPhase.yourTurn);
      expect(yourTurnWrong.nextPhase, LessonPhase.yourTurn);
      expect(yourTurnWrong.requeued, isTrue);
      expect(session.pendingTargets, [t1, t2, t3, t0]);
    });

    test('counts each target once based only on its first answer in the lesson', () {
      final lesson = findNotesLessonById('notes-a-sharp')!; // 5 targets
      final session = LessonSession(lesson);
      session.advanceLearn();
      session.advanceLearn();

      // Practice: fail target 0 twice, pass targets 1..4 on first try.
      expect(session.submitAnswer(isCorrect: false).target, lesson.targets[0]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[1]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[2]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[3]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[4]);
      // Requeued target 0: fail again, then pass.
      expect(session.submitAnswer(isCorrect: false).target, lesson.targets[0]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[0]);

      expect(session.phase, LessonPhase.yourTurn);
      expect(session.firstTryCorrectCount, 4);
      expect(session.totalTargets, 5);
      expect(session.firstTryPercentage, 80.0);

      // In Your Turn: failing target 1 (which already succeeded on first try in Practice)
      // must NOT reduce firstTryCorrectCount; passing target 0 must NOT increase it.
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[0]);
      expect(session.submitAnswer(isCorrect: false).target, lesson.targets[1]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[2]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[3]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[4]);
      expect(session.submitAnswer(isCorrect: true).target, lesson.targets[1]);

      expect(session.isCompleted, isTrue);
      expect(session.firstTryCorrectCount, 4);
      expect(session.totalTargets, 5);
      expect(session.firstTryPercentage, 80.0);
    });

    test('handles 0% first-try accuracy and single-target lessons', () {
      final session = LessonSession(_singleTargetLesson());
      session.advanceLearn();
      expect(session.phase, LessonPhase.practice);

      // Fail 3 times before passing
      for (var i = 0; i < 3; i++) {
        final outcome = session.submitAnswer(isCorrect: false);
        expect(outcome.requeued, isTrue);
        expect(session.phase, LessonPhase.practice);
      }
      expect(session.submitAnswer(isCorrect: true).nextPhase, LessonPhase.yourTurn);
      expect(session.submitAnswer(isCorrect: true).isCompleted, isTrue);

      expect(session.firstTryCorrectCount, 0);
      expect(session.totalTargets, 1);
      expect(session.firstTryPercentage, 0.0);
    });

    test('deduplicates repeated targets and rejects invalid phase actions', () {
      final duplicateLesson = Lesson(
        id: 'dup-targets',
        skill: Skill.notes,
        order: 1,
        string: 0,
        title: 'Duplicate targets',
        includesAccidentals: false,
        targets: const [
          Position(string: 0, fret: 0),
          Position(string: 0, fret: 1),
          Position(string: 0, fret: 0),
        ],
        steps: [
          LearnStep(
            title: 'Step',
            description: 'Desc',
            highlightedPositions: const [Position(string: 0, fret: 0)],
          ),
        ],
        hint: 'Hint',
      );

      final session = LessonSession(duplicateLesson);
      expect(session.totalTargets, 2);
      expect(() => session.submitAnswer(isCorrect: true), throwsStateError);

      session.advanceLearn();
      expect(() => session.advanceLearn(), throwsStateError);
      expect(session.pendingTargets, hasLength(2));
      expect(
        () => session.pendingTargets.add(const Position(string: 0, fret: 3)),
        throwsUnsupportedError,
      );
      expect(
        () => session.firstTryOutcomes[const Position(string: 0, fret: 3)] = true,
        throwsUnsupportedError,
      );

      session.submitAnswer(isCorrect: true);
      session.submitAnswer(isCorrect: true);
      expect(session.phase, LessonPhase.yourTurn);
      expect(() => session.advanceLearn(), throwsStateError);

      session.submitAnswer(isCorrect: true);
      session.submitAnswer(isCorrect: true);
      expect(session.phase, LessonPhase.completed);
      expect(() => session.advanceLearn(), throwsStateError);
      expect(() => session.submitAnswer(isCorrect: true), throwsStateError);
    });
  });
}
