import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routines/providers/routines_provider.dart';
import '../../practice/models/practice_routine.dart';

class CurrentRoutineSet extends StatelessWidget {
  const CurrentRoutineSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutinesProvider>(
      builder: (context, routinesProvider, child) {
        if (routinesProvider.isLoading) {
          return const _LoadingCard();
        }

        if (!routinesProvider.hasCurrentRoutineSet) {
          return const _EmptyCard();
        }

        return _CurrentRoutineCard(
          routines: routinesProvider.currentRoutineSet,
        );
      },
    );
  }
}

class _CurrentRoutineCard extends StatelessWidget {
  final List<PracticeRoutine> routines;

  const _CurrentRoutineCard({required this.routines});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Practice Set',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F4F8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.music_note,
                          size: 18,
                          color: Color(0xFF2E5266),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${routines.length} Practice Routines',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212121),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Generated from your latest assessment',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF757575),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: const Color(0xFF757575),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ...routines.take(2).map((routine) => _RoutinePreview(routine: routine)),
                  if (routines.length > 2)
                    Text(
                      '+ ${routines.length - 2} more routines',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF757575),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutinePreview extends StatelessWidget {
  final PracticeRoutine routine;

  const _RoutinePreview({required this.routine});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              color: const Color(0xFF2E5266),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              routine.title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF424242),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            routine.estimatedDuration,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Routines',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/assessment'),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.assessment,
                      size: 32,
                      color: const Color(0xFF757575),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Take Assessment',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Get personalized practice routines',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Practice Routines',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF212121),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5266)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}