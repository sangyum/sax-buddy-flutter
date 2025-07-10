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
}