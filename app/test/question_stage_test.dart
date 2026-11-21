import 'dart:ui' show PointerDeviceKind, Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_core/fretboard_core.dart';
import 'package:fretboard_trainer/design/app_tokens.dart';
import 'package:fretboard_trainer/lesson/learn_stage_page.dart';
import 'package:fretboard_trainer/lesson/note_sequence_player.dart';
import 'package:fretboard_trainer/lesson/question_stage_view.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Treinar mostra referências e dica sem revelar resposta; Sua vez oculta ambos',
    (tester) async {
      final lesson = notesCurriculum[2]; // Sustenidos na corda E grave (com várias refs)
      final session = LessonSession(lesson);
      for (var i = 0; i < lesson.steps.length; i++) {
        session.advanceLearn();
      }
      final player = _RecordingPlayer();
      final results = <QuestionAnswerResult>[];
      final semantics = tester.ensureSemantics();

      await _pumpLesson(
        tester,
        session: session,
        player: player,
        onAnswerEvaluated: results.add,
        questionBuilder: ({
          required target,
          required phase,
          required includesAccidentals,
          required attemptIndex,
        }) {
          return generateQuestionForTarget(
            target: target,
            phase: phase,
            includesAccidentals: includesAccidentals,
            kind: QuestionKind.nameNote,
            seed: attemptIndex,
          );
        },
      );

      expect(find.text('Treino'), findsOneWidget);
      expect(find.bySemanticsLabel('Dica'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp(r'^Nota de referência, ')),
        findsWidgets,
      );

      // Dica: ação semântica, mostra texto curto sem revelar resposta
      final hintSemantics = tester
          .getSemantics(find.bySemanticsLabel('Dica'))
          .getSemanticsData();
      expect(hintSemantics.hasAction(SemanticsAction.tap), isTrue);
      expect(hintSemantics.flagsCollection.isButton, isTrue);
      expect(hintSemantics.flagsCollection.isEnabled, Tristate.isTrue);

      await tester.tap(find.bySemanticsLabel('Dica'));
      await tester.pumpAndSettle();
      expect(find.text(lesson.hint), findsOneWidget);

      // Responder todas as perguntas de Treinar com 1 toque sem confirmação
      while (session.phase == LessonPhase.practice) {
        final target = session.currentTarget!;
        final note = noteAt(standardGuitar, target);
        final label = _pitchLabel(note);
        final optionSemantics = tester
            .getSemantics(find.bySemanticsLabel(label))
            .getSemanticsData();
        expect(optionSemantics.hasAction(SemanticsAction.tap), isTrue);
        expect(optionSemantics.flagsCollection.isButton, isTrue);
        await tester.tap(find.bySemanticsLabel(label));
        await tester.pumpAndSettle();
      }

      expect(session.phase, LessonPhase.yourTurn);
      expect(results.every((r) => r.usesLongFeedback), isTrue);
      expect(find.text('Sua vez'), findsOneWidget);
      expect(find.bySemanticsLabel('Dica'), findsNothing);
      expect(find.text(lesson.hint), findsNothing);
      expect(
        find.bySemanticsLabel(RegExp(r'^Nota de referência, ')),
        findsNothing,
      );

      // Em Sua vez com sustenidos, NameNote tem 12 opções cromáticas
      for (final pitch in PitchClass.values) {
        expect(find.bySemanticsLabel(_pitchLabel(pitch)), findsOneWidget);
      }

      // Responder uma pergunta em Sua vez -> usesLongFeedback == false
      final firstYourTurnTarget = session.currentTarget!;
      final firstNoteLabel = _pitchLabel(
        noteAt(standardGuitar, firstYourTurnTarget),
      );
      await tester.tap(find.bySemanticsLabel(firstNoteLabel));
      await tester.pumpAndSettle();
      expect(results.last.phase, LessonPhase.yourTurn);
      expect(results.last.usesLongFeedback, isFalse);
      expect(player.plays, isNotEmpty);

      semantics.dispose();
    },
  );

  testWidgets('Sua vez em lição só de naturais exibe 7 opções', (tester) async {
    final lesson = notesCurriculum.first; // Naturais na corda E grave
    final session = LessonSession(lesson);
    for (var i = 0; i < lesson.steps.length; i++) {
      session.advanceLearn();
    }
    while (session.phase == LessonPhase.practice) {
      session.submitAnswer(isCorrect: true);
    }

    await _pumpLesson(
      tester,
      session: session,
      player: _RecordingPlayer(),
      questionBuilder: ({
        required target,
        required phase,
        required includesAccidentals,
        required attemptIndex,
      }) => generateQuestionForTarget(
        target: target,
        phase: phase,
        includesAccidentals: includesAccidentals,
        kind: QuestionKind.nameNote,
        seed: attemptIndex,
      ),
    );

    expect(find.text('Sua vez'), findsOneWidget);
    for (final natural in const [
      PitchClass.c,
      PitchClass.d,
      PitchClass.e,
      PitchClass.f,
      PitchClass.g,
      PitchClass.a,
      PitchClass.b,
    ]) {
      expect(find.bySemanticsLabel(_pitchLabel(natural)), findsOneWidget);
    }
    expect(find.bySemanticsLabel('C♯'), findsNothing);
  });

  testWidgets(
    'FindOnString, FindAtFret e OpenString respondem por toque no braço com semântica',
    (tester) async {
      final lesson = notesCurriculum.first;
      final session = LessonSession(lesson);
      for (var i = 0; i < lesson.steps.length; i++) {
        session.advanceLearn();
      }
      final player = _RecordingPlayer();
      final results = <QuestionAnswerResult>[];
      final kinds = [
        QuestionKind.openString,
        QuestionKind.findOnString,
        QuestionKind.findAtFret,
      ];
      final semantics = tester.ensureSemantics();

      await _pumpLesson(
        tester,
        session: session,
        player: player,
        onAnswerEvaluated: results.add,
        questionBuilder: ({
          required target,
          required phase,
          required includesAccidentals,
          required attemptIndex,
        }) {
          final kind = kinds[attemptIndex % kinds.length];
          if (kind == QuestionKind.openString && target.fret != 0) {
            return generateQuestionForTarget(
              target: target,
              phase: phase,
              includesAccidentals: includesAccidentals,
              kind: QuestionKind.findOnString,
              seed: attemptIndex,
            );
          }
          return generateQuestionForTarget(
            target: target,
            phase: phase,
            includesAccidentals: includesAccidentals,
            kind: kind,
            seed: attemptIndex,
          );
        },
      );

      // 1. OpenString (target: string 0, fret 0)
      expect(find.text('Toque na corda E grave solta'), findsOneWidget);
      expect(find.text('Toque no braço'), findsOneWidget);
      final openCellLabel = 'Corda E grave, casa 0 (solta)';
      final openSemantics = tester
          .getSemantics(find.bySemanticsLabel(openCellLabel))
          .getSemanticsData();
      expect(openSemantics.hasAction(SemanticsAction.tap), isTrue);
      expect(openSemantics.flagsCollection.isButton, isTrue);
      expect(openSemantics.label.contains('nota'), isFalse);

      await tester.tap(find.bySemanticsLabel(openCellLabel));
      await tester.pumpAndSettle();
      expect(results.last.evaluation.isCorrect, isTrue);
      expect(player.plays.last, [const Position(string: 0, fret: 0)]);

      // 2. FindOnString (target: string 0, fret 1 -> F)
      expect(find.text('Ache o F na corda E grave'), findsOneWidget);
      final fret1Label = 'Corda E grave, casa 1';
      final fret1Semantics = tester
          .getSemantics(find.bySemanticsLabel(fret1Label))
          .getSemanticsData();
      expect(fret1Semantics.hasAction(SemanticsAction.tap), isTrue);
      expect(fret1Semantics.flagsCollection.isButton, isTrue);

      await tester.tap(find.bySemanticsLabel(fret1Label));
      await tester.pumpAndSettle();
      expect(results.last.evaluation.isCorrect, isTrue);

      // 3. FindAtFret (target: string 0, fret 3 -> G)
      expect(find.text('Ache o G na casa 3'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Corda E grave, casa 3'));
      await tester.pumpAndSettle();
      expect(results.last.evaluation.isCorrect, isTrue);

      semantics.dispose();
    },
  );

  testWidgets('Hover no desktop destaca a célula sem erros', (tester) async {
    final lesson = notesCurriculum.first;
    final session = LessonSession(lesson);
    for (var i = 0; i < lesson.steps.length; i++) {
      session.advanceLearn();
    }
    await _pumpLesson(
      tester,
      session: session,
      player: _RecordingPlayer(),
      questionBuilder: ({
        required target,
        required phase,
        required includesAccidentals,
        required attemptIndex,
      }) => generateQuestionForTarget(
        target: target,
        phase: phase,
        includesAccidentals: includesAccidentals,
        kind: QuestionKind.findOnString,
        seed: attemptIndex,
      ),
    );

    final cellFinder = find.byKey(const ValueKey('question-cell-0-1'));
    expect(cellFinder, findsOneWidget);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(cellFinder));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  for (final (size, layout) in [
    (const Size(390, 844), 'compacto'),
    (const Size(844, 390), 'expandido'),
  ]) {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      testWidgets('perguntas sem overflow no $layout $brightness', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        final lesson = notesCurriculum[2]; // 12 opções em Sua vez
        final session = LessonSession(lesson);
        for (var i = 0; i < lesson.steps.length; i++) {
          session.advanceLearn();
        }
        while (session.phase == LessonPhase.practice) {
          session.submitAnswer(isCorrect: true);
        }

        await _pumpLesson(
          tester,
          session: session,
          player: _RecordingPlayer(),
          brightness: brightness,
          questionBuilder: ({
            required target,
            required phase,
            required includesAccidentals,
            required attemptIndex,
          }) => generateQuestionForTarget(
            target: target,
            phase: phase,
            includesAccidentals: includesAccidentals,
            kind: QuestionKind.nameNote,
            seed: attemptIndex,
          ),
        );

        expect(find.text('Sua vez'), findsOneWidget);
        expect(find.text('Que nota é essa?'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

Future<void> _pumpLesson(
  WidgetTester tester, {
  required LessonSession session,
  required NoteSequencePlayer player,
  ValueChanged<QuestionAnswerResult>? onAnswerEvaluated,
  QuestionBuilder? questionBuilder,
  Brightness brightness = Brightness.dark,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: spikeTheme(brightness),
      home: LearnStagePage(
        session: session,
        player: player,
        onAbandoned: () {},
        onAnswerEvaluated: onAnswerEvaluated,
        questionBuilder: questionBuilder,
      ),
    ),
  );
}

String _pitchLabel(PitchClass pitch) => const [
  'C',
  'C♯',
  'D',
  'D♯',
  'E',
  'F',
  'F♯',
  'G',
  'G♯',
  'A',
  'A♯',
  'B',
][pitch.index];

final class _RecordingPlayer implements NoteSequencePlayer {
  final plays = <List<Position>>[];
  int stops = 0;

  @override
  void stop() => stops++;

  @override
  Future<void> play(List<Position> positions) async {
    plays.add(List<Position>.of(positions));
  }
}
