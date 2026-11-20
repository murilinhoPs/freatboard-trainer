import 'package:material_ui/material_ui.dart';

/// Centro vertical (em em, acima da linha de base) do glifo no Noto Music,
/// medido no bbox do arquivo da fonte (ver `docs/spike-fontes.md`).
const _notoMusicGlyphCenter = {'♯': 0.131, '♭': 0.280};

/// Meia altura de maiúsculas (em em) de cada família principal.
const _capHeightCenter = {
  'Space Grotesk': 0.350,
  'Atkinson Hyperlegible': 0.334,
};

/// Deslocamento para cima, em frações do tamanho da fonte, que centraliza o
/// glifo musical na altura das maiúsculas da família principal. ♯ e ♭ têm
/// centros diferentes no Noto Music, então cada um tem seu ajuste.
double musicGlyphRise(String symbol, String? fontFamily) {
  final capCenter =
      _capHeightCenter[fontFamily] ??
      _capHeightCenter['Atkinson Hyperlegible']!;
  return capCenter - (_notoMusicGlyphCenter[symbol] ?? capCenter);
}

/// Alinha os glifos musicais da fonte de fallback às letras da fonte principal.
class MusicText extends StatelessWidget {
  const MusicText(this.data, {required this.style, super.key});

  final String data;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    // Família e tamanho efetivos: o corpo herda Atkinson do tema.
    final effective = DefaultTextStyle.of(context).style.merge(style);
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
            offset: Offset(
              0,
              -(effective.fontSize ?? 14) *
                  musicGlyphRise(match.group(0)!, effective.fontFamily),
            ),
            child: Text(
              match.group(0)!,
              style: effective.copyWith(fontFamily: 'Noto Music'),
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
