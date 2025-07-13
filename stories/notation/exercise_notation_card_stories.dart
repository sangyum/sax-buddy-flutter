import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/notation/widgets/exercise_notation_card.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

final List<Story> exerciseNotationCardStories = [
  Story(
    name: 'ExerciseNotationCard/Basic Scale Exercise',
    description: 'Basic exercise card with C major scale notation',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createScaleExercise(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Expanded by Default',
    description: 'Exercise card with notation expanded by default',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createArpeggioExercise(),
          showNotationByDefault: true,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Complex Exercise',
    description: 'Advanced exercise with complex notation and mixed durations',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createComplexExercise(),
          showNotationByDefault: true,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Without Notation',
    description: 'Exercise card without musical notation data',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createExerciseWithoutNotation(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Long Title Exercise',
    description: 'Exercise with very long title and description',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createLongTitleExercise(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Interactive States',
    description: 'Multiple cards showing various interactive states',
    builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Collapsed State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExerciseNotationCard(
              exercise: _createScaleExercise(),
              showNotationByDefault: false,
            ),
            const SizedBox(height: 24),
            const Text(
              'Expanded State',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExerciseNotationCard(
              exercise: _createArpeggioExercise(),
              showNotationByDefault: true,
            ),
            const SizedBox(height: 24),
            const Text(
              'Without Musical Notation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ExerciseNotationCard(
              exercise: _createExerciseWithoutNotation(),
              showNotationByDefault: false,
            ),
          ],
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Tap Callbacks',
    description: 'Exercise card with tap callback demonstration',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Tap on the card to see callback',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            ExerciseNotationCard(
              exercise: _createScaleExercise(),
              showNotationByDefault: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exercise card tapped!')),
                );
              },
            ),
          ],
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Different Durations',
    description: 'Exercise cards with various duration estimates',
    builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ExerciseNotationCard(
              exercise: _createExerciseWithDuration('5 minutes'),
              showNotationByDefault: false,
            ),
            const SizedBox(height: 16),
            ExerciseNotationCard(
              exercise: _createExerciseWithDuration('15 minutes'),
              showNotationByDefault: false,
            ),
            const SizedBox(height: 16),
            ExerciseNotationCard(
              exercise: _createExerciseWithDuration('30 minutes'),
              showNotationByDefault: false,
            ),
          ],
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Error Handling',
    description: 'Exercise card with invalid notation data',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createExerciseWithInvalidNotation(),
          showNotationByDefault: true,
        ),
      );
    },
  ),
];

// Helper functions to create sample exercises

PracticeExercise _createScaleExercise() {
  return PracticeExercise(
    name: 'C Major Scale',
    description: 'Practice ascending and descending C major scale with proper fingering and breath control.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: '10 minutes',
    etude: PracticeExercise.convertJsonToMeasures(_cMajorScaleNotation),
  );
}

PracticeExercise _createArpeggioExercise() {
  return PracticeExercise(
    name: 'D Major Arpeggio',
    description: 'Focus on smooth transitions between notes in the D major triad.',
    tempo: '♩ = 100',
    keySignature: 'D Major',
    estimatedDuration: '8 minutes',
    etude: PracticeExercise.convertJsonToMeasures(_dMajorArpeggioNotation),
  );
}

PracticeExercise _createComplexExercise() {
  return PracticeExercise(
    name: 'Advanced Rhythm Patterns',
    description: 'Complex exercise combining mixed note durations, accidentals, and syncopated rhythms for advanced players.',
    tempo: '♩ = 140',
    keySignature: 'F Major',
    estimatedDuration: '20 minutes',
    etude: PracticeExercise.convertJsonToMeasures(_complexExerciseNotation),
  );
}

PracticeExercise _createExerciseWithoutNotation() {
  return PracticeExercise(
    name: 'Breathing Exercise',
    description: 'Focus on proper breathing technique and air support without instrument.',
    estimatedDuration: '5 minutes',
    etude: null,
  );
}

PracticeExercise _createLongTitleExercise() {
  return PracticeExercise(
    name: 'Extended Chromatic Scale Exercise with Complex Articulation Patterns and Dynamic Variations',
    description: 'This is a very comprehensive exercise that includes multiple technical elements such as chromatic passages, various articulation patterns including staccato, legato, and accent marks, as well as dynamic variations from pianissimo to fortissimo, designed to challenge intermediate to advanced saxophone players.',
    tempo: '♩ = 80',
    keySignature: 'Bb Major',
    estimatedDuration: '25 minutes',
    etude: PracticeExercise.convertJsonToMeasures(_cMajorScaleNotation),
  );
}

PracticeExercise _createExerciseWithDuration(String duration) {
  return PracticeExercise(
    name: 'Scale Practice',
    description: 'Basic scale exercise with different duration estimate.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: duration,
    etude: PracticeExercise.convertJsonToMeasures(_cMajorScaleNotation),
  );
}

PracticeExercise _createExerciseWithInvalidNotation() {
  return PracticeExercise(
    name: 'Error Test Exercise',
    description: 'Exercise with invalid notation data to test error handling.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: '10 minutes',
    etude: null, // Invalid notation should result in null etude
  );
}

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
      ]
    },
    {
      'notes': [
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c5', 'duration': 'quarter', 'accidental': null},
      ]
    },
    {
      'notes': [
        {'pitch': 'b4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'g4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
      ]
    },
    {
      'notes': [
        {'pitch': 'e4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'c4', 'duration': 'half', 'accidental': null},
      ]
    },
  ]
};

final Map<String, dynamic> _dMajorArpeggioNotation = {
  'clef': 'treble',
  'keySignature': 'dMajor',
  'tempo': 100,
  'measures': [
    {
      'notes': [
        {'pitch': 'd4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': 'sharp'},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'd5', 'duration': 'quarter', 'accidental': null},
      ]
    },
    {
      'notes': [
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': 'sharp'},
        {'pitch': 'd4', 'duration': 'half', 'accidental': null},
      ]
    },
  ]
};

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
      ]
    },
    {
      'notes': [
        {'pitch': 'c5', 'duration': 'half', 'accidental': null},
        {'pitch': 'f4', 'duration': 'quarter', 'accidental': null},
        {'pitch': 'a4', 'duration': 'quarter', 'accidental': null},
      ]
    },
    {
      'notes': [
        {'pitch': 'b4', 'duration': 'sixteenth', 'accidental': 'flat'},
        {'pitch': 'a4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'g4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'f4', 'duration': 'sixteenth', 'accidental': null},
        {'pitch': 'c5', 'duration': 'half', 'accidental': null},
      ]
    },
    {
      'notes': [
        {'pitch': 'f4', 'duration': 'whole', 'accidental': null},
      ]
    },
  ]
};

