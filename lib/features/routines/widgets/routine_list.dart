import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
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
      return _EmptyState(onRefresh: onRefresh);
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

class _EmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const _EmptyState({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note_outlined,
            size: 64,
            color: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Practice Routines Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Complete an assessment to get personalized practice routines',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/assessment'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Assessment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5266),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E5266),
              ),
            ),
          ],
        ],
      ),
    );
  }
}