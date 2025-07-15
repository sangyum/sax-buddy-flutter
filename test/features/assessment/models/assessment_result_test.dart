import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';

void main() {
  group('AssessmentResult', () {
    late AssessmentResult assessmentResult;
    late DateTime testDate;
    late List<ExerciseResult> exerciseResults;

    setUp(() {
      testDate = DateTime.parse('2023-01-01T10:00:00Z');
      exerciseResults = [
        ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0, 'timing': 90.0},
        ),
        ExerciseResult(
          exerciseId: 2,
          completedAt: testDate.add(const Duration(minutes: 5)),
          actualDuration: const Duration(seconds: 45),
          wasCompleted: true,
          analysisData: {'pitch': 78.0, 'timing': 88.0},
        ),
      ];

      assessmentResult = AssessmentResult(
        sessionId: 'test-session-123',
        completedAt: testDate,
        exerciseResults: exerciseResults,
        skillLevel: SkillLevel.intermediate,
        strengths: ['pitch accuracy', 'timing consistency'],
        weaknesses: ['breath control', 'articulation'],
        notes: 'Good overall performance with room for improvement in breath control.',
      );
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Act
        final json = assessmentResult.toJson();

        // Assert
        expect(json['sessionId'], equals('test-session-123'));
        expect(json['completedAt'], equals('2023-01-01T10:00:00.000Z'));
        expect(json['skillLevel'], equals('intermediate'));
        expect(json['strengths'], equals(['pitch accuracy', 'timing consistency']));
        expect(json['weaknesses'], equals(['breath control', 'articulation']));
        expect(json['notes'], equals('Good overall performance with room for improvement in breath control.'));
        expect(json['exerciseResults'], isA<List>());
        expect(json['exerciseResults'].length, equals(2));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'sessionId': 'test-session-456',
          'completedAt': '2023-01-02T14:30:00.000Z',
          'skillLevel': 'advanced',
          'strengths': ['technical proficiency', 'musical expression'],
          'weaknesses': ['intonation'],
          'notes': 'Excellent technical skills, minor intonation issues.',
          'exerciseResults': [
            {
              'exerciseId': 1,
              'completedAt': '2023-01-02T14:30:00.000Z',
              'actualDuration': 30000,
              'wasCompleted': true,
              'analysisData': {'pitch': 92.0, 'timing': 95.0},
            },
          ],
        };

        // Act
        final result = AssessmentResult.fromJson(json);

        // Assert
        expect(result.sessionId, equals('test-session-456'));
        expect(result.completedAt, equals(DateTime.parse('2023-01-02T14:30:00.000Z')));
        expect(result.skillLevel, equals(SkillLevel.advanced));
        expect(result.strengths, equals(['technical proficiency', 'musical expression']));
        expect(result.weaknesses, equals(['intonation']));
        expect(result.notes, equals('Excellent technical skills, minor intonation issues.'));
        expect(result.exerciseResults.length, equals(1));
        expect(result.exerciseResults.first.exerciseId, equals(1));
      });

      test('should handle null notes in JSON serialization', () {
        // Arrange
        final resultWithoutNotes = AssessmentResult(
          sessionId: assessmentResult.sessionId,
          completedAt: assessmentResult.completedAt,
          exerciseResults: assessmentResult.exerciseResults,
          skillLevel: assessmentResult.skillLevel,
          strengths: assessmentResult.strengths,
          weaknesses: assessmentResult.weaknesses,
          notes: null,
        );

        // Act
        final json = resultWithoutNotes.toJson();

        // Assert
        expect(json['notes'], isNull);
      });

      test('should handle null notes in JSON deserialization', () {
        // Arrange
        final json = {
          'sessionId': 'test-session-789',
          'completedAt': '2023-01-03T09:00:00.000Z',
          'skillLevel': 'beginner',
          'strengths': ['enthusiasm'],
          'weaknesses': ['technique', 'timing'],
          'notes': null,
          'exerciseResults': [],
        };

        // Act
        final result = AssessmentResult.fromJson(json);

        // Assert
        expect(result.notes, isNull);
      });

      test('should round-trip serialize and deserialize correctly', () {
        // Act
        final json = assessmentResult.toJson();
        final deserialized = AssessmentResult.fromJson(json);

        // Assert
        expect(deserialized.sessionId, equals(assessmentResult.sessionId));
        expect(deserialized.completedAt, equals(assessmentResult.completedAt));
        expect(deserialized.skillLevel, equals(assessmentResult.skillLevel));
        expect(deserialized.strengths, equals(assessmentResult.strengths));
        expect(deserialized.weaknesses, equals(assessmentResult.weaknesses));
        expect(deserialized.notes, equals(assessmentResult.notes));
        expect(deserialized.exerciseResults.length, equals(assessmentResult.exerciseResults.length));
      });
    });

    group('existing functionality', () {
      test('should return correct allExercisesCompleted when all exercises are completed', () {
        expect(assessmentResult.allExercisesCompleted, isFalse); // Only 2 exercises, expects 4
      });

      test('should return correct allExercisesCompleted when 4 exercises are completed', () {
        final fourExercises = [
          ...exerciseResults,
          ExerciseResult(
            exerciseId: 3,
            completedAt: testDate.add(const Duration(minutes: 10)),
            actualDuration: const Duration(seconds: 40),
            wasCompleted: true,
            analysisData: {'pitch': 80.0},
          ),
          ExerciseResult(
            exerciseId: 4,
            completedAt: testDate.add(const Duration(minutes: 15)),
            actualDuration: const Duration(seconds: 35),
            wasCompleted: true,
            analysisData: {'timing': 85.0},
          ),
        ];

        final resultWithFourExercises = assessmentResult.copyWith(
          exerciseResults: fourExercises,
        );

        expect(resultWithFourExercises.allExercisesCompleted, isTrue);
      });
    });
  });
}