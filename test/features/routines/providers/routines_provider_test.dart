import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mockito/mockito.dart';
import 'package:sax_buddy/features/routines/providers/routines_provider.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/practice/repositories/practice_routine_repository.dart';
import 'package:sax_buddy/services/logger_service.dart';

// Mock classes
class MockLoggerService extends Mock implements LoggerService {}
class MockPracticeRoutineRepository extends Mock implements PracticeRoutineRepository {}

void main() {
  group('RoutinesProvider', () {
    late RoutinesProvider provider;
    late MockLoggerService mockLogger;
    late MockPracticeRoutineRepository mockRepository;
    late List<PracticeRoutine> mockRoutines;
    
    setUpAll(() async {
      // Initialize environment variables for testing
      await dotenv.load(fileName: ".env");
    });
    
    setUp(() {
      mockLogger = MockLoggerService();
      mockRepository = MockPracticeRoutineRepository();
      provider = RoutinesProvider(mockLogger, mockRepository);
      
      mockRoutines = [
        PracticeRoutine(
          id: 'routine-1',
          userId: 'test-user',
          title: 'Scale Fundamentals',
          description: 'Basic scale practice routine',
          targetAreas: ['scales', 'technique'],
          difficulty: 'intermediate',
          estimatedDuration: '20 minutes',
          exercises: [
            PracticeExercise(
              name: 'C Major Scale',
              description: 'Practice C major scale slowly',
              estimatedDuration: '10 minutes',
              tempo: '80 BPM',
              keySignature: 'C Major',
              notes: 'Focus on intonation',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: true,
        ),
        PracticeRoutine(
          id: 'routine-2',
          userId: 'test-user',
          title: 'Timing Development',
          description: 'Rhythm and timing practice',
          targetAreas: ['timing', 'rhythm'],
          difficulty: 'intermediate',
          estimatedDuration: '15 minutes',
          exercises: [
            PracticeExercise(
              name: 'Metronome Practice',
              description: 'Practice with metronome',
              estimatedDuration: '15 minutes',
              tempo: '100 BPM',
              notes: 'Keep steady tempo',
            ),
          ],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: true,
        ),
      ];
    });

    test('should initialize with empty routines list', () {
      expect(provider.recentRoutines, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('should add multiple routines and maintain order', () {
      provider.addRoutine(mockRoutines[0]);
      provider.addRoutine(mockRoutines[1]);
      
      expect(provider.recentRoutines, hasLength(2));
      expect(provider.recentRoutines[0].title, equals('Timing Development')); // Most recent first
      expect(provider.recentRoutines[1].title, equals('Scale Fundamentals'));
    });

    test('should limit recent routines to maximum count', () {
      // Add more routines than the limit
      for (int i = 0; i < 15; i++) {
        provider.addRoutine(PracticeRoutine(
          id: 'routine-$i',
          userId: 'test-user',
          title: 'Routine $i',
          description: 'Description $i',
          targetAreas: ['test'],
          difficulty: 'intermediate',
          estimatedDuration: '10 minutes',
          exercises: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isAIGenerated: false,
        ));
      }
      
      expect(provider.recentRoutines.length, lessThanOrEqualTo(10)); // Assuming max 10
    });

    test('should clear all routines', () {
      provider.addRoutine(mockRoutines[0]);
      provider.addRoutine(mockRoutines[1]);
      
      expect(provider.recentRoutines, hasLength(2));
      
      provider.clearRoutines();
      
      expect(provider.recentRoutines, isEmpty);
    });

    test('should handle refresh routines', () async {
      provider.addRoutine(mockRoutines[0]);
      
      await provider.refreshRoutines();
      
      expect(provider.isLoading, isFalse);
      expect(provider.error, isNull);
    });

    test('should handle error states', () {
      provider.setError('Test error');
      
      expect(provider.error, equals('Test error'));
      expect(provider.isLoading, isFalse);
    });

    test('should handle loading states', () {
      provider.setLoading(true);
      
      expect(provider.isLoading, isTrue);
      expect(provider.error, isNull);
    });

    test('should notify listeners when routines change', () {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });
      
      provider.addRoutine(mockRoutines[0]);
      
      expect(notified, isTrue);
    });

    test('should get routine by index', () {
      provider.addRoutine(mockRoutines[0]);
      provider.addRoutine(mockRoutines[1]);
      
      final routine = provider.getRoutineAt(0);
      expect(routine?.title, equals('Timing Development')); // Most recent first
    });

    test('should return null for invalid index', () {
      final routine = provider.getRoutineAt(0);
      expect(routine, isNull);
    });
  });
}