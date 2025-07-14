import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart';
import 'package:sax_buddy/features/assessment/services/audio_analysis_dataset_service.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:injectable/injectable.dart';
import 'dart:math';

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
  Future<List<PracticeRoutine>> generatePracticePlans(AssessmentDataset dataset) async {
    try {
      if (!_isInitialized) {
        throw Exception('Practice generation service not initialized');
      }

      _logger.debug('Generating practice plans for session: ${dataset.sessionId}');

      // Validate dataset
      if (!validateDataset(dataset)) {
        throw Exception('Invalid dataset provided');
      }

      // Generate practice plans using OpenAI
      final practiceRoutines = await _openAIService.generatePracticePlan(dataset);

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

  /// Get service status
  Map<String, dynamic> getStatus() {
    return {
      'isInitialized': _isInitialized,
      'service': 'PracticeGenerationService',
      'openAIServiceInitialized': _isInitialized ? _openAIService.isInitialized : false,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}