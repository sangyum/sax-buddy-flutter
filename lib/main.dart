import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/firebase_options.dart';
import 'package:sax_buddy/my_app.dart';
import 'services/logger_service.dart';
import 'services/openai_service.dart';
import 'features/practice/services/practice_generation_service.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  final stopwatch = Stopwatch()..start();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    stopwatch.stop();
  } catch (e) {
    stopwatch.stop();
    rethrow;
  }
  
  // Initialize dependency injection
  configureDependencies();
  
  // Initialize logger after DI is configured
  final logger = getIt<LoggerService>();
  logger.info('SaxBuddy app starting up', extra: {
    'environment': dotenv.env['ENVIRONMENT'] ?? 'unknown',
    'logLevel': dotenv.env['LOG_LEVEL'] ?? 'INFO',
  });
  
  // Initialize AI services
  initializeAIServices(logger);
  
  logger.info('Starting Flutter app');
  runApp(MyApp(logger: logger));
}

void initializeAIServices(LoggerService logger) {
  logger.info('Initializing AI services');
  final serviceStopwatch = Stopwatch()..start();
  
  try {
    final openAIApiKey = dotenv.env['OPENAI_API_KEY'];
    if (openAIApiKey != null) {
      final openAIService = getIt<OpenAIService>();
      openAIService.initialize(openAIApiKey);
      
      final practiceService = getIt<PracticeGenerationService>();
      practiceService.initialize(openAIApiKey);
      
      serviceStopwatch.stop();
      logger.info('AI services initialized successfully', extra: {
        'durationMs': serviceStopwatch.elapsedMilliseconds,
      });
      logger.logPerformance('ai_services_initialization', serviceStopwatch.elapsed);
    } else {
      logger.warning('OpenAI API key not found, AI services will not be available');
    }
  } catch (e) {
    serviceStopwatch.stop();
    logger.logError('ai_services_initialization', e, extra: {
      'durationMs': serviceStopwatch.elapsedMilliseconds,
    });
    // Don't rethrow here - app should continue even if AI services fail
    logger.warning('App will continue without AI services');
  }
}
