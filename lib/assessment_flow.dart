import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';
import 'package:sax_buddy/features/assessment/screens/exercise_screen.dart';

class AssessmentFlow extends StatelessWidget {
  const AssessmentFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        // Start the assessment when the flow is first accessed
        if (assessmentProvider.currentSession == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            assessmentProvider.startAssessment();
          });
        }
        
        return const ExerciseScreen();
      },
    );
  }
}
