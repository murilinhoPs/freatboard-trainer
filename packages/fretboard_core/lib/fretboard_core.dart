/// Pure Dart music theory primitives for the standard guitar fretboard.
library;

/// Chromatic pitch class, ordered by semitone from C.
enum PitchClass { c, cs, d, ds, e, f, fs, g, gs, a, as_, b }

/// Open-string tuning, ordered from lowest to highest string.
final class Tuning {
  Tuning({required this.name, required List<PitchClass> openStrings})
    : openStrings = List.unmodifiable(openStrings) {
    if (openStrings.isEmpty)
      throw ArgumentError.value(openStrings, 'openStrings');
  }

  final String name;
  final List<PitchClass> openStrings;

  static final standard = Tuning(
    name: 'Standard',
    openStrings: [
      PitchClass.e,
      PitchClass.a,
      PitchClass.d,
      PitchClass.g,
      PitchClass.b,
      PitchClass.e,
    ],
  );
}

/// Instrument fret count excludes the open string (fret 0).
final class Instrument {
  const Instrument({required this.tuning, required this.frets})
    : assert(frets >= 0);

  final Tuning tuning;
  final int frets;
}

/// Zero-based string index (0 is lowest string) and fret number.
final class Position {
  const Position({required this.string, required this.fret});

  final int string;
  final int fret;

  @override
  bool operator ==(Object other) =>
      other is Position && string == other.string && fret == other.fret;

  @override
  int get hashCode => Object.hash(string, fret);

  @override
  String toString() => 'Position(string: $string, fret: $fret)';
}

/// Inclusive fret range.
final class FretRange {
  const FretRange(this.start, this.end)
    : assert(start >= 0),
      assert(end >= start);

  final int start;
  final int end;
}

final standardGuitar = Instrument(tuning: Tuning.standard, frets: 22);

void _validatePosition(Instrument instrument, Position position) {
  if (position.string < 0 ||
      position.string >= instrument.tuning.openStrings.length) {
    throw RangeError.range(
      position.string,
      0,
      instrument.tuning.openStrings.length - 1,
      'string',
    );
  }
  if (position.fret < 0 || position.fret > instrument.frets) {
    throw RangeError.range(position.fret, 0, instrument.frets, 'fret');
  }
}

/// Return pitch at [position]. Invalid string/fret throws [RangeError].
PitchClass noteAt(Instrument instrument, Position position) {
  _validatePosition(instrument, position);
  return PitchClass.values[(PitchClass.values.indexOf(
            instrument.tuning.openStrings[position.string],
          ) +
          position.fret) %
      12];
}

/// List every matching position, ordered by string then fret, range inclusive.
List<Position> positionsOf(
  Instrument instrument,
  PitchClass note,
  FretRange range,
) {
  if (range.start < 0 ||
      range.end > instrument.frets ||
      range.end < range.start) {
    throw RangeError(
      'Fret range ${range.start}..${range.end} outside 0..${instrument.frets}',
    );
  }
  return [
    for (
      var string = 0;
      string < instrument.tuning.openStrings.length;
      string++
    )
      for (var fret = range.start; fret <= range.end; fret++)
        if (noteAt(instrument, Position(string: string, fret: fret)) == note)
          Position(string: string, fret: fret),
  ];
}

/// Nearest higher-string position one octave above [position].
/// Ties resolve to the lower fret, then the lower string index.
Position? octaveOf(Instrument instrument, Position position) {
  _validatePosition(instrument, position);
  final sourceOffset =
      PitchClass.values.indexOf(
        instrument.tuning.openStrings[position.string],
      ) +
      position.fret;
  final candidates = [
    for (
      var string = position.string + 1;
      string < instrument.tuning.openStrings.length;
      string++
    )
      for (var fret = 0; fret <= instrument.frets; fret++)
        if (PitchClass.values.indexOf(instrument.tuning.openStrings[string]) +
                fret -
                sourceOffset ==
            12)
          Position(string: string, fret: fret),
  ];
  candidates.sort((a, b) {
    final stringDistance = a.string.compareTo(b.string);
    return stringDistance != 0 ? stringDistance : a.fret.compareTo(b.fret);
  });
  return candidates.firstOrNull;
}

