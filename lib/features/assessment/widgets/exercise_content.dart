import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_setup.dart';
import 'exercise_recording.dart';
import 'exercise_completed.dart';
import 'exercise_countdown.dart';

class ExerciseContent extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;
  final int? exerciseNumber; // Optional for completed state
  final VoidCallback? onStartRecording; // Optional callback for recording state
  final VoidCallback? onStopRecording; // Optional callback for recording state

  const ExerciseContent({
    super.key,
    required this.provider,
    required this.exercise,
    this.exerciseNumber,
    this.onStartRecording,
    this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    switch (provider.exerciseState) {
      case ExerciseState.setup:
        return ExerciseSetup(
          exercise: exercise,
          exerciseNumber: exerciseNumber!,
          onStart: onStartRecording!,
        );
      case ExerciseState.countdown:
        return ExerciseCountdown(provider: provider, exercise: exercise);
      case ExerciseState.recording:
        return ExerciseRecording(
          exercise: exercise,
          exerciseNumber: exerciseNumber ?? provider.currentExerciseNumber,
          onStopRecording: onStopRecording ?? provider.stopRecording,
          audioService: provider.audioService,
        );
      case ExerciseState.completed:
        return ExerciseCompleted(
          exercise: exercise,
          exerciseNumber: exerciseNumber ?? provider.currentExerciseNumber,
        );
    }
  }
}
