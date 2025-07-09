# Firebase App Distribution Setup

This document describes how to set up Firebase App Distribution for automatic deployment of iOS and Android builds.

## Required GitHub Secrets

You need to configure the following secrets in your GitHub repository (Settings → Secrets and variables → Actions):

### 1. `FIREBASE_SERVICE_ACCOUNT_JSON`
- **Description**: Firebase service account JSON for authentication
- **How to get**:
  1. Go to [Firebase Console](https://console.firebase.google.com/)
  2. Select your project
  3. Go to Project Settings → Service Accounts
  4. Generate a new private key
  5. Copy the entire JSON content
  6. Paste it as the secret value

### 2. `FIREBASE_ANDROID_APP_ID`
- **Description**: Firebase Android app ID
- **How to get**:
  1. Go to Firebase Console → Project Settings → General
  2. Find your Android app
  3. Copy the App ID (format: `1:123456789:android:abc123def456`)

### 3. `FIREBASE_IOS_APP_ID`
- **Description**: Firebase iOS app ID
- **How to get**:
  1. Go to Firebase Console → Project Settings → General
  2. Find your iOS app
  3. Copy the App ID (format: `1:123456789:ios:abc123def456`)

### 4. `GOOGLE_SERVICES_BASE64` (Already configured)
- **Description**: Base64 encoded google-services.json for Android
- **Status**: ✅ Already configured

### 5. `GOOGLE_SERVICE_INFO_PLIST_BASE64` (Already configured)
- **Description**: Base64 encoded GoogleService-Info.plist for iOS
- **Status**: ✅ Already configured

## Firebase App Distribution Setup

### 1. Enable App Distribution
1. Go to Firebase Console → App Distribution
2. Click "Get started"
3. Add your Android and iOS apps if not already added

### 2. Create Tester Groups
1. Go to App Distribution → Testers & Groups
2. Create a group called "testers"
3. Add email addresses of testers who should receive the builds

### 3. Configure Distribution Settings
1. Go to App Distribution → Releases
2. Review the release settings for both Android and iOS apps
3. Ensure the tester group "testers" has access

## How It Works

### Automatic Distribution
- **Trigger**: Every push to `main` or `develop` branches
- **Android**: APK file is built and uploaded to Firebase App Distribution
- **iOS**: IPA file is created and uploaded to Firebase App Distribution
- **Notifications**: Testers in the "testers" group receive email notifications

### Release Notes
The workflow automatically generates release notes including:
- Commit SHA
- Commit message
- Branch name
- Build timestamp

### Manual Distribution
You can also manually distribute builds:
1. Go to Firebase Console → App Distribution
2. Upload your APK/IPA file
3. Select tester groups
4. Add release notes
5. Distribute

## Troubleshooting

### Common Issues

1. **Service Account Permissions**
   - Ensure the service account has "Firebase App Distribution Admin" role
   - Check that the service account JSON is valid and not corrupted

2. **App ID Mismatch**
   - Verify the App IDs match your Firebase project
   - Check that the bundle IDs match between your app and Firebase

3. **Build Failures**
   - Check that google-services.json and GoogleService-Info.plist are properly configured
   - Ensure your app builds successfully locally

### Getting Help
- [Firebase App Distribution Documentation](https://firebase.google.com/docs/app-distribution)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)