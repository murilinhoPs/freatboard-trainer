import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_trainer/design/app_tokens.dart';
import 'package:fretboard_trainer/spike_board.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('uses standard tuning and labels the handedness switch', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: spikeTheme(Brightness.dark)
            .copyWith(splashFactory: InkRipple.splashFactory),
        home: const SpikeBoardPage(),
      ),
    );
    await tester.tap(find.byKey(const ValueKey('cell-4-2')));
    await tester.pump();
    expect(find.text('Corda A · casa 2 · B'), findsOneWidget);
    expect(find.text('Canhoto'), findsOneWidget);
    final switchFinder = find.bySemanticsLabel('Canhoto');
    expect(switchFinder, findsOneWidget);
    final accessibleSwitch = switchFinder;
    final initialData = tester
        .getSemantics(accessibleSwitch)
        .getSemanticsData();
    expect(initialData.hasAction(SemanticsAction.tap), isTrue);
    expect(initialData.flagsCollection.isEnabled, Tristate.isTrue);
    expect(initialData.flagsCollection.isToggled, Tristate.isFalse);
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    final toggledData = tester
        .getSemantics(accessibleSwitch)
        .getSemanticsData();
    expect(toggledData.hasAction(SemanticsAction.tap), isTrue);
    expect(toggledData.flagsCollection.isEnabled, Tristate.isTrue);
    expect(toggledData.flagsCollection.isToggled, Tristate.isTrue);
    await tester.tap(find.byKey(const ValueKey('cell-4-0')));
    await tester.pump();
    expect(find.text('Corda A · casa 0 · A'), findsOneWidget);
  });

  testWidgets('voltar em paisagem retorna à tela anterior', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: spikeTheme(Brightness.dark)
            .copyWith(splashFactory: InkRipple.splashFactory),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SpikeBoardPage()),
              ),
              child: const Text('Abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Abrir'), findsOneWidget);
    expect(find.byType(SpikeBoardPage), findsNothing);
  });

  for (final size in [const Size(390, 844), const Size(844, 390)]) {
    testWidgets('seleciona bordas e espelha em $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: spikeTheme(Brightness.dark)
              .copyWith(splashFactory: InkRipple.splashFactory),
          home: const SpikeBoardPage(),
        ),
      );
      final cell = find.byKey(const ValueKey('cell-0-0'));
      final rect = tester.getRect(cell);
      await tester.tapAt(rect.topLeft + const Offset(2, 2));
      await tester.pump();
      expect(find.text('Corda e · casa 0 · E'), findsOneWidget);
      Border cellBorder() =>
          (tester
                          .widget<Container>(
                            find
                                .descendant(
                                  of: cell,
                                  matching: find.byWidgetPredicate(
                                    (widget) =>
                                        widget is Container &&
                                        widget.decoration is BoxDecoration,
                                  ),
                                )
                                .first,
                          )
                          .decoration!
                      as BoxDecoration)
                  .border!
              as Border;
      expect(cellBorder().right.width, 6);
      expect(cellBorder().left.width, 0);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(cellBorder().left.width, 6);
      expect(cellBorder().right.width, 0);
      expect(
        tester.getTopLeft(cell).dx,
        greaterThan(
          tester.getTopLeft(find.byKey(const ValueKey('cell-0-5'))).dx,
        ),
      );
      await tester.tap(find.byTooltip('Próxima janela'));
      await tester.pumpAndSettle();
      expect(find.text('Casas 1–6'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('cell-5-6')));
      await tester.tap(find.byKey(const ValueKey('cell-5-6')));
      await tester.pump();
      expect(find.text('Corda E · casa 6 · A♯'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('a janela alcança casas 17–22 sem inverter ordem das cordas', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(844, 390);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      MaterialApp(
        theme: spikeTheme(Brightness.dark)
            .copyWith(splashFactory: InkRipple.splashFactory),
        home: const SpikeBoardPage(),
      ),
    );
    for (var i = 0; i < 17; i++) {
      await tester.tap(find.byTooltip('Próxima janela'));
      await tester.pump();
    }
    expect(find.text('Casas 17–22'), findsOneWidget);
    expect(find.byKey(const ValueKey('cell-0-22')), findsOneWidget);
    expect(
      tester.getTopLeft(find.byKey(const ValueKey('cell-0-17'))).dy,
      lessThan(tester.getTopLeft(find.byKey(const ValueKey('cell-5-17'))).dy),
    );
    expect(tester.takeException(), isNull);
  });
}
