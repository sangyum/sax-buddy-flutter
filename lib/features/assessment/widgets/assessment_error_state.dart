import 'package:flutter/material.dart';
import '../providers/assessment_provider.dart';
import 'permission_request_dialog.dart';

class AssessmentErrorState extends StatelessWidget {
  final AssessmentProvider provider;

  const AssessmentErrorState({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final error = provider.lastError ?? 'An unknown error occurred';
    final isPermissionError = error.toLowerCase().contains('permission');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPermissionError ? Icons.mic_off : Icons.error_outline,
              size: 64,
              color: const Color(0xFFFF6B6B),
            ),
            const SizedBox(height: 24),
            Text(
              isPermissionError 
                  ? 'Microphone Access Required'
                  : 'Recording Error',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2E5266),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              error,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isPermissionError)
                  OutlinedButton(
                    onPressed: () => provider.resetAssessment(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E5266),
                      side: const BorderSide(color: Color(0xFF2E5266)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                if (!isPermissionError) const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (isPermissionError) {
                      final shouldRetry = await PermissionRequestDialog.showMicrophonePermission(context);
                      if (shouldRetry == true) {
                        await provider.retryAfterError();
                      }
                    } else {
                      await provider.retryAfterError();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E5266),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isPermissionError ? 'Allow Access' : 'Try Again',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isPermissionError)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why do we need microphone access?',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2E5266),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Record your saxophone playing for analysis\n'
                      '• Provide real-time feedback on pitch accuracy\n'
                      '• Generate personalized practice recommendations\n'
                      '• Track your progress over time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}