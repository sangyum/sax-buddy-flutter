import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'routine_detail_presentation.dart';

class RoutineDetailScreen extends StatelessWidget {
  final PracticeRoutine routine;

  const RoutineDetailScreen({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return RoutineDetailPresentation(routine: routine);
  }
}