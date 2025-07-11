import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';
import 'package:sax_buddy/features/notation/widgets/notation_view.dart';
import 'package:sax_buddy/features/notation/widgets/exercise_notation_card.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/notation/services/notation_generation_service.dart';

import '../../test/utils/test_notation_helper.dart';

final notationStories = [
  Story(
    name: 'Notation/NotationView',
    builder: (context) => _NotationViewStory(),
  ),
  Story(
    name: 'Notation/ExerciseNotationCard',
    builder: (context) => _ExerciseNotationCardStory(),
  ),
  Story(
    name: 'Notation/NotationGenerator',
    builder: (context) => _NotationGeneratorStory(),
  ),
];

class _NotationViewStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final sheetMusicData = SheetMusicData(
      measures: [
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.c,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.d,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.e,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.f,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
        MusicalMeasure(
          notes: [
            MusicalNote(
              pitch: NotePitch.g,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.a,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.b,
              octave: 4,
              duration: NoteDuration.quarter,
            ),
            MusicalNote(
              pitch: NotePitch.c,
              octave: 5,
              duration: NoteDuration.quarter,
            ),
          ],
          timeSignature: TimeSignature.fourFour,
          keySignature: KeySignature.cMajor,
        ),
      ],
      metadata: NotationMetadata(
        clef: Clef.treble,
        tempo: context.knobs
            .slider(label: 'Tempo', min: 60, max: 180, initial: 120)
            .round(),
        title: context.knobs.text(label: 'Title', initial: 'C Major Scale'),
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
          sheetMusicData = TestNotationHelper.createScaleNotation(title: exerciseName);
          break;
        case 'arpeggio':
          sheetMusicData = TestNotationHelper.createArpeggioNotation(title: exerciseName);
          break;
        case 'chromatic':
          sheetMusicData = TestNotationHelper.createChromaticNotation();
          break;
        case 'intervals':
          sheetMusicData = TestNotationHelper.createIntervalsNotation();
          break;
        default:
          sheetMusicData = null;
      }
    }

    final exercise = PracticeExercise(
      name: exerciseName,
      description: _getExerciseDescription(exerciseType),
      tempo:
          '${context.knobs.slider(label: 'Tempo', min: 60, max: 180, initial: 120).round()} BPM',
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
      estimatedDuration:
          '${context.knobs.slider(label: 'Duration (minutes)', min: 3, max: 20, initial: 10).round()} minutes',
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
                  _featureItem(
                    '✅ Responsive design for different screen sizes',
                  ),
                  _featureItem('✅ Graceful fallback for missing notation'),
                  _featureItem(
                    '✅ Integration with existing exercise UI patterns',
                  ),
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
}

class _NotationGeneratorStory extends StatefulWidget {
  @override
  State<_NotationGeneratorStory> createState() =>
      _NotationGeneratorStoryState();
}

class _NotationGeneratorStoryState extends State<_NotationGeneratorStory> {
  final _notationService = NotationGenerationService();
  SheetMusicData? _generatedNotation;
  String _selectedType = 'scale';
  String _selectedKey = 'C';
  String _selectedScaleType = 'major';
  String _selectedChordType = 'major';
  int _selectedTempo = 120;

