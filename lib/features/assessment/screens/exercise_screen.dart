import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';
import '../widgets/exercise_progress_indicator.dart';
import '../widgets/countdown_widget.dart';
import '../widgets/recording_button.dart';
import '../widgets/exercise_card.dart';
import '../widgets/waveform_placeholder.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Assessment'),
        backgroundColor: const Color(0xFF2E5266),
        foregroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _showExitDialog(context),
        ),
      ),
      body: Consumer<AssessmentProvider>(
        builder: (context, assessmentProvider, child) {
          final exercise = assessmentProvider.currentExercise;
          
          if (exercise == null) {
            return const Center(
              child: Text('No exercise available'),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),
              // Progress indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ExerciseProgressIndicator(
                  currentExercise: assessmentProvider.currentExerciseNumber,
                  totalExercises: assessmentProvider.totalExercises,
                ),
              ),
              const SizedBox(height: 24),
              
              // Recording indicator
              if (assessmentProvider.isRecording)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53E3E),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'REC',
                        style: TextStyle(
                          color: Color(0xFFE53E3E),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              
              Expanded(
                child: _buildExerciseContent(context, assessmentProvider, exercise),
              ),
              
              // Navigation buttons
              _buildNavigationButtons(context, assessmentProvider),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExerciseContent(
    BuildContext context,
    AssessmentProvider provider,
    exercise,
  ) {
    switch (provider.exerciseState) {
      case ExerciseState.setup:
        return _buildSetupState(context, provider, exercise);
      case ExerciseState.countdown:
        return _buildCountdownState(context, provider);
      case ExerciseState.recording:
        return _buildRecordingState(context, provider, exercise);
      case ExerciseState.completed:
        return _buildCompletedState(context, provider, exercise);
    }
  }

  Widget _buildSetupState(
    BuildContext context,
    AssessmentProvider provider,
    exercise,
  ) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                ExerciseCard(
                  exercise: exercise,
                  exerciseNumber: provider.currentExerciseNumber,
                ),
                const SizedBox(height: 48),
                RecordingButton(
                  isRecording: false,
                  onPressed: provider.startCountdown,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tap to start recording',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountdownState(
    BuildContext context,
    AssessmentProvider provider,
  ) {
    return CountdownWidget(
      countdownValue: provider.countdownValue,
      onCancel: provider.cancelCountdown,
    );
  }

  Widget _buildRecordingState(
    BuildContext context,
    AssessmentProvider provider,
    exercise,
  ) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ExerciseCard(
          exercise: exercise,
          exerciseNumber: provider.currentExerciseNumber,
        ),
        const Spacer(),
        RecordingButton(
          isRecording: true,
          onPressed: provider.stopRecording,
        ),
        const SizedBox(height: 16),
        const Text(
          'Recording... Tap to stop',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 24),
        const WaveformPlaceholder(isActive: true),
        const Spacer(),
      ],
    );
  }

  Widget _buildCompletedState(
    BuildContext context,
    AssessmentProvider provider,
    exercise,
  ) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ExerciseCard(
          exercise: exercise,
          exerciseNumber: provider.currentExerciseNumber,
        ),
        const Spacer(),
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(
            Icons.check,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Exercise completed!',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildNavigationButtons(
    BuildContext context,
    AssessmentProvider provider,
  ) {
    if (provider.exerciseState != ExerciseState.completed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          if (provider.canGoToPreviousExercise)
            Expanded(
              child: OutlinedButton(
                onPressed: provider.goToPreviousExercise,
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
              onPressed: provider.canGoToNextExercise
                  ? provider.goToNextExercise
                  : () => _completeAssessment(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.canGoToNextExercise
                    ? const Color(0xFF2E5266)
                    : const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                provider.canGoToNextExercise ? 'Next Exercise' : 'Complete Assessment',
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

  void _completeAssessment(BuildContext context, AssessmentProvider provider) {
    provider.completeAssessment();
    // Navigate to completion screen (will be implemented next)
    Navigator.of(context).pushReplacementNamed('/assessment/complete');
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit Assessment?'),
          content: const Text(
            'Are you sure you want to exit? Your progress will be lost.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final provider = Provider.of<AssessmentProvider>(context, listen: false);
                provider.cancelAssessment();
                Navigator.of(context).pop();
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
}