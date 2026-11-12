import 'package:material_ui/material_ui.dart';

import 'design/app_tokens.dart';
import 'spike_board.dart';

void main() => runApp(const FretboardApp());

class FretboardApp extends StatefulWidget {
  const FretboardApp({super.key});

  @override
  State<FretboardApp> createState() => _FretboardAppState();
}

class _FretboardAppState extends State<FretboardApp> {
  ThemeMode mode = ThemeMode.dark;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Fretboard Trainer',
    theme: spikeTheme(Brightness.light),
    darkTheme: spikeTheme(Brightness.dark),
    themeMode: mode,
    home: Builder(
      builder: (context) {
        final tokens = Theme.of(context).extension<AppTokens>()!;
        final text = tokens.color('text');
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Caderno neon', style: spikeTitle(text)),
                      TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SpikeBoardPage(),
                          ),
                        ),
                        child: const Text('Abrir spike do braço'),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Amostra de temas e fontes',
                        style: TextStyle(
                          color: tokens.color('muted'),
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        children: [
                          for (final entry in const [
                            (ThemeMode.dark, 'Escuro'),
                            (ThemeMode.light, 'Claro'),
                            (ThemeMode.system, 'Sistema'),
                          ])
                            ChoiceChip(
                              label: Text(entry.$2),
                              selected: mode == entry.$1,
                              selectedColor: tokens.color('accent'),
                              backgroundColor: tokens.color('surface'),
                              labelStyle: TextStyle(
                                color: mode == entry.$1
                                    ? tokens.color('onAccent')
                                    : text,
                              ),
                              onSelected: (_) =>
                                  setState(() => mode = entry.$1),
                            ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: tokens.color('surface'),
                          border: Border.all(
                            color: tokens.color('cardBorder'),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MusicText(
                              'C♯  D♭  F♯  B♭',
                              style: spikeTitle(text),
                            ),
                            const SizedBox(height: 12),
                            MusicText(
                              'Notas: C♯ e D♭',
                              style: TextStyle(
                                color: text,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final pair in const [
                                  ('accent', 'onAccent', 'Acento'),
                                  ('target', 'onTarget', 'Alvo'),
                                  ('ok', 'onOk', 'Acerto'),
                                  ('err', 'onErr', 'Erro'),
                                ])
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: tokens.color(pair.$1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      pair.$3,
                                      style: TextStyle(
                                        color: tokens.color(pair.$2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

/// Alinha os glifos musicais da fonte de fallback às letras da fonte principal.
class MusicText extends StatelessWidget {
  const MusicText(this.data, {required this.style, super.key});

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final spans = <InlineSpan>[];
    final symbols = RegExp('[♯♭]');
    var start = 0;
    for (final match in symbols.allMatches(data)) {
      if (match.start > start) {
        spans.add(TextSpan(text: data.substring(start, match.start)));
      }
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: Transform.translate(
            offset: Offset(0, -(style.fontSize ?? 14) * 0.16),
            child: Text(
              match.group(0)!,
              style: style.copyWith(fontFamily: 'Noto Music'),
            ),
          ),
        ),
      );
      start = match.end;
    }
    if (start < data.length) spans.add(TextSpan(text: data.substring(start)));
    return Text.rich(
      TextSpan(style: style, children: spans),
      semanticsLabel: data,
    );
  }
}
