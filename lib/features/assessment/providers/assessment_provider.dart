import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/assessment_exercise.dart';
import '../models/assessment_session.dart';
import '../models/exercise_result.dart';
import '../data/initial_exercises.dart';
import '../../../services/logger_service.dart';
import '../../../services/audio_recording_service.dart';
import '../../../services/audio_analysis_service.dart';
import '../../../services/firebase_storage_service.dart';
import '../repositories/assessment_repository.dart';
import '../models/assessment_result.dart';
import 'package:injectable/injectable.dart';

enum ExerciseState {
  setup,
  countdown,
  recording,
  completed,
}

@injectable
class AssessmentProvider extends ChangeNotifier {
  final LoggerService _logger;
  final AudioRecordingService _audioService;
  final AudioAnalysisService _analysisService;
  final FirebaseStorageService _storageService;
  final AssessmentRepository _assessmentRepository;

  AssessmentProvider(
    this._logger,
    this._audioService,
    this._analysisService,
    this._storageService,
    this._assessmentRepository,
  );

  AssessmentSession? _currentSession;
  ExerciseState _exerciseState = ExerciseState.setup;
  int _countdownValue = 5;
  Timer? _countdownTimer;
  Timer? _recordingTimer;
  DateTime? _exerciseStartTime;
  String? _currentRecordingPath;
  String? _lastError;
  String? _userId;

  AssessmentSession? get currentSession => _currentSession;
  ExerciseState get exerciseState => _exerciseState;
  int get countdownValue => _countdownValue;
  bool get isCountdownActive => _countdownTimer?.isActive ?? false;
  bool get isRecording => _exerciseState == ExerciseState.recording;

  AssessmentExercise? get currentExercise {
    if (_currentSession == null) return null;
    return InitialExercises.exercises[_currentSession!.currentExerciseIndex];
  }

  int get currentExerciseNumber => (_currentSession?.currentExerciseIndex ?? 0) + 1;
  int get totalExercises => InitialExercises.totalExercises;
  double get progress => (_currentSession?.currentExerciseIndex ?? 0) / totalExercises;

  bool get canGoToNextExercise => 
      _currentSession?.canProceedToNext ?? false;
  
  bool get canGoToPreviousExercise => 
      _currentSession?.canGoToPrevious ?? false;

  // Audio service getter for widgets to access waveform data
  AudioRecordingService get audioService => _audioService;
  
  // Error state getter
  String? get lastError => _lastError;

  Future<void> startAssessment() async {
    _logger.info('Starting initial assessment');
    
    // Initialize audio service
    await _audioService.initialize();
    
    // Check permissions
    final hasPermission = await _audioService.checkPermissions();
    if (!hasPermission) {
      _logger.error('Microphone permission denied');
      _lastError = 'Microphone permission is required for audio recording';
      notifyListeners();
      return;
    }
    
    // Clear any previous errors
    _lastError = null;
    
    _currentSession = AssessmentSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      currentExerciseIndex: 0,
      completedExercises: [],
      state: AssessmentSessionState.inProgress,
    );

