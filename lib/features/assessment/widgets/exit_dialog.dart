import 'package:flutter/material.dart';

class ExitDialog extends StatelessWidget {
  final VoidCallback onCancelAssessment;

  const ExitDialog({
    super.key,
    required this.onCancelAssessment,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Exit Assessment?'),
      content: const Text(
          'Are you sure you want to exit? Your progress will be lost.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog
            onCancelAssessment();
            Navigator.of(context).pop(); // Exit screen
          },
          child: const Text(
            'Exit',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
