import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum LogLevel { trace, debug, info, warning, error, off }

class LoggerService {
  static LoggerService? _instance;
  late Logger _logger;
  late LogLevel _currentLevel;

  LoggerService._internal() {
    _initializeLogger();
  }

  static LoggerService get instance {
    _instance ??= LoggerService._internal();
    return _instance!;
  }

  void _initializeLogger() {
    // Read log level from environment variable
    final logLevelStr = dotenv.env['LOG_LEVEL'] ?? 'INFO';
    _currentLevel = _parseLogLevel(logLevelStr);

    // Configure logger with custom output and filter
    _logger = Logger(
      filter: _CustomLogFilter(_currentLevel),
      printer: _StructuredLogPrinter(),
      output: _CustomLogOutput(),
    );
  }

  LogLevel _parseLogLevel(String levelStr) {
    switch (levelStr.toUpperCase()) {
      case 'TRACE':
        return LogLevel.trace;
      case 'DEBUG':
        return LogLevel.debug;
      case 'INFO':
        return LogLevel.info;
      case 'WARNING':
        return LogLevel.warning;
      case 'ERROR':
        return LogLevel.error;
      case 'NOTHING':
      case 'OFF':
        return LogLevel.off;
      default:
        return LogLevel.info;
    }
  }


  // Structured logging methods
  void trace(String message, {Map<String, dynamic>? extra, Object? error, StackTrace? stackTrace}) {
    _logWithContext(Level.trace, message, extra: extra, error: error, stackTrace: stackTrace);
  }

  void debug(String message, {Map<String, dynamic>? extra, Object? error, StackTrace? stackTrace}) {
    _logWithContext(Level.debug, message, extra: extra, error: error, stackTrace: stackTrace);
  }

  void info(String message, {Map<String, dynamic>? extra, Object? error, StackTrace? stackTrace}) {
    _logWithContext(Level.info, message, extra: extra, error: error, stackTrace: stackTrace);
  }

  void warning(String message, {Map<String, dynamic>? extra, Object? error, StackTrace? stackTrace}) {
    _logWithContext(Level.warning, message, extra: extra, error: error, stackTrace: stackTrace);
  }

  void error(String message, {Map<String, dynamic>? extra, Object? error, StackTrace? stackTrace}) {
    _logWithContext(Level.error, message, extra: extra, error: error, stackTrace: stackTrace);
  }

  void _logWithContext(
    Level level,
    String message, {
    Map<String, dynamic>? extra,
    Object? error,
    StackTrace? stackTrace,
  }) {
    final logData = <String, dynamic>{
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      'environment': dotenv.env['ENVIRONMENT'] ?? 'unknown',
    };

    if (extra != null) {
      logData.addAll(extra);
    }

    _logger.log(level, logData, error: error, stackTrace: stackTrace);
  }

  // Context-specific logging helpers
  void logAuthEvent(String event, {String? userId, Map<String, dynamic>? extra}) {
    final logExtra = <String, dynamic>{
      'category': 'auth',
      'event': event,
      if (userId != null) 'userId': userId,
      ...?extra,
    };
    info('Authentication event: $event', extra: logExtra);
  }

  void logUserAction(String action, String userId, {Map<String, dynamic>? extra}) {
    final logExtra = <String, dynamic>{
      'category': 'user_action',
      'action': action,
      'userId': userId,
      ...?extra,
    };
    info('User action: $action', extra: logExtra);
  }

  void logApiCall(String endpoint, String method, {int? statusCode, Duration? duration, Map<String, dynamic>? extra}) {
    final logExtra = <String, dynamic>{
      'category': 'api',
      'endpoint': endpoint,
      'method': method,
      if (statusCode != null) 'statusCode': statusCode,
      if (duration != null) 'durationMs': duration.inMilliseconds,
      ...?extra,
    };
    info('API call: $method $endpoint', extra: logExtra);
  }

  void logError(String operation, Object error, {StackTrace? stackTrace, Map<String, dynamic>? extra}) {
    final logExtra = <String, dynamic>{
      'category': 'error',
      'operation': operation,
      'errorType': error.runtimeType.toString(),
      ...?extra,
    };
    this.error('Error in $operation: $error', extra: logExtra, error: error, stackTrace: stackTrace);
  }

  void logPerformance(String operation, Duration duration, {Map<String, dynamic>? extra}) {
    final logExtra = <String, dynamic>{
      'category': 'performance',
      'operation': operation,
      'durationMs': duration.inMilliseconds,
      ...?extra,
    };
    
    // Log as warning if operation takes too long
    if (duration.inMilliseconds > 1000) {
      warning('Slow operation: $operation (${duration.inMilliseconds}ms)', extra: logExtra);
    } else {
      debug('Performance: $operation completed in ${duration.inMilliseconds}ms', extra: logExtra);
    }
  }

  // Getter for current log level
  LogLevel get currentLevel => _currentLevel;

  // Reset singleton for testing
  @visibleForTesting
  static void resetForTesting() {
    _instance = null;
  }
}

class _CustomLogFilter extends LogFilter {
  final LogLevel _currentLevel;

  _CustomLogFilter(this._currentLevel);

  @override
  bool shouldLog(LogEvent event) {
    final eventLevel = _mapFromLoggerLevel(event.level);
    return eventLevel.index >= _currentLevel.index && _currentLevel != LogLevel.off;
  }

  LogLevel _mapFromLoggerLevel(Level level) {
    switch (level) {
      case Level.trace:
        return LogLevel.trace;
      case Level.debug:
        return LogLevel.debug;
      case Level.info:
        return LogLevel.info;
      case Level.warning:
        return LogLevel.warning;
      case Level.error:
        return LogLevel.error;
      case Level.fatal:
        return LogLevel.error;
      default:
        return LogLevel.info;
    }
  }
}

class _StructuredLogPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    final data = event.message as Map<String, dynamic>? ?? {};
    final level = event.level.name.toUpperCase();
    final timestamp = data['timestamp'] ?? DateTime.now().toIso8601String();
    final message = data['message'] ?? 'No message';
    
    // Remove processed fields from data
    final extraData = Map<String, dynamic>.from(data);
    extraData.remove('message');
    extraData.remove('timestamp');
    
    final buffer = StringBuffer();
    buffer.write('[$level] $timestamp - $message');
    
    if (extraData.isNotEmpty) {
      buffer.write(' | Data: ${_formatData(extraData)}');
    }
    
    if (event.error != null) {
      buffer.write(' | Error: ${event.error}');
    }
    
    return [buffer.toString()];
  }

  String _formatData(Map<String, dynamic> data) {
    final pairs = data.entries.map((e) => '${e.key}=${e.value}').join(', ');
    return '{$pairs}';
  }
}

class _CustomLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      // In development, use print. In production, you might want to 
      // send to a logging service like Firebase Crashlytics or Sentry
      debugPrint(line);
    }
  }
}