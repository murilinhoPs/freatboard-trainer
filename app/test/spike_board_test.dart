import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_trainer/design/app_tokens.dart';
import 'package:fretboard_trainer/spike_board.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  for (final size in [const Size(390, 844), const Size(844, 390)]) {
    testWidgets('seleciona bordas e espelha em $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          theme: spikeTheme(Brightness.dark),
          home: const SpikeBoardPage(),
        ),
      );
      final cell = find.byKey(const ValueKey('cell-0-0'));
      final rect = tester.getRect(cell);
      await tester.tapAt(rect.topLeft + const Offset(2, 2));
      await tester.pump();
      expect(find.text('Corda e · casa 0'), findsOneWidget);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
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
      expect(find.text('Corda E · casa 6'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
