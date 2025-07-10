import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_card.dart';
import 'countdown_overlay_button.dart';

class ExerciseCountdown extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;

  const ExerciseCountdown({
    super.key,
    required this.provider,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Exercise card remains visible during countdown
                ExerciseCard(
                  exercise: exercise,
                  exerciseNumber: provider.currentExerciseNumber,
                ),
                const SizedBox(height: 48),
                // Countdown overlay over the recording button
                CountdownOverlayButton(
                  countdownValue: provider.countdownValue,
                  onCancel: provider.cancelCountdown,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
