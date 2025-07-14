import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/routines/widgets/exercise_card.dart';

void main() {
  group('ExerciseCard Tests', () {
    testWidgets('should display exercise name and description', (WidgetTester tester) async {
      final exercise = PracticeExercise(
        name: 'C Major Scale',
        description: 'Play C major scale ascending and descending',
        estimatedDuration: '10 minutes',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: exercise),
          ),
        ),
      );

      expect(find.text('C Major Scale'), findsOneWidget);
      expect(find.text('Play C major scale ascending and descending'), findsOneWidget);
      expect(find.text('Duration: 10 minutes'), findsOneWidget);
    });

    testWidgets('should display optional fields when provided', (WidgetTester tester) async {
      final exercise = PracticeExercise(
        name: 'Scale Practice',
        description: 'Focus on accuracy',
        tempo: '60 BPM',
        keySignature: 'C Major',
        notes: 'Focus on even timing',
        estimatedDuration: '15 minutes',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: exercise),
          ),
        ),
      );

      expect(find.text('Tempo: 60 BPM'), findsOneWidget);
      expect(find.text('Key: C Major'), findsOneWidget);
      expect(find.text('Focus on even timing'), findsOneWidget);
    });

    testWidgets('should not display optional fields when not provided', (WidgetTester tester) async {
      final exercise = PracticeExercise(
        name: 'Simple Exercise',
        description: 'Basic practice',
        estimatedDuration: '5 minutes',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCard(exercise: exercise),
          ),
        ),
      );

      // Verify required fields are shown
      expect(find.text('Simple Exercise'), findsOneWidget);
      expect(find.text('Basic practice'), findsOneWidget);
      expect(find.text('Duration: 5 minutes'), findsOneWidget);
      
      // Verify optional fields are not shown
      expect(find.text('Tempo:'), findsNothing);
      expect(find.text('Key:'), findsNothing);
    });
  });
}