import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';

class AssessmentDataset {
  final String sessionId;
  final String userLevel;
  final List<ExerciseDataset> exercises;
  final OverallAssessment overallAssessment;
  final DateTime timestamp;

  const AssessmentDataset({
    required this.sessionId,
    required this.userLevel,
    required this.exercises,
    required this.overallAssessment,
    required this.timestamp,
  });

  factory AssessmentDataset.fromAssessmentData(
    AssessmentResult assessmentResult,
    List<AudioAnalysisResult> audioAnalysisResults,
  ) {
    final exercises = <ExerciseDataset>[];
    
    for (int i = 0; i < assessmentResult.exerciseResults.length; i++) {
      final exerciseResult = assessmentResult.exerciseResults[i];
      final audioAnalysis = i < audioAnalysisResults.length 
          ? audioAnalysisResults[i] 
          : null;
      
      exercises.add(ExerciseDataset.fromResults(exerciseResult, audioAnalysis));
    }

    return AssessmentDataset(
      sessionId: assessmentResult.sessionId,
      userLevel: assessmentResult.skillLevel.name,
      exercises: exercises,
      overallAssessment: OverallAssessment.fromAssessmentResult(assessmentResult),
      timestamp: assessmentResult.completedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userLevel': userLevel,
      'exercises': exercises.map((e) => e.toJson()).toList(),
      'overallAssessment': overallAssessment.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory AssessmentDataset.fromJson(Map<String, dynamic> json) {
    return AssessmentDataset(
      sessionId: json['sessionId'] as String,
      userLevel: json['userLevel'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseDataset.fromJson(e as Map<String, dynamic>))
          .toList(),
      overallAssessment: OverallAssessment.fromJson(
        json['overallAssessment'] as Map<String, dynamic>,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  AssessmentDataset copyWith({
    String? sessionId,
    String? userLevel,
    List<ExerciseDataset>? exercises,
    OverallAssessment? overallAssessment,
    DateTime? timestamp,
  }) {
    return AssessmentDataset(
      sessionId: sessionId ?? this.sessionId,
      userLevel: userLevel ?? this.userLevel,
      exercises: exercises ?? this.exercises,
      overallAssessment: overallAssessment ?? this.overallAssessment,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() {
    return 'AssessmentDataset(sessionId: $sessionId, userLevel: $userLevel, exercises: ${exercises.length})';
  }
}

class ExerciseDataset {
  final int exerciseId;
  final String exerciseType;
  final List<String> expectedNotes;
  final List<String> detectedNotes;
  final double pitchAccuracy;
  final double timingAccuracy;
  final List<String> recommendations;
  final List<String> strengths;
  final List<String> weaknesses;

  const ExerciseDataset({
    required this.exerciseId,
    required this.exerciseType,
    required this.expectedNotes,
    required this.detectedNotes,
    required this.pitchAccuracy,
    required this.timingAccuracy,
    required this.recommendations,
    required this.strengths,
    required this.weaknesses,
  });

  factory ExerciseDataset.fromResults(
    ExerciseResult exerciseResult,
    AudioAnalysisResult? audioAnalysis,
  ) {
    final analysisData = audioAnalysis?.detailedAnalysis ?? {};
    
    return ExerciseDataset(
      exerciseId: exerciseResult.exerciseId,
      exerciseType: analysisData['exerciseType'] as String? ?? 'Unknown Exercise',
      expectedNotes: List<String>.from(analysisData['expectedNotes'] ?? []),
      detectedNotes: List<String>.from(analysisData['detectedNotes'] ?? []),
      pitchAccuracy: audioAnalysis?.pitchStability != null 
          ? (1.0 - (audioAnalysis!.pitchStability / 100.0)).clamp(0.0, 1.0)
          : 0.0,
      timingAccuracy: audioAnalysis?.rhythmAccuracy ?? 0.0,
      recommendations: List<String>.from(analysisData['recommendations'] ?? []),
      strengths: _identifyStrengths(audioAnalysis),
      weaknesses: _identifyWeaknesses(audioAnalysis),
    );
  }

  static List<String> _identifyStrengths(AudioAnalysisResult? analysis) {
    if (analysis == null) return [];
    
    final strengths = <String>[];
    if (analysis.pitchStability < 10) strengths.add('pitch accuracy');
    if (analysis.rhythmAccuracy > 0.8) strengths.add('timing consistency');
    if (analysis.totalNotes >= 8) strengths.add('technical completion');
    
    return strengths;
  }

  static List<String> _identifyWeaknesses(AudioAnalysisResult? analysis) {
    if (analysis == null) return [];
    
    final weaknesses = <String>[];
    if (analysis.pitchStability > 20) weaknesses.add('pitch stability');
    if (analysis.rhythmAccuracy < 0.8) weaknesses.add('timing accuracy');
    
    return weaknesses;
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseType': exerciseType,
      'expectedNotes': expectedNotes,
      'detectedNotes': detectedNotes,
      'pitchAccuracy': pitchAccuracy,
      'timingAccuracy': timingAccuracy,
      'recommendations': recommendations,
      'strengths': strengths,
      'weaknesses': weaknesses,
    };
  }

  factory ExerciseDataset.fromJson(Map<String, dynamic> json) {
    return ExerciseDataset(
      exerciseId: json['exerciseId'] as int,
      exerciseType: json['exerciseType'] as String,
      expectedNotes: List<String>.from(json['expectedNotes'] as List),
      detectedNotes: List<String>.from(json['detectedNotes'] as List),
      pitchAccuracy: (json['pitchAccuracy'] as num).toDouble(),
      timingAccuracy: (json['timingAccuracy'] as num).toDouble(),
      recommendations: List<String>.from(json['recommendations'] as List),
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
    );
  }
}

class OverallAssessment {
  final String skillLevel;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> recommendedFocusAreas;

  const OverallAssessment({
    required this.skillLevel,
    required this.strengths,
    required this.weaknesses,
    required this.recommendedFocusAreas,
  });

  factory OverallAssessment.fromAssessmentResult(AssessmentResult result) {
    return OverallAssessment(
      skillLevel: result.skillLevel.name,
      strengths: result.strengths,
      weaknesses: result.weaknesses,
      recommendedFocusAreas: _generateRecommendedFocusAreas(result),
    );
  }

  static List<String> _generateRecommendedFocusAreas(AssessmentResult result) {
    final focusAreas = <String>[];
    
    // Add focus areas based on weaknesses
    for (final weakness in result.weaknesses) {
      if (weakness.contains('timing')) focusAreas.add('rhythm');
      if (weakness.contains('pitch')) focusAreas.add('intonation');
      if (weakness.contains('breath')) focusAreas.add('breathing');
    }
    
    // Add skill level appropriate focus areas
    switch (result.skillLevel) {
      case SkillLevel.beginner:
        focusAreas.addAll(['basic scales', 'fundamental technique']);
        break;
      case SkillLevel.intermediate:
        focusAreas.addAll(['advanced scales', 'articulation']);
        break;
      case SkillLevel.advanced:
        focusAreas.addAll(['complex patterns', 'musical expression']);
        break;
    }
    
    return focusAreas.toSet().toList(); // Remove duplicates
  }

  Map<String, dynamic> toJson() {
    return {
      'skillLevel': skillLevel,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'recommendedFocusAreas': recommendedFocusAreas,
    };
  }

  factory OverallAssessment.fromJson(Map<String, dynamic> json) {
    return OverallAssessment(
      skillLevel: json['skillLevel'] as String,
      strengths: List<String>.from(json['strengths'] as List),
      weaknesses: List<String>.from(json['weaknesses'] as List),
      recommendedFocusAreas: List<String>.from(json['recommendedFocusAreas'] as List),
    );
  }
}