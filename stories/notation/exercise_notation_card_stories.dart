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
    description: 'Complex exercise with mixed durations and accidentals',
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
    description: 'Exercise card without any notation data',
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
    name: 'ExerciseNotationCard/Invalid Notation',
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
  Story(
    name: 'ExerciseNotationCard/Long Title',
    description: 'Exercise card with a very long title',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createExerciseWithLongTitle(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Multiple Cards',
    description: 'Multiple exercise cards in a column',
    builder: (context) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ExerciseNotationCard(
              exercise: _createScaleExercise(),
              showNotationByDefault: false,
            ),
            const SizedBox(height: 16),
            ExerciseNotationCard(
              exercise: _createArpeggioExercise(),
              showNotationByDefault: false,
            ),
            const SizedBox(height: 16),
            ExerciseNotationCard(
              exercise: _createComplexExercise(),
              showNotationByDefault: false,
            ),
          ],
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/No Tempo or Key',
    description: 'Exercise card without tempo or key signature',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: ExerciseNotationCard(
          exercise: _createBasicExercise(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
  Story(
    name: 'ExerciseNotationCard/Small Card',
    description: 'Exercise card with constrained height',
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: 200,
        child: ExerciseNotationCard(
          exercise: _createScaleExercise(),
          showNotationByDefault: false,
        ),
      );
    },
  ),
];

// Exercise creation functions

PracticeExercise _createScaleExercise() {
  return PracticeExercise(
    name: 'C Major Scale',
    description: 'Practice the C major scale ascending and descending with quarter notes at a moderate tempo.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: '10 minutes',
    notes: 'Focus on even fingering and smooth transitions between notes.',
    musicXML: _cMajorScaleMusicXML,
  );
}

PracticeExercise _createArpeggioExercise() {
  return PracticeExercise(
    name: 'D Major Arpeggio',
    description: 'Focus on smooth transitions between notes in the D major triad.',
    tempo: '♩ = 100',
    keySignature: 'D Major',
    estimatedDuration: '8 minutes',
    musicXML: _dMajorArpeggioMusicXML,
  );
}

PracticeExercise _createComplexExercise() {
  return PracticeExercise(
    name: 'Mixed Rhythms Etude',
    description: 'Complex exercise combining mixed note durations, accidentals, and syncopated rhythms for advanced players.',
    tempo: '♩ = 140',
    keySignature: 'F Major',
    estimatedDuration: '20 minutes',
    musicXML: _complexExerciseMusicXML,
  );
}

PracticeExercise _createExerciseWithoutNotation() {
  return PracticeExercise(
    name: 'Breathing Exercise',
    description: 'Practice proper breathing technique and breath support.',
    tempo: null,
    keySignature: null,
    estimatedDuration: '5 minutes',
    notes: 'Focus on diaphragmatic breathing and steady airflow.',
    musicXML: null,
  );
}

PracticeExercise _createExerciseWithInvalidNotation() {
  return PracticeExercise(
    name: 'Error Test Exercise',
    description: 'Exercise with invalid notation data to test error handling.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: '10 minutes',
    musicXML: null, // Invalid notation should result in null musicXML
  );
}

PracticeExercise _createExerciseWithLongTitle() {
  return PracticeExercise(
    name: 'This is a Very Long Exercise Title That Should Test Text Overflow and Wrapping Behavior in the Card Widget Layout',
    description: 'Exercise with an extremely long title to test the card layout.',
    tempo: '♩ = 120',
    keySignature: 'C Major',
    estimatedDuration: '15 minutes',
    musicXML: _cMajorScaleMusicXML,
  );
}

PracticeExercise _createBasicExercise() {
  return PracticeExercise(
    name: 'Long Tones',
    description: 'Practice sustained notes for tone development.',
    estimatedDuration: '10 minutes',
    notes: 'Hold each note for 8 beats with steady tone.',
    musicXML: _cMajorScaleMusicXML,
  );
}

// Sample MusicXML data for stories
const String _cMajorScaleMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>C Major Scale</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
        <key>
          <fifths>0</fifths>
        </key>
        <time>
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
        <clef>
          <sign>G</sign>
          <line>2</line>
        </clef>
      </attributes>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const String _dMajorArpeggioMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>D Major Arpeggio</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
        <key>
          <fifths>2</fifths>
        </key>
        <time>
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
        <clef>
          <sign>G</sign>
          <line>2</line>
        </clef>
      </attributes>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <alter>1</alter>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
  </part>
</score-partwise>''';

const String _complexExerciseMusicXML = '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>Complex Exercise</work-title>
  </work>
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>2</divisions>
        <key>
          <fifths>-1</fifths>
        </key>
        <time>
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
        <clef>
          <sign>G</sign>
          <line>2</line>
        </clef>
      </attributes>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>eighth</type>
      </note>
      <note>
        <pitch>
          <step>G</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>eighth</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>2</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>B</step>
          <alter>-1</alter>
          <octave>4</octave>
        </pitch>
        <duration>4</duration>
        <type>half</type>
      </note>
    </measure>
  </part>
</score-partwise>''';