import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import 'exercise_card.dart';
import 'recording_button.dart';

class ExerciseSetup extends StatelessWidget {
  final AssessmentExercise exercise;
  final int exerciseNumber;
  final VoidCallback onStart;

  const ExerciseSetup({
    super.key,
    required this.exercise,
    required this.exerciseNumber,
    required this.onStart,
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
                  exerciseNumber: exerciseNumber,
                ),
                const SizedBox(height: 48),
                RecordingButton(
                  isRecording: false,
                  onPressed: onStart,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap microphone to start recording',
                  style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
