import 'package:logger/logger.dart';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/assessment/models/assessment_result.dart';
import 'package:sax_buddy/services/audio_analysis_service.dart';

class AudioAnalysisDatasetService {
  final Logger _logger = Logger();

  /// Creates a structured dataset from assessment and audio analysis results
  Future<AssessmentDataset> createDataset(
    AssessmentResult assessmentResult,
    List<AudioAnalysisResult> audioAnalysisResults,
  ) async {
    try {
      _logger.d('Creating dataset from assessment results');
      
      final dataset = AssessmentDataset.fromAssessmentData(
        assessmentResult,
        audioAnalysisResults,
      );
      
      _logger.d('Dataset created successfully: ${dataset.exercises.length} exercises');
      return dataset;
      
    } catch (e) {
      _logger.e('Failed to create dataset: $e');
      rethrow;
    }
  }

  /// Prepares dataset for LLM consumption by converting to JSON
  Map<String, dynamic> prepareForLLM(AssessmentDataset dataset) {
    try {
      _logger.d('Preparing dataset for LLM consumption');
      
      final json = dataset.toJson();
      
      // Add additional metadata for LLM context
      json['metadata'] = {
        'totalExercises': dataset.exercises.length,
        'completedExercises': dataset.exercises.where((e) => e.detectedNotes.isNotEmpty).length,
        'averagePitchAccuracy': _calculateAveragePitchAccuracy(dataset.exercises),
        'averageTimingAccuracy': _calculateAverageTimingAccuracy(dataset.exercises),
        'primaryWeaknesses': _identifyPrimaryWeaknesses(dataset.exercises),
        'primaryStrengths': _identifyPrimaryStrengths(dataset.exercises),
      };
      
      return json;
      
    } catch (e) {
      _logger.e('Failed to prepare dataset for LLM: $e');
      rethrow;
    }
  }

  /// Generates a structured prompt context for LLM
  String generateLLMPromptContext(AssessmentDataset dataset) {
    try {
      _logger.d('Generating LLM prompt context');
      
      final buffer = StringBuffer();
      
      // User profile
      buffer.writeln('## User Assessment Profile');
      buffer.writeln('- **Skill Level**: ${dataset.userLevel}');
      buffer.writeln('- **Session ID**: ${dataset.sessionId}');
      buffer.writeln('- **Assessment Date**: ${dataset.timestamp.toIso8601String()}');
      buffer.writeln();
      
      // Exercise performance
      buffer.writeln('## Exercise Performance');
      for (final exercise in dataset.exercises) {
        buffer.writeln('### ${exercise.exerciseType}');
        buffer.writeln('- **Pitch Accuracy**: ${(exercise.pitchAccuracy * 100).toStringAsFixed(1)}%');
        buffer.writeln('- **Timing Accuracy**: ${(exercise.timingAccuracy * 100).toStringAsFixed(1)}%');
        buffer.writeln('- **Expected Notes**: ${exercise.expectedNotes.join(', ')}');
        buffer.writeln('- **Detected Notes**: ${exercise.detectedNotes.join(', ')}');
        
        if (exercise.strengths.isNotEmpty) {
          buffer.writeln('- **Strengths**: ${exercise.strengths.join(', ')}');
        }
        
        if (exercise.weaknesses.isNotEmpty) {
          buffer.writeln('- **Weaknesses**: ${exercise.weaknesses.join(', ')}');
        }
        
        if (exercise.recommendations.isNotEmpty) {
          buffer.writeln('- **Recommendations**: ${exercise.recommendations.join(', ')}');
        }
        
        buffer.writeln();
      }
      
      // Overall assessment
      buffer.writeln('## Overall Assessment');
      buffer.writeln('- **Skill Level**: ${dataset.overallAssessment.skillLevel}');
      
      if (dataset.overallAssessment.strengths.isNotEmpty) {
        buffer.writeln('- **Overall Strengths**: ${dataset.overallAssessment.strengths.join(', ')}');
      }
      
      if (dataset.overallAssessment.weaknesses.isNotEmpty) {
        buffer.writeln('- **Overall Weaknesses**: ${dataset.overallAssessment.weaknesses.join(', ')}');
      }
      
      if (dataset.overallAssessment.recommendedFocusAreas.isNotEmpty) {
        buffer.writeln('- **Recommended Focus Areas**: ${dataset.overallAssessment.recommendedFocusAreas.join(', ')}');
      }
      
      return buffer.toString();
      
    } catch (e) {
      _logger.e('Failed to generate LLM prompt context: $e');
      rethrow;
    }
  }

  /// Calculates average pitch accuracy across all exercises
  double _calculateAveragePitchAccuracy(List<ExerciseDataset> exercises) {
    if (exercises.isEmpty) return 0.0;
    
    final total = exercises.fold(0.0, (sum, exercise) => sum + exercise.pitchAccuracy);
    return total / exercises.length;
  }

  /// Calculates average timing accuracy across all exercises
  double _calculateAverageTimingAccuracy(List<ExerciseDataset> exercises) {
    if (exercises.isEmpty) return 0.0;
    
    final total = exercises.fold(0.0, (sum, exercise) => sum + exercise.timingAccuracy);
    return total / exercises.length;
  }

  /// Identifies primary weaknesses across all exercises
  List<String> _identifyPrimaryWeaknesses(List<ExerciseDataset> exercises) {
    final weaknessCount = <String, int>{};
    
    for (final exercise in exercises) {
      for (final weakness in exercise.weaknesses) {
        weaknessCount[weakness] = (weaknessCount[weakness] ?? 0) + 1;
      }
    }
    
    // Sort by frequency and return top 3
    final sortedWeaknesses = weaknessCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedWeaknesses.take(3).map((e) => e.key).toList();
  }

  /// Identifies primary strengths across all exercises
  List<String> _identifyPrimaryStrengths(List<ExerciseDataset> exercises) {
    final strengthCount = <String, int>{};
    
    for (final exercise in exercises) {
      for (final strength in exercise.strengths) {
        strengthCount[strength] = (strengthCount[strength] ?? 0) + 1;
      }
    }
    
    // Sort by frequency and return top 3
    final sortedStrengths = strengthCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedStrengths.take(3).map((e) => e.key).toList();
  }

  /// Validates dataset before LLM processing
  bool validateDataset(AssessmentDataset dataset) {
    try {
      // Check required fields
      if (dataset.sessionId.isEmpty) {
        _logger.w('Dataset validation failed: empty session ID');
        return false;
      }
      
      if (dataset.exercises.isEmpty) {
        _logger.w('Dataset validation failed: no exercises');
        return false;
      }
      
      // Check exercise data quality
      for (final exercise in dataset.exercises) {
        if (exercise.exerciseType.isEmpty) {
          _logger.w('Dataset validation failed: empty exercise type');
          return false;
        }
        
        if (exercise.pitchAccuracy < 0 || exercise.pitchAccuracy > 1) {
          _logger.w('Dataset validation failed: invalid pitch accuracy');
          return false;
        }
        
        if (exercise.timingAccuracy < 0 || exercise.timingAccuracy > 1) {
          _logger.w('Dataset validation failed: invalid timing accuracy');
          return false;
        }
      }
      
      _logger.d('Dataset validation passed');
      return true;
      
    } catch (e) {
      _logger.e('Dataset validation error: $e');
      return false;
    }
  }
}