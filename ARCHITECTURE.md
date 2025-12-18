# Architecture & Repository Structure

This document describes the design and structure of the iMessage Clone project.

## Overview

The app follows a modular SwiftUI architecture with clear separation between:
- **Authentication** (Supabase)
- **Messaging** (Stream Chat SDK)
- **UI Components** (Custom SwiftUI views)

## Directory Structure

```
iMessage-weldon/
├── iMessageClone/
│   ├── Config/
│   │   ├── AppConfig.swift          # Centralized configuration, loads secrets
│   │   ├── Secrets.plist            # API keys (gitignored)
│   │   └── Secrets.template.plist   # Template for credentials
│   │
│   ├── Core/
│   │   ├── Authentication/
│   │   │   ├── AuthManager.swift    # Handles Supabase auth & Stream connection
│   │   │   ├── AuthView.swift       # Sign-in/sign-up UI
│   │   │   └── ProfileView.swift    # User profile & sign-out
│   │   │
│   │   ├── Views/
│   │   │   ├── RootView.swift       # Main entry point, routes by auth state
│   │   │   ├── AdminChannelListView.swift    # Admin's channel list
│   │   │   ├── StandardUserView.swift        # Standard user's chat view
│   │   │   ├── StandardUserHeaderModifier.swift
│   │   │   ├── StandardUserChannelInfoView.swift
│   │   │   ├── CustomChannelInfoView.swift   # Channel info with sign-out
│   │   │   └── SignOutButton.swift           # Shared sign-out component
│   │   │
│   │   └── Supabase/
│   │       └── SupabaseClient.swift  # Supabase client configuration
│   │
│   ├── StreamChat/
│   │   ├── AppDelegate.swift         # Stream Chat client initialization
│   │   ├── iMessageViewFactory.swift # Custom ViewFactory for Stream UI
│   │   ├── iMessageViewFactory+ChannelList.swift
│   │   └── iMessageViewFactory+MessageList.swift
│   │
│   ├── ChannelList/
│   │   ├── View/
│   │   │   ├── ChannelList/
│   │   │   │   └── iMessageChannelList.swift
│   │   │   ├── ChannelListItem/
│   │   │   │   ├── iMessageChannelListItem.swift
│   │   │   │   └── iMessageChannelListItemView.swift
│   │   │   ├── Header/
│   │   │   │   ├── iMessageChannelListHeader.swift
│   │   │   │   └── iMessageChannelListHeaderModifier.swift
│   │   │   ├── PinnedChannels/
│   │   │   │   └── PinnedChannelsView.swift
│   │   │   └── SwipeArea/
│   │   │       ├── LeadingSwipeAreaView.swift
│   │   │       └── TrailingSwipeAreaView.swift
│   │   └── ViewModel/
│   │       └── iMessageChannelListViewModel.swift
│   │
│   ├── MessageList/
│   │   ├── View/
│   │   │   ├── Attachments/
│   │   │   │   └── LinkView.swift
│   │   │   ├── Composer/
│   │   │   │   ├── ComposerInputView.swift
│   │   │   │   └── LeadingComposerView.swift
│   │   │   ├── Header/
│   │   │   │   ├── MessageListHeader.swift
│   │   │   │   └── MessageListHeaderModifier.swift
│   │   │   └── Message/
│   │   │       └── MessageView.swift
│   │   └── ViewModel/
│   │       └── MessageListHeaderViewModel.swift
│   │
│   ├── iMessageCloneApp.swift        # App entry point
│   ├── Assets.xcassets/              # Images and colors
│   └── Preview Content/
│
├── scripts/                          # Development/setup scripts (Node.js)
├── docs/                             # Additional documentation
├── AUDIT_PLAN.md                     # Repository audit findings
└── README.md                         # Project overview and setup
```

## Key Components

### Authentication Flow

1. **AuthManager** (`Core/Authentication/AuthManager.swift`)
   - Manages Supabase authentication state
   - Generates Stream Chat JWT tokens
   - Determines user type (admin vs standard)
   - Connects users to Stream Chat with appropriate IDs

2. **RootView** (`Core/Views/RootView.swift`)
   - Entry point for the UI
   - Routes to `AuthView`, `AdminChannelListView`, or `StandardUserView` based on auth state

### User Types

| User Type | Stream ID | View | Capabilities |
|-----------|-----------|------|--------------|
| Admin | `weldon_admin` (fixed) | `AdminChannelListView` | See all channels, message any user |
| Standard | Supabase UUID | `StandardUserView` | Single DM with admin |

### Stream Chat Customization

The app heavily customizes Stream Chat UI through:

1. **iMessageViewFactory** - Custom `ViewFactory` implementation
   - Provides custom channel list items
   - Provides custom message views
   - Provides custom headers

2. **StandardUserViewFactory** - Variant for standard users
   - Simplified header without channel info
   - Custom info sheet for account management

### Credential Management

Credentials are externalized to `Secrets.plist`:

```swift
// AppConfig.swift loads from Secrets.plist
static var streamAPIKey: String {
    secrets["StreamAPIKey"] as? String ?? ""
}
```

**Security**: `Secrets.plist` is gitignored. Use `Secrets.template.plist` as a reference.

## Data Flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   AuthView  │────▶│  AuthManager │────▶│  Supabase   │
└─────────────┘     └──────────────┘     └─────────────┘
                           │
                           ▼
                    ┌──────────────┐
                    │ Stream Chat  │
                    │   Client     │
                    └──────────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
    ┌─────────────────┐      ┌──────────────────┐
    │ AdminChannelList│      │ StandardUserView │
    │      View       │      │                  │
    └─────────────────┘      └──────────────────┘
```

## Channel Naming Convention

- DM channels: `dm_weldon_{user_id}`
- Channel display name: User's first name (from Supabase profile)

## Build Configuration

- **Development Team**: Set in Xcode signing settings
- **Bundle ID**: `app.justchat.ios`
- **App Group**: `group.app.justchat`
- **Minimum iOS**: 15.2
