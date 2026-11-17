import '../fretboard_core.dart';

/// Sequential stages of a Notes lesson.
enum LessonPhase { learn, practice, yourTurn, completed }

/// Result of submitting an answer for the current target in a [LessonSession].
final class AnswerOutcome {
  const AnswerOutcome({
    required this.target,
    required this.isCorrect,
    required this.previousPhase,
    required this.nextPhase,
    required this.requeued,
    required this.isCompleted,
  });

  final Position target;
  final bool isCorrect;
  final LessonPhase previousPhase;
  final LessonPhase nextPhase;
  final bool requeued;
  final bool isCompleted;

  @override
  bool operator ==(Object other) =>
      other is AnswerOutcome &&
      target == other.target &&
      isCorrect == other.isCorrect &&
      previousPhase == other.previousPhase &&
      nextPhase == other.nextPhase &&
      requeued == other.requeued &&
      isCompleted == other.isCompleted;

  @override
  int get hashCode => Object.hash(
    target,
    isCorrect,
    previousPhase,
    nextPhase,
    requeued,
    isCompleted,
  );
}

/// Pure Dart state machine for a lesson: Learn -> Practice -> Your Turn -> Completed.
///
/// Wrong answers are requeued at the end of the current phase's queue until
/// answered correctly. Each target is counted once for the first-try metric
/// based solely on its first answer in the lesson.
final class LessonSession {
  LessonSession(this.lesson)
    : _uniqueTargets = _deduplicateTargets(lesson.targets);

  final Lesson lesson;
  final List<Position> _uniqueTargets;

  LessonPhase _phase = LessonPhase.learn;
  int _learnStepIndex = 0;
  final List<Position> _queue = [];
  final Map<Position, bool> _firstTryOutcomes = {};

  static List<Position> _deduplicateTargets(List<Position> targets) {
    final seen = <Position>{};
    return List.unmodifiable([
      for (final target in targets)
        if (seen.add(target)) target,
    ]);
  }

  /// Current lesson phase.
  LessonPhase get phase => _phase;

  /// Zero-based index of the active step while in [LessonPhase.learn].
  int get learnStepIndex => _learnStepIndex;

  /// Active learn step, or `null` outside [LessonPhase.learn].
  LearnStep? get currentLearnStep =>
      _phase == LessonPhase.learn ? lesson.steps[_learnStepIndex] : null;

  /// Front target of the active question queue, or `null` in learn/completed.
  Position? get currentTarget => _queue.isEmpty ? null : _queue.first;

  /// Unmodifiable snapshot of remaining targets in the current phase queue.
  List<Position> get pendingTargets => List.unmodifiable(_queue);

  /// Distinct target count used as the denominator for first-try accuracy.
  int get totalTargets => _uniqueTargets.length;

  /// Number of distinct targets answered correctly on their first attempt.
  int get firstTryCorrectCount =>
      _firstTryOutcomes.values.where((correct) => correct).length;

  /// First-try accuracy percentage in the range `0.0..100.0`.
  double get firstTryPercentage => (firstTryCorrectCount / totalTargets) * 100;

  /// Recorded first-attempt outcome (`true` = correct) per target so far.
  Map<Position, bool> get firstTryOutcomes =>
      Map.unmodifiable(_firstTryOutcomes);

  /// Whether the lesson has reached [LessonPhase.completed].
  bool get isCompleted => _phase == LessonPhase.completed;

  /// Advances from the current learn step to the next one, or transitions to
  /// [LessonPhase.practice] after the last learn step.
  void advanceLearn() {
    if (_phase != LessonPhase.learn) {
      throw StateError(
        'Cannot advance learn step while in phase $_phase.',
      );
    }
    if (_learnStepIndex + 1 < lesson.steps.length) {
      _learnStepIndex++;
      return;
    }
    _phase = LessonPhase.practice;
    _queue
      ..clear()
      ..addAll(_uniqueTargets);
  }

  /// Evaluates the current target in [LessonPhase.practice] or
  /// [LessonPhase.yourTurn].
  ///
  /// When [isCorrect] is `false`, the target is appended to the end of the
  /// active phase queue. Transitions to the next phase when the queue empties.
  AnswerOutcome submitAnswer({required bool isCorrect}) {
    if (_phase != LessonPhase.practice && _phase != LessonPhase.yourTurn) {
      throw StateError(
        'Cannot submit an answer while in phase $_phase.',
      );
    }

    final previousPhase = _phase;
    final target = _queue.removeAt(0);
    _firstTryOutcomes.putIfAbsent(target, () => isCorrect);

    final requeued = !isCorrect;
    if (requeued) {
      _queue.add(target);
    } else if (_queue.isEmpty) {
      if (_phase == LessonPhase.practice) {
        _phase = LessonPhase.yourTurn;
        _queue.addAll(_uniqueTargets);
      } else {
        _phase = LessonPhase.completed;
      }
    }

    return AnswerOutcome(
      target: target,
      isCorrect: isCorrect,
      previousPhase: previousPhase,
      nextPhase: _phase,
      requeued: requeued,
      isCompleted: isCompleted,
    );
  }
}
