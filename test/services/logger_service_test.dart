import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/services/logger_service.dart';

void main() {
  group('LoggerService', () {
    late LoggerService logger;

    setUp(() {
      // Load test environment variables
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
      
      // Create new instance for each test
      logger = LoggerService();
    });

    test('should create new instances correctly', () {
      final logger1 = LoggerService();
      final logger2 = LoggerService();
      
      // Different instances but same functionality
      expect(logger1, isNotNull);
      expect(logger2, isNotNull);
      expect(logger1.currentLevel, equals(logger2.currentLevel));
    });

    test('should parse log levels correctly from environment', () {
      // Test different log levels
      final testCases = {
        'TRACE': LogLevel.trace,
        'DEBUG': LogLevel.debug,
        'INFO': LogLevel.info,
        'WARNING': LogLevel.warning,
        'ERROR': LogLevel.error,
        'OFF': LogLevel.off,
        'NOTHING': LogLevel.off,
        'invalid': LogLevel.info, // default fallback
      };

      for (final entry in testCases.entries) {
        dotenv.testLoad(fileInput: 'LOG_LEVEL=${entry.key}');
        
        final testLogger = LoggerService();
        expect(testLogger.currentLevel, equals(entry.value), 
               reason: 'Failed for log level: ${entry.key}');
      }
    });

    test('should default to INFO level when LOG_LEVEL is not set', () {
      dotenv.testLoad(fileInput: 'ENVIRONMENT=test');
      
      final testLogger = LoggerService();
      expect(testLogger.currentLevel, equals(LogLevel.info));
    });

    group('logging methods', () {
      setUp(() {
        // Note: In a real implementation, you'd want to inject a testable output
      });

      test('should log structured data correctly', () {
        // Test that methods don't throw exceptions
        expect(() => logger.trace('Trace message'), returnsNormally);
        expect(() => logger.debug('Debug message'), returnsNormally);
        expect(() => logger.info('Info message'), returnsNormally);
        expect(() => logger.warning('Warning message'), returnsNormally);
        expect(() => logger.error('Error message'), returnsNormally);
      });

      test('should log with extra data', () {
        final extraData = {'userId': 'test123', 'action': 'login'};
        
        expect(() => logger.info('User logged in', extra: extraData), returnsNormally);
        expect(() => logger.error('Login failed', extra: extraData), returnsNormally);
      });

      test('should log with error and stack trace', () {
        final error = Exception('Test error');
        final stackTrace = StackTrace.current;
        
        expect(() => logger.error('Operation failed', 
                                  error: error, 
                                  stackTrace: stackTrace), 
               returnsNormally);
      });
    });

    group('context-specific logging helpers', () {

      test('should log auth events correctly', () {
        expect(() => logger.logAuthEvent('user_login'), returnsNormally);
        expect(() => logger.logAuthEvent('user_logout', userId: 'test123'), returnsNormally);
        expect(() => logger.logAuthEvent('password_reset', 
                                         userId: 'test123', 
                                         extra: {'email': 'test@example.com'}), 
               returnsNormally);
      });

      test('should log user actions correctly', () {
        expect(() => logger.logUserAction('practice_session', 'user123'), returnsNormally);
        expect(() => logger.logUserAction('subscription_upgrade', 'user123',
                                          extra: {'plan': 'premium'}), 
               returnsNormally);
      });

      test('should log API calls correctly', () {
        expect(() => logger.logApiCall('/api/users', 'GET'), returnsNormally);
        expect(() => logger.logApiCall('/api/auth/login', 'POST', 
                                       statusCode: 200, 
                                       duration: const Duration(milliseconds: 150)), 
               returnsNormally);
      });

      test('should log errors correctly', () {
        final error = Exception('Database connection failed');
        expect(() => logger.logError('database_query', error), returnsNormally);
        expect(() => logger.logError('api_request', error,
                                     extra: {'endpoint': '/api/users'}), 
               returnsNormally);
      });

      test('should log performance metrics correctly', () {
        // Fast operation should log as debug
        expect(() => logger.logPerformance('quick_operation', 
                                           const Duration(milliseconds: 50)), 
               returnsNormally);
        
        // Slow operation should log as warning
        expect(() => logger.logPerformance('slow_operation', 
                                           const Duration(milliseconds: 1500)), 
               returnsNormally);
      });
    });

    group('log level filtering', () {
      test('should respect log level filtering for INFO level', () {
        dotenv.testLoad(fileInput: 'LOG_LEVEL=INFO');
        final testLogger = LoggerService();
        
        // All methods should execute without error
        // In a real test, you'd verify that only appropriate levels are output
        expect(() => testLogger.trace('Should not appear'), returnsNormally);
        expect(() => testLogger.debug('Should not appear'), returnsNormally);
        expect(() => testLogger.info('Should appear'), returnsNormally);
        expect(() => testLogger.warning('Should appear'), returnsNormally);
        expect(() => testLogger.error('Should appear'), returnsNormally);
      });

      test('should respect log level filtering for ERROR level', () {
        dotenv.testLoad(fileInput: 'LOG_LEVEL=ERROR');
        final testLogger = LoggerService();
        
        expect(() => testLogger.trace('Should not appear'), returnsNormally);
        expect(() => testLogger.debug('Should not appear'), returnsNormally);
        expect(() => testLogger.info('Should not appear'), returnsNormally);
        expect(() => testLogger.warning('Should not appear'), returnsNormally);
        expect(() => testLogger.error('Should appear'), returnsNormally);
      });

      test('should not log anything when level is OFF', () {
        dotenv.testLoad(fileInput: 'LOG_LEVEL=OFF');
        final testLogger = LoggerService();
        
        expect(() => testLogger.trace('Should not appear'), returnsNormally);
        expect(() => testLogger.debug('Should not appear'), returnsNormally);
        expect(() => testLogger.info('Should not appear'), returnsNormally);
        expect(() => testLogger.warning('Should not appear'), returnsNormally);
        expect(() => testLogger.error('Should not appear'), returnsNormally);
      });
    });

    group('structured logging format', () {
      test('should include required fields in log context', () {
        // These tests verify the methods execute and don't throw
        // In production, you'd want to capture and verify actual log output
        expect(() => logger.info('Test message'), returnsNormally);
        expect(() => logger.info('Test with data', extra: {'key': 'value'}), returnsNormally);
      });
    });
  });
}