import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';
import 'dashboard_presentation.dart';
import 'package:sax_buddy/features/dashboard/widgets/sign_out_dialog.dart';

class DashboardContainer extends StatelessWidget {
  const DashboardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.user;
        
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
}