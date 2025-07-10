import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_setup_state.dart';
import 'exercise_recording_state.dart';
import 'exercise_completed_state.dart';
import 'countdown.dart';

class ExerciseContent extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;

  const ExerciseContent({
    super.key,
    required this.provider,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    switch (provider.exerciseState) {
      case ExerciseState.setup:
        return ExerciseSetupState(provider: provider, exercise: exercise);
      case ExerciseState.countdown:
        return Countdown(
          countdownValue: provider.countdownValue,
          onCancel: provider.cancelCountdown,
        );
      case ExerciseState.recording:
        return ExerciseRecordingState(provider: provider, exercise: exercise);
      case ExerciseState.completed:
        return ExerciseCompletedState(provider: provider, exercise: exercise);
    }
  }
}
