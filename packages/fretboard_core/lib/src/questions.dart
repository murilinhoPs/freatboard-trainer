import 'dart:math';

import '../fretboard_core.dart';

/// Question kinds supported in Notes lessons.
enum QuestionKind { findOnString, findAtFret, openString, nameNote }

const List<PitchClass> _naturalNotes = [
  PitchClass.c,
  PitchClass.d,
  PitchClass.e,
  PitchClass.f,
  PitchClass.g,
  PitchClass.a,
  PitchClass.b,
];

/// Pure Dart representation of a lesson question.
sealed class Question {
  const Question({required this.target, required this.targetNote});

  final Position target;
  final PitchClass targetNote;

  QuestionKind get kind;

  /// Whether the user answers by tapping a fretboard cell rather than a note button.
  bool get isBoardTapQuestion => kind != QuestionKind.nameNote;
}

/// Ask the user to tap [note] on [string].
final class FindOnString extends Question {
  const FindOnString({
    required super.target,
    required this.note,
    required this.string,
  }) : super(targetNote: note);

  final PitchClass note;
  final int string;

  @override
  QuestionKind get kind => QuestionKind.findOnString;

  @override
  bool operator ==(Object other) =>
      other is FindOnString &&
      target == other.target &&
      note == other.note &&
      string == other.string;

  @override
  int get hashCode => Object.hash(kind, target, note, string);
}

/// Ask the user to tap [note] at [fret].
final class FindAtFret extends Question {
  const FindAtFret({
    required super.target,
    required this.note,
    required this.fret,
  }) : super(targetNote: note);

  final PitchClass note;
  final int fret;

  @override
  QuestionKind get kind => QuestionKind.findAtFret;

  @override
  bool operator ==(Object other) =>
      other is FindAtFret &&
      target == other.target &&
      note == other.note &&
      fret == other.fret;

  @override
  int get hashCode => Object.hash(kind, target, note, fret);
}

/// Ask the user to tap the open [string] (fret 0).
final class OpenString extends Question {
  OpenString({
    required this.string,
    required super.targetNote,
  }) : super(target: Position(string: string, fret: 0));

  final int string;

  @override
  QuestionKind get kind => QuestionKind.openString;

  @override
  bool operator ==(Object other) =>
      other is OpenString &&
      target == other.target &&
      targetNote == other.targetNote &&
      string == other.string;

  @override
  int get hashCode => Object.hash(kind, target, targetNote, string);
}

/// Ask the user to name the note at [target] using [options].
final class NameNote extends Question {
  NameNote({
    required super.target,
    required super.targetNote,
    required List<PitchClass> options,
  }) : options = List.unmodifiable(options) {
    if (!this.options.contains(targetNote)) {
      throw ArgumentError('Options must contain targetNote $targetNote');
    }
  }

  final List<PitchClass> options;

  @override
  QuestionKind get kind => QuestionKind.nameNote;

  @override
  bool operator ==(Object other) =>
      other is NameNote &&
      target == other.target &&
      targetNote == other.targetNote &&
      _pitchListEquals(options, other.options);

  @override
  int get hashCode =>
      Object.hash(kind, target, targetNote, Object.hashAll(options));
}

