import 'package:flutter/material.dart';
import 'package:sax_buddy/features/assessment/widgets/excercise_info.dart';
import 'package:sax_buddy/features/assessment/widgets/focus_areas.dart';
import '../models/assessment_exercise.dart';

class ExerciseCard extends StatelessWidget {
  final AssessmentExercise exercise;
  final int exerciseNumber;

  const ExerciseCard({
    super.key,
    required this.exercise,
    required this.exerciseNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exercise $exerciseNumber',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E5266),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exercise.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            exercise.instructions,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF212121),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ExcerciseInfo(exercise: exercise),
          const SizedBox(height: 16),
          Text(
            'Focus Areas:',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF757575),
            ),
          ),
          const SizedBox(height: 4),
          FocusAreas(exercise: exercise),
        ],
      ),
    );
  }
}
