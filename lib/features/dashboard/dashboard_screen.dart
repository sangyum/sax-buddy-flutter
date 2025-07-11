import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import '../routines/providers/routines_provider.dart';
import 'dashboard_presentation.dart';
import 'package:sax_buddy/features/dashboard/widgets/sign_out_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _routinesInitialized = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthProvider, RoutinesProvider>(
      builder: (context, authProvider, routinesProvider, child) {
        final user = authProvider.user;
        
        // Initialize routines when user is available and not yet initialized
        if (user != null && !_routinesInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _initializeUserRoutines(user.id, routinesProvider);
          });
        }
        
        if (user == null) {
          return const Scaffold(
            backgroundColor: Color(0xFFFAFAFA),
            body: Center(
              child: Text('No user data available'),
            ),
          );
        }
        
        void showSignOutDialog(BuildContext context) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return SignOutDialog(onSignOut: authProvider.signOut);
            },
          );
        }

        return DashboardPresentation(
          user: user,
          onSignOut: () => showSignOutDialog(context),
        );
      },
    );
  }

  Future<void> _initializeUserRoutines(String userId, RoutinesProvider routinesProvider) async {
    try {
      // Set the user ID for the routines provider
      routinesProvider.setUserId(userId);
      
      // Load user's existing routines from Firestore
      await routinesProvider.loadUserRoutines();
      
      setState(() {
        _routinesInitialized = true;
      });
    } catch (e) {
      // Error handling is done within the routines provider
      setState(() {
        _routinesInitialized = true; // Mark as initialized even on error to prevent retry loops
      });
    }
  }
}