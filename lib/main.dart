import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/firebase_options.dart';
import 'features/landing/landing_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/assessment/screens/exercise_screen.dart';
import 'features/assessment/screens/assessment_complete_screen.dart';
import 'features/routines/screens/routines_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/assessment/providers/assessment_provider.dart';
import 'features/routines/providers/routines_provider.dart';
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
  
  logger.info('Starting Flutter app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggerService>();
    logger.info('Building MyApp widget');
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            logger.info('Creating AuthProvider');
            return getIt<AuthProvider>();
          },
        ),
        ChangeNotifierProvider<AssessmentProvider>(
          create: (context) {
            logger.info('Creating AssessmentProvider');
            return getIt<AssessmentProvider>();
          },
        ),
        ChangeNotifierProvider<RoutinesProvider>(
          create: (context) {
            logger.info('Creating RoutinesProvider');
            return getIt<RoutinesProvider>();
          },
        ),
      ],
      child: MaterialApp(
        title: 'SaxAI Coach',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E5266)),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
        routes: {
          '/assessment': (context) => const AssessmentFlow(),
          '/assessment/complete': (context) => const AssessmentCompleteScreen(),
          '/routines': (context) => const RoutinesScreen(),
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = getIt<LoggerService>();
    
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        logger.debug('AuthWrapper: Building with auth state: ${authProvider.state.name}');
        
        if (authProvider.isAuthenticated) {
          logger.debug('AuthWrapper: User authenticated, showing dashboard');
          return const DashboardScreen();
        } else {
          logger.debug('AuthWrapper: User not authenticated, showing landing');
          return const LandingScreen();
        }
      },
    );
  }
}

class AssessmentFlow extends StatelessWidget {
  const AssessmentFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentProvider>(
      builder: (context, assessmentProvider, child) {
        // Start the assessment when the flow is first accessed
        if (assessmentProvider.currentSession == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            assessmentProvider.startAssessment();
          });
        }
        
        return const ExerciseScreen();
      },
    );
  }
}
