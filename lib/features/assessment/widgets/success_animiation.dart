import 'package:flutter/material.dart';

class SuccessAnimiation extends StatelessWidget {
  const SuccessAnimiation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withAlpha(76),
            blurRadius: 20,
            spreadRadius: 4,
          ),
        ],
      ),
      child: const Icon(Icons.check, size: 60, color: Colors.white),
    );
  }
}
