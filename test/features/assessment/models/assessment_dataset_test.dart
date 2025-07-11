import 'package:flutter_test/flutter_test.dart';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';

void main() {
  group('AssessmentDataset', () {
    late AssessmentResult mockAssessmentResult;
    late List<AudioAnalysisResult> mockAudioAnalysisResults;
    
    setUp(() {
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
        ],
        skillLevel: SkillLevel.intermediate,
        strengths: ['pitch accuracy'],
        weaknesses: ['timing'],
      );
      
      mockAudioAnalysisResults = [
        AudioAnalysisResult(
          pitchData: [440.0, 450.0, 460.0],
          timingData: [0.0, 0.5, 1.0],
          avgPitch: 450.0,
          pitchStability: 10.0,
          rhythmAccuracy: 0.8,
          totalNotes: 3,
          detailedAnalysis: {
            'exerciseType': 'C Major Scale',
            'detectedNotes': ['A4', 'A#4', 'B4'],
          },
        ),
      ];
    });

    test('should create AssessmentDataset with required fields', () {
      final dataset = AssessmentDataset(
        sessionId: 'test-session-123',
        userLevel: 'intermediate',
        exercises: [
          ExerciseDataset(
            exerciseId: 1,
            exerciseType: 'C Major Scale',
            expectedNotes: ['C4', 'D4', 'E4'],
            detectedNotes: ['C4', 'D4', 'E4'],
            pitchAccuracy: 0.8,
            timingAccuracy: 0.75,
            recommendations: ['Practice with metronome'],
            strengths: ['pitch accuracy'],
            weaknesses: ['timing'],
          ),
        ],
        overallAssessment: OverallAssessment(
          skillLevel: 'intermediate',
          strengths: ['pitch accuracy'],
          weaknesses: ['timing'],
          recommendedFocusAreas: ['timing', 'rhythm'],
        ),
        timestamp: DateTime(2024, 1, 1),
      );

      expect(dataset.sessionId, equals('test-session-123'));
      expect(dataset.userLevel, equals('intermediate'));
      expect(dataset.exercises.length, equals(1));
      expect(dataset.exercises[0].exerciseType, equals('C Major Scale'));
      expect(dataset.overallAssessment.skillLevel, equals('intermediate'));
    });

    test('should create AssessmentDataset from AssessmentResult and AudioAnalysisResult', () {
      final dataset = AssessmentDataset.fromAssessmentData(
        mockAssessmentResult,
        mockAudioAnalysisResults,
      );

      expect(dataset.sessionId, equals('test-session-123'));
      expect(dataset.userLevel, equals('intermediate'));
      expect(dataset.exercises.length, equals(1));
      expect(dataset.exercises[0].exerciseId, equals(1));
      expect(dataset.exercises[0].pitchAccuracy, equals(0.9)); // 1.0 - (10.0 / 100.0) = 0.9
      expect(dataset.overallAssessment.skillLevel, equals('intermediate'));
    });

    test('should serialize to JSON correctly', () {
      final dataset = AssessmentDataset(
        sessionId: 'test-session-123',
        userLevel: 'intermediate',
        exercises: [
          ExerciseDataset(
            exerciseId: 1,
            exerciseType: 'C Major Scale',
            expectedNotes: ['C4', 'D4', 'E4'],
            detectedNotes: ['C4', 'D4', 'E4'],
            pitchAccuracy: 0.8,
            timingAccuracy: 0.75,
            recommendations: ['Practice with metronome'],
            strengths: ['pitch accuracy'],
            weaknesses: ['timing'],
          ),
        ],
        overallAssessment: OverallAssessment(
          skillLevel: 'intermediate',
          strengths: ['pitch accuracy'],
          weaknesses: ['timing'],
          recommendedFocusAreas: ['timing', 'rhythm'],
        ),
        timestamp: DateTime(2024, 1, 1),
      );

      final json = dataset.toJson();
      
      expect(json['sessionId'], equals('test-session-123'));
      expect(json['userLevel'], equals('intermediate'));
      expect(json['exercises'], isA<List>());
      expect(json['exercises'][0]['exerciseType'], equals('C Major Scale'));
      expect(json['overallAssessment']['skillLevel'], equals('intermediate'));
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'sessionId': 'test-session-123',
        'userLevel': 'intermediate',
        'exercises': [
          {
            'exerciseId': 1,
            'exerciseType': 'C Major Scale',
            'expectedNotes': ['C4', 'D4', 'E4'],
            'detectedNotes': ['C4', 'D4', 'E4'],
            'pitchAccuracy': 0.8,
            'timingAccuracy': 0.75,
            'recommendations': ['Practice with metronome'],
            'strengths': ['pitch accuracy'],
            'weaknesses': ['timing'],
          }
        ],
        'overallAssessment': {
          'skillLevel': 'intermediate',
          'strengths': ['pitch accuracy'],
          'weaknesses': ['timing'],
          'recommendedFocusAreas': ['timing', 'rhythm'],
        },
        'timestamp': '2024-01-01T00:00:00.000',
      };

      final dataset = AssessmentDataset.fromJson(json);
      
      expect(dataset.sessionId, equals('test-session-123'));
      expect(dataset.userLevel, equals('intermediate'));
      expect(dataset.exercises.length, equals(1));
      expect(dataset.exercises[0].exerciseType, equals('C Major Scale'));
      expect(dataset.overallAssessment.skillLevel, equals('intermediate'));
    });
  });
}