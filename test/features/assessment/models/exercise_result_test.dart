import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';

void main() {
  group('ExerciseResult', () {
    late ExerciseResult exerciseResult;
    late DateTime testDate;

    setUp(() {
      testDate = DateTime.parse('2023-01-01T10:00:00Z');
      exerciseResult = ExerciseResult(
        exerciseId: 1,
        completedAt: testDate,
        actualDuration: const Duration(seconds: 30),
        wasCompleted: true,
        analysisData: {
          'pitch': 85.0,
          'timing': 90.0,
          'exerciseType': 'scale',
          'audioRecordingUrl': 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac',
        },
      );
    });

    group('JSON serialization', () {
      test('should serialize to JSON correctly', () {
        // Act
        final json = exerciseResult.toJson();

        // Assert
        expect(json['exerciseId'], equals(1));
        expect(json['completedAt'], equals('2023-01-01T10:00:00.000Z'));
        expect(json['actualDuration'], equals(30000)); // Duration in milliseconds
        expect(json['wasCompleted'], equals(true));
        expect(json['analysisData'], equals({
          'pitch': 85.0,
          'timing': 90.0,
          'exerciseType': 'scale',
          'audioRecordingUrl': 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac',
        }));
      });

      test('should deserialize from JSON correctly', () {
        // Arrange
        final json = {
          'exerciseId': 2,
          'completedAt': '2023-01-02T14:30:00.000Z',
          'actualDuration': 45000,
          'wasCompleted': true,
          'analysisData': {
            'pitch': 78.0,
            'timing': 88.0,
            'exerciseType': 'arpeggio',
            'audioRecordingUrl': 'https://storage.googleapis.com/test-bucket/audio/exercise_2_789012.aac',
          },
        };

        // Act
        final result = ExerciseResult.fromJson(json);

        // Assert
        expect(result.exerciseId, equals(2));
        expect(result.completedAt, equals(DateTime.parse('2023-01-02T14:30:00.000Z')));
        expect(result.actualDuration, equals(const Duration(milliseconds: 45000)));
        expect(result.wasCompleted, equals(true));
        expect(result.analysisData, equals({
          'pitch': 78.0,
          'timing': 88.0,
          'exerciseType': 'arpeggio',
          'audioRecordingUrl': 'https://storage.googleapis.com/test-bucket/audio/exercise_2_789012.aac',
        }));
      });

      test('should handle null analysisData in JSON serialization', () {
        // Arrange
        final resultWithoutAnalysis = ExerciseResult(
          exerciseId: exerciseResult.exerciseId,
          completedAt: exerciseResult.completedAt,
          actualDuration: exerciseResult.actualDuration,
          wasCompleted: exerciseResult.wasCompleted,
          analysisData: null,
        );

        // Act
        final json = resultWithoutAnalysis.toJson();

        // Assert
        expect(json['analysisData'], isNull);
      });

      test('should handle null analysisData in JSON deserialization', () {
        // Arrange
        final json = {
          'exerciseId': 3,
          'completedAt': '2023-01-03T09:00:00.000Z',
          'actualDuration': 25000,
          'wasCompleted': false,
          'analysisData': null,
        };

        // Act
        final result = ExerciseResult.fromJson(json);

        // Assert
        expect(result.analysisData, isNull);
      });

      test('should round-trip serialize and deserialize correctly', () {
        // Act
        final json = exerciseResult.toJson();
        final deserialized = ExerciseResult.fromJson(json);

        // Assert
        expect(deserialized.exerciseId, equals(exerciseResult.exerciseId));
        expect(deserialized.completedAt, equals(exerciseResult.completedAt));
        expect(deserialized.actualDuration, equals(exerciseResult.actualDuration));
        expect(deserialized.wasCompleted, equals(exerciseResult.wasCompleted));
        expect(deserialized.analysisData, equals(exerciseResult.analysisData));
      });

      test('should handle empty analysisData map', () {
        // Arrange
        final resultWithEmptyAnalysis = exerciseResult.copyWith(analysisData: {});

        // Act
        final json = resultWithEmptyAnalysis.toJson();
        final deserialized = ExerciseResult.fromJson(json);

        // Assert
        expect(deserialized.analysisData, equals({}));
      });
    });

    group('audio recording URL field', () {
      test('should create ExerciseResult with audioRecordingUrl field', () {
        // Arrange
        const audioUrl = 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac';
        
        // Act
        final result = ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0},
          audioRecordingUrl: audioUrl,
        );

        // Assert
        expect(result.audioRecordingUrl, equals(audioUrl));
      });

      test('should handle null audioRecordingUrl', () {
        // Act
        final result = ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0},
          audioRecordingUrl: null,
        );

        // Assert
        expect(result.audioRecordingUrl, isNull);
      });

      test('should serialize audioRecordingUrl to JSON', () {
        // Arrange
        const audioUrl = 'https://storage.googleapis.com/test-bucket/audio/exercise_1_123456.aac';
        final result = ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0},
          audioRecordingUrl: audioUrl,
        );

        // Act
        final json = result.toJson();

        // Assert
        expect(json['audioRecordingUrl'], equals(audioUrl));
      });

      test('should deserialize audioRecordingUrl from JSON', () {
        // Arrange
        const audioUrl = 'https://storage.googleapis.com/test-bucket/audio/exercise_2_789012.aac';
        final json = {
          'exerciseId': 2,
          'completedAt': '2023-01-02T14:30:00.000Z',
          'actualDuration': 45000,
          'wasCompleted': true,
          'analysisData': {'pitch': 78.0},
          'audioRecordingUrl': audioUrl,
        };

        // Act
        final result = ExerciseResult.fromJson(json);

        // Assert
        expect(result.audioRecordingUrl, equals(audioUrl));
      });

      test('should handle null audioRecordingUrl in JSON serialization', () {
        // Arrange
        final result = ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0},
          audioRecordingUrl: null,
        );

        // Act
        final json = result.toJson();

        // Assert
        expect(json.containsKey('audioRecordingUrl'), isFalse);
      });

      test('should handle missing audioRecordingUrl in JSON deserialization', () {
        // Arrange
        final json = {
          'exerciseId': 3,
          'completedAt': '2023-01-03T09:00:00.000Z',
          'actualDuration': 25000,
          'wasCompleted': false,
          'analysisData': {'pitch': 70.0},
        };

        // Act
        final result = ExerciseResult.fromJson(json);

        // Assert
        expect(result.audioRecordingUrl, isNull);
      });

      test('should copy with new audioRecordingUrl', () {
        // Arrange
        const originalUrl = 'https://storage.googleapis.com/test-bucket/audio/original.aac';
        const newUrl = 'https://storage.googleapis.com/test-bucket/audio/updated.aac';
        final original = ExerciseResult(
          exerciseId: 1,
          completedAt: testDate,
          actualDuration: const Duration(seconds: 30),
          wasCompleted: true,
          analysisData: {'pitch': 85.0},
          audioRecordingUrl: originalUrl,
        );

        // Act
        final updated = original.copyWith(audioRecordingUrl: newUrl);

        // Assert
        expect(updated.audioRecordingUrl, equals(newUrl));
        expect(original.audioRecordingUrl, equals(originalUrl)); // Original unchanged
      });
    });

    group('existing functionality', () {
      test('should create copy with modified fields', () {
        // Act
        final modified = exerciseResult.copyWith(
          exerciseId: 99,
          wasCompleted: false,
        );

        // Assert
        expect(modified.exerciseId, equals(99));
        expect(modified.wasCompleted, equals(false));
        expect(modified.completedAt, equals(exerciseResult.completedAt));
        expect(modified.actualDuration, equals(exerciseResult.actualDuration));
        expect(modified.analysisData, equals(exerciseResult.analysisData));
      });

      test('should have correct string representation', () {
        // Act
        final stringRep = exerciseResult.toString();

        // Assert
        expect(stringRep, contains('ExerciseResult'));
        expect(stringRep, contains('exerciseId: 1'));
        expect(stringRep, contains('completed: true'));
        expect(stringRep, contains('duration: 0:00:30.000000'));
      });
    });
  });
}