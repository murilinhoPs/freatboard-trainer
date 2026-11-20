import 'package:fretboard_core/fretboard_core.dart';
import 'package:material_ui/material_ui.dart';

import '../design/app_tokens.dart';
import '../design/music_text.dart';
import 'learn_board.dart';
import 'note_sequence_player.dart';

final _highlightPattern = RegExp(
  r'casa\s+\d+|\(\d+\)|(?<![A-Za-z])[A-G]♯?(?![A-Za-z])',
);

/// Learn stage of a notes lesson: steps, highlighted notes, listen, continue,
/// and an exit confirmation that drops the round without saving it.
class LearnStagePage extends StatefulWidget {
  const LearnStagePage({
    required this.session,
    required this.player,
    required this.onAbandoned,
    super.key,
  });

  final LessonSession session;
  final NoteSequencePlayer player;

  /// Called when the person confirms Sair. Nothing is persisted.
  final VoidCallback onAbandoned;

  @override
  State<LearnStagePage> createState() => _LearnStagePageState();
}

class _LearnStagePageState extends State<LearnStagePage> {
  void _listen() {
    final step = widget.session.currentLearnStep;
    if (step == null) return;
    widget.player.play(step.highlightedPositions);
  }

  void _continue() {
    widget.session.advanceLearn();
    setState(() {});
  }

