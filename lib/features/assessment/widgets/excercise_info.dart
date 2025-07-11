import 'package:flutter/material.dart';
import 'package:sax_buddy/features/assessment/models/assessment_exercise.dart';
import 'package:sax_buddy/features/assessment/widgets/info_chip.dart';

class ExcerciseInfo extends StatelessWidget {
  const ExcerciseInfo({
    super.key,
    required this.exercise,
  });

  final AssessmentExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (exercise.tempo != null) ...[
          InfoChip(
            icon: Icons.speed,
            label: '${exercise.tempo} BPM',
          ),
          const SizedBox(width: 12),
        ],
        InfoChip(
          icon: Icons.timer,
          label: _formatDuration(exercise.duration),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    }
    return '${duration.inSeconds}s';
  }

}
