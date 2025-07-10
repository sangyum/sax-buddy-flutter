import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/assessment/screens/assessment_complete_presentation.dart';
import 'package:sax_buddy/features/assessment/models/assessment_session.dart';
import 'package:sax_buddy/features/assessment/models/exercise_result.dart';

final List<Story> assessmentStories = [
  Story(
    name: 'Assessment/Complete Screen - All Completed',
    description: 'Assessment completion screen with all exercises completed',
    builder: (context) {
      final completedExercises = [
        ExerciseResult(
          exerciseId: 1,
          completedAt: DateTime.now().subtract(const Duration(minutes: 5)),
          actualDuration: const Duration(seconds: 45),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 2,
          completedAt: DateTime.now().subtract(const Duration(minutes: 4)),
          actualDuration: const Duration(seconds: 52),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 3,
          completedAt: DateTime.now().subtract(const Duration(minutes: 3)),
          actualDuration: const Duration(seconds: 38),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 4,
          completedAt: DateTime.now().subtract(const Duration(minutes: 2)),
          actualDuration: const Duration(seconds: 41),
          wasCompleted: true,
        ),
      ];
      final session = AssessmentSession(
        id: 'test_session_all_completed',
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        currentExerciseIndex: 4,
        completedExercises: completedExercises,
        state: AssessmentSessionState.completed,
      );
      return AssessmentCompletePresentation(
        session: session,
        totalExcercises: 4,
        onGeneratePracticeRoutine: () => debugPrint('Generate Practice Routine tapped'),
        onReturnToDashboard: () => debugPrint('Return to Dashboard tapped'),
      );
    },
  ),
  Story(
    name: 'Assessment/Complete Screen - Partial',
    description: 'Assessment completion screen with some exercises completed',
    builder: (context) {
      final completedExercises = [
        ExerciseResult(
          exerciseId: 1,
          completedAt: DateTime.now().subtract(const Duration(minutes: 3)),
          actualDuration: const Duration(seconds: 45),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 2,
          completedAt: DateTime.now().subtract(const Duration(minutes: 2)),
          actualDuration: const Duration(seconds: 52),
          wasCompleted: true,
        ),
      ];
      final session = AssessmentSession(
        id: 'test_session_partial',
        startTime: DateTime.now().subtract(const Duration(minutes: 5)),
        currentExerciseIndex: 2,
        completedExercises: completedExercises,
        state: AssessmentSessionState.inProgress,
      );
      return AssessmentCompletePresentation(
        session: session,
        totalExcercises: 4,
        onGeneratePracticeRoutine: () => debugPrint('Generate Practice Routine tapped'),
        onReturnToDashboard: () => debugPrint('Return to Dashboard tapped'),
      );
    },
  ),
  Story(
    name: 'Assessment/Complete Screen - Mobile',
    description: 'Assessment completion screen optimized for mobile',
    builder: (context) {
      final completedExercises = [
        ExerciseResult(
          exerciseId: 1,
          completedAt: DateTime.now().subtract(const Duration(minutes: 2)),
          actualDuration: const Duration(seconds: 45),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 2,
          completedAt: DateTime.now().subtract(const Duration(minutes: 1)),
          actualDuration: const Duration(seconds: 52),
          wasCompleted: true,
        ),
        ExerciseResult(
          exerciseId: 3,
          completedAt: DateTime.now(),
          actualDuration: const Duration(seconds: 38),
          wasCompleted: true,
        ),
      ];
      final session = AssessmentSession(
        id: 'test_session_mobile',
        startTime: DateTime.now().subtract(const Duration(minutes: 7)),
        currentExerciseIndex: 3,
        completedExercises: completedExercises,
        state: AssessmentSessionState.inProgress,
      );
      return SizedBox(
        width: 375,
        height: 812,
        child: AssessmentCompletePresentation(
          session: session,
          totalExcercises: 4,
          onGeneratePracticeRoutine: () => debugPrint('Generate Practice Routine tapped'),
          onReturnToDashboard: () => debugPrint('Return to Dashboard tapped'),
        ),
      );
    },
  ),
];