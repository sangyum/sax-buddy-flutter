import 'dart:convert';
import 'dart:math';
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

  /// Generate a unique ID for practice routines
  String _generateId() {
    final random = Random();
    final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
      12,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  /// Helper method to create PracticeRoutine with all required fields
  PracticeRoutine _createRoutine({
    required String title,
    required String description,
    required List<String> targetAreas,
    required String difficulty,
    required String estimatedDuration,
    required List<PracticeExercise> exercises,
    String? userId,
    bool isAIGenerated = true,
  }) {
    final now = DateTime.now();
    return PracticeRoutine(
      id: _generateId(),
      userId: userId ?? 'temp-user',
      title: title,
      description: description,
      targetAreas: targetAreas,
      difficulty: difficulty,
      estimatedDuration: estimatedDuration,
      exercises: exercises,
      createdAt: now,
      updatedAt: now,
      isAIGenerated: isAIGenerated,
    );
  }

  /// Generate personalized practice plan from assessment dataset
  /// Uses two-prompt architecture: 1) Generate routines, 2) Generate MusicXML for each exercise
  Future<List<PracticeRoutine>> generatePracticePlan(
    AssessmentDataset dataset,
  ) async {
    try {
      if (!_isInitialized) {
        throw Exception('OpenAI service not initialized');
      }

      _logger.debug(
        'Generating practice plan for session: ${dataset.sessionId}',
      );

      // Validate dataset
      if (!validateDataset(dataset)) {
        throw Exception('Invalid dataset provided');
      }

      // Step 1: Generate practice routines (pedagogical focus)
      final routines = await _generatePracticeRoutines(dataset);
      _logger.debug('Generated ${routines.length} practice routines');

      // Step 2: Generate MusicXML for each exercise (musical focus)
      for (final routine in routines) {
        for (final exercise in routine.exercises) {
          try {
            final musicXML = await _generateEtudeMusicXML(
              exercise,
              routine.difficulty,
            );
            exercise.musicXML = musicXML;
            _logger.debug('Generated MusicXML for exercise: ${exercise.name}');
          } catch (e) {
            _logger.warning(
              'Failed to generate MusicXML for ${exercise.name}: $e',
            );
            // Continue with other exercises - don't fail entire routine
            exercise.musicXML = _getFallbackMusicXML(exercise.name);
          }
        }
      }

      return routines;
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

  /// Generate practice routines without MusicXML (Step 1 of two-prompt architecture)
  Future<List<PracticeRoutine>> _generatePracticeRoutines(
    AssessmentDataset dataset,
  ) async {
    final prompt = _generatePracticeRoutinePrompt(dataset);
    final response = await _makeOpenAIRequest(prompt);
    return _parsePracticeRoutines(response);
  }

  /// Generate MusicXML for a specific exercise (Step 2 of two-prompt architecture)
  Future<String> _generateEtudeMusicXML(
    PracticeExercise exercise,
    String difficulty,
  ) async {
    final prompt = _generateMusicXMLPrompt(exercise, difficulty);
    final response = await _makeOpenAIRequest(prompt);
    return _extractMusicXML(response);
  }

  /// Generate structured prompt for practice routine generation (Step 1)
  String _generatePracticeRoutinePrompt(AssessmentDataset dataset) {
    final buffer = StringBuffer();

    buffer.writeln(
      'You are an expert saxophone instructor. Based on the following assessment data, create a personalized practice plan for a ${dataset.userLevel} level student.',
    );
    buffer.writeln();

    buffer.writeln('## Assessment Results');
    buffer.writeln('- **Student Level**: ${dataset.userLevel}');
    buffer.writeln('- **Session ID**: ${dataset.sessionId}');
    buffer.writeln(
      '- **Assessment Date**: ${dataset.timestamp.toIso8601String()}',
    );
    buffer.writeln();

    buffer.writeln('## Exercise Performance');
    for (final exercise in dataset.exercises) {
      buffer.writeln('### ${exercise.exerciseType}');
      buffer.writeln(
        '- **Pitch Accuracy**: ${(exercise.pitchAccuracy * 100).toStringAsFixed(1)}%',
      );
      buffer.writeln(
        '- **Timing Accuracy**: ${(exercise.timingAccuracy * 100).toStringAsFixed(1)}%',
      );
      buffer.writeln(
        '- **Expected Notes**: ${exercise.expectedNotes.join(', ')}',
      );
      buffer.writeln(
        '- **Detected Notes**: ${exercise.detectedNotes.join(', ')}',
      );

      if (exercise.strengths.isNotEmpty) {
        buffer.writeln('- **Strengths**: ${exercise.strengths.join(', ')}');
      }

      if (exercise.weaknesses.isNotEmpty) {
        buffer.writeln('- **Weaknesses**: ${exercise.weaknesses.join(', ')}');
      }

      buffer.writeln();
    }

    buffer.writeln('## Overall Assessment');
    buffer.writeln(
      '- **Skill Level**: ${dataset.overallAssessment.skillLevel}',
    );

    if (dataset.overallAssessment.strengths.isNotEmpty) {
      buffer.writeln(
        '- **Overall Strengths**: ${dataset.overallAssessment.strengths.join(', ')}',
      );
    }

    if (dataset.overallAssessment.weaknesses.isNotEmpty) {
      buffer.writeln(
        '- **Overall Weaknesses**: ${dataset.overallAssessment.weaknesses.join(', ')}',
      );
    }

    if (dataset.overallAssessment.recommendedFocusAreas.isNotEmpty) {
      buffer.writeln(
        '- **Recommended Focus Areas**: ${dataset.overallAssessment.recommendedFocusAreas.join(', ')}',
      );
    }

    buffer.writeln();
    buffer.writeln('## Task');
    buffer.writeln(
      'Create a personalized practice plan with the following structure:',
    );
    buffer.writeln(
      '- 3-5 practice routines, each targeting specific weaknesses',
    );
    buffer.writeln('- Each routine should contain 2-4 exercises');
    buffer.writeln(
      '- Include difficulty level, estimated duration, and detailed instructions',
    );
    buffer.writeln(
      '- Focus on the identified weaknesses while building on strengths',
    );
    buffer.writeln(
      '- Make exercises progressive and appropriate for the student\'s level',
    );
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
          "description": "Detailed instructions for the exercise concept",
          "tempo": "BPM (optional)",
          "keySignature": "Key (optional)",
          "notes": "Additional notes",
          "estimatedDuration": "X minutes",
          "musicalConcept": "Brief description of the musical pattern or etude concept to be generated"
        }
      ]
    }
  ]
}

