import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

void main() {
  group('PracticeRoutine Model', () {
    test('should create PracticeRoutine instance with assessment fields', () {
      // Arrange
      const id = 'test-routine-id';
      const userId = 'test-user-id';
      const title = 'Test Routine';
      const description = 'Test Description';
      const targetAreas = ['scales', 'technique'];
      const difficulty = 'intermediate';
      const estimatedDuration = '20 minutes';
      final exercises = <PracticeExercise>[];
      final createdAt = DateTime.now();
      final updatedAt = DateTime.now();
      const isAIGenerated = true;
      const assessmentId = 'test-assessment-123';
      const isCurrent = true;

      // Act
      final routine = PracticeRoutine(
        id: id,
        userId: userId,
        title: title,
        description: description,
        targetAreas: targetAreas,
        difficulty: difficulty,
        estimatedDuration: estimatedDuration,
        exercises: exercises,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isAIGenerated: isAIGenerated,
        assessmentId: assessmentId,
        isCurrent: isCurrent,
      );

      // Assert
      expect(routine.id, equals(id));
      expect(routine.userId, equals(userId));
      expect(routine.title, equals(title));
      expect(routine.description, equals(description));
      expect(routine.targetAreas, equals(targetAreas));
      expect(routine.difficulty, equals(difficulty));
      expect(routine.estimatedDuration, equals(estimatedDuration));
      expect(routine.exercises, equals(exercises));
      expect(routine.createdAt, equals(createdAt));
      expect(routine.updatedAt, equals(updatedAt));
      expect(routine.isAIGenerated, equals(isAIGenerated));
      expect(routine.assessmentId, equals(assessmentId));
      expect(routine.isCurrent, equals(isCurrent));
    });

    test('should serialize assessment fields to JSON', () {
      // Arrange
      final routine = PracticeRoutine(
        id: 'test-routine-id',
        userId: 'test-user-id',
        title: 'Test Routine',
        description: 'Test Description',
        targetAreas: const ['scales'],
        difficulty: 'intermediate',
        estimatedDuration: '20 minutes',
        exercises: const [],
        createdAt: DateTime.parse('2023-01-01T10:00:00Z'),
        updatedAt: DateTime.parse('2023-01-01T10:00:00Z'),
        isAIGenerated: true,
        assessmentId: 'test-assessment-456',
        isCurrent: true,
      );

      // Act
      final json = routine.toJson();

      // Assert
      expect(json['assessmentId'], equals('test-assessment-456'));
      expect(json['isCurrent'], equals(true));
    });

    test('should deserialize assessment fields from JSON', () {
      // Arrange
      final json = {
        'id': 'test-routine-id',
        'userId': 'test-user-id',
        'title': 'Test Routine',
        'description': 'Test Description',
        'targetAreas': ['scales'],
        'difficulty': 'intermediate',
        'estimatedDuration': '20 minutes',
        'exercises': [],
        'createdAt': '2023-01-01T10:00:00.000Z',
        'updatedAt': '2023-01-01T10:00:00.000Z',
        'isAIGenerated': true,
        'assessmentId': 'test-assessment-789',
        'isCurrent': false,
      };

      // Act
      final routine = PracticeRoutine.fromJson(json);

      // Assert
      expect(routine.assessmentId, equals('test-assessment-789'));
      expect(routine.isCurrent, equals(false));
    });

    test('should handle null assessment fields in JSON', () {
      // Arrange
      final json = {
        'id': 'test-routine-id',
        'userId': 'test-user-id',
        'title': 'Test Routine',
        'description': 'Test Description',
        'targetAreas': ['scales'],
        'difficulty': 'intermediate',
        'estimatedDuration': '20 minutes',
        'exercises': [],
        'createdAt': '2023-01-01T10:00:00.000Z',
        'updatedAt': '2023-01-01T10:00:00.000Z',
        'isAIGenerated': false,
        'assessmentId': null,
        'isCurrent': null,
      };

      // Act
      final routine = PracticeRoutine.fromJson(json);

      // Assert
      expect(routine.assessmentId, isNull);
      expect(routine.isCurrent, equals(false)); // should default to false
    });

    test('should have isCurrentSet computed property', () {
      // Arrange - current routine
      final currentRoutine = PracticeRoutine(
        id: 'test-routine-id',
        userId: 'test-user-id',
        title: 'Current Routine',
        description: 'Test Description',
        targetAreas: const ['scales'],
        difficulty: 'intermediate',
        estimatedDuration: '20 minutes',
        exercises: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAIGenerated: true,
        assessmentId: 'test-assessment-123',
        isCurrent: true,
      );

      // Arrange - previous routine
      final previousRoutine = PracticeRoutine(
        id: 'test-routine-id-2',
        userId: 'test-user-id',
        title: 'Previous Routine',
        description: 'Test Description',
        targetAreas: const ['scales'],
        difficulty: 'intermediate',
        estimatedDuration: '20 minutes',
        exercises: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isAIGenerated: true,
        assessmentId: 'test-assessment-456',
        isCurrent: false,
      );

      // Assert
      expect(currentRoutine.isCurrentSet, equals(true));
      expect(previousRoutine.isCurrentSet, equals(false));
    });
  });
}