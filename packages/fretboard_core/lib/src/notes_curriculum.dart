import '../fretboard_core.dart';

/// Learning track supported by the lesson and drill engine.
enum Skill { notes }

/// Single instructional step shown during the Learn phase of a lesson.
final class LearnStep {
  LearnStep({
    required this.title,
    required this.description,
    required List<Position> highlightedPositions,
    List<Position> referencePositions = const [],
  }) : highlightedPositions = List.unmodifiable(highlightedPositions),
       referencePositions = List.unmodifiable(referencePositions);

  final String title;
  final String description;
  final List<Position> highlightedPositions;
  final List<Position> referencePositions;

  @override
  bool operator ==(Object other) =>
      other is LearnStep &&
      title == other.title &&
      description == other.description &&
      _listEquals(highlightedPositions, other.highlightedPositions) &&
      _listEquals(referencePositions, other.referencePositions);

  @override
  int get hashCode => Object.hash(
    title,
    description,
    Object.hashAll(highlightedPositions),
    Object.hashAll(referencePositions),
  );
}

/// Curriculum unit targeting a set of fretboard positions.
final class Lesson {
  Lesson({
    required this.id,
    required this.skill,
    required this.order,
    required this.string,
    required this.title,
    required this.includesAccidentals,
    required List<Position> targets,
    required List<LearnStep> steps,
    required this.hint,
    List<Position> referencePositions = const [],
  }) : targets = List.unmodifiable(targets),
       steps = List.unmodifiable(steps),
       referencePositions = List.unmodifiable(referencePositions) {
    if (order < 1) {
      throw ArgumentError.value(order, 'order', 'Must be >= 1');
    }
    if (targets.isEmpty) {
      throw ArgumentError.value(targets, 'targets', 'Must not be empty');
    }
    if (steps.isEmpty) {
      throw ArgumentError.value(steps, 'steps', 'Must not be empty');
    }
  }

  final String id;
  final Skill skill;
  final int order;
  final int string;
  final String title;
  final bool includesAccidentals;
  final List<Position> targets;
  final List<Position> referencePositions;
  final List<LearnStep> steps;
  final String hint;

  @override
  bool operator ==(Object other) =>
      other is Lesson &&
      id == other.id &&
      skill == other.skill &&
      order == other.order &&
      string == other.string &&
      title == other.title &&
      includesAccidentals == other.includesAccidentals &&
      _listEquals(targets, other.targets) &&
      _listEquals(referencePositions, other.referencePositions) &&
      _listEquals(steps, other.steps) &&
      hint == other.hint;

