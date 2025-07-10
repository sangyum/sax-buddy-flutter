import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SaxAI Coach'),
        backgroundColor: const Color(0xFF2E5266),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showSignOutDialog(context),
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(
              child: Text('No user data available'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeSection(user, context),
                const SizedBox(height: 32),
                _buildSubscriptionStatus(user, context),
                const SizedBox(height: 32),
                _buildQuickActions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(user, BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: user.photoURL != null 
                  ? NetworkImage(user.photoURL!) 
                  : null,
              child: user.photoURL == null 
                  ? Text(
                      user.displayName.isNotEmpty 
                          ? user.displayName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 24),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.displayName.isNotEmpty 
                        ? user.displayName 
                        : user.email,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionStatus(user, BuildContext context) {
    final hasAccess = user.hasAccess;
    final isTrialActive = user.isTrialActive;
    
    return Card(
      color: hasAccess ? Colors.green.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hasAccess ? Icons.check_circle : Icons.warning,
                  color: hasAccess ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  'Account Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (user.hasActiveSubscription)
              const Text('✓ Active Subscription')
            else if (isTrialActive)
              Text('✓ Free Trial Active${user.trialEndsAt != null ? ' (ends ${_formatDate(user.trialEndsAt!)})' : ''}')
            else
              const Text('⚠ Trial Expired - Upgrade to continue'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildActionCard(
                  icon: Icons.music_note,
                  title: 'Start Practice',
                  subtitle: 'Begin assessment',
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.history,
                  title: 'View History',
                  subtitle: 'Past sessions',
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () {},
                ),
                _buildActionCard(
                  icon: Icons.help,
                  title: 'Help',
                  subtitle: 'Support & FAQ',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: const Color(0xFF2E5266)),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        );
      },
    );
  }
}