import 'package:material_ui/material_ui.dart';

/// Tokens do spike, espelhados de docs/design/tokens.json.
@immutable
class AppTokens extends ThemeExtension<AppTokens> {
  const AppTokens(this.colors);
  final Map<String, Color> colors;
  Color color(String name) => colors[name]!;

  static const escuro = <String, Color>{
    'bg': Color(0xFF0D0F1A),
    'grid': Color(0xFF181C32),
    'surface': Color(0xFF171A2B),
    'text': Color(0xFFEEF0FF),
    'muted': Color(0xFF9AA0C3),
    'line': Color(0xFF2A2E4A),
    'ink': Color(0xFFEEF0FF),
    'cardBorder': Color(0xFF2A2E4A),
    'accent': Color(0xFFB9A6FF),
    'onAccent': Color(0xFF120A33),
    'pop': Color(0xFFB9A6FF),
    'optionBorder': Color(0xFFEEF0FF),
    'board': Color(0xFF121526),
    'boardHi': Color(0xFF2A3370),
    'fret': Color(0xFF5A6296),
    'string': Color(0xFFAEB5DD),
    'inlay': Color(0xFF2A3058),
    'target': Color(0xFFFFD84D),
    'onTarget': Color(0xFF221A00),
    'ok': Color(0xFF5CF08A),
    'onOk': Color(0xFF06210F),
    'okSoft': Color(0xFF12281F),
    'err': Color(0xFFFF6B8B),
    'onErr': Color(0xFF33030F),
    'errSoft': Color(0xFF2B1420),
    'learn': Color(0xFF4DE2FF),
  };
  static const claro = <String, Color>{
    'bg': Color(0xFFFAFAFD),
    'grid': Color(0xFFE4E6F4),
    'surface': Color(0xFFFFFFFF),
    'text': Color(0xFF16183A),
    'muted': Color(0xFF555A80),
    'line': Color(0xFFC9CCE6),
    'ink': Color(0xFF16183A),
    'cardBorder': Color(0xFFC9CCE6),
    'accent': Color(0xFF5B3FE0),
    'onAccent': Color(0xFFFFFFFF),
    'pop': Color(0xFF5B3FE0),
    'optionBorder': Color(0xFF16183A),
    'board': Color(0xFFFFFFFF),
    'boardHi': Color(0xFFFFF3A6),
    'fret': Color(0xFF16183A),
    'string': Color(0xFF16183A),
    'inlay': Color(0xFFD9DCF0),
    'target': Color(0xFFFFD84D),
    'onTarget': Color(0xFF221A00),
    'ok': Color(0xFF12A150),
    'onOk': Color(0xFF06210F),
    'okSoft': Color(0xFFDFF7E8),
    'err': Color(0xFFF0476E),
    'onErr': Color(0xFF33030F),
    'errSoft': Color(0xFFFFE1E8),
    'learn': Color(0xFF0E7FA8),
  };
  static const space = <String, double>{
    '0': 2.0,
    '1': 4.0,
    '2': 8.0,
    '3': 12.0,
    '4': 16.0,
    '5': 20.0,
    '6': 24.0,
    '7': 28.0,
    '8': 32.0,
    '9': 40.0,
  };
  static const radius = <String, double>{
    'tag': 6.0,
    'control': 8.0,
    'feedbackBadge': 10.0,
    'card': 12.0,
    'switch': 16.0,
    'chip': 22.0,
    'full': 999.0,
  };
  static const border = <String, double>{'ink': 2.0, 'nut': 6.0, 'fret': 2.0};
  static const size = <String, double>{
    'touchMin': 44.0,
    'button': 52.0,
    'option': 60.0,
    'chip': 44.0,
    'tag': 28.0,
    'infoChip': 32.0,
    'icon': 20.0,
    'iconSm': 16.0,
    'marker': 30.0,
    'stringRow': 40.0,
    'listRow': 56.0,
    'openStringCol': 44.0,
    'stringLabelCol': 26.0,
    'gridStep': 20.0,
  };
  static const motion = <String, double>{'maxMs': 250.0};
  static const breakpoint = <String, double>{'expanded': 600.0};

