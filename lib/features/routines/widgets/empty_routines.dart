import 'package:flutter/material.dart';

class EmptyRoutines extends StatelessWidget {
  final VoidCallback? onRefresh;

  const EmptyRoutines({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note_outlined,
            size: 64,
            color: Color(0xFFBDBDBD),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Practice Routines Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Complete an assessment to get personalized practice routines',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/assessment'),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Assessment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5266),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          if (onRefresh != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF2E5266),
              ),
            ),
          ],
        ],
      ),
    );
  }
}