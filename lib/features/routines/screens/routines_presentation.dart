import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/features/routines/widgets/error_banner.dart';
import 'package:sax_buddy/features/routines/widgets/loading_indicator.dart';
import '../widgets/routine_list.dart';

class RoutinesPresentation extends StatelessWidget {
  final List<PracticeRoutine> routines;
  final bool isLoading;
  final String? error;
  final VoidCallback onRefresh;
  final Function(PracticeRoutine) onRoutineTap;

  const RoutinesPresentation({
    super.key,
    required this.routines,
    required this.isLoading,
    this.error,
    required this.onRefresh,
    required this.onRoutineTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Practice Routines',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF2E5266)),
            onPressed: onRefresh,
          ),
        ],
      ),
      body: Column(
        children: [
          if (error != null) ErrorBanner(error: error!),
          if (isLoading) LoadingIndicator(),
          Expanded(
            child: RoutineList(
              routines: routines,
              onRoutineTap: onRoutineTap,
              onRefresh: onRefresh,
            ),
          ),
        ],
      ),
    );
  }
}
