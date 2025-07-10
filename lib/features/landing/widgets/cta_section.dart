import 'package:flutter/material.dart';
import '../../auth/widgets/google_sign_in_button.dart';

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
        GoogleSignInButton(
          text: 'Sign up for free trial',
          onPressed: onStartTrialPressed,
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