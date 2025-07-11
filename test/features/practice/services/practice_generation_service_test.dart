import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

void main() {
  group('PracticeGenerationService', () {
    late PracticeGenerationService service;
    late AssessmentDataset mockDataset;
    
    setUp(() {
      // Load test environment variables
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');

      service = PracticeGenerationService();
      
      mockDataset = AssessmentDataset(
        sessionId: 'test-session-123',
        userLevel: 'intermediate',
        exercises: [
          ExerciseDataset(
            exerciseId: 1,
            exerciseType: 'C Major Scale',
            expectedNotes: ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'],
            detectedNotes: ['C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5'],
            pitchAccuracy: 0.85,
            timingAccuracy: 0.8,
            recommendations: ['Practice with metronome'],
            strengths: ['pitch accuracy'],
            weaknesses: ['timing consistency'],
          ),
          ExerciseDataset(
            exerciseId: 2,
            exerciseType: 'C Major Arpeggio',
            expectedNotes: ['C4', 'E4', 'G4', 'C5'],
            detectedNotes: ['C4', 'E4', 'G4', 'C5'],
            pitchAccuracy: 0.75,
            timingAccuracy: 0.7,
            recommendations: ['Focus on interval accuracy'],
            strengths: [],
            weaknesses: ['pitch stability', 'timing accuracy'],
          ),
        ],
        overallAssessment: OverallAssessment(
          skillLevel: 'intermediate',
          strengths: ['pitch accuracy'],
          weaknesses: ['timing consistency'],
          recommendedFocusAreas: ['rhythm', 'intonation'],
        ),
        timestamp: DateTime(2024, 1, 1),
      );
    });

    test('should initialize with OpenAI service', () {
      expect(service.isInitialized, isFalse);
      
      service.initialize('test-api-key');
      expect(service.isInitialized, isTrue);
    });

    test('should generate practice plan from dataset', () async {
      service.initialize('test-api-key');
      
      // Since this involves OpenAI API calls, we'll mock the response
      // In a real implementation, you would mock the OpenAI service
      final practiceRoutines = await service.generatePracticePlans(mockDataset);
      
      expect(practiceRoutines, isA<List<PracticeRoutine>>());
      expect(practiceRoutines.isNotEmpty, isTrue);
    });

    test('should generate fallback routine when API fails', () async {
      service.initialize('invalid-api-key');
      
      final practiceRoutines = await service.generatePracticePlans(mockDataset);
      
      expect(practiceRoutines, isA<List<PracticeRoutine>>());
      expect(practiceRoutines.isNotEmpty, isTrue);
      expect(practiceRoutines.first.title, contains('Timing and Rhythm Development'));
    });

    test('should validate dataset before processing', () {
      service.initialize('test-api-key');
      
      // Valid dataset
      final isValid = service.validateDataset(mockDataset);
      expect(isValid, isTrue);
      
      // Invalid dataset (empty session ID)
      final invalidDataset = AssessmentDataset(
        sessionId: '',
        userLevel: 'intermediate',
        exercises: [],
        overallAssessment: OverallAssessment(
          skillLevel: 'intermediate',
          strengths: [],
          weaknesses: [],
          recommendedFocusAreas: [],
        ),
        timestamp: DateTime(2024, 1, 1),
      );
      
      final isInvalid = service.validateDataset(invalidDataset);
      expect(isInvalid, isFalse);
    });

    test('should generate targeted routines based on weaknesses', () async {
      service.initialize('test-api-key');
      
      final practiceRoutines = await service.generatePracticePlans(mockDataset);
      
      // Should generate routines targeting timing and rhythm issues
      expect(practiceRoutines.isNotEmpty, isTrue);
      
      // Check that routines are appropriate for intermediate level
      for (final routine in practiceRoutines) {
        expect(routine.difficulty, isIn(['intermediate', 'beginner']));
        expect(routine.exercises.isNotEmpty, isTrue);
      }
    });

    test('should handle different skill levels appropriately', () async {
      service.initialize('test-api-key');
      
      // Test with beginner level
      final beginnerDataset = mockDataset.copyWith(
        userLevel: 'beginner',
        overallAssessment: OverallAssessment(
          skillLevel: 'beginner',
          strengths: [],
          weaknesses: ['basic technique'],
          recommendedFocusAreas: ['fundamentals'],
        ),
      );
      
      final beginnerRoutines = await service.generatePracticePlans(beginnerDataset);
      expect(beginnerRoutines.isNotEmpty, isTrue);
      
      // Test with advanced level
      final advancedDataset = mockDataset.copyWith(
        userLevel: 'advanced',
        overallAssessment: OverallAssessment(
          skillLevel: 'advanced',
          strengths: ['technical facility'],
          weaknesses: ['musical expression'],
          recommendedFocusAreas: ['advanced techniques'],
        ),
      );
      
      final advancedRoutines = await service.generatePracticePlans(advancedDataset);
      expect(advancedRoutines.isNotEmpty, isTrue);
    });

    test('should provide service status', () {
      service.initialize('test-api-key');
      
      final status = service.getStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status['isInitialized'], isTrue);
      expect(status['service'], equals('PracticeGenerationService'));
    });
  });
}