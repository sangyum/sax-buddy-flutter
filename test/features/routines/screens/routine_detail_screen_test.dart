import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/routines/screens/routine_detail_presentation.dart';

void main() {
  group('RoutineDetailScreen Tests', () {
    late PracticeRoutine testRoutine;
    setUp(() {
      
      testRoutine = PracticeRoutine(
        id: 'test-routine',
        userId: 'test-user',
        title: 'Beginner Scale Practice',
        description: 'Focus on major scale accuracy and timing',
        targetAreas: ['Scales', 'Timing'],
        difficulty: 'beginner',
        estimatedDuration: '20 minutes',
        exercises: [
          PracticeExercise(
            name: 'C Major Scale',
            description: 'Play C major scale ascending and descending',
            tempo: '60 BPM',
            keySignature: 'C Major',
            notes: 'Focus on even timing between notes',
            estimatedDuration: '10 minutes',
          ),
          PracticeExercise(
            name: 'Scale Intervals',
            description: 'Practice thirds in C major',
            estimatedDuration: '10 minutes',
          ),
        ],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAIGenerated: true,
      );
    });

    testWidgets('should display routine title in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RoutineDetailPresentation(
            routine: testRoutine,
          ),
        ),
      );

      expect(find.text('Beginner Scale Practice'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('should display routine description', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RoutineDetailPresentation(
            routine: testRoutine,
          ),
        ),
      );

      expect(find.text('Focus on major scale accuracy and timing'), findsOneWidget);
    });

    testWidgets('should display all exercises', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RoutineDetailPresentation(
            routine: testRoutine,
          ),
        ),
      );

      expect(find.text('C Major Scale'), findsOneWidget);
      expect(find.text('Scale Intervals'), findsOneWidget);
    });

    testWidgets('should display routine metadata', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RoutineDetailPresentation(
            routine: testRoutine,
          ),
        ),
      );

      expect(find.text('20 minutes'), findsOneWidget);
      expect(find.text('beginner'), findsOneWidget);
    });
  });
}