import 'package:flutter/material.dart';
import '../providers/assessment_provider.dart';
import '../widgets/exercise_progress_indicator.dart';
import '../widgets/exercise_content.dart';
import '../widgets/exercise_navigation_buttons.dart';
import '../widgets/recording_indicator.dart';

class ExercisePresentation extends StatelessWidget {
  final AssessmentProvider assessmentProvider;
  final VoidCallback onCompleteAssessment;
  final VoidCallback onExit;

  const ExercisePresentation({
    super.key,
    required this.assessmentProvider,
    required this.onCompleteAssessment,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = assessmentProvider.currentExercise;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Assessment'),
        backgroundColor: const Color(0xFF2E5266),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onExit,
        ),
      ),
      body: exercise == null
          ? const Center(
              child: Text('No exercise available'),
            )
          : Column(
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: ExerciseProgressIndicator(
                    currentExercise: assessmentProvider.currentExerciseNumber,
                    totalExercises: assessmentProvider.totalExercises,
                  ),
                ),
                const SizedBox(height: 24),
                if (assessmentProvider.isRecording)
                  const RecordingIndicator(),
                Expanded(
                  child: ExerciseContent(
                    provider: assessmentProvider,
                    exercise: exercise,
                  ),
                ),
                ExerciseNavigationButtons(
                  provider: assessmentProvider,
                  onCompleteAssessment: onCompleteAssessment,
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }
}
