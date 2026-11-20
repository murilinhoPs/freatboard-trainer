import 'dart:math' as math;

import 'package:fretboard_core/fretboard_core.dart';

/// MIDI number of each open string in standard tuning, low E to high e.
const openStringMidi = [40, 45, 50, 55, 59, 64];

/// MIDI number of the bundled A2 pluck used to pitch the other notes.
const sampleMidi = 45;

const noteSpellings = [
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

/// Spoken string name for semantics. Index 0 is the low E string.
String stringLabel(int string) => switch (string) {
  0 => 'E grave',
  1 => 'A',
  2 => 'D',
  3 => 'G',
  4 => 'B',
  5 => 'e',
  _ => throw RangeError.index(string, openStringMidi, 'string'),
};

/// Note spelling at [position] on the standard guitar.
String noteSpelling(Position position) {
  final pitch = noteAt(standardGuitar, position);
  return noteSpellings[PitchClass.values.indexOf(pitch)];
}

/// Playback speed that shifts the A2 sample to the pitch at [position].
///
/// `1` is A2. Each octave doubles the speed, which also shortens the pluck.
double playbackScaleFor(Position position) {
  if (position.string < 0 || position.string >= openStringMidi.length) {
    throw RangeError.index(position.string, openStringMidi, 'string');
  }
  if (position.fret < 0 || position.fret > standardGuitar.frets) {
    throw RangeError.range(position.fret, 0, standardGuitar.frets, 'fret');
  }
  final midi = openStringMidi[position.string] + position.fret;
  return math.pow(2, (midi - sampleMidi) / 12).toDouble();
}
