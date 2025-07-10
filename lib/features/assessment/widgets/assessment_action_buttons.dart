import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';

class AssessmentActionButtons extends StatelessWidget {
  const AssessmentActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _generatePracticeRoutine(context),
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
            onPressed: () => _returnToDashboard(context),
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

  void _generatePracticeRoutine(BuildContext context) {
    // For now, just return to dashboard
    // In the future, this will navigate to practice routine generation
    _returnToDashboard(context);
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Practice routine generation coming soon!'),
        backgroundColor: Color(0xFF4CAF50),
      ),
    );
  }

  void _returnToDashboard(BuildContext context) {
    // Reset the assessment state
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    assessmentProvider.resetAssessment();
    
    // Navigate back to dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}