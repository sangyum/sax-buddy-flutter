import 'package:flutter/material.dart';
import 'logo.dart';
import 'title_section.dart';
import 'feature_cards.dart';
import 'cta_section.dart';

class PortraitLayout extends StatelessWidget {
  const PortraitLayout({
    super.key,
    required this.logoSize,
    required this.titleFontSize,
    required this.subtitleFontSize,
    required this.onStartTrialPressed,
    required this.onSignInPressed,
  });

  final double logoSize;
  final double titleFontSize;
  final double subtitleFontSize;
  final VoidCallback onStartTrialPressed;
  final VoidCallback onSignInPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
        const SizedBox(height: 40),
        
        // App Logo
        Logo(size: logoSize),
        
        const SizedBox(height: 24),
        
        // App Name and Tagline
        TitleSection(
          titleFontSize: titleFontSize,
          subtitleFontSize: subtitleFontSize,
        ),
        
        const SizedBox(height: 40),
        
        // Feature Cards
        const FeatureCards(),
        
        const SizedBox(height: 40),
        
        // CTAs
        CTASection(
          onStartTrialPressed: onStartTrialPressed,
          onSignInPressed: onSignInPressed,
        ),
        
        const SizedBox(height: 32),
        ],
      ),
    );
  }
}