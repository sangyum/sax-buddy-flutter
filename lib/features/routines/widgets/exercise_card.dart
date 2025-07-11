import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

class ExerciseCard extends StatelessWidget {
  final PracticeExercise exercise;

  const ExerciseCard({
    super.key,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              exercise.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5266),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              exercise.description,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF5A6C7D),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _buildDetailChip('Duration', exercise.estimatedDuration),
                if (exercise.tempo != null)
                  _buildDetailChip('Tempo', exercise.tempo!),
                if (exercise.keySignature != null)
                  _buildDetailChip('Key', exercise.keySignature!),
              ],
            ),
            if (exercise.notes != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: Color(0xFF2E5266),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        exercise.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2E5266),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF2E5266),
        ),
      ),
    );
  }
}