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
    final isTrialActive = user.isTrialActive;
    
    // Calculate trial progress (assuming 14-day trial)
    final trialDaysRemaining = user.trialEndsAt != null 
        ? user.trialEndsAt!.difference(DateTime.now()).inDays
        : 0;
    
    // Mock routine usage (2 of 5 routines used)
    final routinesUsed = 2;
    final totalRoutines = 5;
    final routineProgress = routinesUsed / totalRoutines;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2E5266),
            Color(0xFF4A7C95),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  user.hasActiveSubscription ? 'Premium' : 'Free Trial',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isTrialActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$trialDaysRemaining days left',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (isTrialActive) ...[
              Text(
                '$routinesUsed of $totalRoutines routines used',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  widthFactor: routineProgress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Upgrade to Premium',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2E5266),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ] else if (user.hasActiveSubscription) ...[
              const Text(
                'All features unlocked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ] else ...[
              const Text(
                'Trial expired - Upgrade to continue',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Upgrade Now',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF2E5266),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

}