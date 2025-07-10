import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sax_buddy/firebase_options.dart';
import 'features/landing/landing_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/auth/repositories/user_repository.dart';
import 'services/logger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize logger (this will read LOG_LEVEL from .env)
  final logger = LoggerService.instance;
  logger.info('SaxBuddy app starting up', extra: {
    'environment': dotenv.env['ENVIRONMENT'] ?? 'unknown',
    'logLevel': dotenv.env['LOG_LEVEL'] ?? 'INFO',
  });
  
  // Initialize Firebase
  logger.info('Initializing Firebase');
  final stopwatch = Stopwatch()..start();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    stopwatch.stop();
    
    logger.info('Firebase initialized successfully', extra: {
      'durationMs': stopwatch.elapsedMilliseconds,
    });
    logger.logPerformance('firebase_initialization', stopwatch.elapsed);
  } catch (e) {
    stopwatch.stop();
    logger.logError('firebase_initialization', e, extra: {
      'durationMs': stopwatch.elapsedMilliseconds,
    });
    rethrow;
  }
  
  logger.info('Starting Flutter app');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = LoggerService.instance;
    logger.info('Building MyApp widget');
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) {
            logger.info('Creating AuthProvider');
            return AuthProvider(
              authService: AuthService(),
              userRepository: UserRepository(),
            );
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
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final logger = LoggerService.instance;
    
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
