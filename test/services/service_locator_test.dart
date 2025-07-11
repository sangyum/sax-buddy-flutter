import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/services/service_locator.dart';
import 'package:sax_buddy/services/openai_service.dart';
import 'package:sax_buddy/features/practice/services/practice_generation_service.dart';

void main() {
  setUpAll(() async {
    await dotenv.load(fileName: ".env");
  });

  tearDown(() {
    ServiceLocator.instance.clear();
  });

  group('ServiceLocator', () {
    test('should initialize successfully', () async {
      expect(ServiceLocator.instance.isInitialized, isFalse);
      
      await ServiceLocator.instance.initialize();
      
      expect(ServiceLocator.instance.isInitialized, isTrue);
    });

    test('should register OpenAI service when API key is available', () async {
      await ServiceLocator.instance.initialize();
      
      final hasOpenAIService = ServiceLocator.instance.isRegistered<OpenAIService>();
      final hasPracticeService = ServiceLocator.instance.isRegistered<PracticeGenerationService>();
      
      // These should be true if API key is in environment
      if (dotenv.env['OPENAI_API_KEY'] != null && dotenv.env['OPENAI_API_KEY']!.isNotEmpty) {
        expect(hasOpenAIService, isTrue);
        expect(hasPracticeService, isTrue);
      } else {
        expect(hasOpenAIService, isFalse);
        expect(hasPracticeService, isFalse);
      }
    });

    test('should provide service instances', () async {
      await ServiceLocator.instance.initialize();
      
      if (ServiceLocator.instance.isRegistered<OpenAIService>()) {
        expect(() => ServiceLocator.instance.get<OpenAIService>(), returnsNormally);
      }
      
      if (ServiceLocator.instance.isRegistered<PracticeGenerationService>()) {
        expect(() => ServiceLocator.instance.get<PracticeGenerationService>(), returnsNormally);
      }
    });

    test('should throw exception when getting unregistered service', () async {
      await ServiceLocator.instance.initialize();
      
      expect(() => ServiceLocator.instance.get<String>(), throwsException);
    });

    test('should throw exception when not initialized', () {
      expect(() => ServiceLocator.instance.get<OpenAIService>(), throwsException);
    });

    test('should provide status information', () async {
      await ServiceLocator.instance.initialize();
      
      final status = ServiceLocator.instance.getStatus();
      
      expect(status, isA<Map<String, dynamic>>());
      expect(status['isInitialized'], isTrue);
      expect(status['registeredServices'], isA<List>());
    });

    test('should clear services', () async {
      await ServiceLocator.instance.initialize();
      expect(ServiceLocator.instance.isInitialized, isTrue);
      
      ServiceLocator.instance.clear();
      
      expect(ServiceLocator.instance.isInitialized, isFalse);
    });
  });
}