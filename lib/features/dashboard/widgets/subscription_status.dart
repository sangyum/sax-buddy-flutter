import 'package:flutter/material.dart';
import '../../auth/models/user.dart';

class SubscriptionStatus extends StatelessWidget {
  final User user;

  const SubscriptionStatus({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
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

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}