import 'package:flutter/material.dart';
import 'package:storybook_flutter/storybook_flutter.dart';
import 'package:sax_buddy/features/dashboard/dashboard_presentation.dart';
import 'package:sax_buddy/features/auth/models/user.dart';

final List<Story> dashboardStories = [
  Story(
    name: 'Dashboard/Trial User',
    description: 'Dashboard for a user with active trial',
    builder: (context) => DashboardPresentation(
      user: User(
        id: 'trial_user_123',
        email: 'trial@saxbuddy.com',
        displayName: 'Trial User',
        photoURL: null,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().add(const Duration(days: 11)),
      ),
      onSignOut: () => debugPrint('Sign out tapped'),
    ),
  ),
  Story(
    name: 'Dashboard/Subscribed User',
    description: 'Dashboard for a user with active subscription',
    builder: (context) => DashboardPresentation(
      user: User(
        id: 'subscribed_user_456',
        email: 'premium@saxbuddy.com',
        displayName: 'Premium User',
        photoURL: null,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        hasActiveSubscription: true,
        trialEndsAt: null,
      ),
      onSignOut: () => debugPrint('Sign out tapped'),
    ),
  ),
  Story(
    name: 'Dashboard/Expired Trial',
    description: 'Dashboard for a user with expired trial',
    builder: (context) => DashboardPresentation(
      user: User(
        id: 'expired_user_789',
        email: 'expired@saxbuddy.com',
        displayName: 'Expired Trial User',
        photoURL: null,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      onSignOut: () => debugPrint('Sign out tapped'),
    ),
  ),
  Story(
    name: 'Dashboard/User with Photo',
    description: 'Dashboard for a user with profile photo',
    builder: (context) => DashboardPresentation(
      user: User(
        id: 'photo_user_101',
        email: 'photo@saxbuddy.com',
        displayName: 'User With Photo',
        photoURL: 'https://via.placeholder.com/100',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        hasActiveSubscription: false,
        trialEndsAt: DateTime.now().add(const Duration(days: 5)),
      ),
      onSignOut: () => debugPrint('Sign out tapped'),
    ),
  ),
  Story(
    name: 'Dashboard/Mobile View',
    description: 'Dashboard optimized for mobile devices',
    builder: (context) => SizedBox(
      width: 375,
      height: 812,
      child: DashboardPresentation(
        user: User(
          id: 'mobile_user_222',
          email: 'mobile@saxbuddy.com',
          displayName: 'Mobile User',
          photoURL: null,
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
          hasActiveSubscription: false,
          trialEndsAt: DateTime.now().add(const Duration(days: 7)),
        ),
        onSignOut: () => debugPrint('Sign out tapped'),
      ),
    ),
  ),
  Story(
    name: 'Dashboard/Tablet View',
    description: 'Dashboard optimized for tablet devices',
    builder: (context) => SizedBox(
      width: 768,
      height: 1024,
      child: DashboardPresentation(
        user: User(
          id: 'tablet_user_333',
          email: 'tablet@saxbuddy.com',
          displayName: 'Tablet User',
          photoURL: null,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          hasActiveSubscription: true,
          trialEndsAt: null,
        ),
        onSignOut: () => debugPrint('Sign out tapped'),
      ),
    ),
  ),
];