import 'package:flutter/material.dart';

class ExerciseProgressIndicator extends StatelessWidget {
  final int currentExercise;
  final int totalExercises;

  const ExerciseProgressIndicator({
    super.key,
    required this.currentExercise,
    required this.totalExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Exercise $currentExercise of $totalExercises',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (currentExercise - 1) / totalExercises,
          backgroundColor: const Color(0xFFE0E0E0),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E5266)),
        ),
      ],
    );
  }
}