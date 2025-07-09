import 'package:flutter/material.dart';
import 'logo.dart';
import 'title_section.dart';
import 'feature_cards.dart';
import 'cta_section.dart';

class LandscapeLayout extends StatelessWidget {
  const LandscapeLayout({
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
    return Row(
      children: [
        // Left side - Logo and title
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Logo(size: logoSize),
              const SizedBox(height: 24),
              TitleSection(
                titleFontSize: titleFontSize,
                subtitleFontSize: subtitleFontSize,
              ),
            ],
          ),
        ),
        
        const SizedBox(width: 40),
        
        // Right side - Features and CTAs
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FeatureCards(),
              const SizedBox(height: 40),
              CTASection(
                onStartTrialPressed: onStartTrialPressed,
                onSignInPressed: onSignInPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}