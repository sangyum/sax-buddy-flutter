import 'package:flutter/material.dart';

class ErrorBanner extends StatelessWidget {
  final String error;

  const ErrorBanner({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFFFEBEE),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFD32F2F),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: Color(0xFFD32F2F),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
