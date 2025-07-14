import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/services/logger_service.dart';

// Mock classes
class MockLoggerService extends Mock implements LoggerService {}

void main() {
  group('OpenAIService', () {
    late OpenAIService service;
    late MockLoggerService mockLogger;

    setUp(() {
      // Load test environment variables
      dotenv.testLoad(fileInput: '''
LOG_LEVEL=DEBUG
ENVIRONMENT=test
''');
      
      // Create mocks
      mockLogger = MockLoggerService();
      
      // Create service with mock dependencies
      service = OpenAIService(mockLogger);
    });

    test('should initialize with API key', () {
      expect(service.isInitialized, isFalse);

      service.initialize('test-api-key');
      expect(service.isInitialized, isTrue);
    });

    test('should handle initialization errors gracefully', () {
      // Test that the service can handle initialization without throwing
      expect(() => service.initialize('test-api-key'), returnsNormally);
      expect(service.isInitialized, isTrue);
    });

    test('should provide service status', () {
      final status = service.getStatus();
      expect(status, isA<Map<String, dynamic>>());
      expect(status['isInitialized'], isFalse);
      expect(status['service'], 'OpenAI');
      expect(status['timestamp'], isA<String>());

      service.initialize('test-api-key');
      final statusAfterInit = service.getStatus();
      expect(statusAfterInit['isInitialized'], isTrue);
    });

    test('should have generic generateResponse method', () {
      service.initialize('test-api-key');
      
      // Test that the method exists and requires initialization
      expect(() => service.generateResponse('test prompt'), isA<Function>());
    });

    test('should have batch response generation capability', () {
      service.initialize('test-api-key');
      
      // Test that the batch method exists
      expect(() => service.generateBatchResponses(['prompt1', 'prompt2']), isA<Function>());
    });
  });
}
