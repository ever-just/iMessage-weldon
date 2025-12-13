# iMessage Clone for Weldon - Product Requirements Document

**Project Name:** weldon.vip  
**Version:** 1.0  
**Last Updated:** December 12, 2024  
**Author:** Weldon (Admin)

---

## 1. Executive Summary

An iMessage-style mobile messaging application built for iOS that enables direct communication between users and a single admin (Weldon). The app leverages GetStream.io as the real-time messaging backend and provides both anonymous and authenticated messaging experiences.

---

## 2. Product Vision

Create a streamlined, iMessage-inspired communication platform where:
- **Admin (Weldon)** has full visibility and can communicate with all users
- **Standard Users** can message only the admin, either anonymously or authenticated
- The experience mirrors Apple's native iMessage for familiarity and ease of use

---

## 3. User Types & Permissions

### 3.1 Admin User (Weldon)
| Capability | Description |
|------------|-------------|
| View All Channels | See every conversation from all users |
| Message Any User | Initiate or respond to any user's messages |
| User Management | View user profiles (anonymous vs authenticated) |
| Push Notifications | Receive notifications for all incoming messages |
| Channel Management | Pin, mute, archive, or delete conversations |

### 3.2 Standard User
| Capability | Description |
|------------|-------------|
| Message Admin Only | Can only create/view a single channel with Weldon |
| Anonymous Mode | Start messaging immediately without sign-in |
| Authenticated Mode | Sign in to persist messages across devices |
| Message Persistence | Anonymous messages migrate to authenticated account |
| Push Notifications | Receive notifications for admin replies |

---

## 4. Core Features

### 4.1 Anonymous Messaging (MVP)
- **Instant Start**: Users can begin messaging immediately upon app launch
- **Device-bound Identity**: Anonymous users identified by unique device ID
- **Seamless Upgrade**: When user signs in, anonymous messages persist and link to their account

### 4.2 Authentication Flow
- **Profile Icon Access**: Tap profile icon in header to access sign-in
- **Sign-In Options**:
  - Apple Sign-In (primary)
  - Email/Password (secondary)
- **Account Linking**: Link anonymous session to authenticated account

### 4.3 Messaging Experience
- **iMessage UI/UX**: Blue bubbles for sent, gray for received
- **Real-time Updates**: Instant message delivery via Stream WebSockets
- **Typing Indicators**: Show when the other party is typing
- **Read Receipts**: Display when messages are read
- **Media Support**: Images, links with previews

### 4.4 Admin Dashboard (Weldon Only)
- **Unified Inbox**: All user conversations in one channel list
- **User Identification**: See if user is anonymous or authenticated
- **Quick Actions**: Pin important conversations, mark as unread
- **Search**: Find conversations by user name or message content

---

## 5. Technical Specifications

### 5.1 Technology Stack
| Layer | Technology |
|-------|------------|
| Platform | iOS 15+ |
| Language | Swift 5.5+ |
| UI Framework | SwiftUI |
| Chat Backend | GetStream.io Chat SDK |
| Authentication | Firebase Auth / Sign in with Apple |
| Push Notifications | APNs via Stream |
| Storage | Stream (messages) + Keychain (local tokens) |

### 5.2 Stream Chat Architecture
```
┌─────────────────────────────────────────────────────┐
│                    Stream Chat                       │
├─────────────────────────────────────────────────────┤
│  Admin User: weldon_admin                           │
│  - Role: admin                                       │
│  - Permissions: read_all, write_all, manage_channels│
├─────────────────────────────────────────────────────┤
│  Standard Users: user_{uuid} or anon_{device_id}    │
│  - Role: user                                        │
│  - Permissions: read_own, write_own                 │
├─────────────────────────────────────────────────────┤
│  Channel Type: messaging                             │
│  - 1:1 channels between admin and each user         │
│  - Channel ID format: dm_weldon_{user_id}           │
└─────────────────────────────────────────────────────┘
```

