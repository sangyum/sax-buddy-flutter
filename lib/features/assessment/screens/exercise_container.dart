import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';
import 'exercise_presentation.dart';

class ExerciseContainer extends StatelessWidget {
  const ExerciseContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        void completeAssessment() {
          assessmentProvider.completeAssessment();
          Navigator.of(context).pushReplacementNamed('/assessment/complete');
        }

        void showExitDialog() {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Exit Assessment?'),
                content: const Text(
                    'Are you sure you want to exit? Your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Close dialog
                      assessmentProvider.cancelAssessment();
                      Navigator.of(context).pop(); // Exit screen
                    },
                    child: const Text(
                      'Exit',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              );
            },
          );
        }

        return ExercisePresentation(
          assessmentProvider: assessmentProvider,
          onCompleteAssessment: completeAssessment,
          onExit: showExitDialog,
        );
      },
    );
  }
}
