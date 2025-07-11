import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sax_buddy/features/assessment/widgets/exit_dialog.dart';
import '../providers/assessment_provider.dart';
import '../models/exercise_state.dart' as model;
import 'exercise_presentation.dart';

class ExerciseContainer extends StatelessWidget {
  const ExerciseContainer({super.key});

  model.ExerciseState _convertExerciseState(ExerciseState providerState) {
    switch (providerState) {
      case ExerciseState.setup:
        return model.ExerciseState.setup;
      case ExerciseState.countdown:
        return model.ExerciseState.countdown;
      case ExerciseState.recording:
        return model.ExerciseState.recording;
      case ExerciseState.completed:
        return model.ExerciseState.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        void completeAssessment() {
          assessmentProvider.completeAssessment();
          Navigator.of(context).pushReplacementNamed('/assessment/complete');
        }

        void showExitDialog() {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return ExitDialog(
                onCancelAssessment: assessmentProvider.cancelAssessment,
              );
            },
          );
        }

        return ExercisePresentation(
          currentExercise: assessmentProvider.currentExercise,
          exerciseState: _convertExerciseState(assessmentProvider.exerciseState),
          currentExerciseNumber: assessmentProvider.currentExerciseNumber,
          totalExercises: assessmentProvider.totalExercises,
          isRecording: assessmentProvider.isRecording,
          countdownValue: assessmentProvider.countdownValue,
          audioService: assessmentProvider.audioService,
          canGoToPreviousExercise: assessmentProvider.canGoToPreviousExercise,
          canGoToNextExercise: assessmentProvider.canGoToNextExercise,
          onStartRecording: assessmentProvider.startRecording,
          onStopRecording: assessmentProvider.stopRecording,
          onCancelCountdown: assessmentProvider.cancelCountdown,
          onPreviousExercise: assessmentProvider.goToPreviousExercise,
          onNextExercise: assessmentProvider.goToNextExercise,
          onCompleteAssessment: completeAssessment,
          onExit: showExitDialog,
        );
      },
    );
  }
}