  Future<void> _confirmExit() async {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: tokens.color('surface'),
          title: Text(
            'Sair da sessão?',
            style: _titleStyle(tokens.color('text'), 22),
          ),
          content: Text(
            'Esta rodada não será salva.',
            style: TextStyle(color: tokens.color('text'), fontSize: 16),
          ),
          actions: [
            _dialogAction(
              label: 'Cancelar',
              color: tokens.color('text'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            _dialogAction(
              label: 'Sair',
              color: tokens.color('err'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (leave == true && mounted) widget.onAbandoned();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final session = widget.session;
    return Scaffold(
      backgroundColor: tokens.color('bg'),
      body: SafeArea(
        child: session.phase == LessonPhase.learn
            ? _learn(tokens, session)
            : _trainHandoff(tokens),
      ),
    );
  }

  Widget _learn(AppTokens tokens, LessonSession session) {
    final step = session.currentLearnStep!;
    final index = session.learnStepIndex;
    final total = session.lesson.steps.length;
    return Column(
      children: [
        _topBar(
          tokens,
          value: '${index + 1} de $total',
          factor: (index + 1) / total,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LearnBoard(
                  highlighted: step.highlightedPositions,
                  references: step.referencePositions,
                ),
                const SizedBox(height: 16),
                Text(
                  'Aprender · ${index + 1} de $total',
                  style: TextStyle(color: tokens.color('muted'), fontSize: 13),
                ),
                const SizedBox(height: 8),
                MusicText(
                  step.title,
                  style: _titleStyle(tokens.color('text'), 28),
                ),
                const SizedBox(height: 12),
                _LessonCopy(text: step.description),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 19, 19),
          child: Row(
            children: [
              _LessonButton(
                label: 'Ouvir',
                primary: false,
                icon: _SpeakerIcon(color: tokens.color('text')),
                onPressed: _listen,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _LessonButton(
                  label: 'Continuar',
                  primary: true,
                  onPressed: _continue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _trainHandoff(AppTokens tokens) {
    return Column(
      children: [
        _topBar(tokens, value: 'Treinar', factor: 1),
        Expanded(
          child: Center(
            child: Semantics(
              container: true,
              label: 'Treinar',
              child: ExcludeSemantics(
                child: Text(
                  'Treinar',
                  style: _titleStyle(tokens.color('text'), 28),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _topBar(
    AppTokens tokens, {
    required String value,
    required double factor,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
      child: Row(
        children: [
          Semantics(
            button: true,
            enabled: true,
            label: 'Sair da lição',
            container: true,
            onTap: _confirmExit,
            child: ExcludeSemantics(
              child: IconButton(
                tooltip: 'Sair da lição',
                onPressed: _confirmExit,
                icon: _CloseIcon(color: tokens.color('text')),
                style: IconButton.styleFrom(
                  fixedSize: const Size(44, 44),
                  minimumSize: const Size(44, 44),
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Semantics(
              container: true,
              label: 'Progresso da lição',
              value: value,
              child: ExcludeSemantics(
                child: SizedBox(
                  height: 12,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: tokens.color('surface'),
                      border: Border.all(color: tokens.color('ink'), width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: factor,
                        child: ColoredBox(color: tokens.color('accent')),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LessonCopy extends StatelessWidget {
  const _LessonCopy({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final style = TextStyle(
      color: tokens.color('text'),
      fontSize: 16,
      height: 1.5,
    );
    final spans = <InlineSpan>[];
    var start = 0;
    for (final match in _highlightPattern.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: ColoredBox(
            color: tokens.color('boardHi'),
            child: MusicText(match.group(0)!, style: style),
          ),
        ),
      );
      start = match.end;
    }
    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }
    return Text.rich(TextSpan(style: style, children: spans));
  }
}

class _LessonButton extends StatelessWidget {
  const _LessonButton({
    required this.label,
    required this.primary,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final bool primary;
  final VoidCallback onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final background = primary
        ? tokens.color('accent')
        : tokens.color('surface');
    final foreground = primary
        ? tokens.color('onAccent')
        : tokens.color('text');
    final button = Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: tokens.color('ink'), width: 2),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: SizedBox(
          height: 52,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: primary ? MainAxisSize.max : MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Space Grotesk',
                    fontFamilyFallback: musicFallback,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final labeled = Semantics(
      button: true,
      enabled: true,
      label: label,
      container: true,
      onTap: onPressed,
      child: ExcludeSemantics(child: button),
    );
    if (!primary) return labeled;
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: tokens.color('ink'), offset: const Offset(3, 3)),
        ],
      ),
      child: labeled,
    );
  }
}

Widget _dialogAction({
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return Semantics(
    button: true,
    enabled: true,
    label: label,
    container: true,
    onTap: onPressed,
    child: ExcludeSemantics(
      child: TextButton(
        onPressed: onPressed,
        child: Text(label, style: _titleStyle(color, 16)),
      ),
    ),
  );
}

TextStyle _titleStyle(Color color, double size) => TextStyle(
  fontFamily: 'Space Grotesk',
  fontFamilyFallback: musicFallback,
  fontSize: size,
  fontWeight: FontWeight.w700,
  height: 1.15,
  color: color,
);

class _CloseIcon extends StatelessWidget {
  const _CloseIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _StrokePainter(color: color, close: true),
    );
  }
}

class _SpeakerIcon extends StatelessWidget {
  const _SpeakerIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 20),
      painter: _StrokePainter(color: color, close: false),
    );
  }
}

class _StrokePainter extends CustomPainter {
  const _StrokePainter({required this.color, required this.close});

  final Color color;
  final bool close;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 2.2 / 24
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final s = size.width / 24;
    if (close) {
      canvas.drawLine(Offset(6 * s, 6 * s), Offset(18 * s, 18 * s), paint);
      canvas.drawLine(Offset(18 * s, 6 * s), Offset(6 * s, 18 * s), paint);
      return;
    }
    final body = Path()
      ..moveTo(4 * s, 10 * s)
      ..lineTo(4 * s, 14 * s)
      ..lineTo(8 * s, 14 * s)
      ..lineTo(13 * s, 18 * s)
      ..lineTo(13 * s, 6 * s)
      ..close();
    canvas.drawPath(body, paint);
    canvas.drawArc(
      Rect.fromCircle(center: Offset(14 * s, 12 * s), radius: 4 * s),
      -0.9,
      1.8,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _StrokePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.close != close;
}
