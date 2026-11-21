import 'package:fretboard_core/fretboard_core.dart';
import 'package:material_ui/material_ui.dart';

import '../design/app_tokens.dart';
import '../design/music_text.dart';
import 'learn_board.dart';
import 'note_pitch.dart';

const _visualStrings = ['e', 'B', 'G', 'D', 'A', 'E'];
const _windowSize = 6;
const _inlayFrets = {3, 5, 7, 9, 12};

/// Interactive fretboard for Practice and Your Turn questions.
class QuestionBoard extends StatefulWidget {
  const QuestionBoard({
    required this.question,
    required this.references,
    this.onPositionTap,
    super.key,
  });

  final Question question;
  final List<Position> references;
  final ValueChanged<Position>? onPositionTap;

  @override
  State<QuestionBoard> createState() => _QuestionBoardState();
}

class _QuestionBoardState extends State<QuestionBoard> {
  Position? _hovered;

  @override
  void didUpdateWidget(covariant QuestionBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question) {
      _hovered = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final question = widget.question;
    final start = question is OpenString
        ? 0
        : learnFretWindowStart([
            question.target.fret,
            for (final ref in widget.references)
              if ((ref.fret - question.target.fret).abs() < _windowSize)
                ref.fret,
          ]);
    final frets = [for (var i = 0; i < _windowSize; i++) start + i];
    final tapEnabled =
        question.isBoardTapQuestion && widget.onPositionTap != null;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      label: 'Braço da pergunta',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = ((constraints.maxWidth - 26) / _windowSize).clamp(
            44.0,
            96.0,
          );
          return Column(
            children: [
              for (var row = 0; row < _visualStrings.length; row++)
                _stringRow(
                  visualRow: row,
                  frets: frets,
                  cellWidth: cellWidth,
                  tokens: tokens,
                  tapEnabled: tapEnabled,
                ),
              ExcludeSemantics(
                child: Row(
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _stringRow({
    required int visualRow,
    required List<int> frets,
    required double cellWidth,
    required AppTokens tokens,
    required bool tapEnabled,
  }) {
    final coreString = _visualStrings.length - 1 - visualRow;
    final thickness = visualRow < 2
        ? 1.0
        : visualRow < 4
        ? 2.0
        : 3.0;
    return Row(
      children: [
        ExcludeSemantics(
          child: SizedBox(
            width: 26,
            height: 40,
            child: Center(
              child: Text(
                _visualStrings[visualRow],
                style: TextStyle(color: tokens.color('muted'), fontSize: 13),
              ),
            ),
          ),
        ),
        for (final fret in frets)
          _cell(
            visualRow: visualRow,
            coreString: coreString,
            fret: fret,
            width: cellWidth,
            thickness: thickness,
            tokens: tokens,
            tapEnabled: tapEnabled,
          ),
      ],
    );
  }

  Widget _cell({
    required int visualRow,
    required int coreString,
    required int fret,
    required double width,
    required double thickness,
    required AppTokens tokens,
    required bool tapEnabled,
  }) {
    final question = widget.question;
    final position = Position(string: coreString, fret: fret);
    final isNameTarget =
        question is NameNote && question.target == position;
    final isReference =
        !isNameTarget && widget.references.contains(position);
    final isHighlightedString =
        question is FindOnString && question.string == coreString;
    final isHighlightedFret =
        question is FindAtFret && question.fret == fret;
    final isOpenCircle = question is OpenString && fret == 0;
    final isHovered = tapEnabled && _hovered == position;

    final baseColor = isHovered || isHighlightedString || isHighlightedFret
        ? tokens.color('boardHi')
        : tokens.color('board');

    final showInlay =
        _inlayFrets.contains(fret) &&
        ((fret != 12 && visualRow == 2) ||
            (fret == 12 && (visualRow == 1 || visualRow == 4)));

    Widget content = SizedBox(
      width: width,
      height: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: baseColor,
          border: Border(
            right: BorderSide(
              color: fret == 0 ? tokens.color('ink') : tokens.color('fret'),
              width: fret == 0 ? 6 : 2,
            ),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (showInlay)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: tokens.color('inlay'),
                  shape: BoxShape.circle,
                ),
              ),
            Container(height: thickness, color: tokens.color('string')),
            if (isOpenCircle)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: tokens.color('surface'),
                  shape: BoxShape.circle,
                  border: Border.all(color: tokens.color('ink'), width: 2),
                ),
              ),
            if (isReference)
              _referenceMarker(position: position, tokens: tokens),
            if (isNameTarget) _targetMarker(position: position, tokens: tokens),
          ],
        ),
      ),
    );

    if (tapEnabled) {
      final baseLabel = fret == 0
          ? 'Corda ${stringLabel(coreString)}, casa 0 (solta)'
          : 'Corda ${stringLabel(coreString)}, casa $fret';
      final cellLabel = isReference
          ? '$baseLabel, nota de referência ${noteSpelling(position)}'
          : baseLabel;
      content = MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = position),
        onExit: (_) => setState(() {
          if (_hovered == position) _hovered = null;
        }),
        child: Semantics(
          button: true,
          enabled: true,
          label: cellLabel,
          container: true,
          onTap: () => widget.onPositionTap!(position),
          child: ExcludeSemantics(
            child: InkWell(
              key: ValueKey('question-cell-$coreString-$fret'),
              onTap: () => widget.onPositionTap!(position),
              child: content,
            ),
          ),
        ),
      );
    }

    return content;
  }

  Widget _referenceMarker({
    required Position position,
    required AppTokens tokens,
  }) {
    final spelling = noteSpelling(position);
    return Semantics(
      container: true,
      label:
          'Nota de referência, $spelling, corda ${stringLabel(position.string)}, casa ${position.fret}',
      child: ExcludeSemantics(
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tokens.color('board'),
            shape: BoxShape.circle,
            border: Border.all(color: tokens.color('ink'), width: 2),
          ),
          child: MusicText(
            spelling,
            style: TextStyle(
              color: tokens.color('text'),
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

  Widget _targetMarker({
    required Position position,
    required AppTokens tokens,
  }) {
    return Semantics(
      container: true,
      label:
          'Alvo da pergunta, corda ${stringLabel(position.string)}, casa ${position.fret}',
      child: ExcludeSemantics(
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: tokens.color('target'),
            shape: BoxShape.circle,
            border: Border.all(color: tokens.color('ink'), width: 2),
            boxShadow: [
              BoxShadow(
                color: tokens.color('target').withValues(alpha: 0.45),
                blurRadius: 8,
              ),
            ],
          ),
          child: Text(
            '?',
            style: TextStyle(
              color: tokens.color('onTarget'),
              fontFamily: 'Space Grotesk',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
