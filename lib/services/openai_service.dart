import 'dart:convert';
import 'package:dart_openai/dart_openai.dart';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';

@singleton
class OpenAIService {
  final LoggerService _logger;
  bool _isInitialized = false;

  OpenAIService(this._logger);

  bool get isInitialized => _isInitialized;

  /// Initialize the OpenAI service with API key
  void initialize(String apiKey) {
    try {
      OpenAI.apiKey = apiKey;
      _isInitialized = true;
      _logger.debug('OpenAI service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize OpenAI service: $e');
      rethrow;
    }
  }

  /// Generate personalized practice plan from assessment dataset
  Future<List<PracticeRoutine>> generatePracticePlan(AssessmentDataset dataset) async {
    try {
      if (!_isInitialized) {
        throw Exception('OpenAI service not initialized');
      }

      _logger.debug('Generating practice plan for session: ${dataset.sessionId}');

      // Validate dataset
      if (!validateDataset(dataset)) {
        throw Exception('Invalid dataset provided');
      }

      // Generate prompt
      final prompt = generatePracticePlanPrompt(dataset);

      // Make API call to OpenAI
      final response = await _makeOpenAIRequest(prompt);

      // Parse response into practice routines
      final practiceRoutines = parsePracticeRoutines(response);

      _logger.debug('Generated ${practiceRoutines.length} practice routines');
      return practiceRoutines;

    } catch (e) {
      _logger.error('Failed to generate practice plan: $e');
      rethrow;
    }
  }

  /// Validate dataset before processing
  bool validateDataset(AssessmentDataset dataset) {
    try {
      // Check required fields
      if (dataset.sessionId.isEmpty) {
        _logger.warning('Dataset validation failed: empty session ID');
        return false;
      }

      if (dataset.exercises.isEmpty) {
        _logger.warning('Dataset validation failed: no exercises');
        return false;
      }

      if (dataset.userLevel.isEmpty) {
        _logger.warning('Dataset validation failed: empty user level');
        return false;
      }

      // Check exercise data quality
      for (final exercise in dataset.exercises) {
        if (exercise.exerciseType.isEmpty) {
          _logger.warning('Dataset validation failed: empty exercise type');
          return false;
        }

        if (exercise.pitchAccuracy < 0 || exercise.pitchAccuracy > 1) {
          _logger.warning('Dataset validation failed: invalid pitch accuracy');
          return false;
        }

        if (exercise.timingAccuracy < 0 || exercise.timingAccuracy > 1) {
          _logger.warning('Dataset validation failed: invalid timing accuracy');
          return false;
        }
      }

      _logger.debug('Dataset validation passed');
      return true;

    } catch (e) {
      _logger.error('Dataset validation error: $e');
      return false;
    }
  }

  /// Generate structured prompt for practice plan generation
  String generatePracticePlanPrompt(AssessmentDataset dataset) {
    final buffer = StringBuffer();
    
    buffer.writeln('You are an expert saxophone instructor. Based on the following assessment data, create a personalized practice plan for a ${dataset.userLevel} level student.');
    buffer.writeln();
    
    buffer.writeln('## Assessment Results');
    buffer.writeln('- **Student Level**: ${dataset.userLevel}');
    buffer.writeln('- **Session ID**: ${dataset.sessionId}');
    buffer.writeln('- **Assessment Date**: ${dataset.timestamp.toIso8601String()}');
    buffer.writeln();
    
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
      
      buffer.writeln();
    }
    
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
    
    buffer.writeln();
    buffer.writeln('## Task');
    buffer.writeln('Create a personalized practice plan with the following structure:');
    buffer.writeln('- 3-5 practice routines, each targeting specific weaknesses');
    buffer.writeln('- Each routine should contain 2-4 exercises');
    buffer.writeln('- Include difficulty level, estimated duration, and detailed instructions');
    buffer.writeln('- Focus on the identified weaknesses while building on strengths');
    buffer.writeln('- Make exercises progressive and appropriate for the student\'s level');
    buffer.writeln();
    buffer.writeln('Please respond with a JSON object matching this schema:');
    buffer.writeln('''
{
  "practiceRoutines": [
    {
      "title": "Routine Name",
      "description": "Brief description of the routine focus",
      "targetAreas": ["area1", "area2"],
      "difficulty": "beginner|intermediate|advanced",
      "estimatedDuration": "X minutes",
      "exercises": [
        {
          "name": "Exercise Name",
          "description": "Detailed instructions",
          "tempo": "BPM (optional)",
          "keySignature": "Key (optional)",
          "notes": "Additional notes",
          "estimatedDuration": "X minutes"
        }
      ]
    }
  ]
}
''');
    
    return buffer.toString();
  }

  /// Make request to OpenAI API
  Future<String> _makeOpenAIRequest(String prompt) async {
    try {
      final response = await OpenAI.instance.chat.create(
        model: 'gpt-4o-mini',
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.system,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(
                'You are an expert saxophone instructor specializing in personalized practice plan generation.',
              ),
            ],
          ),
          OpenAIChatCompletionChoiceMessageModel(
            role: OpenAIChatMessageRole.user,
            content: [
              OpenAIChatCompletionChoiceMessageContentItemModel.text(prompt),
            ],
          ),
        ],
        maxTokens: 2000,
        temperature: 0.7,
      );

      if (response.choices.isEmpty) {
        throw Exception('No response from OpenAI');
      }

      final content = response.choices.first.message.content;
      if (content == null || content.isEmpty) {
        throw Exception('Empty response from OpenAI');
      }

      return content.first.text ?? '';

    } catch (e) {
      _logger.error('OpenAI API request failed: $e');
      rethrow;
    }
  }

  /// Parse OpenAI response into practice routines
  List<PracticeRoutine> parsePracticeRoutines(String response) {
    try {
      // Clean the response to extract JSON
      String cleanResponse = response.trim();
      
      // Remove code block markers if present
      if (cleanResponse.startsWith('```json')) {
        cleanResponse = cleanResponse.substring(7);
      }
      if (cleanResponse.endsWith('```')) {
        cleanResponse = cleanResponse.substring(0, cleanResponse.length - 3);
      }
      
      final jsonData = jsonDecode(cleanResponse);
      
      if (jsonData is! Map<String, dynamic>) {
        throw Exception('Invalid JSON structure');
      }
      
      final routinesData = jsonData['practiceRoutines'] as List?;
      if (routinesData == null) {
        throw Exception('No practiceRoutines found in response');
      }
      
      return routinesData
          .map((routine) => PracticeRoutine.fromJson(routine as Map<String, dynamic>))
          .toList();
      
    } catch (e) {
      _logger.error('Failed to parse practice routines: $e');
      
      // Return a fallback routine if parsing fails
      return [
        PracticeRoutine(
          title: 'Basic Practice Session',
          description: 'A simple practice routine based on your assessment',
          targetAreas: ['fundamentals'],
          difficulty: 'intermediate',
          estimatedDuration: '20 minutes',
          exercises: [
            PracticeExercise(
              name: 'Scale Practice',
              description: 'Practice major scales slowly with focus on intonation',
              estimatedDuration: '10 minutes',
              notes: 'Use a metronome at 60 BPM',
            ),
            PracticeExercise(
              name: 'Long Tones',
              description: 'Hold long tones for 8 counts each',
              estimatedDuration: '10 minutes',
              notes: 'Focus on steady pitch and tone quality',
            ),
          ],
        ),
      ];
    }
  }

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'service': 'OpenAI',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}