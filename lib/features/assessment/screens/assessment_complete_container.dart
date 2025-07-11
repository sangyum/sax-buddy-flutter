import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';
import '../../routines/providers/routines_provider.dart';
import '../../practice/models/practice_routine.dart';
import '../models/assessment_session.dart';
import '../models/assessment_dataset.dart';
import '../models/assessment_result.dart';
import '../../practice/services/practice_generation_service.dart';
import '../../../services/service_locator.dart';
import '../../../services/logger_service.dart';
import 'assessment_complete_presentation.dart';

class AssessmentCompleteContainer extends StatelessWidget {
  const AssessmentCompleteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AssessmentProvider, RoutinesProvider>(
      builder: (context, assessmentProvider, routinesProvider, child) {
        final session = assessmentProvider.currentSession;

        return AssessmentCompletePresentation(
          session: session,
          totalExcercises: assessmentProvider.totalExercises,
          onGeneratePracticeRoutine: () => _generatePracticeRoutine(
            context,
            assessmentProvider,
            routinesProvider,
          ),
          onReturnToDashboard: () =>
              _returnToDashboard(context, assessmentProvider),
        );
      },
    );
  }

  void _generatePracticeRoutine(
    BuildContext context,
    AssessmentProvider assessmentProvider,
    RoutinesProvider routinesProvider,
  ) async {
    final logger = LoggerService.instance;
    
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Generate practice routines based on assessment
      final session = assessmentProvider.currentSession;
      if (session != null) {
        logger.info('Generating AI-powered practice routines for session: ${session.id}');
        
        List<PracticeRoutine> routines;
        
        try {
          // Try to use AI generation first
          if (ServiceLocator.instance.isInitialized && 
              ServiceLocator.instance.isRegistered<PracticeGenerationService>()) {
            
            final practiceService = ServiceLocator.instance.get<PracticeGenerationService>();
            
            // Convert assessment session to dataset
            final dataset = await _createAssessmentDataset(session);
            
            // Generate routines using AI
            routines = await practiceService.generatePracticePlans(dataset);
            logger.info('Successfully generated ${routines.length} AI-powered routines');
            
          } else {
            logger.warning('AI services not available, falling back to sample routines');
            routines = await _generateSampleRoutines(session);
          }
        } catch (e) {
          logger.error('AI generation failed, falling back to sample routines: $e');
          routines = await _generateSampleRoutines(session);
        }

        // Add routines to the provider
        routinesProvider.addRoutines(routines);

        if (context.mounted) {
          // Hide loading indicator
          Navigator.of(context).pop();

          // Navigate to routines screen
          Navigator.of(context).pushNamed('/routines');

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Practice routines generated successfully!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }
      } else {
        logger.warning('No assessment session available for routine generation');
        
        if (context.mounted) {
          // Hide loading indicator
          Navigator.of(context).pop();

          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Unable to generate routines. Please try again.'),
              backgroundColor: Color(0xFFf44336),
            ),
          );
        }
      }
    } catch (e) {
      logger.error('Error in practice routine generation: $e');
      
      if (context.mounted) {
        // Hide loading indicator
        Navigator.of(context).pop();

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating routines: $e'),
            backgroundColor: const Color(0xFFf44336),
          ),
        );
      }
    }
  }

  /// Create assessment dataset from session for AI processing
  Future<AssessmentDataset> _createAssessmentDataset(AssessmentSession session) async {
    final logger = LoggerService.instance;
    
    try {
      // Use the completed exercises from the session
      final exerciseResults = session.completedExercises;
      
      // Create assessment result
      final assessmentResult = AssessmentResult(
        sessionId: session.id,
        completedAt: DateTime.now(),
        skillLevel: _inferSkillLevel(session),
        exerciseResults: exerciseResults,
        strengths: _identifyStrengths(session),
        weaknesses: _identifyWeaknesses(session),
        notes: 'Assessment completed through app',
      );
      
      // Create dataset from assessment result
      final dataset = AssessmentDataset.fromAssessmentData(assessmentResult, []);
      
      logger.debug('Created assessment dataset for session: ${session.id}');
      return dataset;
      
    } catch (e) {
      logger.error('Failed to create assessment dataset: $e');
      rethrow;
    }
  }
  
  /// Infer skill level from session performance
  SkillLevel _inferSkillLevel(AssessmentSession session) {
    // Simple inference based on completion rate
    final completionRate = session.completedExercises.length / 4.0; // 4 total exercises
    
    if (completionRate >= 0.8) return SkillLevel.intermediate;
    if (completionRate >= 0.6) return SkillLevel.beginner;
    return SkillLevel.beginner;
  }
  
  /// Identify strengths from session
  List<String> _identifyStrengths(AssessmentSession session) {
    final strengths = <String>[];
    
    // Basic strength identification
    if (session.completedExercises.length >= 3) {
      strengths.add('exercise completion');
    }
    
    if (session.completedExercises.length >= 2) {
      strengths.add('assessment participation');
    }
    
    // Check for completed exercises
    final completedCount = session.completedExercises.where((e) => e.wasCompleted).length;
    if (completedCount >= 2) {
      strengths.add('persistence');
    }
    
    return strengths;
  }
  
  /// Identify weaknesses from session
  List<String> _identifyWeaknesses(AssessmentSession session) {
    final weaknesses = <String>[];
    
    // Basic weakness identification
    final incompleteCount = session.completedExercises.where((e) => !e.wasCompleted).length;
    if (incompleteCount > 0) {
      weaknesses.add('exercise completion');
    }
    
    // Add common areas for improvement based on typical saxophone challenges
    weaknesses.addAll(['timing consistency', 'pitch accuracy']);
    
    return weaknesses;
  }
  

  Future<List<PracticeRoutine>> _generateSampleRoutines(
    AssessmentSession session,
  ) async {
    // Simulate routine generation time
    await Future.delayed(const Duration(seconds: 2));

    // Generate sample routines based on assessment
    return [
      PracticeRoutine(
        title: 'Scale Fundamentals',
        description:
            'Practice basic scale patterns to improve finger coordination and pitch accuracy',
        targetAreas: ['scales', 'pitch accuracy', 'finger coordination'],
        difficulty: 'intermediate',
        estimatedDuration: '20 minutes',
        exercises: [
          PracticeExercise(
            name: 'C Major Scale',
            description: 'Practice C major scale at slow tempo',
            estimatedDuration: '10 minutes',
            tempo: '80 BPM',
            keySignature: 'C Major',
            notes: 'Focus on clean fingering and intonation',
          ),
          PracticeExercise(
            name: 'Chromatic Scale',
            description: 'Practice chromatic scale for finger dexterity',
            estimatedDuration: '10 minutes',
            tempo: '60 BPM',
            notes: 'Keep fingers close to keys',
          ),
        ],
      ),
      PracticeRoutine(
        title: 'Timing Development',
        description:
            'Improve rhythm and timing accuracy with metronome practice',
        targetAreas: ['timing', 'rhythm', 'metronome'],
        difficulty: 'intermediate',
        estimatedDuration: '15 minutes',
        exercises: [
          PracticeExercise(
            name: 'Metronome Practice',
            description: 'Practice long tones with metronome',
            estimatedDuration: '8 minutes',
            tempo: '60 BPM',
            notes: 'Focus on starting and stopping exactly with the beat',
          ),
          PracticeExercise(
            name: 'Rhythmic Patterns',
            description: 'Practice various rhythmic patterns',
            estimatedDuration: '7 minutes',
            tempo: '100 BPM',
            notes: 'Use different note values and patterns',
          ),
        ],
      ),
      PracticeRoutine(
        title: 'Breath Control',
        description: 'Exercises to improve breath control and support',
        targetAreas: ['breath control', 'tone quality', 'endurance'],
        difficulty: 'beginner',
        estimatedDuration: '12 minutes',
        exercises: [
          PracticeExercise(
            name: 'Long Tones',
            description: 'Hold sustained notes for breath development',
            estimatedDuration: '8 minutes',
            notes: 'Focus on steady air flow and tone quality',
          ),
          PracticeExercise(
            name: 'Breathing Exercises',
            description: 'Practice proper breathing technique',
            estimatedDuration: '4 minutes',
            notes: 'Use diaphragmatic breathing',
          ),
        ],
      ),
    ];
  }

  void _returnToDashboard(BuildContext context, AssessmentProvider provider) {
    // Reset the assessment state
    provider.resetAssessment();

    // Navigate back to dashboard
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
