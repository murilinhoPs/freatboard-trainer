import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_trainer/main.dart';

void main() {
  testWidgets('displays the initial screen', (tester) async {
    await tester.pumpWidget(const FretboardApp());
    expect(find.text('Fretboard Trainer'), findsOneWidget);
  });
}
