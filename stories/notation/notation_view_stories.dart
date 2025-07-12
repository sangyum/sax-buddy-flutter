import 'package:flutter/material.dart';
import 'package:simple_sheet_music/simple_sheet_music.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';
import 'package:sax_buddy/features/notation/services/simple_sheet_music_service.dart';

final List<Story> notationViewStories = [
  Story(
    name: 'NotationView/C Major Scale',
    description: 'NotationView displaying a C major scale exercise',
    builder: (context) {
      final service = SimpleSheetMusicService();
      final measures = service.convertJsonToMeasures(_cMajorScaleNotation);
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          measures: measures,
          height: 250,
          tempo: 120,
          title: 'C Major Scale',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/D Major Arpeggio',
    description: 'NotationView showing a D major arpeggio with sharps',
    builder: (context) {
      final measures = _dMajorArpeggioNotation;
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          measures: measures,
          height: 250,
          tempo: 100,
          title: 'D Major Arpeggio',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Complex Exercise',
    description: 'NotationView with mixed note durations and accidentals',
    builder: (context) {
      final service = SimpleSheetMusicService();
      final measures = service.convertJsonToMeasures(_complexExerciseNotation);
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          measures: measures,
          height: 250,
          tempo: 140,
          title: 'Complex Exercise',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Small Size',
    description: 'NotationView in compact mode (100px height)',
    builder: (context) {
      final service = SimpleSheetMusicService();
      final measures = service.convertJsonToMeasures(_cMajorScaleNotation);
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(measures: measures, height: 100, tempo: 120),
      );
    },
  ),
  Story(
    name: 'NotationView/Large Size',
    description: 'NotationView in expanded mode (400px height)',
    builder: (context) {
      final service = SimpleSheetMusicService();
      final measures = service.convertJsonToMeasures(_cMajorScaleNotation);
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(
          measures: measures,
          height: 400,
          tempo: 120,
          title: 'C Major Scale - Large',
        ),
      );
    },
  ),
  Story(
    name: 'NotationView/Loading State',
    description: 'NotationView showing loading indicator',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(measures: null, isLoading: true, height: 250),
      );
    },
  ),
  Story(
    name: 'NotationView/Empty State',
    description: 'NotationView with no musical notation data',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(measures: null, height: 250),
      );
    },
  ),
  Story(
    name: 'NotationView/Error State',
    description: 'NotationView with empty measures list',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: NotationView(measures: [], height: 250, title: 'Error State'),
      );
    },
  ),
  Story(
    name: 'NotationView/Different Tempos',
    description: 'NotationView examples with various tempo markings',
    builder: (context) {
      final service = SimpleSheetMusicService();
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Slow (60 BPM)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            NotationView(
              measures: service.convertJsonToMeasures(
                _getNotationWithTempo(60),
              ),
              height: 200,
              tempo: 60,
              title: 'Slow Exercise',
            ),
            const SizedBox(height: 24),
            const Text(
              'Moderate (120 BPM)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            NotationView(
              measures: service.convertJsonToMeasures(
                _getNotationWithTempo(120),
              ),
              height: 200,
              tempo: 120,
              title: 'Moderate Exercise',
            ),
            const SizedBox(height: 24),
            const Text(
              'Fast (180 BPM)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            NotationView(
              measures: service.convertJsonToMeasures(
                _getNotationWithTempo(180),
              ),
              height: 200,
              tempo: 180,
              title: 'Fast Exercise',
            ),
          ],
        ),
      );
    },
  ),
];

// Sample musical notation data
final Map<String, dynamic> _cMajorScaleNotation = {
  'clef': 'treble',
  'keySignature': 'cMajor',
  'tempo': 120,
  'measures': [
    {
      'notes': [
        {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c5', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c4', 'duration': 'half', 'accidental': null},
      ],
    },
  ],
};

final List<Measure> _dMajorArpeggioNotation = [
  Measure([
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
  ]),
  // Measure([
  //   const Clef(ClefType.treble),
  //   const KeySignature(KeySignatureType.dMajor),
  //   const Note(Pitch.d4, noteDuration: NoteDuration.quarter),
  //   const Note(Pitch.f4, noteDuration: NoteDuration.quarter, accidental: Accidental.sharp),
  //   const Note(Pitch.a4, noteDuration: NoteDuration.quarter),
  //   const Note(Pitch.d5, noteDuration: NoteDuration.quarter),
  // ]),
  // Measure([
  //   const Clef(ClefType.treble),
  //   const KeySignature(KeySignatureType.dMajor),
  //   const Note(Pitch.a4, noteDuration: NoteDuration.quarter),
  //   const Note(Pitch.f4, noteDuration: NoteDuration.quarter, accidental: Accidental.sharp),
  //   const Note(Pitch.d4, noteDuration: NoteDuration.quarter),
  // ]),
];

final Map<String, dynamic> _complexExerciseNotation = {
  'clef': 'treble',
  'keySignature': 'fMajor',
  'tempo': 140,
  'measures': [
    {
      'notes': [
        {'pitch': 'f4', 'duration': 'eighth', 'accidental': null},
        {'pitch': 'g4', 'duration': 'eighth', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': 'flat'},
      ],
    },
    {
      'notes': [
        {'pitch': 'c5', 'duration': 'half', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'b4', 'duration': 'sixteenth', 'accidental': 'flat'},
        {'pitch': 'a4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'g4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'f4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'c5', 'duration': 'half', 'accidental': null},
      ],
    },
    {
      'notes': [
        {'pitch': 'f4', 'duration': 'whole', 'accidental': null},
      ],
    },
  ],
};

Map<String, dynamic> _getNotationWithTempo(int tempo) => {
  'clef': 'treble',
  'keySignature': 'cMajor',
  'tempo': tempo,
  'measures': [
    {
      'notes': [
        {'pitch': 'c4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c5', 'duration': 'quarter', 'accidental': null},
      ],
    },
  ],
};
