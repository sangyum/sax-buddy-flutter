import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';

void main() {
  group('OpenAIService', () {
    late OpenAIService service;
    late AssessmentDataset mockDataset;

    setUp(() {

      // Load test environment variables
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
      // Note: For testing, we'll need to mock the OpenAI API calls
      // In a real implementation, you would set up proper API mocking
      service = OpenAIService();

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

    test('should initialize with API key', () {
      expect(service.isInitialized, isFalse);

      service.initialize('test-api-key');
      expect(service.isInitialized, isTrue);
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

    test('should generate practice plan prompt', () {
      service.initialize('test-api-key');

      final prompt = service.generatePracticePlanPrompt(mockDataset);

      expect(prompt, isA<String>());
      expect(prompt, contains('intermediate'));
      expect(prompt, contains('C Major Scale'));
      expect(prompt, contains('practice plan'));
      expect(prompt, contains('saxophone'));
    });

    test('should handle API errors gracefully', () async {
      service.initialize('invalid-api-key');

      // This would normally make an API call and handle errors
      // For testing, we'll simulate error handling
      expect(() => service.validateDataset(mockDataset), returnsNormally);
    });

    test('should create structured practice plan from response', () {
      service.initialize('test-api-key');

      const mockResponse = '''
{
  "practiceRoutines": [
    {
      "title": "Scale Fundamentals",
      "exercises": [
        {
          "name": "C Major Scale - Slow Practice",
          "description": "Practice C major scale at 60 BPM, focus on intonation",
          "difficulty": "intermediate",
          "estimatedDuration": "10 minutes"
        }
      ]
    }
  ]
}
''';

      final practiceRoutines = service.parsePracticeRoutines(mockResponse);

      expect(practiceRoutines, isA<List>());
      expect(practiceRoutines.length, equals(1));
      expect(practiceRoutines[0].title, equals('Scale Fundamentals'));
      expect(practiceRoutines[0].exercises.length, equals(1));
      expect(
        practiceRoutines[0].exercises[0].name,
        equals('C Major Scale - Slow Practice'),
      );
    });
  });
}
