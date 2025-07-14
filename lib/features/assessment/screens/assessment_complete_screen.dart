import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../providers/assessment_provider.dart';
import '../../routines/providers/routines_provider.dart';
import '../bloc/assessment_complete_cubit.dart';
import '../bloc/assessment_complete_state.dart';
import '../../../injection.dart';
import 'assessment_complete_presentation.dart';

class AssessmentCompleteScreen extends StatefulWidget {
  const AssessmentCompleteScreen({super.key});

  @override
  State<AssessmentCompleteScreen> createState() => _AssessmentCompleteScreenState();
}

class _AssessmentCompleteScreenState extends State<AssessmentCompleteScreen> {
  bool _isDialogShowing = false;

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

  Widget _buildProgressDialog(BuildContext context, AssessmentCompleteGeneratingRoutines state) {
    return AlertDialog(
      title: const Text('Generating Practice Routines'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          if (state.completedRoutines.isEmpty)
            const Text('Analyzing your assessment and creating personalized routines...')
          else
            Column(
              children: [
                Text('${state.completedRoutines.length} routines completed'),
                const SizedBox(height: 8),
                ...state.completedRoutines.map((routine) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            routine.title,
                            style: const TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _handleStateChanges(BuildContext context, AssessmentCompleteState state) {
    switch (state) {
      case AssessmentCompleteGeneratingRoutines():
        if (!_isDialogShowing) {
          _isDialogShowing = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => _buildProgressDialog(dialogContext, state),
          );
        } else {
          // Update existing dialog - we'll need to rebuild it
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (dialogContext) => _buildProgressDialog(dialogContext, state),
          );
        }
        break;
      
      case AssessmentCompleteRoutinesGenerated():
        if (Navigator.of(context).canPop()) {
          _isDialogShowing = false;
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
          _isDialogShowing = false;
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
          _isDialogShowing = false;
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
