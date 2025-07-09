import 'package:flutter/material.dart';
import 'widgets/portrait_layout.dart';
import 'widgets/landscape_layout.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final isTablet = screenWidth > 600;
            final isLandscape = screenWidth > screenHeight;
            
            // Responsive content width
            final contentWidth = isTablet 
                ? (screenWidth * 0.6).clamp(400.0, 600.0) 
                : screenWidth;
            
            // Responsive logo size
            final logoSize = isTablet ? 140.0 : 100.0;
            
            // Responsive font sizes
            final titleFontSize = isTablet ? 36.0 : 28.0;
            final subtitleFontSize = isTablet ? 20.0 : 16.0;
            
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  width: contentWidth,
                  constraints: BoxConstraints(
                    minHeight: isLandscape ? screenHeight * 0.9 : screenHeight,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 48.0 : 24.0,
                    vertical: isLandscape ? 16.0 : 24.0,
                  ),
                  child: isLandscape && !isTablet
                      ? LandscapeLayout(
                          logoSize: logoSize,
                          titleFontSize: titleFontSize,
                          subtitleFontSize: subtitleFontSize,
                          onStartTrialPressed: () {
                            // TODO: Navigate to assessment or signup
                          },
                          onSignInPressed: () {
                            // TODO: Navigate to sign in
                          },
                        )
                      : PortraitLayout(
                          logoSize: logoSize,
                          titleFontSize: titleFontSize,
                          subtitleFontSize: subtitleFontSize,
                          onStartTrialPressed: () {
                            // TODO: Navigate to assessment or signup
                          },
                          onSignInPressed: () {
                            // TODO: Navigate to sign in
                          },
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}