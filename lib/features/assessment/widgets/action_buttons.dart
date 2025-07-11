import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({
    super.key,
    required this.onGeneratePracticeRoutine,
    required this.onReturnToDashboard,
    this.isGeneratingRoutines = false,
  });

  final VoidCallback onGeneratePracticeRoutine;
  final VoidCallback onReturnToDashboard;
  final bool isGeneratingRoutines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isGeneratingRoutines ? null : onGeneratePracticeRoutine,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5266),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isGeneratingRoutines
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
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
