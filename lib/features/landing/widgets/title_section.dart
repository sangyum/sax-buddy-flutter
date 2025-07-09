import 'package:flutter/material.dart';

class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.titleFontSize,
    required this.subtitleFontSize,
  });

  final double titleFontSize;
  final double subtitleFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SaxAI Coach',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E5266),
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          'AI-powered practice routines',
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: const Color(0xFF757575),
          ),
          textAlign: TextAlign.center,
        ),
        
        Text(
          'for self-taught saxophonists',
          style: TextStyle(
            fontSize: subtitleFontSize,
            color: const Color(0xFF757575),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}