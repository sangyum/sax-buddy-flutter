import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/widgets/exercise_completed.dart';
import 'package:sax_buddy/features/assessment/models/assessment_exercise.dart';

void main() {
  group('ExerciseCompleted', () {
    late AssessmentExercise testExercise;

    setUp(() {
      testExercise = AssessmentExercise(
        id: 1,
        title: 'C Major Scale',
        instructions: 'Play the C major scale',
        duration: const Duration(seconds: 45),
        focusAreas: ['pitch accuracy', 'timing'],
        tempo: 80,
      );
    });

    testWidgets('should display exercise card with correct exercise number', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 2,
            ),
          ),
        ),
      );

      // Check that the exercise card is displayed
      expect(find.text('Exercise 2'), findsOneWidget);
      expect(find.text('C Major Scale'), findsOneWidget);
    });

    testWidgets('should display completion checkmark icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 1,
            ),
          ),
        ),
      );

      // Check that the checkmark icon is displayed
      expect(find.byIcon(Icons.check), findsOneWidget);
    });

    testWidgets('should display completion message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 3,
            ),
          ),
        ),
      );

      // Check that the completion message is displayed
      expect(find.text('Exercise completed!'), findsOneWidget);
    });

    testWidgets('should have correct styling for completion elements', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 1,
            ),
          ),
        ),
      );

      // Check that the checkmark container has correct styling
      final containers = tester.widgetList<Container>(find.byType(Container));
      bool hasGreenCircle = false;
      
      for (final container in containers) {
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.color == const Color(0xFF4CAF50) && decoration?.shape == BoxShape.circle) {
          hasGreenCircle = true;
          break;
        }
      }
      
      expect(hasGreenCircle, isTrue);
    });

    testWidgets('should work with different exercise numbers', (WidgetTester tester) async {
      // Test with exercise number 4
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 4,
            ),
          ),
        ),
      );

      expect(find.text('Exercise 4'), findsOneWidget);
      
      // Test with exercise number 1
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 1,
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Exercise 1'), findsOneWidget);
    });

    testWidgets('should not reference AssessmentProvider', (WidgetTester tester) async {
      // This test ensures the widget doesn't depend on provider
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ExerciseCompleted(
              exercise: testExercise,
              exerciseNumber: 1,
            ),
          ),
        ),
      );

      // Widget should render without any provider context
      expect(find.byType(ExerciseCompleted), findsOneWidget);
      expect(find.text('Exercise completed!'), findsOneWidget);
    });
  });
}