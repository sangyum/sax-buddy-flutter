import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/models/assessment_exercise.dart';

void main() {
  group('AssessmentExercise', () {
    test('should create assessment exercise with all properties', () {
      const exercise = AssessmentExercise(
        id: 1,
        title: 'C Major Scale',
        instructions: 'Play C Major scale',
        duration: Duration(seconds: 45),
        tempo: 80,
        focusAreas: ['pitch accuracy', 'timing'],
      );

      expect(exercise.id, equals(1));
      expect(exercise.title, equals('C Major Scale'));
      expect(exercise.instructions, equals('Play C Major scale'));
      expect(exercise.duration, equals(const Duration(seconds: 45)));
      expect(exercise.tempo, equals(80));
      expect(exercise.focusAreas, equals(['pitch accuracy', 'timing']));
    });

    test('should create assessment exercise without tempo', () {
      const exercise = AssessmentExercise(
        id: 2,
        title: 'Octave Jumps',
        instructions: 'Play octave jumps',
        duration: Duration(minutes: 1),
        focusAreas: ['range capability'],
      );

      expect(exercise.tempo, isNull);
      expect(exercise.focusAreas, equals(['range capability']));
    });

    test('should compare exercises for equality', () {
      const exercise1 = AssessmentExercise(
        id: 1,
        title: 'Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 30),
        focusAreas: ['pitch'],
      );

      const exercise2 = AssessmentExercise(
        id: 1,
        title: 'Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 30),
        focusAreas: ['pitch'],
      );

      const exercise3 = AssessmentExercise(
        id: 2,
        title: 'Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 30),
        focusAreas: ['pitch'],
      );

      expect(exercise1, equals(exercise2));
      expect(exercise1, isNot(equals(exercise3)));
    });

    test('should have consistent hashCode for equal objects', () {
      const exercise1 = AssessmentExercise(
        id: 1,
        title: 'Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 30),
        focusAreas: ['pitch'],
      );

      const exercise2 = AssessmentExercise(
        id: 1,
        title: 'Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 30),
        focusAreas: ['pitch'],
      );

      expect(exercise1.hashCode, equals(exercise2.hashCode));
    });

    test('should provide meaningful toString', () {
      const exercise = AssessmentExercise(
        id: 1,
        title: 'C Major Scale',
        instructions: 'Play scale',
        duration: Duration(seconds: 45),
        tempo: 80,
        focusAreas: ['pitch'],
      );

      final stringRepresentation = exercise.toString();
      expect(stringRepresentation, contains('C Major Scale'));
      expect(stringRepresentation, contains('45'));
      expect(stringRepresentation, contains('80'));
    });
  });
}