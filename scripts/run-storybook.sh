#!/bin/bash

# Sax Buddy Flutter Storybook Runner
# This script runs the Flutter Storybook for component development

echo "🎷 Starting Sax Buddy Flutter Storybook..."
echo "📚 Running storybook on http://localhost:8080"
echo "🔄 Press Ctrl+C to stop"
echo ""

# Run Flutter with storybook target
flutter run -t stories/main.dart --web-port=8080 --web-hostname=localhost