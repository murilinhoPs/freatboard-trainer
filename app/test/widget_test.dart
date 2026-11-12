import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fretboard_trainer/design/app_tokens.dart';
import 'package:fretboard_trainer/main.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  test('cores e medidas correspondem aos tokens de origem', () {
    final source = jsonDecode(
      File('../docs/design/tokens.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final colors = source['color'] as Map<String, dynamic>;
    for (final entry in {
      'escuro': AppTokens.escuro,
      'claro': AppTokens.claro,
    }.entries) {
      final expected = colors[entry.key] as Map<String, dynamic>;
      expect(entry.value.keys.toSet(), expected.keys.toSet());
      for (final token in expected.entries) {
        expect(
          entry.value[token.key]!.toARGB32(),
          int.parse('FF${(token.value as String).substring(1)}', radix: 16),
          reason: '${entry.key}.${token.key}',
        );
      }
    }
    final typography = source['type'] as Map<String, dynamic>;
    expect(AppTokens.typography.keys.toSet(), typography.keys.toSet());
    for (final entry in AppTokens.typography.entries) {
      final token = typography[entry.key] as Map<String, dynamic>;
      expect(entry.value.family, token['family']);
      expect(entry.value.size, token['size']);
      expect(entry.value.weight, token['weight']);
      expect(entry.value.lineHeight, token['lineHeight']);
    }
    expect(AppTokens.shadows, source['shadow']);
    for (final entry in {
      'space': AppTokens.space,
      'radius': AppTokens.radius,
      'border': AppTokens.border,
      'size': AppTokens.size,
      'motion': AppTokens.motion,
      'breakpoint': AppTokens.breakpoint,
    }.entries) {
      expect(entry.value, source[entry.key]);
    }
  });

  test('pares de texto aplicáveis atendem contraste AA', () {
    const pairs = [
      ('text', 'bg'),
      ('text', 'surface'),
      ('muted', 'bg'),
      ('muted', 'surface'),
      ('text', 'boardHi'),
      ('onAccent', 'accent'),
      ('onTarget', 'target'),
      ('onOk', 'ok'),
      ('onErr', 'err'),
    ];
    for (final colors in [AppTokens.escuro, AppTokens.claro]) {
      for (final (foreground, background) in pairs) {
        final a = colors[foreground]!.computeLuminance();
        final b = colors[background]!.computeLuminance();
        final ratio = (a > b ? a + .05 : b + .05) / (a < b ? a + .05 : b + .05);
        expect(
          ratio,
          greaterThanOrEqualTo(4.5),
          reason: '$foreground / $background: $ratio',
        );
      }
    }
  });

  testWidgets('troca entre claro, escuro e sistema', (tester) async {
    await tester.pumpWidget(const FretboardApp());
    expect(find.text('C♯  D♭  F♯  B♭'), findsOneWidget);
    ThemeData theme() => Theme.of(tester.element(find.text('Caderno neon')));
    expect(theme().brightness, Brightness.dark);
    await tester.tap(find.text('Claro'));
    await tester.pumpAndSettle();
    expect(theme().brightness, Brightness.light);
    await tester.tap(find.text('Escuro'));
    await tester.pumpAndSettle();
    expect(theme().brightness, Brightness.dark);
    await tester.tap(find.text('Sistema'));
    await tester.pumpAndSettle();
    expect(theme().brightness, tester.platformDispatcher.platformBrightness);
    expect(
      theme().textTheme.bodyMedium!.fontFamilyFallback,
      contains('Noto Music'),
    );
  });
}
