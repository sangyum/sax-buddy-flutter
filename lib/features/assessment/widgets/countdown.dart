import 'package:flutter/material.dart';

class Countdown extends StatelessWidget {
  final int countdownValue;
  final VoidCallback? onCancel;

  const Countdown({super.key, required this.countdownValue, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E5266).withValues(alpha: 0.1),
              border: Border.all(color: const Color(0xFF2E5266), width: 3),
            ),
            child: Center(
              child: Text(
                countdownValue.toString(),
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5266),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Get ready to play...',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          if (onCancel != null)
            TextButton(
              onPressed: onCancel,
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF2E5266), fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }
}