  static const typography =
      <String, ({String family, double size, int weight, double lineHeight})>{
        'display': (
          family: 'display',
          size: 40.0,
          weight: 700,
          lineHeight: 1.1,
        ),
        'titleXl': (
          family: 'display',
          size: 32.0,
          weight: 700,
          lineHeight: 1.15,
        ),
        'titleLg': (
          family: 'display',
          size: 30.0,
          weight: 700,
          lineHeight: 1.15,
        ),
        'title': (family: 'display', size: 28.0, weight: 700, lineHeight: 1.15),
        'titleMd': (
          family: 'display',
          size: 24.0,
          weight: 700,
          lineHeight: 1.2,
        ),
        'titleSm': (
          family: 'display',
          size: 22.0,
          weight: 700,
          lineHeight: 1.2,
        ),
        'heading': (
          family: 'display',
          size: 20.0,
          weight: 700,
          lineHeight: 1.2,
        ),
        'subheading': (
          family: 'display',
          size: 18.0,
          weight: 700,
          lineHeight: 1.25,
        ),
        'button': (family: 'display', size: 16.0, weight: 700, lineHeight: 1.0),
        'noteOption': (
          family: 'display',
          size: 22.0,
          weight: 700,
          lineHeight: 1.0,
        ),
        'noteMarker': (
          family: 'display',
          size: 13.0,
          weight: 700,
          lineHeight: 1.0,
        ),
        'bodyLg': (family: 'body', size: 16.0, weight: 400, lineHeight: 1.5),
        'body': (family: 'body', size: 15.0, weight: 400, lineHeight: 1.45),
        'bodySm': (family: 'body', size: 14.0, weight: 400, lineHeight: 1.45),
        'chip': (family: 'body', size: 14.0, weight: 400, lineHeight: 1.0),
        'tag': (family: 'body', size: 13.0, weight: 400, lineHeight: 1.0),
        'caption': (family: 'body', size: 13.0, weight: 400, lineHeight: 1.3),
        'label': (family: 'body', size: 13.0, weight: 400, lineHeight: 1.0),
        'tab': (family: 'body', size: 12.0, weight: 400, lineHeight: 1.0),
      };
  static const shadows = <String, String>{
    'hard': '3 3 0 ink',
    'pop': '3 3 0 pop',
    'popLg': '4 4 0 pop',
  };

  @override
  AppTokens copyWith({Map<String, Color>? colors}) =>
      AppTokens(colors ?? this.colors);

  @override
  AppTokens lerp(covariant AppTokens? other, double t) {
    if (other == null) return this;
    return AppTokens({
      for (final key in colors.keys)
        key: Color.lerp(colors[key], other.colors[key], t)!,
    });
  }
}

const musicFallback = <String>['Noto Music'];

ThemeData spikeTheme(Brightness brightness) {
  final colors = brightness == Brightness.dark
      ? AppTokens.escuro
      : AppTokens.claro;
  final tokens = AppTokens(colors);
  final scheme =
      ColorScheme.fromSeed(
        seedColor: colors['accent']!,
        brightness: brightness,
      ).copyWith(
        surface: colors['surface'],
        primary: colors['accent'],
        onPrimary: colors['onAccent'],
        onSurface: colors['text'],
        error: colors['err'],
        onError: colors['onErr'],
      );
  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    scaffoldBackgroundColor: colors['bg'],
    fontFamily: 'Atkinson Hyperlegible',
    fontFamilyFallback: musicFallback,
    extensions: [tokens],
  );
}

TextStyle spikeTitle(Color color) => TextStyle(
  fontFamily: 'Space Grotesk',
  fontFamilyFallback: musicFallback,
  fontSize: AppTokens.typography['title']!.size,
  fontWeight: FontWeight.w700,
  height: AppTokens.typography['title']!.lineHeight,
  color: color,
);