  void _generateNotation() {
    try {
      SheetMusicData notation;

      switch (_selectedType) {
        case 'scale':
          final scaleType = _selectedScaleType == 'major'
              ? ScaleType.major
              : _selectedScaleType == 'minor'
              ? ScaleType.minor
              : ScaleType.chromatic;
          notation = _notationService.generateScaleNotation(
            key: _selectedKey,
            scaleType: scaleType,
            octave: 4,
            tempo: _selectedTempo,
          );
          break;
        case 'arpeggio':
          final chordType = _selectedChordType == 'major'
              ? ChordType.major
              : _selectedChordType == 'minor'
              ? ChordType.minor
              : ChordType.dominant7;
          notation = _notationService.generateArpeggioNotation(
            key: _selectedKey,
            chordType: chordType,
            octave: 4,
            tempo: _selectedTempo,
          );
          break;
        case 'longTone':
          notation = _notationService.generateLongToneNotation(
            notes: ['${_selectedKey}4', '${_selectedKey}5'],
            tempo: _selectedTempo,
          );
          break;
        case 'intervals':
          notation = _notationService.generateIntervalNotation(
            startNote: '${_selectedKey}4',
            intervalType: IntervalType.perfect5th,
            repetitions: 2,
            tempo: _selectedTempo,
          );
          break;
        default:
          return;
      }

      setState(() {
        _generatedNotation = notation;
      });
    } catch (e) {
      setState(() {
        _generatedNotation = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _generateNotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notation Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notation Generator Service',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Controls
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Generation Parameters',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Exercise Type
                    Row(
                      children: [
                        const Text('Type: '),
                        DropdownButton<String>(
                          value: _selectedType,
                          items: const [
                            DropdownMenuItem(
                              value: 'scale',
                              child: Text('Scale'),
                            ),
                            DropdownMenuItem(
                              value: 'arpeggio',
                              child: Text('Arpeggio'),
                            ),
                            DropdownMenuItem(
                              value: 'longTone',
                              child: Text('Long Tone'),
                            ),
                            DropdownMenuItem(
                              value: 'intervals',
                              child: Text('Intervals'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value!;
                            });
                            _generateNotation();
                          },
                        ),
                      ],
                    ),

                    // Key
                    Row(
                      children: [
                        const Text('Key: '),
                        DropdownButton<String>(
                          value: _selectedKey,
                          items: const [
                            DropdownMenuItem(value: 'C', child: Text('C')),
                            DropdownMenuItem(value: 'D', child: Text('D')),
                            DropdownMenuItem(value: 'E', child: Text('E')),
                            DropdownMenuItem(value: 'F', child: Text('F')),
                            DropdownMenuItem(value: 'G', child: Text('G')),
                            DropdownMenuItem(value: 'A', child: Text('A')),
                            DropdownMenuItem(value: 'B', child: Text('B')),
                            DropdownMenuItem(value: 'BB', child: Text('Bb')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedKey = value!;
                            });
                            _generateNotation();
                          },
                        ),
                      ],
                    ),

                    // Scale Type (only for scales)
                    if (_selectedType == 'scale')
                      Row(
                        children: [
                          const Text('Scale Type: '),
                          DropdownButton<String>(
                            value: _selectedScaleType,
                            items: const [
                              DropdownMenuItem(
                                value: 'major',
                                child: Text('Major'),
                              ),
                              DropdownMenuItem(
                                value: 'minor',
                                child: Text('Minor'),
                              ),
                              DropdownMenuItem(
                                value: 'chromatic',
                                child: Text('Chromatic'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedScaleType = value!;
                              });
                              _generateNotation();
                            },
                          ),
                        ],
                      ),

                    // Chord Type (only for arpeggios)
                    if (_selectedType == 'arpeggio')
                      Row(
                        children: [
                          const Text('Chord Type: '),
                          DropdownButton<String>(
                            value: _selectedChordType,
                            items: const [
                              DropdownMenuItem(
                                value: 'major',
                                child: Text('Major'),
                              ),
                              DropdownMenuItem(
                                value: 'minor',
                                child: Text('Minor'),
                              ),
                              DropdownMenuItem(
                                value: 'dominant7',
                                child: Text('Dominant 7th'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedChordType = value!;
                              });
                              _generateNotation();
                            },
                          ),
                        ],
                      ),

                    // Tempo Slider
                    Row(
                      children: [
                        const Text('Tempo: '),
                        Expanded(
                          child: Slider(
                            value: _selectedTempo.toDouble(),
                            min: 60,
                            max: 180,
                            divisions: 24,
                            label: '$_selectedTempo BPM',
                            onChanged: (value) {
                              setState(() {
                                _selectedTempo = value.round();
                              });
                              _generateNotation();
                            },
                          ),
                        ),
                        Text('$_selectedTempo BPM'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Generated Notation Display
            Expanded(
              child: _generatedNotation != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Generated Notation:',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: NotationView(
                            sheetMusicData: _generatedNotation,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Measures: ${_generatedNotation!.measures.length} | '
                          'Total Notes: ${_generatedNotation!.measures.expand((m) => m.notes).length}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    )
                  : const Center(child: Text('Failed to generate notation')),
            ),
          ],
        ),
      ),
    );
  }
}
