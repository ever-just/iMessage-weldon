# App Store Submission Checklist

## ✅ Technical Requirements - COMPLETE

- [x] **App Icons** - All required sizes present (1024x1024, 180x180, 120x120, 80x80, 60x60, 58x58, 40x40, 167x167, 152x152)
- [x] **Bundle ID** - `vip.weldon.app`
- [x] **Display Name** - `WELDON.VIP`
- [x] **Version** - `1.1.0`
- [x] **Build Number** - Auto-incremented by Xcode Cloud
- [x] **Launch Screen** - Auto-generated (UILaunchScreen_Generation = YES)
- [x] **Supported Orientations** - Portrait, Landscape Left, Landscape Right
- [x] **iOS Deployment Target** - 15.2
- [x] **Code Signing** - Automatic via Xcode Cloud
- [x] **Entitlements** - App Groups configured (`group.vip.weldon`)

## ✅ Privacy & Permissions - COMPLETE

- [x] **Photo Library Usage** - "In order to send images we need to access them."
- [x] **Privacy Policy** - Created at `docs/PRIVACY_POLICY.md`
- [x] **Data Collection** - Email, messages, device info (documented in privacy policy)

## 📝 App Store Connect - TO DO

### Required Information

- [ ] **Privacy Policy URL** - Need to host at `https://weldon.vip/privacy`
- [ ] **Support URL** - Need to host at `https://weldon.vip/support`
- [ ] **Marketing URL** - `https://weldon.vip` (optional)

### App Information

- [ ] **App Name** - WELDON.VIP
- [ ] **Subtitle** - Private Direct Messaging (max 30 chars)
- [ ] **Primary Category** - Social Networking
- [ ] **Secondary Category** - Productivity (optional)
- [ ] **Age Rating** - 4+ (no objectionable content)

### Description & Keywords

- [ ] **Description** - See `docs/APP_STORE_METADATA.md`
- [ ] **Keywords** - weldon, private messaging, direct message, chat, secure messaging, dm, private chat, encrypted messaging, instant messaging, real-time chat
- [ ] **Promotional Text** - (optional, can update without new version)

### Screenshots

Need screenshots for:
- [ ] **iPhone 6.7"** (1290 x 2796) - 3-10 screenshots
- [ ] **iPhone 6.5"** (1242 x 2688) - 3-10 screenshots  
- [ ] **iPhone 5.5"** (1242 x 2208) - Optional but recommended

Screenshot ideas:
1. Login/Welcome screen
2. Chat list (admin view)
3. Message conversation with blue/gray bubbles
4. Rich media (image/link preview)
5. Profile/Settings view

### App Review Information

- [ ] **Demo Account Email** - `demo@weldon.vip`
- [ ] **Demo Account Password** - Create secure password
- [ ] **Notes for Reviewer** - "This is a private messaging app connecting users with admin. Standard users message admin only; admin sees all conversations. Requires email/password authentication."
- [ ] **Contact Information** - Name, phone, email

### What's New (Version 1.1.0)

```
• Improved authentication with forgot password support
• Enhanced UI with custom components
• Better session management
• Performance improvements and bug fixes
• Updated security standards
```

## 🚀 Pre-Submission Tasks

### 1. Create Demo Account
```bash
# Create in Supabase or via app
Email: demo@weldon.vip
Password: [Secure password for reviewers]
```

### 2. Host Privacy Policy & Support Pages
Options:
- GitHub Pages (free)
- Netlify (free)
- Custom domain weldon.vip

Files to host:
- `/privacy` - Privacy policy
- `/support` - Support/contact page
- `/` - Marketing page (optional)

### 3. Take Screenshots
- Run app on iPhone 14 Pro Max (6.7")
- Capture key screens
- Use Xcode's screenshot tool or device
- Ensure no personal data visible

### 4. Test on Physical Device
- [x] Install on iPhone 14
- [ ] Test all features
- [ ] Verify push notifications work
- [ ] Test image sharing
- [ ] Verify authentication flow
- [ ] Test forgot password

### 5. Final Build via Xcode Cloud
- [ ] Ensure workflow completed successfully
- [ ] Build appears in TestFlight
- [ ] Install via TestFlight and test
- [ ] Submit for App Review

## 📋 App Review Guidelines to Follow

### Must Comply With:
- **2.1** - App Completeness (fully functional)
- **2.3** - Accurate Metadata (description matches functionality)
- **3.1.1** - In-App Purchase (not applicable - free app)
- **4.0** - Design (native iOS design, no bugs)
- **5.1.1** - Privacy Policy (required, must be accessible)
- **5.1.2** - Permission Requests (photo library explained)

### Common Rejection Reasons to Avoid:
- ❌ Incomplete app information
- ❌ Broken links (privacy policy, support)
- ❌ Demo account doesn't work
- ❌ App crashes
- ❌ Misleading screenshots
- ❌ Missing privacy policy

## 🎯 Next Steps

1. **Commit current changes** (privacy policy, metadata docs)
2. **Create simple website** for privacy/support URLs
3. **Create demo account** in production
4. **Take screenshots** on device
5. **Wait for Xcode Cloud build** to complete
6. **Test via TestFlight**
7. **Fill out App Store Connect** metadata
8. **Submit for review**

## 📞 Contact for Review

**Email**: support@weldon.vip  
**Phone**: [Your phone number]  
**Name**: Weldon [Last Name]

---

**Status**: Ready for screenshots and website hosting
**Last Updated**: December 20, 2024
