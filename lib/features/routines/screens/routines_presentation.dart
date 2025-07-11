import 'package:flutter/material.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
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
          if (error != null) _ErrorBanner(error: error!),
          if (isLoading) _LoadingIndicator(),
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

class _ErrorBanner extends StatelessWidget {
  final String error;

  const _ErrorBanner({required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFEBEE),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFD32F2F),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5266)),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Loading routines...',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}