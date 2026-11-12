import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';

import 'design/app_tokens.dart';

/// Protótipo descartável para exercitar toque e janela do braço.
class SpikeBoardPage extends StatefulWidget {
  const SpikeBoardPage({super.key});

  @override
  State<SpikeBoardPage> createState() => _SpikeBoardPageState();
}

class _SpikeBoardPageState extends State<SpikeBoardPage> {
  int start = 0;
  bool leftHanded = false;
  (int, int)? selected;
  static const strings = ['e', 'B', 'G', 'D', 'A', 'E'];

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final frets = List.generate(6, (index) => start + index);
    final displayed = leftHanded ? frets.reversed.toList() : frets;
    return Scaffold(
      appBar: MediaQuery.orientationOf(context) == Orientation.portrait
          ? AppBar(title: const Text('Spike · braço'))
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (MediaQuery.orientationOf(context) ==
                      Orientation.landscape)
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back),
                      tooltip: 'Voltar',
                    ),
                  IconButton(
                    onPressed: start == 0
                        ? null
                        : () => setState(() => start--),
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Janela anterior',
                  ),
                  Text('Casas $start–${start + 5}'),
                  IconButton(
                    onPressed: start == 17
                        ? null
                        : () => setState(() => start++),
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'Próxima janela',
                  ),
                  const Text('Canhoto'),
                  Switch(
                    value: leftHanded,
                    onChanged: (value) => setState(() => leftHanded = value),
                  ),
                ],
              ),
              Text(
                selected == null
                    ? 'Toque em uma célula'
                    : 'Corda ${strings[selected!.$1]} · casa ${selected!.$2}',
                key: const ValueKey('selection'),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cellWidth = math.max(
                    44.0,
                    (constraints.maxWidth - 26) / 6,
                  );
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        for (var row = 0; row < strings.length; row++)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!leftHanded) _label(strings[row], tokens),
                              for (final fret in displayed)
                                _cell(row, fret, cellWidth, tokens),
                              if (leftHanded) _label(strings[row], tokens),
                            ],
                          ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!leftHanded) const SizedBox(width: 26),
                            for (final fret in displayed)
                              SizedBox(
                                width: cellWidth,
                                child: Center(
                                  child: Text(
                                    '$fret',
                                    style: TextStyle(
                                      color: tokens.color('muted'),
                                    ),
                                  ),
                                ),
                              ),
                            if (leftHanded) const SizedBox(width: 26),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text, AppTokens tokens) => SizedBox(
    width: 26,
    child: Text(text, style: TextStyle(color: tokens.color('muted'))),
  );

  Widget _cell(int row, int fret, double width, AppTokens tokens) =>
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          key: ValueKey('cell-$row-$fret'),
          onTap: () => setState(() => selected = (row, fret)),
          child: Container(
            width: width,
            height: 44,
            decoration: BoxDecoration(
              color: selected == (row, fret)
                  ? tokens.color('boardHi')
                  : tokens.color('board'),
              border: Border(
                right: BorderSide(
                  color: tokens.color('fret'),
                  width: fret == 0 ? 6 : 2,
                ),
              ),
            ),
            child: Center(
              child: Container(
                width: fret == 0 ? width * 0.35 : width,
                height: row < 2
                    ? 1
                    : row < 4
                    ? 2
                    : 3,
                color: tokens.color('string'),
              ),
            ),
          ),
        ),
      );
}