### 5.3 Data Models

#### User Model
```swift
struct AppUser {
    let id: String              // Stream user ID
    let displayName: String?    // Optional for anonymous
    let isAnonymous: Bool
    let deviceId: String        // For anonymous linking
    let createdAt: Date
    let avatarURL: URL?
}
```

#### Channel Model
```swift
struct DMChannel {
    let channelId: String       // dm_weldon_{user_id}
    let userId: String          // Standard user ID
    let isAnonymous: Bool
    let createdAt: Date
    let lastMessageAt: Date?
}
```

---

## 6. User Flows

### 6.1 First Launch (Anonymous User)
```
App Launch → Generate Anonymous ID → Connect to Stream → 
Create/Join Channel with Admin → Start Messaging
```

### 6.2 Sign-In Flow
```
Tap Profile Icon → Sign-In Screen → Apple/Email Auth → 
Link Anonymous Messages → Update Stream User → Refresh UI
```

### 6.3 Admin Flow
```
App Launch → Authenticate as Admin → Load All Channels → 
View Channel List → Select Conversation → Message User
```

---

## 7. UI/UX Specifications

### 7.1 Screens

| Screen | Standard User | Admin |
|--------|--------------|-------|
| Channel List | Hidden (single channel) | Full list of all users |
| Chat View | Direct to admin chat | Selected user chat |
| Profile | Sign-in / Account info | Admin settings |
| Settings | Notifications, logout | Manage users, notifications |

