import 'package:flutter/material.dart';
import '../providers/assessment_provider.dart';

class ExerciseNavigationButtons extends StatelessWidget {
  final AssessmentProvider provider;
  final VoidCallback onCompleteAssessment;

  const ExerciseNavigationButtons({
    super.key,
    required this.provider,
    required this.onCompleteAssessment,
  });

  @override
  Widget build(BuildContext context) {
    if (provider.exerciseState != ExerciseState.completed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          if (provider.canGoToPreviousExercise)
            Expanded(
              child: OutlinedButton(
                onPressed: provider.goToPreviousExercise,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF2E5266)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Previous',
                  style: TextStyle(
                    color: Color(0xFF2E5266),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            const Expanded(child: SizedBox()),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: ElevatedButton(
              onPressed: provider.canGoToNextExercise
                  ? provider.goToNextExercise
                  : onCompleteAssessment,
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.canGoToNextExercise
                    ? const Color(0xFF2E5266)
                    : const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                provider.canGoToNextExercise ? 'Next Exercise' : 'Complete Assessment',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}