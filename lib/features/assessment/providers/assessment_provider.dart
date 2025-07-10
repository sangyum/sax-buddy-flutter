import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/assessment_exercise.dart';
import '../models/assessment_session.dart';
import '../models/exercise_result.dart';
import '../data/initial_exercises.dart';
import '../../../services/logger_service.dart';

enum ExerciseState {
  setup,
  countdown,
  recording,
  completed,
}

class AssessmentProvider extends ChangeNotifier {
  final LoggerService _logger = LoggerService.instance;

  AssessmentSession? _currentSession;
  ExerciseState _exerciseState = ExerciseState.setup;
  int _countdownValue = 5;
  Timer? _countdownTimer;
  Timer? _recordingTimer;
  DateTime? _exerciseStartTime;

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

  void startAssessment() {
    _logger.info('Starting initial assessment');
    
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
          _startRecording();
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

  void _startRecording() {
    _logger.info('Starting recording for exercise $currentExerciseNumber');
    
    _exerciseState = ExerciseState.recording;
    _exerciseStartTime = DateTime.now();
    
    final exerciseDuration = currentExercise?.duration ?? const Duration(seconds: 45);
    
    notifyListeners();

    _recordingTimer = Timer(exerciseDuration, () {
      _stopRecording();
    });
  }

  void stopRecording() {
    _logger.info('Recording stopped manually');
    _stopRecording();
  }

  void _stopRecording() {
    _recordingTimer?.cancel();
    _recordingTimer = null;

    if (_currentSession == null || _exerciseStartTime == null) return;

    final exercise = currentExercise!;
    final actualDuration = DateTime.now().difference(_exerciseStartTime!);

    final result = ExerciseResult(
      exerciseId: exercise.id,
      completedAt: DateTime.now(),
      actualDuration: actualDuration,
      wasCompleted: true,
      analysisData: {
        'exercise_title': exercise.title,
        'target_duration': exercise.duration.inSeconds,
        'actual_duration': actualDuration.inSeconds,
      },
    );

    final updatedResults = List<ExerciseResult>.from(_currentSession!.completedExercises)
      ..add(result);

    _currentSession = _currentSession!.copyWith(
      completedExercises: updatedResults,
    );

    _exerciseState = ExerciseState.completed;
    _exerciseStartTime = null;

    _logger.info('Exercise $currentExerciseNumber completed', extra: {
      'exerciseId': exercise.id,
      'duration': actualDuration.inSeconds,
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
    
    notifyListeners();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    super.dispose();
  }
}