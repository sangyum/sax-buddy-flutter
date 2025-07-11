import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';
import 'package:sax_buddy/features/assessment/services/audio_analysis_dataset_service.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';
import 'package:sax_buddy/services/logger_service.dart';

// Mock class
class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('AudioAnalysisDatasetService', () {
    late AudioAnalysisDatasetService service;
    late MockLoggerService mockLogger;
    late AssessmentResult mockAssessmentResult;
    late List<AudioAnalysisResult> mockAudioAnalysisResults;
    
    setUp(() {
      mockLogger = MockLoggerService();
      service = AudioAnalysisDatasetService(mockLogger);
      
      mockAssessmentResult = AssessmentResult(
        sessionId: 'test-session-123',
        completedAt: DateTime(2024, 1, 1),
        exerciseResults: [
          ExerciseResult(
            exerciseId: 1,
            completedAt: DateTime(2024, 1, 1),
            actualDuration: const Duration(seconds: 45),
            wasCompleted: true,
            analysisData: {'pitch': 440.0, 'accuracy': 0.8},
          ),
          ExerciseResult(
            exerciseId: 2,
            completedAt: DateTime(2024, 1, 1),
            actualDuration: const Duration(seconds: 50),
            wasCompleted: true,
            analysisData: {'pitch': 350.0, 'accuracy': 0.7},
          ),
        ],
        skillLevel: SkillLevel.intermediate,
        strengths: ['pitch accuracy'],
        weaknesses: ['timing consistency'],
      );
      
      mockAudioAnalysisResults = [
        AudioAnalysisResult(
          pitchData: [261.63, 293.66, 329.63], // C, D, E
          timingData: [0.0, 0.5, 1.0],
          avgPitch: 295.0,
          pitchStability: 15.0,
          rhythmAccuracy: 0.85,
          totalNotes: 3,
          detailedAnalysis: {
            'exerciseType': 'C Major Scale',
            'expectedNotes': ['C4', 'D4', 'E4'],
            'detectedNotes': ['C4', 'D4', 'E4'],
            'recommendations': ['Practice scales slowly'],
          },
        ),
        AudioAnalysisResult(
          pitchData: [261.63, 329.63, 392.00], // C, E, G
          timingData: [0.0, 0.6, 1.2],
          avgPitch: 327.75,
          pitchStability: 25.0,
          rhythmAccuracy: 0.7,
          totalNotes: 3,
          detailedAnalysis: {
            'exerciseType': 'C Major Arpeggio',
            'expectedNotes': ['C4', 'E4', 'G4'],
            'detectedNotes': ['C4', 'E4', 'G4'],
            'recommendations': ['Work on timing accuracy'],
          },
        ),
      ];
    });

    test('should create dataset from assessment and audio analysis results', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      expect(dataset.sessionId, equals('test-session-123'));
      expect(dataset.userLevel, equals('intermediate'));
      expect(dataset.exercises.length, equals(2));
      expect(dataset.exercises[0].exerciseType, equals('C Major Scale'));
      expect(dataset.exercises[1].exerciseType, equals('C Major Arpeggio'));
      expect(dataset.overallAssessment.skillLevel, equals('intermediate'));
      expect(dataset.timestamp, equals(DateTime(2024, 1, 1)));
    });

    test('should handle empty audio analysis results', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        [],
      );

      expect(dataset.sessionId, equals('test-session-123'));
      expect(dataset.exercises.length, equals(2));
      expect(dataset.exercises[0].exerciseType, equals('Unknown Exercise'));
      expect(dataset.exercises[0].pitchAccuracy, equals(0.0));
      expect(dataset.exercises[0].timingAccuracy, equals(0.0));
    });

    test('should calculate correct pitch accuracy from stability', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      // First exercise: pitchStability = 15.0, so accuracy = 1.0 - (15.0 / 100.0) = 0.85
      expect(dataset.exercises[0].pitchAccuracy, equals(0.85));
      
      // Second exercise: pitchStability = 25.0, so accuracy = 1.0 - (25.0 / 100.0) = 0.75
      expect(dataset.exercises[1].pitchAccuracy, equals(0.75));
    });

    test('should extract timing accuracy from rhythm accuracy', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      expect(dataset.exercises[0].timingAccuracy, equals(0.85));
      expect(dataset.exercises[1].timingAccuracy, equals(0.7));
    });

    test('should generate appropriate recommendations', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      expect(dataset.exercises[0].recommendations, contains('Practice scales slowly'));
      expect(dataset.exercises[1].recommendations, contains('Work on timing accuracy'));
    });

    test('should identify strengths and weaknesses correctly', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      // First exercise has good pitch stability (15.0) and timing (0.85)
      expect(dataset.exercises[0].strengths, contains('timing consistency'));
      
      // Second exercise has poor pitch stability (25.0) and timing (0.7)
      expect(dataset.exercises[1].weaknesses, contains('pitch stability'));
      expect(dataset.exercises[1].weaknesses, contains('timing accuracy'));
    });

    test('should serialize dataset to JSON for LLM consumption', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      final json = service.prepareForLLM(dataset);
      
      expect(json, isA<Map<String, dynamic>>());
      expect(json['sessionId'], equals('test-session-123'));
      expect(json['userLevel'], equals('intermediate'));
      expect(json['exercises'], isA<List>());
      expect(json['overallAssessment'], isA<Map<String, dynamic>>());
    });

    test('should generate LLM prompt context', () async {
      final dataset = await service.createDataset(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      final promptContext = service.generateLLMPromptContext(dataset);
      
      expect(promptContext, isA<String>());
      expect(promptContext, contains('intermediate'));
      expect(promptContext, contains('C Major Scale'));
      expect(promptContext, contains('C Major Arpeggio'));
      expect(promptContext, contains('pitch accuracy'));
      expect(promptContext, contains('timing consistency'));
    });
  });
}