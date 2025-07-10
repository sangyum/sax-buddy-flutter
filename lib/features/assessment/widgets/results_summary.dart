import 'package:flutter/material.dart';
import '../models/exercise_result.dart';

class ResultsSummary extends StatelessWidget {
  final int completedExercisesCount;
  final int totalExercises;
  final List<ExerciseResult> completedExercises;

  const ResultsSummary({
    super.key,
    required this.completedExercisesCount,
    required this.totalExercises,
    required this.completedExercises,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Text(
            'Exercises Completed',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedExercisesCount / $totalExercises',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E5266),
            ),
          ),
          const SizedBox(height: 16),

          // Exercise list
          ...completedExercises.map((result) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Exercise ${result.exerciseId}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ),
                  Text(
                    '${result.actualDuration.inSeconds}s',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
