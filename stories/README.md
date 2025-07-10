# Sax Buddy Flutter Storybook

This directory contains Storybook stories for the Sax Buddy Flutter app components and screens. Storybook allows you to develop and test UI components in isolation.

## Getting Started

To run the storybook, use the following command:

```bash
flutter run -t stories/main.dart
```

This will start the Flutter app in storybook mode, allowing you to browse and interact with individual screens and components.

## Available Stories

### Dashboard Stories
- **Dashboard/Default State**: The main dashboard screen with a trial user
- **Dashboard/Subscribed User**: Dashboard for a user with active subscription
- **Dashboard/Expired Trial**: Dashboard for a user with expired trial
- **Dashboard/Mobile View**: Dashboard optimized for mobile devices (375x812)
- **Dashboard/Tablet View**: Dashboard optimized for tablet devices (768x1024)

### Assessment Stories
- **Assessment/Exercise Screen - Setup**: Exercise screen in setup state, ready to start recording
- **Assessment/Exercise Screen - Recording**: Exercise screen while recording is in progress
- **Assessment/Exercise Screen - Mobile**: Exercise screen optimized for mobile devices
- **Assessment/Complete Screen**: Assessment completion screen with results summary
- **Assessment/Complete Screen - Mobile**: Assessment completion screen optimized for mobile

## File Structure

```
stories/
├── main.dart                           # Main storybook app entry point
├── dashboard/
│   └── dashboard_stories.dart          # Dashboard screen stories
└── assessment/
    └── assessment_stories.dart         # Assessment screen stories
```

## Features

- **Device Simulation**: Stories include different viewport sizes to simulate mobile, tablet, and desktop devices
- **State Management**: Assessment stories demonstrate different states of the exercise flow
- **Provider Integration**: Stories properly initialize required providers (AssessmentProvider)
- **Responsive Design**: Multiple viewport sizes to test responsive behavior

## Adding New Stories

To add new stories:

1. Create a new `.dart` file in the appropriate feature folder
2. Define your stories using the `Story` class from `storybook_flutter`
3. Export your stories list and import it in `main.dart`
4. Add the stories to the main stories list

Example:
```dart
final List<Story> myStories = [
  Story(
    name: 'MyComponent/Default',
    description: 'Default state of my component',
    builder: (context) => MyComponent(),
  ),
];
```

## Development Tips

- Use the storybook for rapid UI development and testing
- Test components in different viewport sizes
- Verify component behavior with different data states
- Use providers to test components with realistic state management

## Known Limitations

- Dashboard stories require AuthProvider but currently use MockAuthProvider (type mismatch issue)
- Some stories may have runtime provider errors due to type mismatches
- Future improvements should implement proper interface-based dependency injection

## Future Improvements

- Create abstract interfaces for services (AuthService, UserRepository)
- Implement proper dependency injection for providers  
- Add more component-level stories for individual widgets
- Add theme testing and dark mode support