bool _pitchListEquals(List<PitchClass> a, List<PitchClass> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Evaluation result for a submitted answer.
final class QuestionEvaluation {
  const QuestionEvaluation({
    required this.isCorrect,
    required this.target,
    required this.targetNote,
    required this.explanation,
    this.tappedPosition,
    this.selectedNote,
  });

  final bool isCorrect;
  final Position target;
  final PitchClass targetNote;
  final Position? tappedPosition;
  final PitchClass? selectedNote;
  final Explanation explanation;

  @override
  bool operator ==(Object other) =>
      other is QuestionEvaluation &&
      isCorrect == other.isCorrect &&
      target == other.target &&
      targetNote == other.targetNote &&
      tappedPosition == other.tappedPosition &&
      selectedNote == other.selectedNote &&
      explanation == other.explanation;

  @override
  int get hashCode => Object.hash(
    isCorrect,
    target,
    targetNote,
    tappedPosition,
    selectedNote,
    explanation,
  );
}

/// Generates a deterministic [Question] for [target] in [phase].
///
/// In [LessonPhase.practice], `NameNote` has 4 options.
/// In [LessonPhase.yourTurn], `NameNote` has 7 natural options when
/// [includesAccidentals] is `false`, or 12 chromatic options when `true`.
Question generateQuestionForTarget({
  required Position target,
  required LessonPhase phase,
  required bool includesAccidentals,
  Instrument? instrument,
  QuestionKind? kind,
  int seed = 0,
}) {
  if (phase != LessonPhase.practice && phase != LessonPhase.yourTurn) {
    throw ArgumentError.value(
      phase,
      'phase',
      'Questions can only be generated for practice or yourTurn.',
    );
  }

  final inst = instrument ?? standardGuitar;
  final note = noteAt(inst, target);
  if (!includesAccidentals && !_naturalNotes.contains(note)) {
    throw ArgumentError(
      'Target $target produces accidental $note with includesAccidentals=false.',
    );
  }

  final availableKinds = <QuestionKind>[
    QuestionKind.findOnString,
    QuestionKind.findAtFret,
    if (target.fret == 0) QuestionKind.openString,
    QuestionKind.nameNote,
  ];

  final selectedKind =
      kind ??
      availableKinds[_deterministicSeed(seed, target, phase) %
          availableKinds.length];

  if (selectedKind == QuestionKind.openString && target.fret != 0) {
    throw ArgumentError.value(
      target,
      'target',
      'OpenString requires fret 0.',
    );
  }

  return switch (selectedKind) {
    QuestionKind.findOnString => FindOnString(
      target: target,
      note: note,
      string: target.string,
    ),
    QuestionKind.findAtFret => FindAtFret(
      target: target,
      note: note,
      fret: target.fret,
    ),
    QuestionKind.openString => OpenString(
      string: target.string,
      targetNote: note,
    ),
    QuestionKind.nameNote => NameNote(
      target: target,
      targetNote: note,
      options: _buildNameNoteOptions(
        correctNote: note,
        phase: phase,
        includesAccidentals: includesAccidentals,
        seed: _deterministicSeed(seed, target, phase),
      ),
    ),
  };
}

/// Generates deterministic questions for all targets of [lesson] in [phase].
List<Question> generateLessonPhaseQuestions({
  required Lesson lesson,
  required LessonPhase phase,
  int seed = 0,
  Instrument? instrument,
}) {
  return List.unmodifiable([
    for (var i = 0; i < lesson.targets.length; i++)
      generateQuestionForTarget(
        target: lesson.targets[i],
        phase: phase,
        includesAccidentals: lesson.includesAccidentals,
        instrument: instrument,
        seed: seed + i,
      ),
  ]);
}

/// Evaluates a fretboard tap answer against [question].
QuestionEvaluation evaluatePositionAnswer(
  Question question,
  Position tapped, {
  Instrument? instrument,
  Position? anchor,
}) {
  if (!question.isBoardTapQuestion) {
    throw ArgumentError(
      'NameNote questions must be evaluated with evaluateNoteAnswer.',
    );
  }
  final inst = instrument ?? standardGuitar;
  final tappedNote = noteAt(inst, tapped);

  final isCorrect = switch (question) {
    FindOnString(:final string, :final note) =>
      tapped.string == string && tappedNote == note,
    FindAtFret(:final fret, :final note) =>
      tapped.fret == fret && tappedNote == note,
    OpenString(:final string) =>
      tapped.string == string && tapped.fret == 0,
    NameNote() => throw StateError('Unreachable'),
  };

  final explainedPosition = isCorrect ? tapped : question.target;
  return QuestionEvaluation(
    isCorrect: isCorrect,
    target: question.target,
    targetNote: question.targetNote,
    tappedPosition: tapped,
    explanation: explainPosition(inst, explainedPosition, anchor: anchor),
  );
}

/// Evaluates a note button selection against a [NameNote] question.
QuestionEvaluation evaluateNoteAnswer(
  NameNote question,
  PitchClass selected, {
  Instrument? instrument,
  Position? anchor,
}) {
  if (!question.options.contains(selected)) {
    throw ArgumentError.value(
      selected,
      'selected',
      'Selected note is not among the question options.',
    );
  }
  final inst = instrument ?? standardGuitar;
  final isCorrect = selected == question.targetNote;
  return QuestionEvaluation(
    isCorrect: isCorrect,
    target: question.target,
    targetNote: question.targetNote,
    selectedNote: selected,
    explanation: explainPosition(inst, question.target, anchor: anchor),
  );
}

int _deterministicSeed(int seed, Position target, LessonPhase phase) {
  var hash = 0x811c9dc5;
  for (final value in [seed, target.string, target.fret, phase.index]) {
    hash ^= value & 0xffffffff;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

List<PitchClass> _buildNameNoteOptions({
  required PitchClass correctNote,
  required LessonPhase phase,
  required bool includesAccidentals,
  required int seed,
}) {
  if (phase == LessonPhase.yourTurn) {
    return includesAccidentals
        ? List<PitchClass>.unmodifiable(PitchClass.values)
        : List<PitchClass>.unmodifiable(_naturalNotes);
  }

  final pool = includesAccidentals
      ? PitchClass.values.where((n) => n != correctNote).toList()
      : _naturalNotes.where((n) => n != correctNote).toList();

  final rng = Random(seed);
  // Deterministic Fisher-Yates shuffle on the distractor pool.
  for (var i = pool.length - 1; i > 0; i--) {
    final j = rng.nextInt(i + 1);
    final tmp = pool[i];
    pool[i] = pool[j];
    pool[j] = tmp;
  }

  final selected = <PitchClass>[correctNote, ...pool.take(3)]
    ..sort((a, b) => a.index.compareTo(b.index));
  return List<PitchClass>.unmodifiable(selected);
}
