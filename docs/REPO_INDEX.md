# Repository Index - iMessage Clone

**Based on:** GetStream.io StreamChatSwiftUI SDK  
**Original Authors:** Stefan Blos, Martin Mitrevski  
**Purpose:** iMessage-style chat UI built with SwiftUI

---

## Repository Structure

```
iMessage-weldon/
├── docs/
│   ├── PRD.md                    # Product requirements & roadmap
│   └── REPO_INDEX.md             # This file
├── iMessageClone/
│   ├── iMessageCloneApp.swift    # App entry point
│   ├── Assets.xcassets/          # Images, colors, app icon
│   ├── Preview Content/          # SwiftUI preview assets
│   ├── ChannelList/              # Channel list feature
│   ├── MessageList/              # Message list feature
│   └── StreamChat/               # Stream SDK integration
└── iMessageClone.xcodeproj/      # Xcode project file
```

---

## Key Files & Their Purpose

### App Entry Point

| File | Purpose |
|------|---------|
| `iMessageCloneApp.swift` | Main app struct, initializes `iMessageChannelList` |
| `StreamChat/AppDelegate.swift` | Stream SDK initialization, user connection |

### Stream SDK Integration (`StreamChat/`)

| File | Purpose |
|------|---------|
| `AppDelegate.swift` | Configures `ChatClient`, connects demo user |
| `iMessageViewFactory.swift` | Custom `ViewFactory` for UI customization |
| `iMessageViewFactory+ChannelList.swift` | Channel list customizations |
| `iMessageViewFactory+MessageList.swift` | Message list customizations |

### Channel List Feature (`ChannelList/`)

| File | Purpose |
|------|---------|
| `View/ChannelList/iMessageChannelList.swift` | Main channel list view with navigation |
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

### Stream API (Demo)
```swift
// AppDelegate.swift - REPLACE WITH YOUR OWN KEY
apiKey: "8br4watad788"  // Demo key - DO NOT USE IN PRODUCTION
```

### Demo User (Replace)
```swift
// Current hardcoded user - MUST BE REPLACED
userId: "luke_skywalker"
token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## Dependencies

### Swift Package Manager
| Package | Purpose |
|---------|---------|
| `StreamChat` | Core chat SDK |
| `StreamChatSwiftUI` | SwiftUI components |
| `OrderedCollections` | Ordered sets for pinned channels |

### Required iOS Capabilities
- Background Modes (remote notifications)
- Push Notifications
- Keychain Sharing (if using app groups)

---

## UI Components Summary

### Message Bubbles
- **Sent (Current User):** Blue background (#007AFF), white text, right-aligned
- **Received:** Gray background (secondarySystemBackground), primary text, left-aligned
- **Tail:** Custom images (`outgoingTail`, `incomingTail`) for first message in group

### Channel List
- **Pinned Channels:** Horizontal scroll at top with avatars
- **Regular Channels:** Vertical list with swipe actions
- **Swipe Left (Leading):** Pin/Unpin
- **Swipe Right (Trailing):** Mute, Delete

---

## What Needs to Change for Weldon App

### 1. Authentication Layer (NEW)
```
Core/Authentication/
├── AuthManager.swift          # Manages auth state
├── AnonymousAuthProvider.swift # Device-based anonymous ID
└── AppleSignInProvider.swift   # Sign in with Apple
```

### 2. User Role System (NEW)
```swift
enum UserRole {
    case admin      // Weldon - sees all channels
    case standard   // Regular users - sees only their DM
}
```

### 3. Channel Access Control (MODIFY)
- **Admin View:** Show all channels (existing behavior)
- **Standard View:** Single channel to admin only

### 4. Profile/Settings Screens (NEW)
```
Features/Profile/
├── View/ProfileView.swift
├── View/SignInView.swift
└── ViewModel/ProfileViewModel.swift
```

### 5. App Configuration (NEW)
```swift
// Replace hardcoded values
enum AppConfig {
    static let streamAPIKey = "YOUR_KEY"
    static let adminUserId = "weldon_admin"
}
```

---

## Quick Start for Development

### 1. Get Stream API Key
1. Go to [dashboard.getstream.io](https://dashboard.getstream.io)
2. Create new app or use existing
3. Copy API Key and Secret

### 2. Update AppDelegate
```swift
// Replace demo key
ChatClientConfig(apiKey: .init("YOUR_API_KEY"))

// Replace demo user with dynamic auth
connectUser(userId: currentUserId, token: generatedToken)
```

### 3. Run the App
```bash
open iMessageClone.xcodeproj
# Select simulator or device
# Build & Run (Cmd + R)
```

---

## Related Resources

- [StreamChatSwiftUI GitHub](https://github.com/GetStream/stream-chat-swiftui)
- [SwiftUI Chat Tutorial](https://getstream.io/tutorials/swiftui-chat/)
- [Stream iOS Docs](https://getstream.io/chat/docs/sdk/ios/swiftui/)
- [YouTube: Channel List Tutorial](https://youtu.be/526swCwDMX8)
- [YouTube: Message List Tutorial](https://youtu.be/8Nkmk85H8HQ)

---

*Index generated for iMessage-Weldon project development.*
