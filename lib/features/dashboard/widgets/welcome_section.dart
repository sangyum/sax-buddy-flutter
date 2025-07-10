import 'package:flutter/material.dart';
import '../../auth/models/user.dart';

class WelcomeSection extends StatelessWidget {
  final User user;

  const WelcomeSection({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning,',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                user.displayName.isNotEmpty 
                    ? user.displayName.split(' ').first
                    : 'User',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E5266),
                ),
              ),
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF4A7C95),
            backgroundImage: user.photoURL != null 
                ? NetworkImage(user.photoURL!) 
                : null,
            child: user.photoURL == null 
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 24,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}