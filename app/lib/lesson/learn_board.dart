import 'package:fretboard_core/fretboard_core.dart';
import 'package:material_ui/material_ui.dart';

import '../design/app_tokens.dart';
import '../design/music_text.dart';
import 'note_pitch.dart';

const _visualStrings = ['e', 'B', 'G', 'D', 'A', 'E'];
const _windowSize = 6;
const _maxWindowStart = 17;

/// First fret of the 6-fret window that covers [frets] when they fit.
int learnFretWindowStart(Iterable<int> frets) {
  final values = frets.toList();
  if (values.isEmpty) return 0;
  final minFret = values.reduce((a, b) => a < b ? a : b);
  final maxFret = values.reduce((a, b) => a > b ? a : b);
  if (maxFret - minFret >= _windowSize) {
    return minFret.clamp(0, _maxWindowStart);
  }
  final slack = _windowSize - 1 - (maxFret - minFret);
  final start = minFret - slack ~/ 2;
  final clamped = start.clamp(0, _maxWindowStart);
  if (clamped + _windowSize - 1 < maxFret) {
    return (maxFret - (_windowSize - 1)).clamp(0, _maxWindowStart);
  }
  return clamped;
}

/// Fretboard slice for one learn step: lesson notes filled, references outlined.
class LearnBoard extends StatelessWidget {
  const LearnBoard({
    required this.highlighted,
    required this.references,
    super.key,
  });

  final List<Position> highlighted;
  final List<Position> references;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final start = learnFretWindowStart([
      for (final position in [...highlighted, ...references]) position.fret,
    ]);
    final frets = [for (var i = 0; i < _windowSize; i++) start + i];
    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Braço da lição',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = ((constraints.maxWidth - 26) / _windowSize).clamp(
            44.0,
            96.0,
          );
          return Column(
            children: [
              for (var row = 0; row < _visualStrings.length; row++)
                _stringRow(row, frets, cellWidth, tokens),
              Row(
                children: [
                  const SizedBox(width: 26),
                  for (final fret in frets)
                    SizedBox(
                      width: cellWidth,
                      height: 28,
                      child: Center(
                        child: Text(
                          '$fret',
                          style: TextStyle(
                            color: tokens.color('muted'),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _stringRow(
    int visualRow,
    List<int> frets,
    double cellWidth,
    AppTokens tokens,
  ) {
    final coreString = _visualStrings.length - 1 - visualRow;
    final thickness = visualRow < 2
        ? 1.0
        : visualRow < 4
        ? 2.0
        : 3.0;
    return Row(
      children: [
        SizedBox(
          width: 26,
          height: 40,
          child: Center(
            child: Text(
              _visualStrings[visualRow],
              style: TextStyle(color: tokens.color('muted'), fontSize: 13),
            ),
          ),
        ),
        for (final fret in frets)
          _cell(
            coreString: coreString,
            fret: fret,
            width: cellWidth,
            thickness: thickness,
            tokens: tokens,
            showNut: fret == 0,
          ),
      ],
    );
  }

  Widget _cell({
    required int coreString,
    required int fret,
    required double width,
    required double thickness,
    required AppTokens tokens,
    required bool showNut,
  }) {
    final position = Position(string: coreString, fret: fret);
    final isLesson = highlighted.contains(position);
    final isReference = !isLesson && references.contains(position);
    return SizedBox(
      width: width,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color('board'),
          border: Border(
            right: BorderSide(
              color: showNut ? tokens.color('ink') : tokens.color('fret'),
              width: showNut ? 6 : 2,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(height: thickness, color: tokens.color('string')),
            if (isLesson || isReference)
              _marker(position: position, lesson: isLesson, tokens: tokens),
          ],
        ),
      ),
    );
  }

  Widget _marker({
    required Position position,
    required bool lesson,
    required AppTokens tokens,
  }) {
    final spelling = noteSpelling(position);
    final kind = lesson ? 'Nota da lição' : 'Nota de referência';
    final label =
        '$kind, $spelling, corda ${stringLabel(position.string)}, casa ${position.fret}';
    final fill = lesson ? tokens.color('accent') : tokens.color('board');
    final text = lesson ? tokens.color('onAccent') : tokens.color('text');
    return Semantics(
      container: true,
      label: label,
      child: ExcludeSemantics(
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: tokens.color('ink'), width: 2),
          ),
          child: MusicText(
            spelling,
            style: TextStyle(
              color: text,
              fontFamily: 'Space Grotesk',
              fontFamilyFallback: musicFallback,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
