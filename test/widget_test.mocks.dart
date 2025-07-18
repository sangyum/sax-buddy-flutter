// Mocks generated by Mockito 5.4.6 from annotations
// in sax_buddy/test/widget_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:sax_buddy/features/auth/models/user.dart' as _i4;
import 'package:sax_buddy/features/auth/repositories/user_repository.dart'
    as _i5;
import 'package:sax_buddy/features/auth/services/auth_service.dart' as _i2;
import 'package:sax_buddy/services/logger_service.dart' as _i6;

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

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i2.AuthService {
  @override
  _i3.Future<_i4.User?> signInWithGoogle() =>
      (super.noSuchMethod(
            Invocation.method(#signInWithGoogle, []),
            returnValue: _i3.Future<_i4.User?>.value(),
            returnValueForMissingStub: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<void> signOut() =>
      (super.noSuchMethod(
            Invocation.method(#signOut, []),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Stream<_i4.User?> authStateChanges() =>
      (super.noSuchMethod(
            Invocation.method(#authStateChanges, []),
            returnValue: _i3.Stream<_i4.User?>.empty(),
            returnValueForMissingStub: _i3.Stream<_i4.User?>.empty(),
          )
          as _i3.Stream<_i4.User?>);
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i5.UserRepository {
  @override
  _i3.Future<void> createUser(_i4.User? user) =>
      (super.noSuchMethod(
            Invocation.method(#createUser, [user]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<_i4.User?> getUser(String? userId) =>
      (super.noSuchMethod(
            Invocation.method(#getUser, [userId]),
            returnValue: _i3.Future<_i4.User?>.value(),
            returnValueForMissingStub: _i3.Future<_i4.User?>.value(),
          )
          as _i3.Future<_i4.User?>);

  @override
  _i3.Future<void> updateUser(_i4.User? user) =>
      (super.noSuchMethod(
            Invocation.method(#updateUser, [user]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);

  @override
  _i3.Future<void> deleteUser(String? userId) =>
      (super.noSuchMethod(
            Invocation.method(#deleteUser, [userId]),
            returnValue: _i3.Future<void>.value(),
            returnValueForMissingStub: _i3.Future<void>.value(),
          )
          as _i3.Future<void>);
}

/// A class which mocks [LoggerService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerService extends _i1.Mock implements _i6.LoggerService {
  @override
  _i6.LogLevel get currentLevel =>
      (super.noSuchMethod(
            Invocation.getter(#currentLevel),
            returnValue: _i6.LogLevel.trace,
            returnValueForMissingStub: _i6.LogLevel.trace,
          )
          as _i6.LogLevel);

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
