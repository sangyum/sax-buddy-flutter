import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';
import 'package:sax_buddy/features/notation/widgets/exercise_notation_card.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

final notationStories = [
  Story(
    name: 'Notation/NotationView',
    builder: (context) => _NotationViewStory(),
  ),
  Story(
    name: 'Notation/ExerciseNotationCard',
    builder: (context) => _ExerciseNotationCardStory(),
  ),
];

class _NotationViewStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sheetMusicData = SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.a, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.b, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.c, octave: 5, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: context.knobs.slider(
          label: 'Tempo',
          min: 60,
          max: 180,
          initial: 120,
        ).round(),
        title: context.knobs.text(
          label: 'Title',
          initial: 'C Major Scale',
        ),
      ),
    );

    final height = context.knobs.slider(
      label: 'Height',
      min: 100,
      max: 400,
      initial: 200,
    );

    final showLoading = context.knobs.boolean(
      label: 'Show Loading',
      initial: false,
    );

    final showNotation = context.knobs.boolean(
      label: 'Show Notation',
      initial: true,
    );

    return Scaffold(
      appBar: AppBar(title: Text('NotationView Story')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'NotationView Component',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: height,
              child: NotationView(
                sheetMusicData: showNotation ? sheetMusicData : null,
                isLoading: showLoading,
                height: height,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'This is a placeholder visualization. Future versions will use the simple_sheet_music package for actual notation rendering.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseNotationCardStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final withNotation = context.knobs.boolean(
      label: 'Include Notation Data',
      initial: true,
    );

    final showByDefault = context.knobs.boolean(
      label: 'Show Notation by Default',
      initial: false,
    );

    final exerciseName = context.knobs.text(
      label: 'Exercise Name',
      initial: 'C Major Scale',
    );

    final exerciseType = context.knobs.options(
      label: 'Exercise Type',
      initial: 'scale',
      options: [
        Option(label: 'Scale', value: 'scale'),
        Option(label: 'Arpeggio', value: 'arpeggio'),
        Option(label: 'Chromatic', value: 'chromatic'),
        Option(label: 'Intervals', value: 'intervals'),
        Option(label: 'Long Tones', value: 'long_tones'),
      ],
    );

    // Create different notation data based on exercise type
    SheetMusicData? sheetMusicData;
    if (withNotation) {
      switch (exerciseType) {
        case 'scale':
          sheetMusicData = _createScaleNotation(exerciseName);
          break;
        case 'arpeggio':
          sheetMusicData = _createArpeggioNotation(exerciseName);
          break;
        case 'chromatic':
          sheetMusicData = _createChromaticNotation();
          break;
        case 'intervals':
          sheetMusicData = _createIntervalsNotation();
          break;
        default:
          sheetMusicData = null;
      }
    }

    final exercise = PracticeExercise(
      name: exerciseName,
      description: _getExerciseDescription(exerciseType),
      tempo: '${context.knobs.slider(label: 'Tempo', min: 60, max: 180, initial: 120).round()} BPM',
      keySignature: context.knobs.options(
        label: 'Key Signature',
        initial: 'C Major',
        options: [
          Option(label: 'C Major', value: 'C Major'),
          Option(label: 'G Major', value: 'G Major'),
          Option(label: 'F Major', value: 'F Major'),
          Option(label: 'D Major', value: 'D Major'),
        ],
      ),
      estimatedDuration: '${context.knobs.slider(label: 'Duration (minutes)', min: 3, max: 20, initial: 10).round()} minutes',
      sheetMusicData: sheetMusicData,
    );

    return Scaffold(
      appBar: AppBar(title: Text('ExerciseNotationCard Story')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'ExerciseNotationCard Component',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: 16),
          ExerciseNotationCard(
            exercise: exercise,
            showNotationByDefault: showByDefault,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Component Features:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _featureItem('✅ Expandable notation display'),
                  _featureItem('✅ Exercise metadata (tempo, key, duration)'),
                  _featureItem('✅ Responsive design for different screen sizes'),
                  _featureItem('✅ Graceful fallback for missing notation'),
                  _featureItem('✅ Integration with existing exercise UI patterns'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(text, style: const TextStyle(fontSize: 14)),
    );
  }

  String _getExerciseDescription(String type) {
    switch (type) {
      case 'scale':
        return 'Practice major scale with proper fingering and intonation';
      case 'arpeggio':
        return 'Practice arpeggio patterns for chord progressions';
      case 'chromatic':
        return 'Practice chromatic scale for finger dexterity';
      case 'intervals':
        return 'Practice interval training for ear development';
      case 'long_tones':
        return 'Practice sustained notes for breath control';
      default:
        return 'Practice exercise with focused technique development';
    }
  }

  SheetMusicData _createScaleNotation(String title) {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.a, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.b, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.c, octave: 5, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 120,
        title: title,
      ),
    );
  }

  SheetMusicData _createArpeggioNotation(String title) {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
            MusicalNote(pitch: NotePitch.c, octave: 5, duration: NoteDuration.quarter),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 100,
        title: title,
      ),
    );
  }

  SheetMusicData _createChromaticNotation() {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.c, octave: 4, accidental: Accidental.sharp, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.d, octave: 4, accidental: Accidental.sharp, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.e, octave: 4, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.f, octave: 4, accidental: Accidental.sharp, duration: NoteDuration.eighth),
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.eighth),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 80,
        title: 'Chromatic Scale',
      ),
    );
  }

  SheetMusicData _createIntervalsNotation() {
    return SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.half),
            MusicalNote(pitch: NotePitch.f, octave: 4, duration: NoteDuration.half),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.half),
            MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.half),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: 90,
        title: 'Perfect 4ths and 5ths',
      ),
    );
  }
}