  @override
  int get hashCode => Object.hash(
    id,
    skill,
    order,
    string,
    title,
    includesAccidentals,
    Object.hashAll(targets),
    Object.hashAll(referencePositions),
    Object.hashAll(steps),
    hint,
  );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// Inclusive fret range covered by the MVP Notes curriculum.
const notesCurriculumFretRange = FretRange(0, 12);

/// Ordered Notes curriculum covering strings 0..5 across frets 0..12
/// (natural notes and sharps).
final List<Lesson> notesCurriculum = List.unmodifiable([
  // String 0: Low E
  Lesson(
    id: 'notes-e-low-nat-1',
    skill: Skill.notes,
    order: 1,
    string: 0,
    title: 'E, F, G e A na corda E grave',
    includesAccidentals: false,
    targets: const [
      Position(string: 0, fret: 0),
      Position(string: 0, fret: 1),
      Position(string: 0, fret: 3),
      Position(string: 0, fret: 5),
    ],
    referencePositions: const [
      Position(string: 0, fret: 0),
    ],
    hint: 'E para F é 1 casa (semitom); depois conte 2 casas por vez até G e A.',
    steps: [
      LearnStep(
        title: 'Semitom entre E e F',
        description:
            'A corda E grave solta (casa 0) é E. Suba 1 casa para achar F na casa 1.',
        highlightedPositions: const [
          Position(string: 0, fret: 0),
          Position(string: 0, fret: 1),
        ],
      ),
      LearnStep(
        title: 'Tons até G e A',
        description:
            'Pule uma casa a cada tom: G fica no primeiro marcador (casa 3) e A na casa 5.',
        highlightedPositions: const [
          Position(string: 0, fret: 3),
          Position(string: 0, fret: 5),
        ],
        referencePositions: const [
          Position(string: 0, fret: 1),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-e-low-nat-2',
    skill: Skill.notes,
    order: 2,
    string: 0,
    title: 'B, C, D e E na corda E grave',
    includesAccidentals: false,
    targets: const [
      Position(string: 0, fret: 7),
      Position(string: 0, fret: 8),
      Position(string: 0, fret: 10),
      Position(string: 0, fret: 12),
    ],
    referencePositions: const [
      Position(string: 0, fret: 5),
    ],
    hint: 'B para C é 1 casa (7 → 8); depois conte tons até D (10) e E (12).',
    steps: [
      LearnStep(
        title: 'B e C juntos nas casas 7 e 8',
        description:
            'Dois semitons não têm casa no meio: B fica na casa 7 e C logo ao lado, na casa 8.',
        highlightedPositions: const [
          Position(string: 0, fret: 7),
          Position(string: 0, fret: 8),
        ],
        referencePositions: const [
          Position(string: 0, fret: 5),
        ],
      ),
      LearnStep(
        title: 'D e a oitava E na casa 12',
        description:
            'Suba um tom para D na casa 10 e outro tom para E no marcador duplo (casa 12).',
        highlightedPositions: const [
          Position(string: 0, fret: 10),
          Position(string: 0, fret: 12),
        ],
        referencePositions: const [
          Position(string: 0, fret: 8),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-e-low-sharp',
    skill: Skill.notes,
    order: 3,
    string: 0,
    title: 'Sustenidos na corda E grave',
    includesAccidentals: true,
    targets: const [
      Position(string: 0, fret: 2),
      Position(string: 0, fret: 4),
      Position(string: 0, fret: 6),
      Position(string: 0, fret: 9),
      Position(string: 0, fret: 11),
    ],
    referencePositions: const [
      Position(string: 0, fret: 1),
      Position(string: 0, fret: 3),
      Position(string: 0, fret: 5),
      Position(string: 0, fret: 8),
      Position(string: 0, fret: 10),
    ],
    hint: 'Todo sustenido fica uma casa acima da nota natural correspondente.',
    steps: [
      LearnStep(
        title: 'Sustenido é uma casa acima',
        description:
            'Partindo de F (1), G (3) e A (5), suba 1 casa para achar F♯ (2), G♯ (4) e A♯ (6).',
        highlightedPositions: const [
          Position(string: 0, fret: 2),
          Position(string: 0, fret: 4),
          Position(string: 0, fret: 6),
        ],
        referencePositions: const [
          Position(string: 0, fret: 1),
          Position(string: 0, fret: 3),
          Position(string: 0, fret: 5),
        ],
      ),
      LearnStep(
        title: 'C♯ e D♯ na região aguda',
        description:
            'C fica na casa 8 e D na casa 10: uma casa acima estão C♯ (9) e D♯ (11).',
        highlightedPositions: const [
          Position(string: 0, fret: 9),
          Position(string: 0, fret: 11),
        ],
        referencePositions: const [
          Position(string: 0, fret: 8),
          Position(string: 0, fret: 10),
        ],
      ),
    ],
  ),

  // String 1: A
  Lesson(
    id: 'notes-a-nat-1',
    skill: Skill.notes,
    order: 4,
    string: 1,
    title: 'A, B, C e D na corda A',
    includesAccidentals: false,
    targets: const [
      Position(string: 1, fret: 0),
      Position(string: 1, fret: 2),
      Position(string: 1, fret: 3),
      Position(string: 1, fret: 5),
    ],
    referencePositions: const [
      Position(string: 0, fret: 5),
    ],
    hint: 'B e C são vizinhos (casas 2 e 3); D fica na casa 5.',
    steps: [
      LearnStep(
        title: 'Da corda solta até C',
        description:
            'A corda A solta (casa 0) é A. Suba um tom para B na casa 2 e 1 casa para C na casa 3.',
        highlightedPositions: const [
          Position(string: 1, fret: 0),
          Position(string: 1, fret: 2),
          Position(string: 1, fret: 3),
        ],
      ),
      LearnStep(
        title: 'D na casa 5',
        description:
            'De C (casa 3), suba um tom para D no marcador da casa 5.',
        highlightedPositions: const [
          Position(string: 1, fret: 5),
        ],
        referencePositions: const [
          Position(string: 1, fret: 3),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-a-nat-2',
    skill: Skill.notes,
    order: 5,
    string: 1,
    title: 'E, F, G e A na corda A',
    includesAccidentals: false,
    targets: const [
      Position(string: 1, fret: 7),
      Position(string: 1, fret: 8),
      Position(string: 1, fret: 10),
      Position(string: 1, fret: 12),
    ],
    referencePositions: const [
      Position(string: 1, fret: 5),
    ],
    hint: 'E e F ficam lado a lado (7 e 8); G (10) e A (12) seguem de tom em tom.',
    steps: [
      LearnStep(
        title: 'Semitom entre E e F',
        description:
            'E fica no marcador da casa 7 e F logo em seguida, na casa 8.',
        highlightedPositions: const [
          Position(string: 1, fret: 7),
          Position(string: 1, fret: 8),
        ],
        referencePositions: const [
          Position(string: 1, fret: 5),
        ],
      ),
      LearnStep(
        title: 'G e a oitava A',
        description:
            'Suba um tom de F (8) para G (10) e mais um tom para A na casa 12.',
        highlightedPositions: const [
          Position(string: 1, fret: 10),
          Position(string: 1, fret: 12),
        ],
        referencePositions: const [
          Position(string: 1, fret: 8),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-a-sharp',
    skill: Skill.notes,
    order: 6,
    string: 1,
    title: 'Sustenidos na corda A',
    includesAccidentals: true,
    targets: const [
      Position(string: 1, fret: 1),
      Position(string: 1, fret: 4),
      Position(string: 1, fret: 6),
      Position(string: 1, fret: 9),
      Position(string: 1, fret: 11),
    ],
    referencePositions: const [
      Position(string: 1, fret: 0),
      Position(string: 1, fret: 3),
      Position(string: 1, fret: 5),
      Position(string: 1, fret: 8),
      Position(string: 1, fret: 10),
    ],
    hint: 'Use as naturais próximas (C=3, D=5, F=8, G=10) e suba 1 casa.',
    steps: [
      LearnStep(
        title: 'Sustenido é uma casa acima',
        description:
            'O C fica na casa 3; suba uma casa para C♯ na casa 4. O mesmo vale para D (5) e D♯ (6).',
        highlightedPositions: const [
          Position(string: 1, fret: 4),
          Position(string: 1, fret: 6),
        ],
        referencePositions: const [
          Position(string: 1, fret: 3),
          Position(string: 1, fret: 5),
        ],
      ),
      LearnStep(
        title: 'A♯, F♯ e G♯ na corda A',
        description:
            'A solta (0) sobe para A♯ (1); F (8) sobe para F♯ (9) e G (10) para G♯ (11).',
        highlightedPositions: const [
          Position(string: 1, fret: 1),
          Position(string: 1, fret: 9),
          Position(string: 1, fret: 11),
        ],
        referencePositions: const [
          Position(string: 1, fret: 0),
          Position(string: 1, fret: 8),
          Position(string: 1, fret: 10),
        ],
      ),
    ],
  ),

  // String 2: D
  Lesson(
    id: 'notes-d-nat-1',
    skill: Skill.notes,
    order: 7,
    string: 2,
    title: 'D, E, F e G na corda D',
    includesAccidentals: false,
    targets: const [
      Position(string: 2, fret: 0),
      Position(string: 2, fret: 2),
      Position(string: 2, fret: 3),
      Position(string: 2, fret: 5),
    ],
    referencePositions: const [
      Position(string: 0, fret: 0),
      Position(string: 1, fret: 5),
    ],
    hint: 'E (2) e F (3) ficam juntos; G fica na casa 5.',
    steps: [
      LearnStep(
        title: 'Oitava e contagem a partir de D',
        description:
            'D solta (0) é a oitava da casa 5 da corda A. Suba um tom para E (2) e 1 casa para F (3).',
        highlightedPositions: const [
          Position(string: 2, fret: 0),
          Position(string: 2, fret: 2),
          Position(string: 2, fret: 3),
        ],
        referencePositions: const [
          Position(string: 1, fret: 5),
        ],
      ),
      LearnStep(
        title: 'G na casa 5',
        description:
            'De F (casa 3), suba um tom para G na casa 5.',
        highlightedPositions: const [
          Position(string: 2, fret: 5),
        ],
        referencePositions: const [
          Position(string: 2, fret: 3),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-d-nat-2',
    skill: Skill.notes,
    order: 8,
    string: 2,
    title: 'A, B, C e D na corda D',
    includesAccidentals: false,
    targets: const [
      Position(string: 2, fret: 7),
      Position(string: 2, fret: 9),
      Position(string: 2, fret: 10),
      Position(string: 2, fret: 12),
    ],
    referencePositions: const [
      Position(string: 2, fret: 5),
    ],
    hint: 'B (9) e C (10) têm só 1 casa de distância; D fecha na casa 12.',
    steps: [
      LearnStep(
        title: 'A e o par B–C',
        description:
            'A fica no marcador da casa 7, B na casa 9 e C logo ao lado na casa 10.',
        highlightedPositions: const [
          Position(string: 2, fret: 7),
          Position(string: 2, fret: 9),
          Position(string: 2, fret: 10),
        ],
        referencePositions: const [
          Position(string: 2, fret: 5),
        ],
      ),
      LearnStep(
        title: 'Oitava D na casa 12',
        description:
            'Suba um tom de C (casa 10) até D no marcador duplo (casa 12).',
        highlightedPositions: const [
          Position(string: 2, fret: 12),
        ],
        referencePositions: const [
          Position(string: 2, fret: 10),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-d-sharp',
    skill: Skill.notes,
    order: 9,
    string: 2,
    title: 'Sustenidos na corda D',
    includesAccidentals: true,
    targets: const [
      Position(string: 2, fret: 1),
      Position(string: 2, fret: 4),
      Position(string: 2, fret: 6),
      Position(string: 2, fret: 8),
      Position(string: 2, fret: 11),
    ],
    referencePositions: const [
      Position(string: 2, fret: 0),
      Position(string: 2, fret: 3),
      Position(string: 2, fret: 5),
      Position(string: 2, fret: 7),
      Position(string: 2, fret: 10),
    ],
    hint: 'Cada sustenido está 1 casa acima de D (0), F (3), G (5), A (7) e C (10).',
    steps: [
      LearnStep(
        title: 'D♯, F♯ e G♯ até a casa 6',
        description:
            'D (0) → D♯ (1), F (3) → F♯ (4) e G (5) → G♯ (6).',
        highlightedPositions: const [
          Position(string: 2, fret: 1),
          Position(string: 2, fret: 4),
          Position(string: 2, fret: 6),
        ],
        referencePositions: const [
          Position(string: 2, fret: 0),
          Position(string: 2, fret: 3),
          Position(string: 2, fret: 5),
        ],
      ),
      LearnStep(
        title: 'A♯ e C♯ na região aguda',
        description:
            'Suba 1 casa de A (7) para A♯ (8) e de C (10) para C♯ (11).',
        highlightedPositions: const [
          Position(string: 2, fret: 8),
          Position(string: 2, fret: 11),
        ],
        referencePositions: const [
          Position(string: 2, fret: 7),
          Position(string: 2, fret: 10),
        ],
      ),
    ],
  ),

  // String 3: G
  Lesson(
    id: 'notes-g-nat-1',
    skill: Skill.notes,
    order: 10,
    string: 3,
    title: 'G, A, B e C na corda G',
    includesAccidentals: false,
    targets: const [
      Position(string: 3, fret: 0),
      Position(string: 3, fret: 2),
      Position(string: 3, fret: 4),
      Position(string: 3, fret: 5),
    ],
    referencePositions: const [
      Position(string: 1, fret: 0),
      Position(string: 1, fret: 2),
      Position(string: 1, fret: 3),
    ],
    hint: 'A, B, C da corda A (0, 2, 3) reaparecem na corda G duas casas acima (2, 4, 5).',
    steps: [
      LearnStep(
        title: 'Shape da corda vizinha',
        description:
            'A, B e C da corda A (casas 0, 2, 3) são a oitava de A, B e C na corda G (casas 2, 4, 5).',
        highlightedPositions: const [
          Position(string: 3, fret: 2),
          Position(string: 3, fret: 4),
          Position(string: 3, fret: 5),
        ],
        referencePositions: const [
          Position(string: 1, fret: 0),
          Position(string: 1, fret: 2),
          Position(string: 1, fret: 3),
        ],
      ),
      LearnStep(
        title: 'Contagem a partir da corda G solta',
        description:
            'G solta (0) → A (tom, casa 2) → B (tom, casa 4) → C (semitom, casa 5).',
        highlightedPositions: const [
          Position(string: 3, fret: 0),
          Position(string: 3, fret: 2),
          Position(string: 3, fret: 4),
          Position(string: 3, fret: 5),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-g-nat-2',
    skill: Skill.notes,
    order: 11,
    string: 3,
    title: 'D, E, F e G na corda G',
    includesAccidentals: false,
    targets: const [
      Position(string: 3, fret: 7),
      Position(string: 3, fret: 9),
      Position(string: 3, fret: 10),
      Position(string: 3, fret: 12),
    ],
    referencePositions: const [
      Position(string: 3, fret: 5),
    ],
    hint: 'E (9) e F (10) ficam juntos; D (7) e G (12) completam a oitava.',
    steps: [
      LearnStep(
        title: 'D, E e F na corda G',
        description:
            'Suba um tom de C (5) para D (7), outro tom para E (9) e 1 casa para F (10).',
        highlightedPositions: const [
          Position(string: 3, fret: 7),
          Position(string: 3, fret: 9),
          Position(string: 3, fret: 10),
        ],
        referencePositions: const [
          Position(string: 3, fret: 5),
        ],
      ),
      LearnStep(
        title: 'Oitava G na casa 12',
        description:
            'De F (casa 10), suba um tom até G na casa 12.',
        highlightedPositions: const [
          Position(string: 3, fret: 12),
        ],
        referencePositions: const [
          Position(string: 3, fret: 10),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-g-sharp',
    skill: Skill.notes,
    order: 12,
    string: 3,
    title: 'Sustenidos na corda G',
    includesAccidentals: true,
    targets: const [
      Position(string: 3, fret: 1),
      Position(string: 3, fret: 3),
      Position(string: 3, fret: 6),
      Position(string: 3, fret: 8),
      Position(string: 3, fret: 11),
    ],
    referencePositions: const [
      Position(string: 3, fret: 0),
      Position(string: 3, fret: 2),
      Position(string: 3, fret: 5),
      Position(string: 3, fret: 7),
      Position(string: 3, fret: 10),
    ],
    hint: 'Suba 1 casa de G (0), A (2), C (5), D (7) e F (10).',
    steps: [
      LearnStep(
        title: 'G♯, A♯ e C♯',
        description:
            'G (0) → G♯ (1), A (2) → A♯ (3) e C (5) → C♯ (6).',
        highlightedPositions: const [
          Position(string: 3, fret: 1),
          Position(string: 3, fret: 3),
          Position(string: 3, fret: 6),
        ],
        referencePositions: const [
          Position(string: 3, fret: 0),
          Position(string: 3, fret: 2),
          Position(string: 3, fret: 5),
        ],
      ),
      LearnStep(
        title: 'D♯ e F♯ na corda G',
        description:
            'D (7) sobe para D♯ (8) e F (10) sobe para F♯ (11).',
        highlightedPositions: const [
          Position(string: 3, fret: 8),
          Position(string: 3, fret: 11),
        ],
        referencePositions: const [
          Position(string: 3, fret: 7),
          Position(string: 3, fret: 10),
        ],
      ),
    ],
  ),

  // String 4: B
  Lesson(
    id: 'notes-b-nat-1',
    skill: Skill.notes,
    order: 13,
    string: 4,
    title: 'B, C, D e E na corda B',
    includesAccidentals: false,
    targets: const [
      Position(string: 4, fret: 0),
      Position(string: 4, fret: 1),
      Position(string: 4, fret: 3),
      Position(string: 4, fret: 5),
    ],
    referencePositions: const [
      Position(string: 2, fret: 9),
    ],
    hint: 'B solta (0) vai direto para C (1); depois D (3) e E (5).',
    steps: [
      LearnStep(
        title: 'Semitom logo na casa 1',
        description:
            'B solta (0) sobe apenas 1 casa para C na casa 1.',
        highlightedPositions: const [
          Position(string: 4, fret: 0),
          Position(string: 4, fret: 1),
        ],
      ),
      LearnStep(
        title: 'D e E nas casas 3 e 5',
        description:
            'Pule uma casa a cada tom: D fica no primeiro marcador (3) e E na casa 5.',
        highlightedPositions: const [
          Position(string: 4, fret: 3),
          Position(string: 4, fret: 5),
        ],
        referencePositions: const [
          Position(string: 4, fret: 1),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-b-nat-2',
    skill: Skill.notes,
    order: 14,
    string: 4,
    title: 'F, G, A e B na corda B',
    includesAccidentals: false,
    targets: const [
      Position(string: 4, fret: 6),
      Position(string: 4, fret: 8),
      Position(string: 4, fret: 10),
      Position(string: 4, fret: 12),
    ],
    referencePositions: const [
      Position(string: 4, fret: 5),
    ],
    hint: 'E (5) vai direto para F (6); depois G (8), A (10) e B (12).',
    steps: [
      LearnStep(
        title: 'F logo após o E',
        description:
            'Entre E (5) e F (6) não há casa no meio. De F (6), suba um tom para G (8).',
        highlightedPositions: const [
          Position(string: 4, fret: 6),
          Position(string: 4, fret: 8),
        ],
        referencePositions: const [
          Position(string: 4, fret: 5),
        ],
      ),
      LearnStep(
        title: 'A e B até a casa 12',
        description:
            'Continue de tom em tom: A na casa 10 e a oitava B na casa 12.',
        highlightedPositions: const [
          Position(string: 4, fret: 10),
          Position(string: 4, fret: 12),
        ],
        referencePositions: const [
          Position(string: 4, fret: 8),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-b-sharp',
    skill: Skill.notes,
    order: 15,
    string: 4,
    title: 'Sustenidos na corda B',
    includesAccidentals: true,
    targets: const [
      Position(string: 4, fret: 2),
      Position(string: 4, fret: 4),
      Position(string: 4, fret: 7),
      Position(string: 4, fret: 9),
      Position(string: 4, fret: 11),
    ],
    referencePositions: const [
      Position(string: 4, fret: 1),
      Position(string: 4, fret: 3),
      Position(string: 4, fret: 6),
      Position(string: 4, fret: 8),
      Position(string: 4, fret: 10),
    ],
    hint: 'Suba 1 casa de C (1), D (3), F (6), G (8) e A (10).',
    steps: [
      LearnStep(
        title: 'C♯ e D♯ na corda B',
        description:
            'C (1) sobe para C♯ (2) e D (3) sobe para D♯ (4).',
        highlightedPositions: const [
          Position(string: 4, fret: 2),
          Position(string: 4, fret: 4),
        ],
        referencePositions: const [
          Position(string: 4, fret: 1),
          Position(string: 4, fret: 3),
        ],
      ),
      LearnStep(
        title: 'F♯, G♯ e A♯ na região aguda',
        description:
            'F (6) → F♯ (7), G (8) → G♯ (9) e A (10) → A♯ (11).',
        highlightedPositions: const [
          Position(string: 4, fret: 7),
          Position(string: 4, fret: 9),
          Position(string: 4, fret: 11),
        ],
        referencePositions: const [
          Position(string: 4, fret: 6),
          Position(string: 4, fret: 8),
          Position(string: 4, fret: 10),
        ],
      ),
    ],
  ),

  // String 5: High e
  Lesson(
    id: 'notes-e-high-nat-1',
    skill: Skill.notes,
    order: 16,
    string: 5,
    title: 'E, F, G e A na corda e aguda',
    includesAccidentals: false,
    targets: const [
      Position(string: 5, fret: 0),
      Position(string: 5, fret: 1),
      Position(string: 5, fret: 3),
      Position(string: 5, fret: 5),
    ],
    referencePositions: const [
      Position(string: 0, fret: 0),
      Position(string: 0, fret: 1),
      Position(string: 0, fret: 3),
      Position(string: 0, fret: 5),
    ],
    hint: 'A corda e aguda espelha exatamente as casas da corda E grave.',
    steps: [
      LearnStep(
        title: 'Mesmas casas da corda E grave',
        description:
            'As duas cordas E têm as mesmas notas em todas as casas: E (0), F (1), G (3) e A (5).',
        highlightedPositions: const [
          Position(string: 5, fret: 0),
          Position(string: 5, fret: 1),
          Position(string: 5, fret: 3),
          Position(string: 5, fret: 5),
        ],
        referencePositions: const [
          Position(string: 0, fret: 0),
          Position(string: 0, fret: 1),
          Position(string: 0, fret: 3),
          Position(string: 0, fret: 5),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-e-high-nat-2',
    skill: Skill.notes,
    order: 17,
    string: 5,
    title: 'B, C, D e E na corda e aguda',
    includesAccidentals: false,
    targets: const [
      Position(string: 5, fret: 7),
      Position(string: 5, fret: 8),
      Position(string: 5, fret: 10),
      Position(string: 5, fret: 12),
    ],
    referencePositions: const [
      Position(string: 5, fret: 5),
      Position(string: 0, fret: 7),
    ],
    hint: 'Igual à corda E grave: B (7), C (8), D (10) e E (12).',
    steps: [
      LearnStep(
        title: 'Casas 7 a 12 na corda e aguda',
        description:
            'B fica na casa 7, C logo ao lado na casa 8, D na casa 10 e E na casa 12.',
        highlightedPositions: const [
          Position(string: 5, fret: 7),
          Position(string: 5, fret: 8),
          Position(string: 5, fret: 10),
          Position(string: 5, fret: 12),
        ],
        referencePositions: const [
          Position(string: 5, fret: 5),
        ],
      ),
    ],
  ),
  Lesson(
    id: 'notes-e-high-sharp',
    skill: Skill.notes,
    order: 18,
    string: 5,
    title: 'Sustenidos na corda e aguda',
    includesAccidentals: true,
    targets: const [
      Position(string: 5, fret: 2),
      Position(string: 5, fret: 4),
      Position(string: 5, fret: 6),
      Position(string: 5, fret: 9),
      Position(string: 5, fret: 11),
    ],
    referencePositions: const [
      Position(string: 5, fret: 1),
      Position(string: 5, fret: 3),
      Position(string: 5, fret: 5),
      Position(string: 5, fret: 8),
      Position(string: 5, fret: 10),
    ],
    hint: 'Mesmo mapa da corda E grave: F♯ (2), G♯ (4), A♯ (6), C♯ (9) e D♯ (11).',
    steps: [
      LearnStep(
        title: 'Todos os sustenidos da corda e aguda',
        description:
            'Suba 1 casa a partir de cada natural: F♯ (2), G♯ (4), A♯ (6), C♯ (9) e D♯ (11).',
        highlightedPositions: const [
          Position(string: 5, fret: 2),
          Position(string: 5, fret: 4),
          Position(string: 5, fret: 6),
          Position(string: 5, fret: 9),
          Position(string: 5, fret: 11),
        ],
        referencePositions: const [
          Position(string: 5, fret: 1),
          Position(string: 5, fret: 3),
          Position(string: 5, fret: 5),
          Position(string: 5, fret: 8),
          Position(string: 5, fret: 10),
        ],
      ),
    ],
  ),
]);

/// Returns the curriculum lesson with [id], or null if not found.
Lesson? findNotesLessonById(String id) {
  for (final lesson in notesCurriculum) {
    if (lesson.id == id) return lesson;
  }
  return null;
}
