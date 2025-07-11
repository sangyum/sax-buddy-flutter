import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import 'exercise_card.dart';
import 'countdown_overlay_button.dart';

class ExerciseCountdown extends StatelessWidget {
  final AssessmentExercise exercise;
  final int exerciseNumber;
  final int countdownValue;
  final VoidCallback onCancel;

  const ExerciseCountdown({
    super.key,
    required this.exercise,
    required this.exerciseNumber,
    required this.countdownValue,
    required this.onCancel,
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
                  exerciseNumber: exerciseNumber,
                ),
                const SizedBox(height: 48),
                // Countdown overlay over the recording button
                CountdownOverlayButton(
                  countdownValue: countdownValue,
                  onCancel: onCancel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
