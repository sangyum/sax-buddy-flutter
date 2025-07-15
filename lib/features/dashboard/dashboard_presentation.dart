import 'package:flutter/material.dart';
import '../auth/models/user.dart';
import 'widgets/welcome_section.dart';
import 'widgets/subscription_status.dart';
import 'widgets/quick_actions.dart';
import 'widgets/recent_activity.dart';

class DashboardPresentation extends StatelessWidget {
  final User user;
  final VoidCallback onSignOut;

  const DashboardPresentation({
    super.key,
    required this.user,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: const Color(0xFF2E5266),
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onSignOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WelcomeSection(user: user),
            const SizedBox(height: 24),
            SubscriptionStatus(user: user),
            const SizedBox(height: 32),
            const QuickActions(),
            const SizedBox(height: 32),
            const RecentActivity(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
