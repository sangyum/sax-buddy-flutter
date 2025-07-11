import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/routines/widgets/empty_routines.dart';
import 'routine_card.dart';

class RoutineList extends StatelessWidget {
  final List<PracticeRoutine> routines;
  final Function(PracticeRoutine) onRoutineTap;
  final VoidCallback? onRefresh;

  const RoutineList({
    super.key,
    required this.routines,
    required this.onRoutineTap,
    this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (routines.isEmpty) {
      return EmptyRoutines(onRefresh: onRefresh);
    }

    return RefreshIndicator(
      onRefresh: onRefresh != null ? () async => onRefresh!() : () async {},
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: routines.length,
        itemBuilder: (context, index) {
          final routine = routines[index];
          return RoutineCard(
            routine: routine,
            onTap: () => onRoutineTap(routine),
          );
        },
      ),
    );
  }
}
