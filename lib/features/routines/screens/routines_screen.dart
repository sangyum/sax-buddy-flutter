import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/routines_provider.dart';
import 'routines_presentation.dart';

class RoutinesScreen extends StatelessWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RoutinesProvider>(
      builder: (context, routinesProvider, child) {
        return RoutinesPresentation(
          routines: routinesProvider.recentRoutines,
          isLoading: routinesProvider.isLoading,
          error: routinesProvider.error,
          onRefresh: routinesProvider.refreshRoutines,
          onRoutineTap: (routine) => _handleRoutineTap(context, routine),
        );
      },
    );
  }

  void _handleRoutineTap(BuildContext context, routine) {
    // For now, just show a snackbar
    // In the future, this will navigate to routine details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening "${routine.title}" routine'),
        backgroundColor: const Color(0xFF2E5266),
      ),
    );
  }
}