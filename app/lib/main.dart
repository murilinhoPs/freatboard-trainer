import 'package:material_ui/material_ui.dart';

void main() => runApp(const FretboardApp());

class FretboardApp extends StatelessWidget {
  const FretboardApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
    home: Scaffold(body: Center(child: Text('Fretboard Trainer'))),
  );
}