    _exerciseState = ExerciseState.setup;
    notifyListeners();
  }

  void startCountdown() {
    if (_currentSession == null) return;

    _logger.info('Starting countdown for exercise $currentExerciseNumber');
    
    _exerciseState = ExerciseState.countdown;
    _countdownValue = 5;
    notifyListeners();

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _countdownValue--;
        notifyListeners();

        if (_countdownValue <= 0) {
          timer.cancel();
          startRecording();
        }
      },
    );
  }

  void cancelCountdown() {
    _logger.info('Countdown cancelled');
    
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _exerciseState = ExerciseState.setup;
    _countdownValue = 5;
    notifyListeners();
  }

  Future<void> startRecording() async {
    _logger.info('Starting recording for exercise $currentExerciseNumber');
    
    _exerciseState = ExerciseState.recording;
    _exerciseStartTime = DateTime.now();
    
    // Start actual audio recording
    try {
      _currentRecordingPath = await _audioService.startRecording();
      _logger.info('Audio recording started: $_currentRecordingPath');
      _lastError = null; // Clear any previous errors
    } catch (e) {
      _logger.error('Failed to start audio recording: $e');
      _lastError = 'Failed to start audio recording: ${e.toString()}';
      notifyListeners();
    }
    
    final exerciseDuration = currentExercise?.duration ?? const Duration(seconds: 45);
    
    notifyListeners();

    _recordingTimer = Timer(exerciseDuration, () {
      _stopRecording();
    });
  }

  Future<void> stopRecording() async {
    _logger.info('Recording stopped manually');
    await _stopRecording();
  }

  Future<void> _stopRecording() async {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    if (_currentSession == null || _exerciseStartTime == null) return;

    // Stop actual audio recording
    String? recordingPath;
    try {
      recordingPath = await _audioService.stopRecording();
      _logger.info('Audio recording stopped: $recordingPath');
    } catch (e) {
      _logger.error('Failed to stop audio recording: $e');
    }

    final exercise = currentExercise!;
    final actualDuration = DateTime.now().difference(_exerciseStartTime!);

    // Perform audio analysis if recording exists
    Map<String, dynamic> analysisData = {
      'exercise_title': exercise.title,
      'target_duration': exercise.duration.inSeconds,
      'actual_duration': actualDuration.inSeconds,
      'recording_path': recordingPath,
      'recording_file_size': recordingPath != null ? await _audioService.getRecordingSize(recordingPath) : null,
    };

    String? audioRecordingUrl;
    if (recordingPath != null) {
      try {
        // Perform audio analysis
        final analysis = await _analysisService.analyzeRecording(recordingPath);
        analysisData.addAll(analysis.toJson());
        _logger.info('Audio analysis completed for exercise ${exercise.id}');
        
        // Upload to Firebase Storage and get URL
        audioRecordingUrl = await _storageService.uploadAudioFile(recordingPath, exercise.id.toString());
        _logger.info('Audio upload completed for exercise ${exercise.id}: $audioRecordingUrl');
        
      } catch (e) {
        _logger.error('Audio processing failed: $e');
        analysisData['analysis_error'] = e.toString();
        
        // Still try background upload even if analysis fails
        _storageService.uploadAudioFileInBackground(recordingPath, exercise.id.toString());
      }
    }

    final result = ExerciseResult(
      exerciseId: exercise.id,
      completedAt: DateTime.now(),
      actualDuration: actualDuration,
      wasCompleted: true,
      analysisData: analysisData,
      audioRecordingUrl: audioRecordingUrl,
    );

    final updatedResults = List<ExerciseResult>.from(_currentSession!.completedExercises)
      ..add(result);

    _currentSession = _currentSession!.copyWith(
      completedExercises: updatedResults,
    );

    _exerciseState = ExerciseState.completed;
    _exerciseStartTime = null;
    _currentRecordingPath = null;

    _logger.info('Exercise $currentExerciseNumber completed', extra: {
      'exerciseId': exercise.id,
      'duration': actualDuration.inSeconds,
      'recordingPath': recordingPath,
    });

    notifyListeners();
  }

  void goToNextExercise() {
    if (_currentSession == null || !canGoToNextExercise) return;

    _logger.info('Moving to next exercise');

    _currentSession = _currentSession!.copyWith(
      currentExerciseIndex: _currentSession!.currentExerciseIndex + 1,
    );

    _exerciseState = ExerciseState.setup;
    _countdownValue = 5;
    notifyListeners();
  }

  void goToPreviousExercise() {
    if (_currentSession == null || !canGoToPreviousExercise) return;

    _logger.info('Moving to previous exercise');

    _currentSession = _currentSession!.copyWith(
      currentExerciseIndex: _currentSession!.currentExerciseIndex - 1,
    );

    _exerciseState = ExerciseState.setup;
    _countdownValue = 5;
    notifyListeners();
  }

  void completeAssessment() {
    if (_currentSession == null) return;

    _logger.info('Assessment completed', extra: {
      'sessionId': _currentSession!.id,
      'exercisesCompleted': _currentSession!.completedExercises.length,
    });

    _currentSession = _currentSession!.copyWith(
      state: AssessmentSessionState.completed,
    );

    // Persist assessment result
    _persistAssessmentResult();

    notifyListeners();
  }

  void cancelAssessment() {
    _logger.info('Assessment cancelled');

    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    
    _currentSession = _currentSession?.copyWith(
      state: AssessmentSessionState.cancelled,
    );

    _exerciseState = ExerciseState.setup;
    _countdownValue = 5;
    notifyListeners();
  }

  void resetAssessment() {
    _logger.info('Assessment reset');

    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    
    _currentSession = null;
    _exerciseState = ExerciseState.setup;
    _countdownValue = 5;
    _exerciseStartTime = null;
    _lastError = null;
    
    notifyListeners();
  }

  /// Clear last error and retry
  Future<void> retryAfterError() async {
    _lastError = null;
    notifyListeners();
    
    // If we're not in an assessment, try to start one
    if (_currentSession == null) {
      await startAssessment();
    }
  }

  /// Check if we have an active error
  bool get hasError => _lastError != null;

  /// Set user ID for assessment persistence
  void setUserId(String userId) {
    _userId = userId;
    _logger.debug('User ID set for assessment provider: $userId');
  }

  /// Persist assessment result to repository
  Future<void> _persistAssessmentResult() async {
    if (_currentSession == null || _userId == null) {
      _logger.warning('Cannot persist assessment: missing session or user ID');
      return;
    }
    
    try {
      // Only persist if all exercises are completed
      if (_currentSession!.completedExercises.length >= 4) {
        final assessmentResult = _createAssessmentResult();
        await _assessmentRepository.createAssessment(_userId!, assessmentResult);
        
        _logger.info('Assessment result persisted successfully', extra: {
          'sessionId': assessmentResult.sessionId,
          'skillLevel': assessmentResult.skillLevel.name,
          'exerciseCount': assessmentResult.exerciseResults.length,
        });
      }
    } catch (e) {
      _logger.logError('persist_assessment', e, extra: {
        'sessionId': _currentSession!.id,
        'exerciseCount': _currentSession!.completedExercises.length,
      });
      // Don't throw - persistence failures shouldn't block UI flow
    }
  }

  /// Create AssessmentResult from current session
  AssessmentResult _createAssessmentResult() {
    if (_currentSession == null) {
      throw StateError('Cannot create assessment result without active session');
    }

    // Simple skill level determination based on exercise performance
    final skillLevel = _determineSkillLevel(_currentSession!.completedExercises);
    final analysis = _analyzeResults(_currentSession!.completedExercises);

    return AssessmentResult(
      sessionId: _currentSession!.id,
      completedAt: DateTime.now(),
      exerciseResults: _currentSession!.completedExercises,
      skillLevel: skillLevel,
      strengths: analysis['strengths'] as List<String>,
      weaknesses: analysis['weaknesses'] as List<String>,
      notes: analysis['notes'] as String?,
    );
  }

  /// Determine skill level based on exercise results
  SkillLevel _determineSkillLevel(List<ExerciseResult> results) {
    if (results.length < 4) return SkillLevel.beginner;
    
    // Simple heuristic: check if most exercises were completed successfully
    final successfulExercises = results.where((r) => r.wasCompleted).length;
    final successRate = successfulExercises / results.length;
    
    if (successRate >= 0.8) return SkillLevel.advanced;
    if (successRate >= 0.6) return SkillLevel.intermediate;
    return SkillLevel.beginner;
  }

  /// Analyze exercise results to provide feedback
  Map<String, dynamic> _analyzeResults(List<ExerciseResult> results) {
    final strengths = <String>[];
    final weaknesses = <String>[];
    
    // Simple analysis based on completion and timing
    for (final result in results) {
      if (result.wasCompleted) {
        strengths.add('Completed ${_getExerciseName(result.exerciseId)}');
      } else {
        weaknesses.add('Struggled with ${_getExerciseName(result.exerciseId)}');
      }
    }
    
    if (strengths.isEmpty) {
      strengths.add('Participated in assessment');
    }
    
    if (weaknesses.isEmpty) {
      weaknesses.add('Continue practicing fundamentals');
    }
    
    return {
      'strengths': strengths,
      'weaknesses': weaknesses,
      'notes': 'Assessment completed with ${results.length} exercises',
    };
  }

  /// Get exercise name by ID
  String _getExerciseName(int exerciseId) {
    final exercise = InitialExercises.exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => InitialExercises.exercises.first,
    );
    return exercise.title;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }
}