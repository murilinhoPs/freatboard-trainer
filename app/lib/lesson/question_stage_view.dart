import 'package:fretboard_core/fretboard_core.dart';
import 'package:material_ui/material_ui.dart';

import '../design/app_tokens.dart';
import '../design/music_text.dart';
import 'note_pitch.dart';
import 'question_board.dart';

/// Short, target-safe hint for [question] in [lesson] without revealing the answer.
String buildQuestionHint(Lesson lesson, Question question) {
  final target = question.target;
  return switch (question) {
    NameNote() => _nameNoteHint(lesson, target),
    FindOnString() => _findOnStringHint(lesson, target),
    FindAtFret() =>
      'Use as notas de referência e conte a partir das cordas soltas para achar a corda certa.',
    OpenString() =>
      'A corda solta fica na primeira posição, logo antes da pestana.',
  };
}

String _nameNoteHint(Lesson lesson, Position target) {
  if (target.fret == 0) {
    return 'Pense no nome da corda solta nessa linha.';
  }
  if (lesson.includesAccidentals) {
    return 'Use a nota natural uma casa abaixo como referência e suba uma casa.';
  }
  final sameStringRefs = lesson.referencePositions
      .where((p) => p.string == target.string && p.fret != target.fret)
      .toList();
  if (sameStringRefs.isNotEmpty) {
    sameStringRefs.sort(
      (a, b) => (a.fret - target.fret).abs().compareTo(
        (b.fret - target.fret).abs(),
      ),
    );
    final nearest = sameStringRefs.first;
    final diff = target.fret - nearest.fret;
    final steps = diff.abs();
    final unit = steps == 1 ? 'casa' : 'casas';
    final dir = diff > 0 ? 'suba' : 'desça';
    return 'Parta da referência ${noteSpelling(nearest)} e $dir $steps $unit na escala.';
  }
  return 'Conte os semitons e os tons na escala a partir de uma nota de referência.';
}

String _findOnStringHint(Lesson lesson, Position target) {
  if (target.fret == 0) {
    return 'Lembre-se da nota que dá nome à corda solta.';
  }
  if (lesson.includesAccidentals) {
    return 'Encontre a nota natural anterior na mesma corda e suba uma casa.';
  }
  return 'Entre B–C e E–F não há casa no meio; entre as outras naturais há uma casa no meio.';
}

/// Result emitted when a user answers a question in Practice or Your Turn.
final class QuestionAnswerResult {
  const QuestionAnswerResult({
    required this.question,
    required this.evaluation,
    required this.phase,
    required this.outcome,
    required this.usesLongFeedback,
  });

  final Question question;
  final QuestionEvaluation evaluation;
  final LessonPhase phase;
  final AnswerOutcome outcome;
  final bool usesLongFeedback;
}

/// Displays a Practice or Your Turn question with phase-appropriate helpers
/// (references and hint in Practice; neither in Your Turn) and immediate
/// answer interaction without confirmation.
class QuestionStageView extends StatefulWidget {
  const QuestionStageView({
    required this.lesson,
    required this.phase,
    required this.question,
    required this.onOptionSelected,
    required this.onPositionTapped,
    super.key,
  });

  final Lesson lesson;
  final LessonPhase phase;
  final Question question;
  final ValueChanged<PitchClass> onOptionSelected;
  final ValueChanged<Position> onPositionTapped;

  @override
  State<QuestionStageView> createState() => _QuestionStageViewState();
}

class _QuestionStageViewState extends State<QuestionStageView> {
  bool _hintVisible = false;

