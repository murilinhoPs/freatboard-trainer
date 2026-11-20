import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_core/fretboard_core.dart';
import 'package:fretboard_trainer/design/app_tokens.dart';
import 'package:fretboard_trainer/design/music_text.dart';
import 'package:fretboard_trainer/lesson/learn_stage_page.dart';
import 'package:fretboard_trainer/lesson/note_sequence_player.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Lesson lesson;
  late LessonSession session;
  late _RecordingPlayer player;

  setUp(() {
    lesson = notesCurriculum.first;
    session = LessonSession(lesson);
    player = _RecordingPlayer();
  });

  testWidgets('Aprender mostra o passo, as notas e o progresso', (
    tester,
  ) async {
    await _pump(tester, session, player);
    expect(find.text('Aprender · 1 de 2'), findsOneWidget);
    expect(find.text(lesson.steps.first.title), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) => widget is MusicText && widget.data == 'casa 1',
      ),
      findsOneWidget,
    );

    final semantics = tester.ensureSemantics();
    expect(
      find.bySemanticsLabel('Nota da lição, E, corda E grave, casa 0'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Nota da lição, F, corda E grave, casa 1'),
      findsOneWidget,
    );
    final progress = tester
        .getSemantics(find.bySemanticsLabel('Progresso da lição'))
        .getSemanticsData();
    expect(progress.label, 'Progresso da lição');
    expect(progress.value, '1 de 2');
    semantics.dispose();
  });

  testWidgets('Ouvir, Continuar, sair e confirmação expõem a ação', (
    tester,
  ) async {
    await _pump(tester, session, player);
    final semantics = tester.ensureSemantics();

    for (final label in ['Ouvir', 'Continuar', 'Sair da lição']) {
      final data = tester
          .getSemantics(find.bySemanticsLabel(label))
          .getSemanticsData();
      expect(data.label, contains(label), reason: label);
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
      expect(data.flagsCollection.isEnabled, Tristate.isTrue, reason: label);
      expect(data.flagsCollection.isButton, isTrue, reason: label);
    }

    await tester.tap(find.bySemanticsLabel('Ouvir'));
    await tester.pumpAndSettle();
    expect(player.plays, [lesson.steps.first.highlightedPositions]);

    await tester.tap(find.bySemanticsLabel('Sair da lição'));
    await tester.pumpAndSettle();
    expect(find.text('Sair da sessão?'), findsOneWidget);
    expect(find.text('Esta rodada não será salva.'), findsOneWidget);
    for (final label in ['Cancelar', 'Sair']) {
      final data = tester
          .getSemantics(find.bySemanticsLabel(RegExp('^$label\$')))
          .getSemanticsData();
      expect(data.hasAction(SemanticsAction.tap), isTrue, reason: label);
      expect(data.flagsCollection.isButton, isTrue, reason: label);
    }

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Sair da sessão?'), findsNothing);
    expect(find.text('Aprender · 1 de 2'), findsOneWidget);
    expect(session.phase, LessonPhase.learn);
    expect(session.isCompleted, isFalse);
    expect(player.plays, hasLength(1));

    semantics.dispose();
  });

  testWidgets('Continuar avança o passo e depois inicia Treinar', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, session, player);
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(find.text('Aprender · 2 de 2'), findsOneWidget);
    expect(find.text(lesson.steps[1].title), findsOneWidget);
    expect(
      find.bySemanticsLabel('Nota da lição, G, corda E grave, casa 3'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Nota da lição, A, corda E grave, casa 5'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Nota de referência, F, corda E grave, casa 1'),
      findsOneWidget,
    );

    await tester.tap(find.text('Ouvir'));
    await tester.pumpAndSettle();
    expect(player.plays.last, lesson.steps[1].highlightedPositions);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();
    expect(session.phase, LessonPhase.practice);
    expect(find.bySemanticsLabel('Treinar'), findsOneWidget);
    expect(find.text('Ouvir'), findsNothing);
    expect(find.text('Aprender · 2 de 2'), findsNothing);
    expect(session.isCompleted, isFalse);
    semantics.dispose();
  });

  testWidgets('Sair abandona a rodada sem concluir e sem salvar', (
    tester,
  ) async {
    var abandoned = false;
    final semantics = tester.ensureSemantics();
    await _pump(tester, session, player, onAbandoned: () => abandoned = true);
    await tester.tap(find.bySemanticsLabel('Sair da lição'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();

    expect(abandoned, isTrue);
    expect(find.text('rodada abandonada'), findsOneWidget);
    expect(session.phase, LessonPhase.learn);
    expect(session.learnStepIndex, 0);
    expect(session.isCompleted, isFalse);
    semantics.dispose();
  });

  testWidgets('voltar do sistema pede a mesma confirmação', (tester) async {
    final semantics = tester.ensureSemantics();
    var abandoned = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: spikeTheme(Brightness.dark),
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => LearnStagePage(
                    session: session,
                    player: player,
                    onAbandoned: () {
                      abandoned = true;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();

    await _systemBack();
    await tester.pumpAndSettle();
    expect(find.text('Sair da sessão?'), findsOneWidget);
    expect(find.text('Aprender · 1 de 2'), findsOneWidget);
    expect(abandoned, isFalse);

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Sair da sessão?'), findsNothing);
    expect(find.text('Aprender · 1 de 2'), findsOneWidget);
    expect(find.text('abrir'), findsNothing);
    expect(abandoned, isFalse);

    await _systemBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(abandoned, isTrue);
    expect(find.text('abrir'), findsOneWidget);
    expect(find.text('Aprender · 1 de 2'), findsNothing);
    expect(session.isCompleted, isFalse);
    semantics.dispose();
  });

  testWidgets('Ouvir de novo, Continuar e Sair interrompem a sequência', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, session, player);
    await tester.tap(find.text('Ouvir'));
    await tester.pump();
    expect(player.stops, 1);
    expect(player.plays, hasLength(1));

    await tester.tap(find.text('Ouvir'));
    await tester.pump();
    expect(player.stops, 2);
    expect(player.plays, hasLength(2));

    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(player.stops, 3);
    expect(find.text('Aprender · 2 de 2'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Sair da lição'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sair'));
    await tester.pumpAndSettle();
    expect(player.stops, greaterThanOrEqualTo(4));
    expect(player.plays, hasLength(2));
    semantics.dispose();
  });

  for (final (size, layout) in [
    (const Size(390, 844), 'compacto'),
    (const Size(844, 390), 'expandido'),
  ]) {
    for (final brightness in [Brightness.dark, Brightness.light]) {
      testWidgets('etapa Aprender sem overflow no $layout $brightness', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = size;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        await _pump(tester, session, player, brightness: brightness);
        expect(find.text('Aprender · 1 de 2'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

Future<void> _pump(
  WidgetTester tester,
  LessonSession session,
  NoteSequencePlayer player, {
  VoidCallback? onAbandoned,
  Brightness brightness = Brightness.dark,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: spikeTheme(brightness),
      home: _Host(session: session, player: player, onAbandoned: onAbandoned),
    ),
  );
}

class _Host extends StatefulWidget {
  const _Host({required this.session, required this.player, this.onAbandoned});

  final LessonSession session;
  final NoteSequencePlayer player;
  final VoidCallback? onAbandoned;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  bool _abandoned = false;

  @override
  Widget build(BuildContext context) {
    if (_abandoned) return const Text('rodada abandonada');
    return LearnStagePage(
      session: widget.session,
      player: widget.player,
      onAbandoned: () {
        widget.onAbandoned?.call();
        setState(() => _abandoned = true);
      },
    );
  }
}

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

Future<void> _systemBack() {
  return TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .handlePlatformMessage(
        'flutter/navigation',
        const JSONMessageCodec().encodeMessage(<String, dynamic>{
          'method': 'popRoute',
        }),
        (ByteData? _) {},
      );
}
