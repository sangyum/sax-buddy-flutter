import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/notation/domain/musical_note.dart';
import 'package:sax_buddy/features/notation/domain/musical_measure.dart';
import 'package:sax_buddy/features/notation/domain/sheet_music_data.dart';
import 'package:sax_buddy/features/notation/widgets/exercise_notation_card.dart';

void main() {
  group('ExerciseNotationCard', () {
    testWidgets('should display exercise with notation data', (WidgetTester tester) async {
      const exercise = PracticeExercise(
        name: 'C Major Scale',
        description: 'Practice C major scale with notation',
        tempo: '80 BPM',
        keySignature: 'C Major',
        estimatedDuration: '10 minutes',
        sheetMusicData: SheetMusicData(
          measures: [
            MusicalMeasure(
              notes: [
                MusicalNote(pitch: NotePitch.c, octave: 4, duration: NoteDuration.quarter),
                MusicalNote(pitch: NotePitch.d, octave: 4, duration: NoteDuration.quarter),
              ],
              timeSignature: TimeSignature.fourFour,
              keySignature: KeySignature.cMajor,
            ),
          ],
          metadata: NotationMetadata(
            clef: Clef.treble,
            tempo: 80,
            title: 'C Major Scale',
          ),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNotationCard(exercise: exercise),
          ),
        ),
      );

      // Verify exercise name is displayed
      expect(find.text('C Major Scale'), findsOneWidget);
      
      // Verify description is displayed
      expect(find.text('Practice C major scale with notation'), findsOneWidget);
      
      // Verify notation view is displayed
      expect(find.byType(ExerciseNotationCard), findsOneWidget);
      
      // Verify duration is shown
      expect(find.text('10 minutes'), findsOneWidget);
    });

    testWidgets('should display exercise without notation data', (WidgetTester tester) async {
      const exercise = PracticeExercise(
        name: 'Long Tones',
        description: 'Practice sustained notes',
        tempo: '60 BPM',
        estimatedDuration: '5 minutes',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNotationCard(exercise: exercise),
          ),
        ),
      );

      // Verify exercise name is displayed
      expect(find.text('Long Tones'), findsOneWidget);
      
      // Verify description is displayed
      expect(find.text('Practice sustained notes'), findsOneWidget);
      
      // Tap to expand notation
      await tester.tap(find.text('Show Notation'));
      await tester.pumpAndSettle();
      
      // Should show no notation available message
      expect(find.text('No notation available'), findsOneWidget);
    });

    testWidgets('should show expandable notation', (WidgetTester tester) async {
      const exercise = PracticeExercise(
        name: 'G Major Arpeggio',
        description: 'Practice G major arpeggio',
        estimatedDuration: '8 minutes',
        sheetMusicData: SheetMusicData(
          measures: [
            MusicalMeasure(
              notes: [
                MusicalNote(pitch: NotePitch.g, octave: 4, duration: NoteDuration.quarter),
              ],
              timeSignature: TimeSignature.fourFour,
              keySignature: KeySignature.gMajor,
            ),
          ],
          metadata: NotationMetadata(
            clef: Clef.treble,
            tempo: 100,
            title: 'G Major Arpeggio',
          ),
        ),
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ExerciseNotationCard(exercise: exercise),
          ),
        ),
      );

      // Find and tap the expand icon
      final expandIcon = find.byIcon(Icons.expand_more);
      expect(expandIcon, findsOneWidget);
      
      await tester.tap(expandIcon);
      await tester.pumpAndSettle();

      // After expanding, should show less icon
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
    });
  });
}