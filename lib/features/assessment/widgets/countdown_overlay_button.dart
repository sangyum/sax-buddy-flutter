import 'package:flutter/material.dart';

class CountdownOverlayButton extends StatelessWidget {
  final int countdownValue;
  final VoidCallback? onCancel;

  const CountdownOverlayButton({
    super.key,
    required this.countdownValue,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Recording button (disabled during countdown)
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE53E3E).withValues(alpha: 0.3),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53E3E).withValues(alpha: 0.1),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.mic,
                      size: 36,
                      color: Color(0xFFBDBDBD),
                    ),
                  ),
                ),
              ),
            ),
            // Countdown overlay
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2E5266).withValues(alpha: 0.95),
                border: Border.all(
                  color: const Color(0xFF2E5266), 
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  countdownValue.toString(),
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Get ready to play...',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF757575),
          ),
        ),
        const SizedBox(height: 8),
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF2E5266),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}