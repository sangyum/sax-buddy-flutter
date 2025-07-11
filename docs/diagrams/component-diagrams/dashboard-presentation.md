# Dashboard Presentation - Component Diagram

## Overview
The dashboard presentation serves as the main user interface after authentication, displaying user information, subscription status, and navigation actions.

## Component Structure

```mermaid
graph TB
    subgraph "DashboardPresentation"
        A[Scaffold] --> B[AppBar]
        A --> C[Body: SingleChildScrollView]
        
        subgraph "AppBar Structure"
            B --> D[Title: Dashboard]
            B --> E[Actions]
            E --> F[Logout IconButton]
        end
        
        subgraph "Body Content"
            C --> G[Column]
            G --> H[WelcomeSection]
            G --> J[SubscriptionStatus]
            G --> L[QuickActions]
            G --> N[RecentActivity]
        end
        
        subgraph "Component Dependencies"
            H --> P[User Model]
            J --> Q[User Model]
            L --> R[Static Component]
            N --> S[Static Component]
        end
    end
    
    subgraph "External Widgets"
        T[WelcomeSection Widget]
        U[SubscriptionStatus Widget]
        V[QuickActions Widget]
        W[RecentActivity Widget]
        H -.-> T
        J -.-> U
        L -.-> V
        N -.-> W
    end
    
    subgraph "Data Sources"
        X[User: User Model]
        Y[onSignOut: VoidCallback]
        P --> X
        Q --> X
        F --> Y
    end

    style A fill:#e1f5fe
    style B fill:#f3e5f5
    style C fill:#e8f5e8
    style P fill:#fff3e0
    style Q fill:#fff3e0
```

## Component Details

### Core Structure
- **Scaffold**: Root container with light gray background (`#FAFAFA`)
- **AppBar**: Branded header with logout functionality
- **SingleChildScrollView**: Ensures content scrollability on smaller screens

### AppBar Configuration
- **Background**: Primary brand color (`#2E5266`)
- **Title**: Centered "Dashboard" text in white
- **Actions**: Logout icon button with callback

### Content Sections
1. **Welcome Section**: Personalized greeting with user data
2. **Subscription Status**: Current subscription tier and trial info
3. **Quick Actions**: Primary navigation shortcuts
4. **Recent Activity**: Latest user actions and practice history

### Layout Structure
- **Vertical Column**: Sequential section arrangement
- **Consistent Spacing**: 24px/32px gaps between sections
- **Cross-axis Alignment**: Left-aligned content

### Data Dependencies
```
User Model → WelcomeSection & SubscriptionStatus
onSignOut Callback → AppBar Logout Button
```

### Widget Dependencies
- `widgets/welcome_section.dart`
- `widgets/subscription_status.dart`
- `widgets/quick_actions.dart`
- `widgets/recent_activity.dart`
- `../auth/models/user.dart`

### Props Interface
```dart
final User user;              // User data for personalization
final VoidCallback onSignOut; // Logout action handler
```

### State Management
- **Stateless**: Pure presentation component
- **Props-driven**: All data passed from parent container
- **Callback-based**: User actions delegated to parent