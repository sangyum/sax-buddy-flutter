import 'package:flutter/material.dart';
import 'package:sax_buddy/features/assessment/models/assessment_session.dart';
import 'package:sax_buddy/features/assessment/widgets/action_buttons.dart';
import 'package:sax_buddy/features/assessment/widgets/results_summary.dart';
import 'package:sax_buddy/features/assessment/widgets/sub_title.dart';
import 'package:sax_buddy/features/assessment/widgets/success_animiation.dart';
import 'package:sax_buddy/features/assessment/widgets/title_widget.dart';

class AssessmentCompletePresentation extends StatelessWidget {
  final AssessmentSession? session;
  final int totalExcercises;
  final bool isGeneratingRoutines;
  final VoidCallback onGeneratePracticeRoutine;
  final VoidCallback onReturnToDashboard;

  const AssessmentCompletePresentation({
    super.key,
    required this.session,
    required this.totalExcercises,
    this.isGeneratingRoutines = false,
    required this.onGeneratePracticeRoutine,
    required this.onReturnToDashboard,
  });

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
              SuccessAnimiation(),
              const SizedBox(height: 32),

              TitleWidget(),
              const SizedBox(height: 16),

              SubTitle(),
              const SizedBox(height: 32),

              ResultsSummary(
                completedExercisesCount: session!.completedExercises.length,
                totalExercises: totalExcercises,
                completedExercises: session!.completedExercises
              ),

              const Spacer(),

              ActionButtons(
                onGeneratePracticeRoutine: onGeneratePracticeRoutine, 
                onReturnToDashboard: onReturnToDashboard,
                isGeneratingRoutines: isGeneratingRoutines,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
