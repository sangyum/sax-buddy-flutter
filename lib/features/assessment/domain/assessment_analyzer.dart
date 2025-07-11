import 'package:injectable/injectable.dart';
import '../models/assessment_session.dart';
import '../models/assessment_result.dart';
import '../models/assessment_dataset.dart';

@injectable
class AssessmentAnalyzer {
  Future<AssessmentDataset> createAssessmentDataset(AssessmentSession session) async {
    final assessmentResult = AssessmentResult(
      sessionId: session.id,
      completedAt: DateTime.now(),
      skillLevel: inferSkillLevel(session),
      exerciseResults: session.completedExercises,
      strengths: identifyStrengths(session),
      weaknesses: identifyWeaknesses(session),
      notes: 'Assessment completed through app',
    );
    
    return AssessmentDataset.fromAssessmentData(assessmentResult, []);
  }
  
  SkillLevel inferSkillLevel(AssessmentSession session) {
    final completionRate = session.completedExercises.length / 4.0; // 4 total exercises
    
    if (completionRate >= 0.8) return SkillLevel.intermediate;
    if (completionRate >= 0.6) return SkillLevel.beginner;
    return SkillLevel.beginner;
  }
  
  List<String> identifyStrengths(AssessmentSession session) {
    final strengths = <String>[];
    
    if (session.completedExercises.length >= 3) {
      strengths.add('exercise completion');
    }
    
    if (session.completedExercises.length >= 2) {
      strengths.add('assessment participation');
    }
    
    final completedCount = session.completedExercises.where((e) => e.wasCompleted).length;
    if (completedCount >= 2) {
      strengths.add('persistence');
    }
    
    return strengths;
  }
  
  List<String> identifyWeaknesses(AssessmentSession session) {
    final weaknesses = <String>[];
    
    final incompleteCount = session.completedExercises.where((e) => !e.wasCompleted).length;
    if (incompleteCount > 0) {
      weaknesses.add('exercise completion');
    }
    
    weaknesses.addAll(['timing consistency', 'pitch accuracy']);
    
    return weaknesses;
  }
}