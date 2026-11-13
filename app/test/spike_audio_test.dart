import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('amostra do spike está disponível como WAV', (tester) async {
    final data = await rootBundle.load('assets/audio/pluck-a2.wav');
    final bytes = data.buffer.asUint8List();
    expect(String.fromCharCodes(bytes.sublist(0, 4)), 'RIFF');
    expect(String.fromCharCodes(bytes.sublist(8, 12)), 'WAVE');
    expect(bytes.length, greaterThan(44));
  });
}
