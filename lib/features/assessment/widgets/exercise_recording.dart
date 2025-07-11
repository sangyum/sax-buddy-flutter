import 'package:flutter/material.dart';
import '../models/assessment_exercise.dart';
import '../../../services/audio_recording_service.dart';
import 'exercise_card.dart';
import 'recording_button.dart';
import 'real_time_waveform.dart';

class ExerciseRecording extends StatelessWidget {
  final AssessmentExercise exercise;
  final int exerciseNumber;
  final VoidCallback onStopRecording;
  final AudioRecordingService audioService;

  const ExerciseRecording({
    super.key,
    required this.exercise,
    required this.exerciseNumber,
    required this.onStopRecording,
    required this.audioService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        ExerciseCard(
          exercise: exercise,
          exerciseNumber: exerciseNumber,
        ),
        const Spacer(),
        RecordingButton(isRecording: true, onPressed: onStopRecording),
        const SizedBox(height: 16),
        const Text(
          'Recording... Tap to stop',
          style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 24),
        // Audio visualization with error handling
        StreamBuilder<Object>(
          stream: audioService.stateStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                child: const Center(
                  child: Text(
                    'Audio visualization unavailable',
                    style: TextStyle(fontSize: 12, color: Color(0xFF757575)),
                  ),
                ),
              );
            }

            return RealTimeWaveform(
              audioService: audioService,
              isActive: true,
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
