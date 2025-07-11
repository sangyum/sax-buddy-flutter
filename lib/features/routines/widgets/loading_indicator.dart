import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E5266)),
            ),
          ),
          SizedBox(width: 12),
          Text(
            'Loading routines...',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}