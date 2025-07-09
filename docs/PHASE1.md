## Updated Phase 1: User Accounts + Firebase Setup

**Core Requirements:**
- Firebase project configuration
- User registration/authentication flow
- Trial period tracking and enforcement
- Basic subscription status management
- Firestore data structure setup

**Technical Implementation:**
- **Packages:** `firebase_core`, `firebase_auth`, `cloud_firestore`, `purchases_flutter`
- **Domain Models:**
  ```dart
  class User {
    final String uid;
    final String email;
    final DateTime trialStartDate;
    final int routinesGenerated;
    final SubscriptionStatus subscriptionStatus;
  }
  
  enum SubscriptionStatus { trial, active, expired, cancelled }
  ```

**Firestore Structure:**
```
users/{uid}
├── email: string
├── trialStartDate: timestamp
├── routinesGenerated: number
├── subscriptionStatus: string
└── createdAt: timestamp
```

**Key Screens:**
- Welcome/onboarding
- Sign up/Sign in
- Trial status dashboard
- Subscription upgrade flow

**Deliverable:** Working auth flow with trial tracking, ready for routine generation features

## Authentication Flow

**Screen Flow:**
```
App Launch → Auth Check → 
├── Not Authenticated → Welcome → Sign Up/Sign In → Dashboard
└── Authenticated → Dashboard
```

**Implementation:**
```dart
// Auth Service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  Future<UserCredential?> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email, password: password
    );
    
    // Create user document on first signup
    await _createUserDocument(credential.user!);
    return credential;
  }
  
  Future<void> _createUserDocument(User firebaseUser) async {
    await _firestore.collection('users').doc(firebaseUser.uid).set({
      'email': firebaseUser.email,
      'trialStartDate': FieldValue.serverTimestamp(),
      'routinesGenerated': 0,
      'subscriptionStatus': 'trial',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Generated routines - users own their routines
    match /routines/{routineId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
    
    // Usage tracking - read-only for users, server writes
    match /usage/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      // Write access controlled via Cloud Functions only
    }
  }
}
```

## Trial Management Service

```dart
class TrialService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<bool> canGenerateRoutine(String userId) async {
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data()!;
    
    final trialStart = (userData['trialStartDate'] as Timestamp).toDate();
    final routinesGenerated = userData['routinesGenerated'] as int;
    final subscriptionStatus = userData['subscriptionStatus'] as String;
    
    // Check if subscription is active
    if (subscriptionStatus == 'active') return true;
    
    // Check trial limits
    final trialDaysRemaining = 14 - DateTime.now().difference(trialStart).inDays;
    return trialDaysRemaining > 0 && routinesGenerated < 5;
  }
  
  Future<void> incrementRoutineCount(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'routinesGenerated': FieldValue.increment(1),
    });
  }
}
```

This setup ensures secure user data access and proper trial enforcement. Ready to move to Phase 2 (Audio Recording/Analysis)?