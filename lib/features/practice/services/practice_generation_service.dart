import 'dart:convert';
import 'dart:math';
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/assessment/services/audio_analysis_dataset_service.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PracticeGenerationService {
  final LoggerService _logger;
  final OpenAIService _openAIService;
  final AudioAnalysisDatasetService _datasetService;
  bool _isInitialized = false;

  PracticeGenerationService(
    this._logger,
    this._openAIService,
    this._datasetService,
  );

  bool get isInitialized => _isInitialized;

  /// Initialize the practice generation service
  void initialize(String openAIApiKey) {
    try {
      _openAIService.initialize(openAIApiKey);
      _isInitialized = true;
      _logger.debug('Practice generation service initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize practice generation service: $e');
      rethrow;
    }
  }

  /// Generate a unique ID for practice routines
  String _generateId() {
    final random = Random();
    final chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(12, (index) => chars[random.nextInt(chars.length)]).join();
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
    bool isAIGenerated = false,
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

  /// Generate personalized practice plans from assessment dataset
  Future<List<PracticeRoutine>> generatePracticePlans(
    AssessmentDataset dataset, {
    Function(PracticeRoutine)? onRoutineCompleted,
  }) async {
    try {
      if (!_isInitialized) {
        throw Exception('Practice generation service not initialized');
      }

      _logger.debug('Generating practice plans for session: ${dataset.sessionId}');

      // Validate dataset
      if (!validateDataset(dataset)) {
        throw Exception('Invalid dataset provided');
      }

      // Generate practice plans using domain-specific logic
      final practiceRoutines = await _generatePracticeRoutines(
        dataset,
        onRoutineCompleted: onRoutineCompleted,
      );

      // Post-process and validate generated routines
      final validatedRoutines = _validateAndAdjustRoutines(practiceRoutines, dataset);

      _logger.debug('Generated ${validatedRoutines.length} practice routines');
      return validatedRoutines;

    } catch (e) {
      _logger.error('Failed to generate practice plans: $e');
      
      // Return fallback routines if generation fails
      return _generateFallbackRoutines(dataset);
    }
  }

  /// Validate dataset before processing
  bool validateDataset(AssessmentDataset dataset) {
    return _datasetService.validateDataset(dataset);
  }

  /// Validate and adjust generated routines
  List<PracticeRoutine> _validateAndAdjustRoutines(
    List<PracticeRoutine> routines,
    AssessmentDataset dataset,
  ) {
    final validatedRoutines = <PracticeRoutine>[];
    
    for (final routine in routines) {
      // Validate routine structure
      if (routine.title.isEmpty || routine.exercises.isEmpty) {
        _logger.warning('Skipping invalid routine: ${routine.title}');
        continue;
      }
      
      // Adjust difficulty based on user level
      final adjustedRoutine = _adjustRoutineDifficulty(routine, dataset.userLevel);
      validatedRoutines.add(adjustedRoutine);
    }
    
    // Ensure we have at least one routine
    if (validatedRoutines.isEmpty) {
      _logger.warning('No valid routines generated, creating fallback');
      return _generateFallbackRoutines(dataset);
    }
    
    return validatedRoutines;
  }

  /// Adjust routine difficulty based on user level
  PracticeRoutine _adjustRoutineDifficulty(PracticeRoutine routine, String userLevel) {
    // Map user levels to appropriate difficulty
    final difficultyMap = {
      'beginner': 'beginner',
      'intermediate': 'intermediate',
      'advanced': 'advanced',
    };
    
    final adjustedDifficulty = difficultyMap[userLevel] ?? 'intermediate';
    
    return _createRoutine(
      title: routine.title,
      description: routine.description,
      targetAreas: routine.targetAreas,
      difficulty: adjustedDifficulty,
      estimatedDuration: routine.estimatedDuration,
      exercises: routine.exercises,
      userId: routine.userId,
      isAIGenerated: routine.isAIGenerated,
    );
  }

  /// Generate fallback routines when AI generation fails
  List<PracticeRoutine> _generateFallbackRoutines(AssessmentDataset dataset) {
    _logger.debug('Generating fallback routines for ${dataset.userLevel} level');
    
    final routines = <PracticeRoutine>[];
    
    // Generate routines based on identified weaknesses
    if (dataset.overallAssessment.weaknesses.contains('timing consistency') ||
        dataset.overallAssessment.weaknesses.contains('timing accuracy')) {
      routines.add(_createTimingRoutine(dataset.userLevel));
    }
    
    if (dataset.overallAssessment.weaknesses.contains('pitch stability') ||
        dataset.overallAssessment.weaknesses.contains('pitch accuracy')) {
      routines.add(_createPitchRoutine(dataset.userLevel));
    }
    
    // Always include a basic technique routine
    routines.add(_createBasicTechniqueRoutine(dataset.userLevel));
    
    // Add scale work if not already covered
    if (!routines.any((r) => r.title.toLowerCase().contains('scale'))) {
      routines.add(_createScaleRoutine(dataset.userLevel));
    }
    
    return routines;
  }

  /// Create a timing-focused routine
  PracticeRoutine _createTimingRoutine(String userLevel) {
    final exercises = <PracticeExercise>[];
    
    switch (userLevel) {
      case 'beginner':
        exercises.addAll([
          PracticeExercise(
            name: 'Simple Metronome Practice',
            description: 'Play long tones with metronome at 60 BPM',
            tempo: '60 BPM',
            estimatedDuration: '5 minutes',
            notes: 'Focus on starting and stopping exactly with the beat',
          ),
          PracticeExercise(
            name: 'Quarter Note Scales',
            description: 'Play C major scale in quarter notes',
            tempo: '80 BPM',
            keySignature: 'C Major',
            estimatedDuration: '10 minutes',
            notes: 'Keep steady tempo throughout',
            musicXML: _getSampleMusicXML(tempo: 80),
          ),
        ]);
        break;
      case 'intermediate':
        exercises.addAll([
          PracticeExercise(
            name: 'Rhythmic Patterns',
            description: 'Practice various rhythmic patterns with metronome',
            tempo: '100 BPM',
            estimatedDuration: '10 minutes',
            notes: 'Include eighth notes, quarter notes, and half notes',
          ),
          PracticeExercise(
            name: 'Scale Variations',
            description: 'Play major scales with different rhythmic patterns',
            tempo: '120 BPM',
            estimatedDuration: '15 minutes',
            notes: 'Try dotted rhythms and syncopation',
            musicXML: _getSampleMusicXML(tempo: 120),
          ),
        ]);
        break;
      case 'advanced':
        exercises.addAll([
          PracticeExercise(
            name: 'Complex Rhythms',
            description: 'Practice complex rhythmic patterns and odd time signatures',
            tempo: '140 BPM',
            estimatedDuration: '15 minutes',
            notes: 'Include 5/4, 7/8, and mixed meters',
          ),
          PracticeExercise(
            name: 'Polyrhythmic Studies',
            description: 'Practice playing against different rhythmic patterns',
            tempo: '120 BPM',
            estimatedDuration: '20 minutes',
            notes: 'Use polyrhythmic exercises and cross-rhythms',
          ),
        ]);
        break;
    }
    
    return _createRoutine(
      title: 'Timing and Rhythm Development',
      description: 'Focused practice to improve timing accuracy and rhythmic consistency',
      targetAreas: ['timing', 'rhythm', 'metronome skills'],
      difficulty: userLevel,
      estimatedDuration: '${exercises.fold(0, (sum, e) => sum + int.parse(e.estimatedDuration.split(' ')[0]))} minutes',
      exercises: exercises,
    );
  }

  /// Create a pitch-focused routine
  PracticeRoutine _createPitchRoutine(String userLevel) {
    final exercises = <PracticeExercise>[];
    
    switch (userLevel) {
      case 'beginner':
        exercises.addAll([
          PracticeExercise(
            name: 'Long Tones',
            description: 'Hold steady tones for 8 beats each',
            tempo: '60 BPM',
            estimatedDuration: '10 minutes',
            notes: 'Focus on consistent pitch and tone quality',
          ),
          PracticeExercise(
            name: 'Slow Scales',
            description: 'Play major scales very slowly',
            tempo: '60 BPM',
            keySignature: 'C Major',
            estimatedDuration: '10 minutes',
            notes: 'Listen carefully to intonation',
            musicXML: _getSampleMusicXML(tempo: 60),
          ),
        ]);
        break;
      case 'intermediate':
        exercises.addAll([
          PracticeExercise(
            name: 'Interval Training',
            description: 'Practice major and minor intervals',
            tempo: '80 BPM',
            estimatedDuration: '12 minutes',
            notes: 'Use tuner to check intonation',
          ),
          PracticeExercise(
            name: 'Chromatic Scales',
            description: 'Play chromatic scales with focus on pitch accuracy',
            tempo: '100 BPM',
            estimatedDuration: '8 minutes',
            notes: 'Pay attention to half-step relationships',
          ),
        ]);
        break;
      case 'advanced':
        exercises.addAll([
          PracticeExercise(
            name: 'Microtonal Exercises',
            description: 'Practice subtle pitch adjustments and bending',
            estimatedDuration: '15 minutes',
            notes: 'Work on expressive intonation',
          ),
          PracticeExercise(
            name: 'Harmonic Series',
            description: 'Practice overtones and harmonic series',
            estimatedDuration: '15 minutes',
            notes: 'Focus on pure intonation and overtone production',
          ),
        ]);
        break;
    }
    
    return _createRoutine(
      title: 'Pitch Accuracy and Intonation',
      description: 'Exercises to improve pitch stability and intonation',
      targetAreas: ['pitch accuracy', 'intonation', 'tone quality'],
      difficulty: userLevel,
      estimatedDuration: '${exercises.fold(0, (sum, e) => sum + int.parse(e.estimatedDuration.split(' ')[0]))} minutes',
      exercises: exercises,
    );
  }

  /// Create a basic technique routine
  PracticeRoutine _createBasicTechniqueRoutine(String userLevel) {
    final exercises = <PracticeExercise>[];
    
    switch (userLevel) {
      case 'beginner':
        exercises.addAll([
          PracticeExercise(
            name: 'Breathing Exercises',
            description: 'Practice proper breathing technique',
            estimatedDuration: '5 minutes',
            notes: 'Focus on diaphragmatic breathing',
          ),
          PracticeExercise(
            name: 'Embouchure Development',
            description: 'Practice proper mouthpiece position',
            estimatedDuration: '10 minutes',
            notes: 'Maintain consistent embouchure',
          ),
        ]);
        break;
      case 'intermediate':
        exercises.addAll([
          PracticeExercise(
            name: 'Articulation Practice',
            description: 'Practice various articulation techniques',
            tempo: '100 BPM',
            estimatedDuration: '12 minutes',
            notes: 'Include staccato, legato, and accented notes',
          ),
          PracticeExercise(
            name: 'Finger Exercises',
            description: 'Practice finger coordination and dexterity',
            tempo: '120 BPM',
            estimatedDuration: '8 minutes',
            notes: 'Focus on clean finger movements',
          ),
        ]);
        break;
      case 'advanced':
        exercises.addAll([
          PracticeExercise(
            name: 'Advanced Articulation',
            description: 'Practice complex articulation patterns',
            tempo: '140 BPM',
            estimatedDuration: '15 minutes',
            notes: 'Include double tonguing and flutter tonguing',
          ),
          PracticeExercise(
            name: 'Extended Techniques',
            description: 'Practice altissimo and other extended techniques',
            estimatedDuration: '20 minutes',
            notes: 'Work on voicing and overtone manipulation',
          ),
        ]);
        break;
    }
    
    return _createRoutine(
      title: 'Fundamental Technique',
      description: 'Essential exercises for developing proper saxophone technique',
      targetAreas: ['technique', 'fundamentals', 'coordination'],
      difficulty: userLevel,
      estimatedDuration: '${exercises.fold(0, (sum, e) => sum + int.parse(e.estimatedDuration.split(' ')[0]))} minutes',
      exercises: exercises,
    );
  }

  /// Create a scale-focused routine
  PracticeRoutine _createScaleRoutine(String userLevel) {
    final exercises = <PracticeExercise>[];
    
    switch (userLevel) {
      case 'beginner':
        exercises.addAll([
          PracticeExercise(
            name: 'Major Scales',
            description: 'Practice C, G, F major scales',
            tempo: '80 BPM',
            keySignature: 'C Major, G Major, F Major',
            estimatedDuration: '15 minutes',
            notes: 'Focus on fingering accuracy',
            musicXML: _getSampleMusicXML(tempo: 80),
          ),
        ]);
        break;
      case 'intermediate':
        exercises.addAll([
          PracticeExercise(
            name: 'Circle of Fifths',
            description: 'Practice all major scales in circle of fifths order',
            tempo: '100 BPM',
            estimatedDuration: '15 minutes',
            notes: 'Maintain consistent tempo and articulation',
            musicXML: _getSampleMusicXML(tempo: 100),
          ),
          PracticeExercise(
            name: 'Natural Minor Scales',
            description: 'Practice natural minor scales',
            tempo: '100 BPM',
            estimatedDuration: '10 minutes',
            notes: 'Compare with major scale patterns',
          ),
        ]);
        break;
      case 'advanced':
        exercises.addAll([
          PracticeExercise(
            name: 'Mode Practice',
            description: 'Practice all modes of major scale',
            tempo: '120 BPM',
            estimatedDuration: '20 minutes',
            notes: 'Focus on characteristic tones of each mode',
          ),
          PracticeExercise(
            name: 'Exotic Scales',
            description: 'Practice pentatonic, blues, and other exotic scales',
            tempo: '110 BPM',
            estimatedDuration: '15 minutes',
            notes: 'Explore different musical colors',
          ),
        ]);
        break;
    }
    
    return _createRoutine(
      title: 'Scale Mastery',
      description: 'Comprehensive scale practice for technical development',
      targetAreas: ['scales', 'technical facility', 'key signatures'],
      difficulty: userLevel,
      estimatedDuration: '${exercises.fold(0, (sum, e) => sum + int.parse(e.estimatedDuration.split(' ')[0]))} minutes',
      exercises: exercises,
    );
  }

  /// Get sample musical notation for fallback exercises
  String _getSampleMusicXML({
    int tempo = 120,
    String title = 'Practice Exercise',
  }) {
    // Create a simple C major scale pattern that works for most exercises
    return '''<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<score-partwise version="4.0">
  <work>
    <work-title>$title</work-title>
  </work>
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
      <direction placement="above">
        <direction-type>
          <metronome>
            <beat-unit>quarter</beat-unit>
            <per-minute>$tempo</per-minute>
          </metronome>
        </direction-type>
      </direction>
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
</score-partwise>''';
  }

  /// Generate practice routines using domain-specific logic with parallel processing
  Future<List<PracticeRoutine>> _generatePracticeRoutines(
    AssessmentDataset dataset, {
    Function(PracticeRoutine)? onRoutineCompleted,
  }) async {
    try {
      _logger.debug(
        'Generating practice plan for session: ${dataset.sessionId}',
      );

      // Validate dataset
      if (!_validateDataset(dataset)) {
        throw Exception('Invalid dataset provided');
      }

      // Step 1: Generate practice routines (pedagogical focus)
      final routines = await _generateRoutineStructures(dataset);
      _logger.debug('Generated ${routines.length} practice routines');

      // Step 2: Generate MusicXML for exercises in parallel batches per routine
      for (int routineIndex = 0; routineIndex < routines.length; routineIndex++) {
        final routine = routines[routineIndex];
        
        _logger.debug('Processing routine ${routineIndex + 1}/${routines.length}: ${routine.title}');
        
        // Process all exercises in this routine concurrently
        final musicXMLFutures = routine.exercises.map((exercise) =>
          _generateEtudeMusicXMLWithFallback(exercise, routine.difficulty)
        ).toList();
        
        final musicXMLResults = await Future.wait(musicXMLFutures);
        
        // Assign results back to exercises
        for (int i = 0; i < routine.exercises.length; i++) {
          routine.exercises[i].musicXML = musicXMLResults[i];
        }
        
        _logger.debug('Completed routine ${routineIndex + 1}/${routines.length}: ${routine.title}');
        
        // Notify progress callback if provided
        onRoutineCompleted?.call(routine);
      }

      return routines;
    } catch (e) {
      _logger.error('Failed to generate practice plan: $e');
      rethrow;
    }
  }

  /// Validate dataset before processing
  bool _validateDataset(AssessmentDataset dataset) {
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

  /// Generate practice routine structures without MusicXML
  Future<List<PracticeRoutine>> _generateRoutineStructures(
    AssessmentDataset dataset,
  ) async {
    final prompt = _generatePracticeRoutinePrompt(dataset);
    final response = await _openAIService.generateResponse(prompt);
    return _parsePracticeRoutines(response);
  }

  /// Generate MusicXML for a specific exercise with fallback handling
  Future<String> _generateEtudeMusicXMLWithFallback(
    PracticeExercise exercise,
    String difficulty,
  ) async {
    try {
      final prompt = _generateMusicXMLPrompt(exercise, difficulty);
      final response = await _openAIService.generateResponse(prompt);
      final musicXML = _extractMusicXML(response);
      _logger.debug('Generated MusicXML for exercise: ${exercise.name}');
      return musicXML;
    } catch (e) {
      _logger.warning(
        'Failed to generate MusicXML for ${exercise.name}: $e',
      );
      // Continue with other exercises - don't fail entire routine
      return _getFallbackMusicXML(exercise.name);
    }
  }

  /// Generate structured prompt for practice routine generation
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

  /// Generate MusicXML prompt for a specific exercise
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
      '- Generate a complete MusicXML file with at least 8 measures',
    );
    buffer.writeln(
      '- Use treble clef appropriate for alto saxophone (sounds a major 6th lower)',
    );
    buffer.writeln(
      '- Include proper time signature (default 4/4), key signature, and tempo marking',
    );
    buffer.writeln(
      '- Add start and end repeat signs over the entire etude',
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

  /// Parse OpenAI response into practice routines
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
      if (!cleanResponse.contains('<score-partwise')) {
        throw Exception('Response does not contain valid MusicXML structure');
      }

      return cleanResponse;
    } catch (e) {
      _logger.error('Failed to extract MusicXML: $e');
      throw Exception('Invalid MusicXML response: $e');
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

  /// Generate service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'service': 'PracticeGenerationService',
      'openAIServiceInitialized': _isInitialized ? _openAIService.isInitialized : false,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}