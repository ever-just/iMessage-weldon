# Repository Index - iMessage Clone (weldon.vip)

**Version:** 1.0.0  
**Last Updated:** December 18, 2024  
**Based on:** GetStream.io StreamChatSwiftUI SDK  
**Purpose:** Private iMessage-style chat app with Supabase authentication

---

## Repository Structure

```
iMessage-weldon/
├── iMessageClone/                        # Main iOS app
│   ├── iMessageCloneApp.swift            # App entry point
│   ├── Config/
│   │   ├── AppConfig.swift               # Centralized configuration
│   │   ├── Secrets.plist                 # API keys (gitignored)
│   │   └── Secrets.template.plist        # Template for credentials
│   ├── Core/
│   │   ├── Authentication/
│   │   │   ├── AuthManager.swift         # Supabase auth + Stream JWT
│   │   │   ├── AuthView.swift            # Sign-in/sign-up UI
│   │   │   └── ProfileView.swift         # User profile & sign-out
│   │   ├── Supabase/
│   │   │   └── SupabaseClient.swift      # Supabase client singleton
│   │   └── Views/
│   │       ├── RootView.swift            # Main router (auth state)
│   │       ├── AdminChannelListView.swift
│   │       ├── StandardUserView.swift
│   │       ├── StandardUserHeaderModifier.swift
│   │       ├── StandardUserChannelInfoView.swift
│   │       └── CustomChannelInfoView.swift
│   ├── StreamChat/
│   │   ├── AppDelegate.swift             # Stream client initialization
│   │   ├── iMessageViewFactory.swift     # Custom ViewFactory
│   │   ├── iMessageViewFactory+ChannelList.swift
│   │   └── iMessageViewFactory+MessageList.swift
│   ├── ChannelList/                      # Admin channel list feature
│   │   ├── View/
│   │   │   ├── ChannelHeader/
│   │   │   ├── ChannelList/
│   │   │   └── ChannelListItem/
│   │   └── ViewModel/
│   ├── MessageList/                      # Message UI feature
│   │   ├── View/
│   │   │   ├── Attachments/
│   │   │   ├── Composer/
│   │   │   ├── Header/
│   │   │   └── Message/
│   │   └── ViewModel/
│   ├── Assets.xcassets/
│   └── Preview Content/
├── scripts/                              # Node.js dev scripts
│   ├── README.md                         # Script documentation
│   ├── setup-stream.js
│   ├── debug-messages.js
│   ├── register-anon-user.js
│   └── test-user-interactions.js
├── docs/
│   ├── PRD.md                            # Product requirements
│   └── REPO_INDEX.md                     # This file
├── ARCHITECTURE.md                       # Architecture documentation
├── AUDIT_PLAN.md                         # Repository audit & implementation plan
└── README.md                             # Setup instructions
```

---

## Key Files & Their Purpose

### App Entry Point

| File | Purpose |
|------|---------|
| `iMessageCloneApp.swift` | Main app struct, loads `RootView` |
| `StreamChat/AppDelegate.swift` | Stream SDK initialization |

### Configuration (`Config/`)

| File | Purpose |
|------|---------|
| `AppConfig.swift` | Loads credentials from Secrets.plist |
| `Secrets.plist` | API keys (gitignored - never commit) |
| `Secrets.template.plist` | Template for other developers |

### Authentication (`Core/Authentication/`)

| File | Purpose |
|------|---------|
| `AuthManager.swift` | Supabase auth, Stream JWT generation, user state |
| `AuthView.swift` | Sign-in/sign-up form UI |
| `ProfileView.swift` | User profile display and sign-out |

### Core Views (`Core/Views/`)

| File | Purpose |
|------|---------|
| `RootView.swift` | Routes to Auth/Admin/Standard views based on state |
| `AdminChannelListView.swift` | Admin sees all user channels |
| `StandardUserView.swift` | Standard user sees single DM with admin |
| `CustomChannelInfoView.swift` | Channel info sheet with sign-out |

### Stream SDK Integration (`StreamChat/`)

| File | Purpose |
|------|---------|
| `AppDelegate.swift` | Configures `ChatClient` with API key |
| `iMessageViewFactory.swift` | Custom `ViewFactory` + `StandardUserViewFactory` |
| `iMessageViewFactory+ChannelList.swift` | Channel list customizations |
| `iMessageViewFactory+MessageList.swift` | Message list customizations |

