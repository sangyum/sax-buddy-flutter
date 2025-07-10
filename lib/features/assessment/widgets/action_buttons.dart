import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.onGeneratePracticeRoutine,
    required this.onReturnToDashboard,
  });

  final VoidCallback onGeneratePracticeRoutine;
  final VoidCallback onReturnToDashboard;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onGeneratePracticeRoutine,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5266),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Generate Practice Routine',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
    
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onReturnToDashboard,
            child: const Text(
              'Return to Dashboard',
              style: TextStyle(
                color: Color(0xFF2E5266),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
