import 'package:flutter/material.dart';

class CTASection extends StatelessWidget {
  const CTASection({
    super.key,
    required this.onStartTrialPressed,
    required this.onSignInPressed,
  });

  final VoidCallback onStartTrialPressed;
  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onStartTrialPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E5266),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Free Trial',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        GestureDetector(
          onTap: onSignInPressed,
          child: const Text(
            'Already have account? Sign In',
            style: TextStyle(
              color: Color(0xFF2E5266),
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}