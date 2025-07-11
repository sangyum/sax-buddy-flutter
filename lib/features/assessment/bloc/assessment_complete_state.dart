import 'package:equatable/equatable.dart';
import '../../practice/models/practice_routine.dart';

abstract class AssessmentCompleteState extends Equatable {
  const AssessmentCompleteState();

  @override
  List<Object?> get props => [];
}

class AssessmentCompleteInitial extends AssessmentCompleteState {
  const AssessmentCompleteInitial();
}

class AssessmentCompleteGeneratingRoutines extends AssessmentCompleteState {
  const AssessmentCompleteGeneratingRoutines();
}

class AssessmentCompleteRoutinesGenerated extends AssessmentCompleteState {
  final List<PracticeRoutine> routines;

  const AssessmentCompleteRoutinesGenerated(this.routines);

  @override
  List<Object?> get props => [routines];
}

class AssessmentCompleteError extends AssessmentCompleteState {
  final String message;

  const AssessmentCompleteError(this.message);

  @override
  List<Object?> get props => [message];
}

class AssessmentCompleteNoSession extends AssessmentCompleteState {
  const AssessmentCompleteNoSession();
}

class AssessmentCompleteNavigatingToRoutines extends AssessmentCompleteState {
  const AssessmentCompleteNavigatingToRoutines();
}

class AssessmentCompleteReturningToDashboard extends AssessmentCompleteState {
  const AssessmentCompleteReturningToDashboard();
}
