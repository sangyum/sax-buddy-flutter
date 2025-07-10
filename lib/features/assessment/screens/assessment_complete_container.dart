import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';
import 'assessment_complete_presentation.dart';

class AssessmentCompleteContainer extends StatelessWidget {
  const AssessmentCompleteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        final session = assessmentProvider.currentSession;
        
        return AssessmentCompletePresentation(
          session: session,
          totalExcercises: assessmentProvider.totalExercises,
          onGeneratePracticeRoutine: () => _generatePracticeRoutine(context, assessmentProvider),
          onReturnToDashboard: () => _returnToDashboard(context, assessmentProvider),
        );
      },
    );
  }

  void _generatePracticeRoutine(BuildContext context, AssessmentProvider provider) {
    // For now, just return to dashboard
    // In the future, this will navigate to practice routine generation
    _returnToDashboard(context, provider);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Practice routine generation coming soon!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _returnToDashboard(BuildContext context, AssessmentProvider provider) {
    // Reset the assessment state
    provider.resetAssessment();
    
    // Navigate back to dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}