import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import '../widgets/routine_header.dart';
import '../widgets/exercise_list.dart';

class RoutineDetailPresentation extends StatelessWidget {
  final PracticeRoutine routine;

  const RoutineDetailPresentation({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          routine.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E5266),
          ),
        ),
        backgroundColor: const Color(0xFFF8F9FA),
        foregroundColor: const Color(0xFF2E5266),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoutineHeader(routine: routine),
            const SizedBox(height: 24),
            ExerciseList(
              exercises: routine.exercises,
            ),
          ],
        ),
      ),
    );
  }
}