### 7.2 Design Language
- **Colors**: 
  - Primary: iOS Blue (#007AFF)
  - Sent Bubble: Blue (#007AFF)
  - Received Bubble: Gray (#E5E5EA)
  - Background: System Background
- **Typography**: SF Pro (system default)
- **Icons**: SF Symbols

---

## 8. Security & Privacy

### 8.1 Data Protection
- All messages encrypted in transit (TLS)
- Stream handles at-rest encryption
- Anonymous user data minimal (device ID only)

### 8.2 Authentication Security
- JWT tokens for Stream authentication
- Token refresh handled server-side or via Firebase Functions
- Keychain storage for sensitive data

### 8.3 Privacy Considerations
- Anonymous users have no PII stored
- Clear data deletion path for authenticated users
- GDPR-compliant data handling via Stream

---

## 9. Success Metrics

| Metric | Target |
|--------|--------|
| App Launch to First Message | < 5 seconds |
| Message Delivery Time | < 500ms |
| Anonymous to Auth Conversion | Track % |
| Daily Active Users | Growth metric |
| Message Volume | Engagement metric |

---

## 10. Out of Scope (v1.0)

- Group messaging
- Voice/Video calls
- Message reactions (consider for v1.1)
- Message editing/deletion by users
- Multiple admin support
- Android version (future roadmap)

---

# Development Roadmap

## Phase 1: Foundation (Week 1-2)
| Task | Priority | Status |
|------|----------|--------|
| Set up Stream Chat account & API keys | P0 | ⬜ |
| Configure Stream roles (admin, user) | P0 | ⬜ |
| Implement anonymous user creation | P0 | ⬜ |
| Create basic chat UI (existing repo) | P0 | ✅ |
| Connect anonymous user to admin channel | P0 | ⬜ |

## Phase 2: Authentication (Week 2-3)
| Task | Priority | Status |
|------|----------|--------|
| Integrate Sign in with Apple | P0 | ⬜ |
| Implement email/password auth (optional) | P2 | ⬜ |
| Create profile/settings screen | P1 | ⬜ |
| Link anonymous messages to auth account | P0 | ⬜ |
| Token management & refresh | P0 | ⬜ |

## Phase 3: Admin Experience (Week 3-4)
| Task | Priority | Status |
|------|----------|--------|
| Admin authentication flow | P0 | ⬜ |
| Channel list for all user conversations | P0 | ⬜ |
| User identification (anon vs auth) | P1 | ⬜ |
| Pin/Archive channel actions | P2 | ⬜ |
| Search functionality | P2 | ⬜ |

## Phase 4: Polish & Launch (Week 4-5)
| Task | Priority | Status |
|------|----------|--------|
| Push notification setup (APNs) | P0 | ⬜ |
| Error handling & edge cases | P0 | ⬜ |
| Loading states & empty states | P1 | ⬜ |
| App icon & launch screen | P1 | ⬜ |
| TestFlight beta testing | P0 | ⬜ |
| App Store submission | P0 | ⬜ |

## Phase 5: Post-Launch (Ongoing)
| Task | Priority | Status |
|------|----------|--------|
| Analytics integration | P1 | ⬜ |
| Message reactions | P2 | ⬜ |
| Media sharing improvements | P2 | ⬜ |
| Performance optimization | P1 | ⬜ |
| User feedback integration | P1 | ⬜ |

---

# Technical Implementation Notes

## Stream Chat Configuration

### 1. Create Custom Roles
```javascript
// Server-side setup (Node.js)
const adminRole = {
  name: 'admin',
  permissions: [
    'ReadChannel', 'CreateChannel', 'UpdateChannel', 
    'DeleteChannel', 'ReadMessage', 'CreateMessage',
    'UpdateMessage', 'DeleteMessage', 'BanUser'
  ]
};

const userRole = {
  name: 'messaging_user', 
  permissions: [
    'ReadChannel', 'CreateMessage', 'ReadMessage'
  ]
};
```

### 2. Channel Permission Policy
- Admin can read/write all channels
- Users can only access their specific `dm_weldon_{user_id}` channel

### 3. Token Generation
```javascript
// Server-side token generation
const serverClient = StreamChat.getInstance(apiKey, apiSecret);

// For admin
const adminToken = serverClient.createToken('weldon_admin');

// For anonymous user
const anonToken = serverClient.createToken(`anon_${deviceId}`);

// For authenticated user  
const userToken = serverClient.createToken(`user_${firebaseUid}`);
```

---

## File Structure (Proposed)

```
iMessageClone/
├── App/
│   ├── iMessageCloneApp.swift
│   └── AppDelegate.swift
├── Core/
│   ├── Authentication/
│   │   ├── AuthManager.swift
│   │   ├── AnonymousAuthProvider.swift
│   │   └── AppleSignInProvider.swift
│   ├── Stream/
│   │   ├── StreamManager.swift
│   │   ├── ChannelManager.swift
│   │   └── UserManager.swift
│   └── Storage/
│       └── KeychainManager.swift
├── Features/
│   ├── ChannelList/
│   │   ├── View/
│   │   └── ViewModel/
│   ├── MessageList/
│   │   ├── View/
│   │   └── ViewModel/
│   ├── Profile/
│   │   ├── View/
│   │   └── ViewModel/
│   └── Settings/
│       ├── View/
│       └── ViewModel/
├── Shared/
│   ├── Components/
│   ├── Extensions/
│   └── Utilities/
└── Resources/
    ├── Assets.xcassets
    └── Info.plist
```

---

## Environment Configuration

### Required Keys
```swift
enum AppConfig {
    static let streamAPIKey = "YOUR_STREAM_API_KEY"
    static let adminUserId = "weldon_admin"
    
    #if DEBUG
    static let environment = "development"
    #else
    static let environment = "production"
    #endif
}
```

### Stream Dashboard Setup
1. Create new app at dashboard.getstream.io
2. Enable "Disable Auth Checks" for development only
3. Create custom channel type "dm" with appropriate permissions
4. Configure push notifications (APNs certificates)

---

## Next Steps

1. **Immediate**: Replace demo API key with your own Stream API key
2. **Setup**: Configure Stream dashboard with proper roles
3. **Develop**: Implement anonymous user flow first
4. **Test**: Verify admin can see all channels
5. **Iterate**: Add authentication, then polish

---

*Document maintained by the development team. Update as requirements evolve.*
