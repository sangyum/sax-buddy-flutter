import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'exercise_card.dart';

class ExerciseList extends StatelessWidget {
  final List<PracticeExercise> exercises;

  const ExerciseList({
    super.key,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.fitness_center,
              color: Color(0xFF2E5266),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Exercises (${exercises.length})',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5266),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...exercises.map((exercise) => ExerciseCard(exercise: exercise)),
      ],
    );
  }
}