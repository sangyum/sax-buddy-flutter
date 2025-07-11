import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sax_buddy/features/auth/providers/auth_provider.dart';
import 'package:sax_buddy/features/dashboard/dashboard_screen.dart';
import 'package:sax_buddy/features/landing/landing_screen.dart';
import 'package:sax_buddy/services/logger_service.dart';

class AuthWrapper extends StatelessWidget {
  final LoggerService logger;
  
  const AuthWrapper({
    super.key,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
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
