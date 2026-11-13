import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

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
  AudioSource? audio;
  bool audioUnavailable = false;

  @override
  void initState() {
    super.initState();
    _loadAudio();
  }

  Future<void> _loadAudio() async {
    try {
      await SoLoud.instance.init();
      final source = await SoLoud.instance.loadAsset(
        'assets/audio/pluck-a2.wav',
      );
      if (!mounted) {
        SoLoud.instance.deinit();
        return;
      }
      setState(() => audio = source);
    } catch (_) {
      if (mounted) setState(() => audioUnavailable = true);
    }
  }

  @override
  void dispose() {
    if (SoLoud.instance.isInitialized) SoLoud.instance.deinit();
    super.dispose();
  }

  void _select(int row, int fret) {
    setState(() => selected = (row, fret));
    final source = audio;
    if (source != null) {
      try {
        SoLoud.instance.play(source);
      } catch (_) {
        setState(() => audioUnavailable = true);
      }
    }
  }

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
              Text(
                audioUnavailable
                    ? 'Áudio indisponível; continue sem som.'
                    : audio == null
                    ? 'Carregando áudio…'
                    : 'Áudio de teste: mesma nota em todas as células',
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
          onTap: () => _select(row, fret),
          child: Container(
            width: width,
            height: 44,
            decoration: BoxDecoration(
              color: selected == (row, fret)
                  ? tokens.color('boardHi')
                  : tokens.color('board'),
              border: Border(
                left: leftHanded
                    ? BorderSide(
                        color: tokens.color('fret'),
                        width: fret == 0 ? 6 : 2,
                      )
                    : BorderSide.none,
                right: leftHanded
                    ? BorderSide.none
                    : BorderSide(
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
