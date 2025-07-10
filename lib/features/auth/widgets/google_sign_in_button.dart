import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class GoogleSignInButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool enabled;

  const GoogleSignInButton({
    super.key,
    this.text = 'Sign up for free trial',
    this.onPressed,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isLoading = authProvider.isLoading;
        final isEnabled = enabled && !isLoading;
        
        return ElevatedButton(
          onPressed: isEnabled ? () => _handleSignIn(context) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.grey[800],
            elevation: 2,
            shadowColor: Colors.grey.withOpacity(0.5),
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            minimumSize: const Size(200, 48),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      height: 18,
                      width: 18,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 18,
                          width: 18,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.g_mobiledata,
                            size: 14,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _handleSignIn(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (onPressed != null) {
      onPressed!();
    } else {
      authProvider.signInWithGoogle();
    }
  }
}

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}