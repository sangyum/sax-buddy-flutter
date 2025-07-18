import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sax_buddy/assessment_flow.dart';
import 'package:sax_buddy/auth_wrapper.dart';
import 'package:sax_buddy/features/assessment/providers/assessment_provider.dart';
import 'package:sax_buddy/features/assessment/screens/assessment_complete_screen.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/routines/providers/routines_provider.dart';
import 'package:sax_buddy/features/routines/screens/routines_screen.dart';
import 'package:sax_buddy/features/routines/screens/routine_detail_screen.dart';
import 'package:sax_buddy/features/practice/models/practice_routine.dart';
import 'package:sax_buddy/injection.dart';
import 'package:sax_buddy/services/logger_service.dart';

class MyApp extends StatelessWidget {
  final LoggerService logger;
  
  const MyApp({
    super.key,
    required this.logger
  });

  @override
  Widget build(BuildContext context) {
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
        home: AuthWrapper(logger: logger),
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/assessment':
              return MaterialPageRoute(builder: (context) => const AssessmentFlow());
            case '/assessment/complete':
              return MaterialPageRoute(builder: (context) => const AssessmentCompleteScreen());
            case '/routines':
              return MaterialPageRoute(builder: (context) => const RoutinesScreen());
            case '/routines/detail':
              final routine = settings.arguments as PracticeRoutine;
              return MaterialPageRoute(
                builder: (context) => RoutineDetailScreen(routine: routine),
              );
            default:
              return null;
          }
        },
      ),
    );
  }
}