IMPORTANT: 
- Focus on exercise concepts and instructions only
- The "musicalConcept" field should describe what type of etude to generate (e.g., "C major scale ascending and descending", "Arpeggio pattern in G major", "Interval exercise with perfect fifths")
- Do NOT include actual musical notation - that will be generated separately
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

      _logger.debug('Response from OpenAI $content');

      return content.first.text ?? '';
    } catch (e) {
      _logger.error('OpenAI API request failed: $e');
      rethrow;
    }
  }

  /// Generate MusicXML prompt for a specific exercise (Step 2)
  String _generateMusicXMLPrompt(PracticeExercise exercise, String difficulty) {
    final buffer = StringBuffer();

    buffer.writeln(
      'You are an expert music engraver specializing in saxophone etudes. Generate a MusicXML file for the following exercise:',
    );
    buffer.writeln();
    buffer.writeln('## Exercise Details');
    buffer.writeln('- **Name**: ${exercise.name}');
    buffer.writeln('- **Description**: ${exercise.description}');
    buffer.writeln('- **Difficulty**: $difficulty');
    buffer.writeln('- **Estimated Duration**: ${exercise.estimatedDuration}');
    if (exercise.tempo != null) {
      buffer.writeln('- **Tempo**: ${exercise.tempo}');
    }
    if (exercise.keySignature != null) {
      buffer.writeln('- **Key Signature**: ${exercise.keySignature}');
    }
    if (exercise.musicalConcept != null) {
      buffer.writeln('- **Musical Concept**: ${exercise.musicalConcept}');
    }
    if (exercise.notes != null) {
      buffer.writeln('- **Notes**: ${exercise.notes}');
    }
    buffer.writeln();

    buffer.writeln('## Requirements');
    buffer.writeln(
      '- Generate a complete MusicXML file with at least 4 measures',
    );
    buffer.writeln(
      '- Use treble clef appropriate for alto saxophone (sounds a major 6th lower)',
    );
    buffer.writeln(
      '- Include proper time signature (default 4/4), key signature, and tempo marking',
    );
    buffer.writeln(
      '- Create a musically coherent etude that targets the exercise concept',
    );
    buffer.writeln(
      '- Ensure proper MusicXML structure with <score-partwise> root element',
    );
    buffer.writeln('- Use appropriate note durations and rests');
    buffer.writeln('- Include measure numbers');
    buffer.writeln();

    buffer.writeln(
      'Please respond with a complete, valid MusicXML document that can be rendered by OpenSheetMusicDisplay.',
    );

    return buffer.toString();
  }

  /// Extract MusicXML from OpenAI response
  String _extractMusicXML(String response) {
    try {
      // Clean the response to extract MusicXML
      String cleanResponse = response.trim();

      // Remove code block markers if present
      if (cleanResponse.contains('```xml')) {
        final startIndex = cleanResponse.indexOf('```xml') + 6;
        final endIndex = cleanResponse.lastIndexOf('```');
        if (endIndex > startIndex) {
          cleanResponse = cleanResponse.substring(startIndex, endIndex).trim();
        }
      } else if (cleanResponse.contains('```')) {
        final startIndex = cleanResponse.indexOf('```') + 3;
        final endIndex = cleanResponse.lastIndexOf('```');
        if (endIndex > startIndex) {
          cleanResponse = cleanResponse.substring(startIndex, endIndex).trim();
        }
      }

      // Validate it looks like MusicXML
      if (!cleanResponse.contains('<score-partwise')) { // && !cleanResponse.contains('<score-timewise>')) {
        throw Exception('Response does not contain valid MusicXML structure');
      }

      return cleanResponse;
    } catch (e) {
      _logger.error('Failed to extract MusicXML: $e');
      throw Exception('Invalid MusicXML response: $e');
    }
  }

  /// Parse OpenAI response into practice routines (Step 1)
  List<PracticeRoutine> _parsePracticeRoutines(String response) {
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
          .map(
            (routine) =>
                _createRoutineFromJson(routine as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      _logger.error('Failed to parse practice routines: $e');

      // Return a fallback routine if parsing fails
      return [
        _createRoutine(
          title: 'Basic Practice Session',
          description: 'A simple practice routine based on your assessment',
          targetAreas: ['fundamentals'],
          difficulty: 'intermediate',
          estimatedDuration: '20 minutes',
          exercises: [
            _createFallbackExerciseWithNotation(
              name: 'Scale Practice',
              description:
                  'Practice C major scale slowly with focus on intonation',
              estimatedDuration: '10 minutes',
              notes: 'Use a metronome at 60 BPM',
            ),
            _createFallbackExerciseWithNotation(
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

  /// Create PracticeRoutine from JSON response
  PracticeRoutine _createRoutineFromJson(Map<String, dynamic> json) {
    final exercisesData = json['exercises'] as List? ?? [];
    final exercises = exercisesData
        .map((ex) => _createExerciseFromJson(ex as Map<String, dynamic>))
        .toList();

    return _createRoutine(
      title: json['title'] as String? ?? 'Practice Routine',
      description: json['description'] as String? ?? '',
      targetAreas: (json['targetAreas'] as List?)?.cast<String>() ?? [],
      difficulty: json['difficulty'] as String? ?? 'intermediate',
      estimatedDuration: json['estimatedDuration'] as String? ?? '20 minutes',
      exercises: exercises,
    );
  }

  /// Create PracticeExercise from JSON response
  PracticeExercise _createExerciseFromJson(Map<String, dynamic> json) {
    return PracticeExercise(
      name: json['name'] as String? ?? 'Exercise',
      description: json['description'] as String? ?? '',
      estimatedDuration: json['estimatedDuration'] as String? ?? '5 minutes',
      tempo: json['tempo'] as String?,
      keySignature: json['keySignature'] as String?,
      notes: json['notes'] as String?,
      musicalConcept: json['musicalConcept'] as String?,
      // MusicXML will be populated in step 2
      musicXML: null,
    );
  }

  /// Create fallback exercise with basic musical notation
  PracticeExercise _createFallbackExerciseWithNotation({
    required String name,
    required String description,
    required String estimatedDuration,
    String? notes,
  }) {
    return PracticeExercise(
      name: name,
      description: description,
      estimatedDuration: estimatedDuration,
      notes: notes,
      musicXML: _getFallbackMusicXML(name),
    );
  }

  /// Get fallback MusicXML for failed generation
  String _getFallbackMusicXML(String exerciseName) {
    return '''
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <part-list>
    <score-part id="P1">
      <part-name>Saxophone</part-name>
    </score-part>
  </part-list>
  <part id="P1">
    <measure number="1">
      <attributes>
        <divisions>1</divisions>
        <key>
          <fifths>0</fifths>
        </key>
        <time>
          <beats>4</beats>
          <beat-type>4</beat-type>
        </time>
        <clef>
          <sign>G</sign>
          <line>2</line>
        </clef>
      </attributes>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="2">
      <note>
        <pitch>
          <step>G</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>B</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>C</step>
          <octave>5</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="3">
      <note>
        <pitch>
          <step>B</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>A</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>G</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>F</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
    </measure>
    <measure number="4">
      <note>
        <pitch>
          <step>E</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>D</step>
          <octave>4</octave>
        </pitch>
        <duration>1</duration>
        <type>quarter</type>
      </note>
      <note>
        <pitch>
          <step>C</step>
          <octave>4</octave>
        </pitch>
        <duration>2</duration>
        <type>half</type>
      </note>
    </measure>
  </part>
</score-partwise>
''';
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
