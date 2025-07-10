import 'package:flutter/material.dart';

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({
    super.key,
    required this.onSignOut,
  });

  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
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
            onSignOut();
          },
          child: const Text('Sign Out'),
        ),
      ],
    );
  }
}