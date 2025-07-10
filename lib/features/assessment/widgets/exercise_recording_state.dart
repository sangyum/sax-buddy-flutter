import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../providers/assessment_provider.dart';
import 'exercise_card.dart';
import 'recording_button.dart';
import 'real_time_waveform.dart';

class ExerciseRecordingState extends StatelessWidget {
  final AssessmentProvider provider;
  final AssessmentExercise exercise;

  const ExerciseRecordingState({
    super.key,
    required this.provider,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
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
        // Audio visualization with error handling
        StreamBuilder<Object>(
          stream: provider.audioService.stateStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: const Center(
                  child: Text(
                    'Audio visualization unavailable',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ),
              );
            }
            
            return RealTimeWaveform(
              audioService: provider.audioService,
              isActive: true,
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}