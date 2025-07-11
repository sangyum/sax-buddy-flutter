
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import '../../services/logger_service.dart';
import 'landing_presentation.dart';

class LandingContainer extends StatelessWidget {
  final LoggerService logger;
  
  const LandingContainer({
    super.key,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    void handleSignIn() {
      logger.info('User pressed sign-in button on landing screen', extra: {
        'screen': 'landing',
        'action': 'google_signin_initiated',
      });
      authProvider.signInWithGoogle();
    }

    return LandingPresentation(
      onSignIn: handleSignIn,
    );
  }
}
