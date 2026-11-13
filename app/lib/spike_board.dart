import 'dart:math' as math;

import 'package:fretboard_core/fretboard_core.dart';
import 'package:material_ui/material_ui.dart';

import 'design/app_tokens.dart';

/// Interactive standard-tuning fretboard used by lessons and practice screens.
class SpikeBoardPage extends StatefulWidget {
  const SpikeBoardPage({super.key});

  @override
  State<SpikeBoardPage> createState() => _SpikeBoardPageState();
}

class _SpikeBoardPageState extends State<SpikeBoardPage> {
  static const _strings = ['e', 'B', 'G', 'D', 'A', 'E'];
  static const _names = [
    'C',
    'C♯',
    'D',
    'D♯',
    'E',
    'F',
    'F♯',
    'G',
    'G♯',
    'A',
    'A♯',
    'B',
  ];

  int _start = 0;
  bool _leftHanded = false;
  (int, int)? _selected;
  (int, int)? _hovered;

  String _note(int string, int fret) {
    final pitch = noteAt(standardGuitar, Position(string: string, fret: fret));
    return _names[PitchClass.values.indexOf(pitch)];
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final frets = List.generate(6, (index) => _start + index);
    final displayed = _leftHanded ? frets.reversed.toList() : frets;
    return Scaffold(
      appBar: landscape ? null : AppBar(title: const Text('Braço')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  if (landscape)
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Voltar',
                    ),
                  IconButton(
                    onPressed: _start == 0
                        ? null
                        : () => setState(() => _start--),
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Janela anterior',
                  ),
                  Text(
                    'Casas $_start–${_start + 5}',
                    style: TextStyle(color: tokens.color('text')),
                  ),
                  IconButton(
                    onPressed: _start == 17
                        ? null
                        : () => setState(() => _start++),
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Próxima janela',
                  ),
                  const Text('Canhoto'),
                  Switch(
                    value: _leftHanded,
                    onChanged: (value) => setState(() => _leftHanded = value),
                  ),
                ],
              ),
              Text(
                _selected == null
                    ? 'Toque em uma casa para ver a nota'
                    : 'Corda ${_strings[_selected!.$1]} · casa ${_selected!.$2} · ${_note(_selected!.$1, _selected!.$2)}',
                key: const ValueKey('selection'),
                style: TextStyle(color: tokens.color('text')),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cellWidth = math.max(
                      52.0,
                      (constraints.maxWidth - 28) / 6,
                    );
                    return SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (
                              var string = 0;
                              string < _strings.length;
                              string++
                            )
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (!_leftHanded)
                                    _label(_strings[string], tokens),
                                  for (final fret in displayed)
                                    _cell(string, fret, cellWidth, 44, tokens),
                                  if (_leftHanded)
                                    _label(_strings[string], tokens),
                                ],
                              ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!_leftHanded) const SizedBox(width: 28),
                                for (final fret in displayed)
                                  SizedBox(
                                    width: cellWidth,
                                    height: 24,
                                    child: Center(
                                      child: Text(
                                        '$fret',
                                        style: TextStyle(
                                          color: tokens.color('muted'),
                                        ),
                                      ),
                                    ),
                                  ),
                                if (_leftHanded) const SizedBox(width: 28),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, AppTokens tokens) => SizedBox(
    width: 28,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: tokens.color('muted')),
    ),
  );

  Widget _cell(
    int string,
    int fret,
    double width,
    double height,
    AppTokens tokens,
  ) {
    final position = (string, fret);
    final selected = _selected == position;
    final hovered = _hovered == position;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = position),
      onExit: (_) => setState(() => _hovered = null),
      child: Semantics(
        button: true,
        label:
            'Corda ${_strings[string]}, casa $fret, nota ${_note(string, fret)}',
        child: InkWell(
          splashFactory: InkRipple.splashFactory,
          key: ValueKey('cell-$string-$fret'),
          onTap: () => setState(() => _selected = position),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: selected || hovered
                  ? tokens.color('boardHi')
                  : tokens.color('board'),
              border: Border(
                left: _leftHanded
                    ? BorderSide(
                        color: tokens.color('fret'),
                        width: fret == 0 ? 6 : 2,
                      )
                    : BorderSide.none,
                right: _leftHanded
                    ? BorderSide.none
                    : BorderSide(
                        color: tokens.color('fret'),
                        width: fret == 0 ? 6 : 2,
                      ),
                bottom: BorderSide(color: tokens.color('line'), width: 0.5),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: width,
                    height: string < 2
                        ? 1
                        : string < 4
                        ? 2
                        : 3,
                    color: tokens.color('string'),
                  ),
                ),
                Text(
                  _note(string, fret),
                  style: TextStyle(
                    color: tokens.color('text'),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
