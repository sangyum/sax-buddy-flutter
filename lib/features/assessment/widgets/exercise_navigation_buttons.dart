import 'package:flutter/material.dart';
import '../models/exercise_state.dart';

class ExerciseNavigationButtons extends StatelessWidget {
  final ExerciseState exerciseState;
  final bool canGoToPreviousExercise;
  final bool canGoToNextExercise;
  final VoidCallback? onPreviousExercise;
  final VoidCallback? onNextExercise;
  final VoidCallback onCompleteAssessment;

  const ExerciseNavigationButtons({
    super.key,
    required this.exerciseState,
    required this.canGoToPreviousExercise,
    required this.canGoToNextExercise,
    this.onPreviousExercise,
    this.onNextExercise,
    required this.onCompleteAssessment,
  });

  @override
  Widget build(BuildContext context) {
    if (exerciseState != ExerciseState.completed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          if (canGoToPreviousExercise)
            Expanded(
              child: OutlinedButton(
                onPressed: onPreviousExercise,
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
              onPressed: canGoToNextExercise
                  ? onNextExercise
                  : onCompleteAssessment,
              style: ElevatedButton.styleFrom(
                backgroundColor: canGoToNextExercise
                    ? const Color(0xFF2E5266)
                    : const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                canGoToNextExercise ? 'Next Exercise' : 'Complete Assessment',
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