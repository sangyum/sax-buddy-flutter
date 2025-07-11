import 'package:flutter/material.dart';
import 'package:sax_buddy/services/audio_recording_service.dart';
import '../models/assessment_exercise.dart';
import '../models/exercise_state.dart';
import 'exercise_setup.dart';
import 'exercise_recording.dart';
import 'exercise_completed.dart';
import 'exercise_countdown.dart';

class ExerciseContent extends StatelessWidget {
  final ExerciseState exerciseState;
  final AssessmentExercise exercise;
  final int exerciseNumber;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final AudioRecordingService audioService;
  final int? countdownValue;
  final VoidCallback? onCancelCountdown;

  const ExerciseContent({
    super.key,
    required this.exerciseState,
    required this.exercise,
    required this.exerciseNumber,
    required this.onStartRecording,
    required this.onStopRecording,
    required this.audioService,
    this.countdownValue,
    this.onCancelCountdown,
  });

  @override
  Widget build(BuildContext context) {
    switch (exerciseState) {
      case ExerciseState.setup:
        return ExerciseSetup(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
          onStart: onStartRecording,
        );
      case ExerciseState.countdown:
        return ExerciseCountdown(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
          countdownValue: countdownValue ?? 0,
          onCancel: onCancelCountdown ?? () {},
        );
      case ExerciseState.recording:
        return ExerciseRecording(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
          onStopRecording: onStopRecording,
          audioService: audioService,
        );
      case ExerciseState.completed:
        return ExerciseCompleted(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
        );
    }
  }
}