/// Physical inlay number at fret; zero means no marker.
int inlayIndex(int fret) {
  if (fret < 0) throw RangeError.value(fret, 'fret');
  if (fret == 12 || fret == 24) return 2;
  const frets = [3, 5, 7, 9, 15, 17, 19, 21];
  final index = frets.indexOf(fret);
  return index < 0 ? 0 : 1;
}

/// Ascending chromatic path, excluding [from] and including [to].
List<PitchClass> countPath(PitchClass from, PitchClass to) {
  final start = PitchClass.values.indexOf(from);
  final end = PitchClass.values.indexOf(to);
  return [
    for (var i = 1; i <= (end - start + 12) % 12; i++)
      PitchClass.values[(start + i) % 12],
  ];
}

/// Explanation strategy selected for a note answer.
enum ExplanationKind { count, octave, inlay }

/// Feedback explanation for a target position.
final class Explanation {
  const Explanation(this.kind, this.text);

  final ExplanationKind kind;
  final String text;

  @override
  bool operator ==(Object other) =>
      other is Explanation && other.kind == kind && other.text == text;

  @override
  int get hashCode => Object.hash(kind, text);
}

String _noteName(PitchClass note) => switch (note) {
  PitchClass.cs => 'C♯',
  PitchClass.ds => 'D♯',
  PitchClass.fs => 'F♯',
  PitchClass.gs => 'G♯',
  PitchClass.as_ => 'A♯',
  _ => note.name.toUpperCase(),
};

String _stringName(Instrument instrument, int string) {
  final note = _noteName(instrument.tuning.openStrings[string]);
  return note == 'E' && string == instrument.tuning.openStrings.length - 1
      ? 'high E'
      : note;
}

/// Generate stable, localized-neutral explanation using one available strategy.
/// Count is preferred when [anchor] is supplied, then octave, then inlay.
Explanation explainPosition(
  Instrument instrument,
  Position target, {
  Position? anchor,
}) {
  final note = noteAt(instrument, target);
  if (anchor != null) {
    final anchorNote = noteAt(instrument, anchor);
    final chromaticDistance =
        (PitchClass.values.indexOf(note) -
            PitchClass.values.indexOf(anchorNote) +
            12) %
        12;
    if (chromaticDistance == 0) {
      return Explanation(
        ExplanationKind.count,
        'Both positions are ${_noteName(note)}.',
      );
    }
    final path = countPath(anchorNote, note);
    final sequence = [anchorNote, ...path].map(_noteName).join(' → ');
    final between = chromaticDistance == 1 || chromaticDistance == 11
        ? '${_noteName(anchorNote)} and ${_noteName(note)} have no note between them'
        : 'Count up from ${_noteName(anchorNote)} on fret ${anchor.fret}: $sequence';
    return Explanation(ExplanationKind.count, between);
  }
  final octave = octaveOf(instrument, target);
  if (octave != null) {
    final stringDistance = octave.string - target.string;
    final fretDistance = octave.fret - target.fret;
    final direction = fretDistance >= 0 ? 'higher' : 'lower';
    final delta = fretDistance.abs();
    final stringUnit = stringDistance == 1 ? 'string' : 'strings';
    final fretUnit = delta == 1 ? 'fret' : 'frets';
    return Explanation(
      ExplanationKind.octave,
      "It's the octave of ${_noteName(note)} on the ${_stringName(instrument, target.string)} string (fret ${target.fret}): $stringDistance $stringUnit up, $delta $fretUnit $direction.",
    );
  }
  final marker = inlayIndex(target.fret);
  if (marker > 0) {
    final ordinal = marker == 2 ? 'second' : 'first';
    return Explanation(
      ExplanationKind.inlay,
      '${_noteName(note)} sits on the $ordinal dot of the ${_stringName(instrument, target.string)} string, fret ${target.fret}.',
    );
  }
  return Explanation(
    ExplanationKind.count,
    '${_noteName(note)} is on the ${_stringName(instrument, target.string)} string, fret ${target.fret}.',
  );
}
