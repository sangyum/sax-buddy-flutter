import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:sax_buddy/features/assessment/bloc/assessment_complete_cubit.dart';
import 'package:sax_buddy/features/assessment/bloc/assessment_complete_state.dart';
import 'package:sax_buddy/features/assessment/domain/assessment_analyzer.dart';
import 'package:sax_buddy/features/assessment/models/assessment_session.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart';
import 'package:sax_buddy/features/routines/providers/routines_provider.dart';
import 'package:sax_buddy/services/logger_service.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';

import 'assessment_complete_cubit_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AssessmentAnalyzer>(),
  MockSpec<LoggerService>(),
  MockSpec<RoutinesProvider>(),
  MockSpec<AssessmentProvider>(),
  MockSpec<PracticeGenerationService>(),
])
void main() {
  group('AssessmentCompleteCubit', () {
    late AssessmentCompleteCubit cubit;
    late MockLoggerService mockLogger;
    late MockRoutinesProvider mockRoutinesProvider;
    late MockAssessmentProvider mockAssessmentProvider;
    late MockAssessmentAnalyzer mockAssessmentAnalyzer;
    late MockPracticeGenerationService mockPracticeGenerationService;

    setUp(() {
      mockLogger = MockLoggerService();
      mockRoutinesProvider = MockRoutinesProvider();
      mockAssessmentAnalyzer = MockAssessmentAnalyzer();
      mockPracticeGenerationService = MockPracticeGenerationService();
      mockAssessmentProvider = MockAssessmentProvider();

      cubit = AssessmentCompleteCubit(
        mockAssessmentAnalyzer,
        mockPracticeGenerationService,
        mockLogger,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is AssessmentCompleteInitial', () {
      expect(cubit.state, const AssessmentCompleteInitial());
    });

    group('generatePracticeRoutines', () {
      test('emits NoSession when session is null', () async {
        expectLater(
          cubit.stream,
          emitsInOrder([const AssessmentCompleteNoSession()]),
        );

        await cubit.generatePracticeRoutines(
          session: null,
          routinesProvider: mockRoutinesProvider,
        );

        verify(
          mockLogger.warning(
            'No assessment session available for routine generation',
          ),
        );
      });

      test(
        'emits GeneratingRoutines then RoutinesGenerated on success',
        () async {
          final session = AssessmentSession(
            id: 'test-session',
            startTime: DateTime.now(),
            currentExerciseIndex: 0,
            completedExercises: [],
            state: AssessmentSessionState.completed,
          );

          final routines = [
            PracticeRoutine(
              id: 'test-routine-1',
              userId: 'test-user',
              title: 'Test Routine',
              description: 'A test routine',
              targetAreas: ['scales'],
              difficulty: 'beginner',
              estimatedDuration: '10 minutes',
              exercises: [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              isAIGenerated: true,
            ),
          ];

          when(
            mockPracticeGenerationService.generatePracticePlans(
              any,
              onRoutineCompleted: anyNamed('onRoutineCompleted'),
            ),
          ).thenAnswer((_) async => routines);

          expectLater(
            cubit.stream,
            emitsInOrder([
              const AssessmentCompleteGeneratingRoutines(),
              AssessmentCompleteRoutinesGenerated(routines),
              const AssessmentCompleteNavigatingToRoutines(),
            ]),
          );

          await cubit.generatePracticeRoutines(
            session: session,
            routinesProvider: mockRoutinesProvider,
          );

          verify(mockRoutinesProvider.addRoutines(routines));
        },
      );

      test('emits Error when use case throws exception', () async {
        final session = AssessmentSession(
          id: 'test-session',
          startTime: DateTime.now(),
          currentExerciseIndex: 0,
          completedExercises: [],
          state: AssessmentSessionState.completed,
        );

        when(
          mockPracticeGenerationService.generatePracticePlans(
            any,
            onRoutineCompleted: anyNamed('onRoutineCompleted'),
          ),
        ).thenThrow(Exception('Test error'));

        expectLater(
          cubit.stream,
          emitsInOrder([
            const AssessmentCompleteGeneratingRoutines(),
            const AssessmentCompleteError(
              'Error generating routines: Exception: Test error',
            ),
          ]),
        );

        await cubit.generatePracticeRoutines(
          session: session,
          routinesProvider: mockRoutinesProvider,
        );

        verify(
          mockLogger.error(
            'Error in practice routine generation: Exception: Test error',
          ),
        );
      });
    });

    group('returnToDashboard', () {
      test('calls resetAssessment and emits ReturningToDashboard', () {
        cubit.returnToDashboard(mockAssessmentProvider);

        expect(cubit.state, const AssessmentCompleteReturningToDashboard());
        verify(mockAssessmentProvider.resetAssessment());
      });
    });

    test('resetState emits Initial state', () {
      cubit.resetState();
      expect(cubit.state, const AssessmentCompleteInitial());
    });
  });
}
