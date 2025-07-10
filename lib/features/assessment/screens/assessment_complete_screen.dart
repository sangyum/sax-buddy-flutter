import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';

class AssessmentCompleteScreen extends StatelessWidget {
  const AssessmentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),
              // Success animation/icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              const Text(
                'Assessment Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5266),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              const Text(
                'Great job! We\'ve analyzed your performance and are ready to create your personalized practice routine.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Results summary
              Consumer<AssessmentProvider>(
                builder: (context, assessmentProvider, child) {
                  final session = assessmentProvider.currentSession;
                  final completedCount = session?.completedExercises.length ?? 0;
                  
                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Exercises Completed',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$completedCount / 4',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E5266),
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // Exercise list
                        ...session?.completedExercises.map((result) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: Color(0xFF4CAF50),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Exercise ${result.exerciseId}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${result.actualDuration.inSeconds}s',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList() ?? [],
                      ],
                    ),
                  );
                },
              ),
              
              const Spacer(),
              
              // Action buttons
              Column(
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
              ),
            ],
          ),
        ),
      ),
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