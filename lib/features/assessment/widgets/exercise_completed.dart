import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import 'exercise_card.dart';

class ExerciseCompleted extends StatelessWidget {
  final AssessmentExercise exercise;
  final int exerciseNumber;

  const ExerciseCompleted({
    super.key,
    required this.exercise,
    required this.exerciseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ExerciseCard(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
        ),
        const Spacer(),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.check, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        const Text(
          'Exercise completed!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
