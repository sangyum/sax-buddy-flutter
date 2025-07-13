import 'package:flutter/material.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';
import 'package:storybook_flutter/storybook_flutter.dart';

final measure1 = Measure([
  const Clef(ClefType.treble),
  const KeySignature(KeySignatureType.dMajor),
  const ChordNote([
    ChordNotePart(Pitch.b4),
    ChordNotePart(Pitch.g5, accidental: Accidental.sharp),
  ]),
  const Rest(RestType.quarter),
  const Note(
    Pitch.a4,
    noteDuration: NoteDuration.sixteenth,
    accidental: Accidental.flat,
  ),
  const Rest(RestType.sixteenth),
]);
final measure2 = Measure([
  const ChordNote([
    ChordNotePart(Pitch.c4),
    ChordNotePart(Pitch.c5),
  ], noteDuration: NoteDuration.sixteenth),
  const Note(
    Pitch.a4,
    noteDuration: NoteDuration.sixteenth,
    accidental: Accidental.flat,
  ),
]);
final measure3 = Measure([
  const Clef(ClefType.bass),
  const KeySignature(KeySignatureType.cMinor),
  const ChordNote([ChordNotePart(Pitch.c2), ChordNotePart(Pitch.c3)]),
  const Rest(RestType.quarter),
  const Note(
    Pitch.a3,
    noteDuration: NoteDuration.whole,
    accidental: Accidental.flat,
  ),
], isNewLine: true);

final singleNoteMeasures = [
  Measure([
    const Clef(ClefType.treble),
    const KeySignature(KeySignatureType.cMajor),
    const Note(Pitch.c4, noteDuration: NoteDuration.quarter),
    const Note(Pitch.c4, noteDuration: NoteDuration.quarter),
    const Note(Pitch.c4, noteDuration: NoteDuration.quarter),
    const Note(Pitch.c4, noteDuration: NoteDuration.quarter),
  ]),
];

final List<Story> sheetMusicStories = [
  Story(
    name: "Simple Sheet Music/Chords",
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: SimpleSheetMusic(measures: [measure1, measure2, measure3]),
      );
    },
  ),
  Story(
    name: "Simple Sheet Music/Single Notes",
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: SimpleSheetMusic(measures: singleNoteMeasures),
      );
    },
  ),
];
