import 'package:flutter/material.dart';
import 'package:sax_buddy/features/assessment/models/assessment_exercise.dart';
import 'package:sax_buddy/features/assessment/widgets/focus_area_chip.dart';

class FocusAreas extends StatelessWidget {
  const FocusAreas({
    super.key,
    required this.exercise,
  });

  final AssessmentExercise exercise;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: exercise.focusAreas.map((area) => 
        FocusAreaChip(label: area)
      ).toList(),
    );
  }
}