  @override
  void didUpdateWidget(covariant QuestionStageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question != widget.question ||
        oldWidget.phase != widget.phase) {
      _hintVisible = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final isPractice = widget.phase == LessonPhase.practice;
    final references = isPractice
        ? widget.lesson.referencePositions
        : const <Position>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final expanded =
            constraints.maxWidth >= AppTokens.breakpoint['expanded']!;
        if (expanded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: QuestionBoard(
                        question: widget.question,
                        references: references,
                        onPositionTap: widget.question.isBoardTapQuestion
                            ? widget.onPositionTapped
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: tokens.color('surface'),
                      borderRadius: BorderRadius.circular(
                        AppTokens.radius['card']!,
                      ),
                      border: Border.all(
                        color: tokens.color('cardBorder'),
                        width: AppTokens.border['ink']!,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: _questionPanel(tokens, isPractice, compact: false),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QuestionBoard(
                question: widget.question,
                references: references,
                onPositionTap: widget.question.isBoardTapQuestion
                    ? widget.onPositionTapped
                    : null,
              ),
              const SizedBox(height: 16),
              _questionPanel(tokens, isPractice, compact: true),
            ],
          ),
        );
      },
    );
  }

  Widget _questionPanel(
    AppTokens tokens,
    bool isPractice, {
    required bool compact,
  }) {
    final question = widget.question;
    final prompt = _promptText(question);
    final subtitle = _subtitleText(question, isPractice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              isPractice ? 'Treino' : 'Sua vez',
              style: TextStyle(color: tokens.color('muted'), fontSize: 13),
            ),
            const Spacer(),
            if (isPractice)
              Semantics(
                button: true,
                enabled: true,
                label: 'Dica',
                container: true,
                onTap: () => setState(() => _hintVisible = !_hintVisible),
                child: ExcludeSemantics(
                  child: InkWell(
                    onTap: () => setState(() => _hintVisible = !_hintVisible),
                    borderRadius: BorderRadius.circular(
                      AppTokens.radius['tag']!,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _BulbIcon(color: tokens.color('accent')),
                          const SizedBox(width: 6),
                          Text(
                            'Dica',
                            style: TextStyle(
                              color: tokens.color('accent'),
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (isPractice && _hintVisible) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tokens.color('surface'),
              borderRadius: BorderRadius.circular(AppTokens.radius['control']!),
              border: Border.all(
                color: tokens.color('accent'),
                width: AppTokens.border['ink']!,
              ),
            ),
            child: MusicText(
              buildQuestionHint(widget.lesson, question),
              style: TextStyle(
                color: tokens.color('text'),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
        const SizedBox(height: 8),
        MusicText(
          prompt,
          style: TextStyle(
            fontFamily: 'Space Grotesk',
            fontFamilyFallback: musicFallback,
            fontSize: compact ? 28 : 24,
            fontWeight: FontWeight.w700,
            height: 1.15,
            color: tokens.color('text'),
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: tokens.color('muted'),
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
        if (question is NameNote) ...[
          SizedBox(height: compact ? 24 : 16),
          _optionsGrid(question, tokens, isPractice: isPractice),
        ],
      ],
    );
  }

  Widget _optionsGrid(
    NameNote question,
    AppTokens tokens, {
    required bool isPractice,
  }) {
    final columns = isPractice ? 2 : 4;
    final gap = isPractice ? 16.0 : 12.0;
    final options = question.options;
    final rows = (options.length / columns).ceil();

    return Column(
      children: [
        for (var r = 0; r < rows; r++) ...[
          if (r > 0) SizedBox(height: gap),
          Row(
            children: [
              for (var c = 0; c < columns; c++) ...[
                if (c > 0) SizedBox(width: gap),
                Expanded(
                  child: r * columns + c < options.length
                      ? _NoteOptionButton(
                          note: options[r * columns + c],
                          onPressed: () =>
                              widget.onOptionSelected(options[r * columns + c]),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  String _promptText(Question question) => switch (question) {
    FindOnString(:final note, :final string) =>
      'Ache o ${pitchSpelling(note)} na corda ${stringLabel(string)}',
    FindAtFret(:final note, :final fret) =>
      'Ache o ${pitchSpelling(note)} na casa $fret',
    OpenString(:final string) => 'Toque na corda ${stringLabel(string)} solta',
    NameNote() => 'Que nota é essa?',
  };

  String? _subtitleText(Question question, bool isPractice) {
    if (question.isBoardTapQuestion) return 'Toque no braço';
    if (isPractice) return 'As notas vizinhas ficam no braço para te ajudar.';
    return null;
  }
}

class _NoteOptionButton extends StatelessWidget {
  const _NoteOptionButton({required this.note, required this.onPressed});

  final PitchClass note;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).extension<AppTokens>()!;
    final label = pitchSpelling(note);
    return Semantics(
      button: true,
      enabled: true,
      label: label,
      container: true,
      onTap: onPressed,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTokens.radius['control']!),
            boxShadow: [
              BoxShadow(
                color: tokens.color('pop'),
                offset: const Offset(3, 3),
              ),
            ],
          ),
          child: Material(
            color: tokens.color('surface'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTokens.radius['control']!),
              side: BorderSide(
                color: tokens.color('optionBorder'),
                width: AppTokens.border['ink']!,
              ),
            ),
            child: InkWell(
              onTap: onPressed,
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppTokens.radius['control']!,
                ),
              ),
              child: SizedBox(
                height: AppTokens.size['option']!,
                child: Center(
                  child: MusicText(
                    label,
                    style: TextStyle(
                      fontFamily: 'Space Grotesk',
                      fontFamilyFallback: musicFallback,
                      fontSize: AppTokens.typography['noteOption']!.size,
                      fontWeight: FontWeight.w700,
                      height: 1,
                      color: tokens.color('text'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BulbIcon extends StatelessWidget {
  const _BulbIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(16, 16),
      painter: _BulbPainter(color: color),
    );
  }
}

class _BulbPainter extends CustomPainter {
  const _BulbPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 2.0 / 24
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final s = size.width / 24;
    canvas.drawCircle(Offset(12 * s, 9 * s), 5 * s, paint);
    canvas.drawLine(Offset(9.5 * s, 17 * s), Offset(14.5 * s, 17 * s), paint);
    canvas.drawLine(Offset(10 * s, 20 * s), Offset(14 * s, 20 * s), paint);
  }

  @override
  bool shouldRepaint(covariant _BulbPainter oldDelegate) =>
      oldDelegate.color != color;
}
