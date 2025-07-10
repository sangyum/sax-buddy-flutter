import 'package:flutter/material.dart';
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
          Row(
            children: [
              if (exercise.tempo != null) ...[
                _InfoChip(
                  icon: Icons.speed,
                  label: '${exercise.tempo} BPM',
                ),
                const SizedBox(width: 12),
              ],
              _InfoChip(
                icon: Icons.timer,
                label: _formatDuration(exercise.duration),
              ),
            ],
          ),
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
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: exercise.focusAreas.map((area) => 
              _FocusAreaChip(label: area)
            ).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4F8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF2E5266),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF2E5266),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusAreaChip extends StatelessWidget {
  final String label;

  const _FocusAreaChip({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF757575),
        ),
      ),
    );
  }
}