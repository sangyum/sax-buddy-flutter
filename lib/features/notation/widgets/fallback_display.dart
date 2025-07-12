import 'package:flutter/material.dart';

class FallbackDisplay extends StatelessWidget {
  final String message;
  final double? height;

  const FallbackDisplay({super.key, required this.message, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.music_note,
              size: height != null && height! < 150 ? 24 : 48,
              color: Colors.blue,
            ),
            if (height == null || height! >= 120) ...[
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
