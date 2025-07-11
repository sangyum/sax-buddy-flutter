import 'package:flutter/material.dart';

class FocusAreaChip extends StatelessWidget {
  final String label;

  const FocusAreaChip({
    super.key, 
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: Color(0xFF757575),
        ),
      ),
    );
  }
}