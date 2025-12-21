# WELDON.VIP

A private iMessage-style chat application built with SwiftUI and Stream Chat SDK, featuring Supabase authentication. Enables direct messaging between an admin and standard users with a native iOS messaging experience.

**Bundle ID:** `app.justchat.ios`

## Features

- **iMessage-style UI** - Native iOS messaging experience with blue/gray message bubbles, typing indicators, and smooth animations
- **Supabase Authentication** - Secure email/password sign-up and sign-in
- **Role-based Access**
  - **Admin**: Views all user conversations in a channel list, can message any user
  - **Standard Users**: Single chat view with the admin, simplified header UI
- **Stream Chat Integration** - Real-time messaging powered by Stream Chat SDK
- **Custom UI Components** - Customized headers, channel lists, and message views

## Requirements

- iOS 15.2+
- Xcode 15.0+
- Swift 5.9+
- Stream Chat account
- Supabase project

## Setup

### 1. Clone the Repository

```bash
git clone https://github.com/ever-just/iMessage-weldon.git
cd iMessage-weldon
```

### 2. Configure Credentials

Copy the template secrets file and fill in your credentials:

```bash
cp iMessageClone/Config/Secrets.template.plist iMessageClone/Config/Secrets.plist
```

Edit `Secrets.plist` with your actual values:

```xml
<dict>
    <key>SupabaseURL</key>
    <string>YOUR_SUPABASE_URL</string>
    <key>SupabaseAnonKey</key>
    <string>YOUR_SUPABASE_ANON_KEY</string>
    <key>StreamAPIKey</key>
    <string>YOUR_STREAM_API_KEY</string>
    <key>StreamAppId</key>
    <string>YOUR_STREAM_APP_ID</string>
    <key>StreamAPISecret</key>
    <string>YOUR_STREAM_API_SECRET</string>
</dict>
```

> **Important**: `Secrets.plist` is gitignored and should never be committed to version control.

### 3. Open in Xcode

```bash
open iMessageClone.xcodeproj
```

### 4. Resolve Swift Packages

Xcode should automatically resolve dependencies. If not:
- File → Packages → Resolve Package Versions

### 5. Configure Signing

Update the development team and bundle identifier in Xcode:
- Select the project in the navigator
- Select the target
- Under "Signing & Capabilities", set your Team and Bundle Identifier

### 6. Build and Run

Select your target device/simulator and press ⌘R.

## Usage

### Admin Login
- Email: `weldon@weldon.vip`
- The admin sees a list of all user conversations and can message any user

### Standard User
- Sign up with any email/password
- Automatically connected to a DM channel with the admin
- Simplified single-chat interface

## Dependencies

- [StreamChatSwiftUI](https://github.com/GetStream/stream-chat-swiftui) - Chat UI SDK
- [Supabase Swift](https://github.com/supabase/supabase-swift) - Authentication
- [OrderedCollections](https://github.com/apple/swift-collections) - Pinned channels support

## Project Structure

```
iMessageClone/
├── Config/                 # App configuration & secrets
│   ├── AppConfig.swift     # Centralized config loader
│   ├── Secrets.plist       # Your credentials (gitignored)
│   └── Secrets.template.plist
├── Core/                   # App-specific code
│   ├── Authentication/     # Auth views & manager
│   ├── Supabase/           # Supabase client
│   └── Views/              # Shared UI components
├── ChannelList/            # Stream Chat channel list customization
├── MessageList/            # Stream Chat message list customization
├── StreamChat/             # Stream SDK setup & view factory
└── Assets.xcassets/        # App icons & images
```

## Architecture

See [ARCHITECTURE.md](ARCHITECTURE.md) for detailed design documentation.

## License

This project is for private use.
