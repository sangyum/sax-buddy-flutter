import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sax_buddy/features/assessment/domain/assessment_analyzer.dart';
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart';
import '../models/assessment_session.dart';
import '../providers/assessment_provider.dart';
import '../../routines/providers/routines_provider.dart';
import '../../../services/logger_service.dart';
import 'assessment_complete_state.dart';

@injectable
class AssessmentCompleteCubit extends Cubit<AssessmentCompleteState> {
  final AssessmentAnalyzer _assessmentAnalyzer;
  final PracticeGenerationService _practiceGenerationService;
  final LoggerService _logger;

  AssessmentCompleteCubit(
    this._assessmentAnalyzer,
    this._practiceGenerationService,
    this._logger,
  ) : super(const AssessmentCompleteInitial());

  Future<void> generatePracticeRoutines({
    required AssessmentSession? session,
    required RoutinesProvider routinesProvider,
  }) async {
    if (session == null) {
      _logger.warning('No assessment session available for routine generation');
      emit(const AssessmentCompleteNoSession());
      return;
    }

    try {
      emit(const AssessmentCompleteGeneratingRoutines());

      final dataset = await _assessmentAnalyzer.createAssessmentDataset(session);
      final routines = await _practiceGenerationService.generatePracticePlans(dataset);

      routinesProvider.addRoutines(routines);

      emit(AssessmentCompleteRoutinesGenerated(routines));
      emit(const AssessmentCompleteNavigatingToRoutines());
    } catch (e) {
      _logger.error('Error in practice routine generation: $e');
      emit(AssessmentCompleteError('Error generating routines: $e'));
    }
  }

  void returnToDashboard(AssessmentProvider assessmentProvider) {
    assessmentProvider.resetAssessment();
    emit(const AssessmentCompleteReturningToDashboard());
  }

  void resetState() {
    emit(const AssessmentCompleteInitial());
  }
}