### Channel List Feature (`ChannelList/`)

| File | Purpose |
|------|---------|
| `View/ChannelList/iMessageChannelList.swift` | Main channel list with pinned channels |
| `View/ChannelList/PinnedChannelsView.swift` | Horizontal scrolling pinned channels |
| `View/ChannelList/LeadingSwipeAreaView.swift` | Pin action on swipe |
| `View/ChannelList/TrailingSwipeAreaView.swift` | Mute/delete actions on swipe |
| `View/ChannelListItem/iMessageChannelListItem.swift` | Custom channel row |
| `View/ChannelListItem/iMessageChannelListItemView.swift` | Channel item content |
| `View/ChannelHeader/iMessageChannelListHeader.swift` | Navigation bar header |
| `View/ChannelHeader/iMessageChannelListHeaderModifier.swift` | Header styling |
| `ViewModel/iMessageChannelListViewModel.swift` | Channel list state & logic |

### Message List Feature (`MessageList/`)

| File | Purpose |
|------|---------|
| `View/Message/MessageView.swift` | Individual message bubble (blue/gray) |
| `View/Composer/ComposerInputView.swift` | Message input field |
| `View/Composer/LeadingComposerView.swift` | Camera/apps button |
| `View/Header/MessageListHeader.swift` | Chat header with back button |
| `View/Header/MessageListHeaderModifier.swift` | Header styling |
| `View/Attachments/LinkView.swift` | Link preview rendering |
| `ViewModel/MessageListHeaderViewModel.swift` | Header state management |

---

## Current Configuration

### Credentials (Secrets.plist)
Credentials are loaded from `Config/Secrets.plist` (gitignored):
- `SupabaseURL` - Supabase project URL
- `SupabaseAnonKey` - Supabase anonymous key
- `StreamAPIKey` - Stream Chat API key
- `StreamAppId` - Stream App ID
- `StreamAPISecret` - Stream API secret (for JWT generation)

### User Types
```swift
enum UserType {
    case admin      // weldon_admin - sees all channels
    case standard   // Regular users - single DM with admin
}
```

---

## Dependencies

### Swift Package Manager
| Package | Purpose |
|---------|---------|
| `StreamChat` | Core chat SDK |
| `StreamChatSwiftUI` | SwiftUI components |
| `Supabase` | Authentication |
| `OrderedCollections` | Ordered sets for pinned channels |

### Required iOS Capabilities
- Background Modes (remote notifications)
- Push Notifications
- App Groups (`group.vip.weldon.iMessageClone`)

---

## UI Components Summary

### Message Bubbles
- **Sent (Current User):** Blue background (#007AFF), white text, right-aligned
- **Received:** Gray background (secondarySystemBackground), primary text, left-aligned
- **Tail:** Custom images (`outgoingTail`, `incomingTail`) for first message in group

### Channel List (Admin Only)
- **Pinned Channels:** Horizontal scroll at top with avatars
- **Regular Channels:** Vertical list with swipe actions
- **Swipe Left (Leading):** Pin/Unpin
- **Swipe Right (Trailing):** Mute, Delete

### Standard User View
- Single chat view with admin (no channel list)
- Simplified header with "Weldon" name
- Custom info sheet with sign-out option

---

## Implementation Status ✅

All core features have been implemented:

- [x] **Authentication Layer** - Supabase email/password auth
- [x] **User Role System** - Admin vs Standard user detection
- [x] **Channel Access Control** - Admin sees all, users see single DM
- [x] **Profile/Sign-out** - ProfileView with sign-out functionality
- [x] **App Configuration** - Centralized AppConfig with Secrets.plist

---

## Quick Start

1. Copy `Config/Secrets.template.plist` to `Config/Secrets.plist`
2. Fill in your Supabase and Stream credentials
3. Open `iMessageClone.xcodeproj`
4. Build & Run (⌘R)

See [README.md](../README.md) for detailed setup instructions.

---

## Related Resources

- [StreamChatSwiftUI GitHub](https://github.com/GetStream/stream-chat-swiftui)
- [Stream iOS Docs](https://getstream.io/chat/docs/sdk/ios/swiftui/)
- [Supabase Swift Docs](https://supabase.com/docs/reference/swift/introduction)

---

*Last updated: December 18, 2024*
