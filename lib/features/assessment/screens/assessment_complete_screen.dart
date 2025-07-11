import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/assessment_provider.dart';
import '../../routines/providers/routines_provider.dart';
import '../bloc/assessment_complete_cubit.dart';
import '../bloc/assessment_complete_state.dart';
import '../../../injection.dart';
import 'assessment_complete_presentation.dart';

class AssessmentCompleteScreen extends StatelessWidget {
  const AssessmentCompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssessmentCompleteCubit>(
      create: (context) => getIt<AssessmentCompleteCubit>(),
      child: Consumer2<AssessmentProvider, RoutinesProvider>(
        builder: (context, assessmentProvider, routinesProvider, child) {
          final session = assessmentProvider.currentSession;

          return BlocListener<AssessmentCompleteCubit, AssessmentCompleteState>(
            listener: (context, state) {
              _handleStateChanges(context, state);
            },
            child: BlocBuilder<AssessmentCompleteCubit, AssessmentCompleteState>(
              builder: (context, state) {
                return AssessmentCompletePresentation(
                  session: session,
                  totalExcercises: assessmentProvider.totalExercises,
                  isGeneratingRoutines: state is AssessmentCompleteGeneratingRoutines,
                  onGeneratePracticeRoutine: () => context
                      .read<AssessmentCompleteCubit>()
                      .generatePracticeRoutines(
                        session: session,
                        routinesProvider: routinesProvider,
                      ),
                  onReturnToDashboard: () => context
                      .read<AssessmentCompleteCubit>()
                      .returnToDashboard(assessmentProvider),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AssessmentCompleteState state) {
    switch (state) {
      case AssessmentCompleteGeneratingRoutines():
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );
        break;
      
      case AssessmentCompleteRoutinesGenerated():
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close loading dialog
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Practice routines generated successfully!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        break;
      
      case AssessmentCompleteNavigatingToRoutines():
        Navigator.of(context).pushNamed('/routines');
        context.read<AssessmentCompleteCubit>().resetState();
        break;
      
      case AssessmentCompleteNoSession():
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close loading dialog if open
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to generate routines. Please try again.'),
            backgroundColor: Color(0xFFf44336),
          ),
        );
        break;
      
      case AssessmentCompleteError():
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop(); // Close loading dialog if open
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: const Color(0xFFf44336),
          ),
        );
        break;
      
      case AssessmentCompleteReturningToDashboard():
        Navigator.of(context).popUntil((route) => route.isFirst);
        break;
      
      default:
        break;
    }
  }
}
