// Mocks generated by Mockito 5.4.6 from annotations
// in sax_buddy/test/features/practice/services/practice_generation_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;
import 'package:sax_buddy/features/assessment/models/assessment_dataset.dart'
    as _i2;
import 'package:sax_buddy/features/assessment/models/assessment_result.dart'
    as _i7;
import 'package:sax_buddy/features/assessment/services/audio_analysis_dataset_service.dart'
    as _i6;
import 'package:sax_buddy/services/audio_analysis_service.dart' as _i8;
import 'package:sax_buddy/services/logger_service.dart' as _i9;
import 'package:sax_buddy/services/openai_service.dart' as _i3;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAssessmentDataset_0 extends _i1.SmartFake
    implements _i2.AssessmentDataset {
  _FakeAssessmentDataset_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [OpenAIService].
///
/// See the documentation for Mockito's code generation for more information.
class MockOpenAIService extends _i1.Mock implements _i3.OpenAIService {
  MockOpenAIService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isInitialized =>
      (super.noSuchMethod(Invocation.getter(#isInitialized), returnValue: false)
          as bool);

  @override
  void initialize(String? apiKey) => super.noSuchMethod(
    Invocation.method(#initialize, [apiKey]),
    returnValueForMissingStub: null,
  );

  @override
  _i4.Future<String> generateResponse(String? prompt) =>
      (super.noSuchMethod(
            Invocation.method(#generateResponse, [prompt]),
            returnValue: _i4.Future<String>.value(
              _i5.dummyValue<String>(
                this,
                Invocation.method(#generateResponse, [prompt]),
              ),
            ),
          )
          as _i4.Future<String>);

  @override
  _i4.Future<List<String>> generateBatchResponses(List<String>? prompts) =>
      (super.noSuchMethod(
            Invocation.method(#generateBatchResponses, [prompts]),
            returnValue: _i4.Future<List<String>>.value(<String>[]),
          )
          as _i4.Future<List<String>>);

  @override
  Map<String, dynamic> getStatus() =>
      (super.noSuchMethod(
            Invocation.method(#getStatus, []),
            returnValue: <String, dynamic>{},
          )
          as Map<String, dynamic>);
}

/// A class which mocks [AudioAnalysisDatasetService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAudioAnalysisDatasetService extends _i1.Mock
    implements _i6.AudioAnalysisDatasetService {
  MockAudioAnalysisDatasetService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.AssessmentDataset> createDataset(
    _i7.AssessmentResult? assessmentResult,
    List<_i8.AudioAnalysisResult>? audioAnalysisResults,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#createDataset, [
              assessmentResult,
              audioAnalysisResults,
            ]),
            returnValue: _i4.Future<_i2.AssessmentDataset>.value(
              _FakeAssessmentDataset_0(
                this,
                Invocation.method(#createDataset, [
                  assessmentResult,
                  audioAnalysisResults,
                ]),
              ),
            ),
          )
          as _i4.Future<_i2.AssessmentDataset>);

  @override
  Map<String, dynamic> prepareForLLM(_i2.AssessmentDataset? dataset) =>
      (super.noSuchMethod(
            Invocation.method(#prepareForLLM, [dataset]),
            returnValue: <String, dynamic>{},
          )
          as Map<String, dynamic>);

  @override
  String generateLLMPromptContext(_i2.AssessmentDataset? dataset) =>
      (super.noSuchMethod(
            Invocation.method(#generateLLMPromptContext, [dataset]),
            returnValue: _i5.dummyValue<String>(
              this,
              Invocation.method(#generateLLMPromptContext, [dataset]),
            ),
          )
          as String);

  @override
  bool validateDataset(_i2.AssessmentDataset? dataset) =>
      (super.noSuchMethod(
            Invocation.method(#validateDataset, [dataset]),
            returnValue: false,
          )
          as bool);
}

/// A class which mocks [LoggerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerService extends _i1.Mock implements _i9.LoggerService {
  MockLoggerService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.LogLevel get currentLevel =>
      (super.noSuchMethod(
            Invocation.getter(#currentLevel),
            returnValue: _i9.LogLevel.trace,
          )
          as _i9.LogLevel);

  @override
  void trace(
    String? message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) => super.noSuchMethod(
    Invocation.method(
      #trace,
      [message],
      {#extra: extra, #error: error, #stackTrace: stackTrace},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void debug(
    String? message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) => super.noSuchMethod(
    Invocation.method(
      #debug,
      [message],
      {#extra: extra, #error: error, #stackTrace: stackTrace},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void info(
    String? message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) => super.noSuchMethod(
    Invocation.method(
      #info,
      [message],
      {#extra: extra, #error: error, #stackTrace: stackTrace},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void warning(
    String? message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) => super.noSuchMethod(
    Invocation.method(
      #warning,
      [message],
      {#extra: extra, #error: error, #stackTrace: stackTrace},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void error(
    String? message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) => super.noSuchMethod(
    Invocation.method(
      #error,
      [message],
      {#extra: extra, #error: error, #stackTrace: stackTrace},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void logAuthEvent(
    String? event, {
    String? userId,
    Map<String, dynamic>? extra,
  }) => super.noSuchMethod(
    Invocation.method(#logAuthEvent, [event], {#userId: userId, #extra: extra}),
    returnValueForMissingStub: null,
  );

  @override
  void logUserAction(
    String? action,
    String? userId, {
    Map<String, dynamic>? extra,
  }) => super.noSuchMethod(
    Invocation.method(#logUserAction, [action, userId], {#extra: extra}),
    returnValueForMissingStub: null,
  );

  @override
  void logApiCall(
    String? endpoint,
    String? method, {
    int? statusCode,
    Duration? duration,
    Map<String, dynamic>? extra,
  }) => super.noSuchMethod(
    Invocation.method(
      #logApiCall,
      [endpoint, method],
      {#statusCode: statusCode, #duration: duration, #extra: extra},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void logError(
    String? operation,
    Object? error, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extra,
  }) => super.noSuchMethod(
    Invocation.method(
      #logError,
      [operation, error],
      {#stackTrace: stackTrace, #extra: extra},
    ),
    returnValueForMissingStub: null,
  );

  @override
  void logPerformance(
    String? operation,
    Duration? duration, {
    Map<String, dynamic>? extra,
  }) => super.noSuchMethod(
    Invocation.method(#logPerformance, [operation, duration], {#extra: extra}),
    returnValueForMissingStub: null,
  );
}
