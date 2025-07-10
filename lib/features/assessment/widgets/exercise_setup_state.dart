import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_card.dart';
import 'recording_button.dart';

class ExerciseSetupState extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;

  const ExerciseSetupState({
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
                ExerciseCard(
                  exercise: exercise,
                  exerciseNumber: provider.currentExerciseNumber,
                ),
                const SizedBox(height: 48),
                RecordingButton(
                  isRecording: false,
                  onPressed: provider.startCountdown,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap to start recording',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}