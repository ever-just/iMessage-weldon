# Repository Audit Plan

**Last Updated:** December 18, 2024  
**Auditor:** Cascade AI  
**Build Status:** ✅ Passing (iPhone 16 Simulator)

---

## Table of Contents
1. [Executive Summary](#executive-summary)
2. [Current Repository Structure](#current-repository-structure)
3. [Comprehensive File Review](#comprehensive-file-review)
4. [Issues & Concerns](#issues--concerns)
5. [Proposed Optimized Structure](#proposed-optimized-structure)
6. [Action Items](#action-items)
7. [Credentials Status](#credentials-status)

---

## Executive Summary

This audit covers the complete iMessage-weldon repository, including all Swift files, documentation, scripts, and project configuration. The project is a functional iMessage clone using SwiftUI, Stream Chat SDK, and Supabase authentication.

**Overall Health:** 🟢 Good - Build succeeds, core functionality works  
**Architecture:** Hybrid feature-based structure (acceptable, could be optimized)  
**Security:** 🟢 Credentials properly externalized to gitignored Secrets.plist  
**Documentation:** 🟡 Partially outdated - needs updates  
**Testing:** 🔴 No automated tests

---

## Current Repository Structure

```
iMessage-weldon/
├── iMessageClone/                        # Main iOS app (33 Swift files)
│   ├── iMessageCloneApp.swift            # App entry point
│   ├── AppConfig.swift                   # ⚠️ DUPLICATE - legacy file
│   ├── Config/
│   │   ├── AppConfig.swift               # Main config - loads secrets
│   │   ├── Secrets.plist                 # API keys (gitignored) ✅
│   │   └── Secrets.template.plist        # Template for devs
│   ├── Core/
│   │   ├── Authentication/
│   │   │   ├── AuthManager.swift         # Supabase auth + Stream JWT
│   │   │   ├── AuthView.swift            # Sign-in/sign-up UI
│   │   │   └── UserSwitcherView.swift    # ⚠️ Misnamed (contains ProfileView)
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
│   │   ├── AppDelegate.swift             # Stream client init
│   │   ├── iMessageViewFactory.swift     # ViewFactory base + StandardUserViewFactory
│   │   ├── iMessageViewFactory+ChannelList.swift
│   │   └── iMessageViewFactory+MessageList.swift
│   ├── ChannelList/                      # Admin channel list feature
│   │   ├── View/
│   │   │   ├── ChannelHeader/            # 2 files
│   │   │   ├── ChannelList/              # 4 files
│   │   │   └── ChannelListItem/          # 2 files
│   │   └── ViewModel/
│   │       └── iMessageChannelListViewModel.swift
│   ├── MessageList/                      # Message UI feature
│   │   ├── View/
│   │   │   ├── Attachments/LinkView.swift
│   │   │   ├── Composer/                 # 2 files
│   │   │   ├── Header/                   # 2 files
│   │   │   └── Message/MessageView.swift
│   │   └── ViewModel/
│   │       └── MessageListHeaderViewModel.swift
│   ├── Assets.xcassets/                  # Images, colors, app icon
│   └── Preview Content/
├── scripts/                              # Node.js dev scripts (6 files)
├── docs/
│   ├── PRD.md                            # Product requirements (outdated)
│   └── REPO_INDEX.md                     # File index (outdated)
├── ARCHITECTURE.md                       # Architecture docs
├── AUDIT_PLAN.md                         # This file
└── README.md                             # Setup instructions
```

---

## Comprehensive File Review

### Task 1: App Entry & Configuration

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `iMessageCloneApp.swift` | ✅ | None | - |
| `AppConfig.swift` (root) | ⚠️ | **Duplicate** - renamed to `AppConfigLegacy` but still exists | Delete file |
| `Config/AppConfig.swift` | ✅ | None - properly loads from Secrets.plist | - |
| `Config/Secrets.plist` | ✅ | Gitignored, contains real credentials | - |
| `Config/Secrets.template.plist` | ✅ | Template for other developers | - |

### Task 2: Authentication Layer

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `AuthManager.swift` | ✅ | - Generates JWT client-side (acceptable for dev)<br>- No token expiry handling<br>- No rate limiting | Add token refresh logic; consider server-side JWT for production |
| `AuthView.swift` | ✅ | - `TODO: Implement forgot password` on line 113<br>- Uses deprecated `.autocapitalization()` | Implement forgot password; use `.textInputAutocapitalization()` |
| `UserSwitcherView.swift` | ⚠️ | **Misnamed** - file contains `ProfileView`, not `UserSwitcherView` | Rename to `ProfileView.swift` |
| `SupabaseClient.swift` | ✅ | Force-unwrap on URL (line 15) could crash if config invalid | Add guard with error handling |

### Task 3: Core Views

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `RootView.swift` | ✅ | Uses `DispatchQueue.main.asyncAfter` for init delay (line 30) - fragile | Use proper async/await with state observation |
| `AdminChannelListView.swift` | ✅ | None | - |
| `StandardUserView.swift` | ✅ | Uses deprecated `onChange(of:)` without `initial:` parameter (line 61) | Update to iOS 17+ onChange syntax |
| `StandardUserHeaderModifier.swift` | ✅ | None | - |
| `StandardUserChannelInfoView.swift` | ⚠️ | Duplicates sign-out logic from `CustomChannelInfoView` | Extract shared sign-out component |
| `CustomChannelInfoView.swift` | ✅ | None | - |

### Task 4: Stream Chat Integration

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `AppDelegate.swift` | ✅ | None - properly uses AppConfig | - |
| `iMessageViewFactory.swift` | ✅ | Contains both base class and `StandardUserViewFactory` | Consider splitting into separate files |
| `iMessageViewFactory+ChannelList.swift` | ✅ | None | - |
| `iMessageViewFactory+MessageList.swift` | ⚠️ | Uses `[unowned self]` (line 53) - potential crash | Use `[weak self]` with guard |

### Task 5: Channel List Feature

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `iMessageChannelList.swift` | ✅ | Uses deprecated `PreviewProvider` | Update to `#Preview` macro |
| `iMessageChannelListViewModel.swift` | ✅ | None | - |
| `iMessageChannelListHeader.swift` | ✅ | None | - |
| `iMessageChannelListHeaderModifier.swift` | ✅ | None | - |
| `iMessageChannelListItem.swift` | ✅ | None | - |
| `iMessageChannelListItemView.swift` | ✅ | None | - |
| `PinnedChannelsView.swift` | ✅ | None | - |
| `LeadingSwipeAreaView.swift` | ✅ | None | - |
| `TrailingSwipeAreaView.swift` | ✅ | None | - |

### Task 6: Message List Feature

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `MessageView.swift` | ✅ | Uses deprecated `PreviewProvider` | Update to `#Preview` macro |
| `ComposerInputView.swift` | ✅ | Uses deprecated `PreviewProvider` | Update to `#Preview` macro |
| `LeadingComposerView.swift` | ✅ | None | - |
| `MessageListHeader.swift` | ✅ | None | - |
| `MessageListHeaderModifier.swift` | ✅ | None | - |
| `MessageListHeaderViewModel.swift` | ✅ | None | - |
| `LinkView.swift` | ✅ | Fixed - was using optional binding on non-optional | - |

### Task 7: Documentation

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `README.md` | ✅ | Accurate and up-to-date | - |
| `ARCHITECTURE.md` | ✅ | Good overview of structure | - |
| `docs/PRD.md` | ⚠️ | Roadmap tasks all show ⬜ but many are complete | Update task statuses |
| `docs/REPO_INDEX.md` | ⚠️ | Missing Core/ folder, outdated structure | Full rewrite needed |

### Task 8: Scripts

| File | Status | Issues | Solution |
|------|--------|--------|----------|
| `setup-stream.js` | ✅ | Works correctly | - |
| `debug-messages.js` | ✅ | Works correctly | - |
| `register-anon-user.js` | ✅ | Works correctly | - |
| `test-user-interactions.js` | ✅ | Works correctly | - |
| `package.json` | ✅ | None | - |
| **Missing** | ⚠️ | No README for scripts folder | Add `scripts/README.md` |

---

## Issues & Concerns

### 🔴 Critical Issues
_None identified_

### 🟡 Medium Priority Issues

| # | Issue | File | Status |
|---|-------|------|--------|
| 1 | ~~Duplicate AppConfig~~ | `iMessageClone/AppConfig.swift` | ✅ Fixed |
| 2 | ~~Misnamed file~~ | `ProfileView.swift` | ✅ Fixed |
| 3 | ~~Force unwrap URL~~ | `SupabaseClient.swift` | ✅ Fixed |
| 4 | ~~Unowned self~~ | `iMessageViewFactory+MessageList.swift` | ✅ Fixed |
| 5 | ~~Duplicated sign-out logic~~ | `SignOutButton.swift` extracted | ✅ Fixed |
| 6 | ~~Outdated REPO_INDEX.md~~ | `docs/REPO_INDEX.md` | ✅ Fixed |
| 6b | ~~Outdated PRD.md~~ | `docs/PRD.md` | ✅ Fixed |
| 7 | ~~No automated tests~~ | `iMessageCloneTests/` added | ✅ Fixed |

### 🟢 Low Priority / Code Quality

| # | Issue | Files | Status |
|---|-------|-------|--------|
| 8 | ~~Deprecated PreviewProvider~~ | 3 files | ✅ Fixed |
| 9 | ~~Deprecated autocapitalization~~ | `AuthView.swift` | ✅ Fixed |
| 10 | Deprecated `onChange` | `StandardUserView.swift` | ⚠️ Kept (iOS 15 compat) |
| 11 | ~~TODO: Forgot password~~ | `ForgotPasswordSheet` added | ✅ Fixed |
| 12 | ~~No scripts README~~ | `scripts/README.md` | ✅ Fixed |
| 13 | ~~No CI/CD~~ | `.github/workflows/build.yml` | ✅ Fixed |

---

## Proposed Optimized Structure

Based on iOS best practices (Bottle Rocket Studios, Clean Architecture patterns), here's the recommended restructure:

```
iMessage-weldon/
├── iMessageClone/
│   ├── App/                              # App lifecycle
│   │   ├── iMessageCloneApp.swift
│   │   └── AppDelegate.swift
│   │
│   ├── Config/                           # Configuration (unchanged)
│   │   ├── AppConfig.swift
│   │   ├── Secrets.plist
│   │   └── Secrets.template.plist
│   │
│   ├── Core/                             # Shared/Core functionality
│   │   ├── Services/
│   │   │   ├── AuthManager.swift
│   │   │   └── SupabaseClient.swift
│   │   ├── Models/
│   │   │   ├── AppUser.swift             # Extract from AuthManager
│   │   │   └── UserType.swift            # Extract from AuthManager
│   │   └── Extensions/                   # Future: shared extensions
│   │
│   ├── Features/                         # Feature-based organization
│   │   ├── Authentication/
│   │   │   ├── Views/
│   │   │   │   ├── AuthView.swift
│   │   │   │   └── ProfileView.swift     # Renamed from UserSwitcherView
│   │   │   └── Components/
│   │   │       └── AuthTextFieldStyle.swift  # Extract from AuthView
│   │   │
│   │   ├── Admin/
│   │   │   ├── Views/
│   │   │   │   └── AdminChannelListView.swift
│   │   │   └── Components/
│   │   │
│   │   ├── StandardUser/
│   │   │   ├── Views/
│   │   │   │   ├── StandardUserView.swift
│   │   │   │   └── StandardUserChannelInfoView.swift
│   │   │   └── Components/
│   │   │       └── StandardUserHeaderModifier.swift
│   │   │
│   │   ├── ChannelList/                  # Existing structure (good)
│   │   │   ├── Views/
│   │   │   └── ViewModels/
│   │   │
│   │   └── MessageList/                  # Existing structure (good)
│   │       ├── Views/
│   │       └── ViewModels/
│   │
│   ├── Shared/                           # Shared UI components
│   │   ├── Views/
│   │   │   ├── RootView.swift
│   │   │   ├── LaunchView.swift          # Extract from RootView
│   │   │   └── CustomChannelInfoView.swift
│   │   ├── Components/
│   │   │   └── SignOutButton.swift       # Extract duplicated logic
│   │   └── ViewFactories/
│   │       ├── iMessageViewFactory.swift
│   │       ├── iMessageViewFactory+ChannelList.swift
│   │       ├── iMessageViewFactory+MessageList.swift
│   │       └── StandardUserViewFactory.swift  # Extract from base
│   │
│   ├── Resources/
│   │   ├── Assets.xcassets/
│   │   └── Preview Content/
│   │
│   └── Supporting Files/                 # If needed for Info.plist, etc.
│
├── iMessageCloneTests/                   # NEW: Unit tests
│   └── AuthManagerTests.swift
│
├── iMessageCloneUITests/                 # NEW: UI tests
│   └── AuthFlowTests.swift
│
├── scripts/
│   ├── README.md                         # NEW: Script documentation
│   ├── setup-stream.js
│   ├── debug-messages.js
│   ├── register-anon-user.js
│   └── test-user-interactions.js
│
├── docs/
│   ├── PRD.md
│   └── REPO_INDEX.md
│
├── .github/                              # NEW: CI/CD
│   └── workflows/
│       └── build.yml
│
├── ARCHITECTURE.md
├── AUDIT_PLAN.md
└── README.md
```

### Key Changes:
1. **App/** - Isolate app lifecycle files
2. **Features/** - Group by feature (Admin, StandardUser, Auth)
3. **Core/Services/** - Business logic services
4. **Core/Models/** - Extract data models
5. **Shared/** - Cross-feature UI components
6. **Tests/** - Add test targets
7. **Extract duplicated code** - SignOutButton, AuthTextFieldStyle

---

## Action Items

### 🔴 Immediate (Before Next Commit)

| # | Task | File | Status |
|---|------|------|--------|
| 1 | ~~Delete duplicate AppConfig~~ | `iMessageClone/AppConfig.swift` | ✅ Done |
| 2 | ~~Rename UserSwitcherView to ProfileView~~ | `Core/Authentication/ProfileView.swift` | ✅ Done |
| 3 | ~~Fix force unwrap~~ | `Core/Supabase/SupabaseClient.swift` | ✅ Done |
| 4 | ~~Fix unowned self~~ | `StreamChat/iMessageViewFactory+MessageList.swift` | ✅ Done |

### 🟡 Short-term (This Week)

| # | Task | Details | Status |
|---|------|---------|--------|
| 5 | ~~Update REPO_INDEX.md~~ | Reflect current Core/ structure | ✅ Done |
| 6 | ~~Update PRD.md~~ | Mark completed tasks | ✅ Done |
| 7 | ~~Add scripts/README.md~~ | Document how to use scripts | ✅ Done |
| 8 | ~~Extract SignOutButton component~~ | Remove duplication | ✅ Done |
| 9 | ~~Update deprecated APIs~~ | PreviewProvider, autocapitalization | ✅ Done |

### 🟢 Long-term (Backlog)

| # | Task | Details | Status |
|---|------|---------|--------|
| 10 | ~~Add XCTest target~~ | `iMessageCloneTests/` created | ✅ Done |
| 11 | Add UI tests | Auth flow, messaging | ⬜ Future |
| 12 | ~~Implement forgot password~~ | `ForgotPasswordSheet` added | ✅ Done |
| 13 | ~~Set up GitHub Actions CI~~ | Auto-build on PR | ✅ Done |
| 14 | Restructure to proposed layout | Feature-based organization | ⬜ Future |
| 15 | Add token refresh logic | AuthManager enhancement | ⬜ Future |
| 16 | Add auth rate limiting | Security hardening | ⬜ Future |

---

## Credentials Status

| Service | Status | Location |
|---------|--------|----------|
| Supabase URL | ✅ Configured | `Secrets.plist` |
| Supabase Anon Key | ✅ Configured | `Secrets.plist` |
| Stream API Key | ✅ Configured | `Secrets.plist` |
| Stream App ID | ✅ Configured | `Secrets.plist` |
| Stream API Secret | ✅ Configured | `Secrets.plist` |

**Security:** `Secrets.plist` is gitignored and will NOT be pushed to remote.

---

## Build Verification

```
✅ xcodebuild -scheme iMessageClone -destination 'platform=iOS Simulator,name=iPhone 16'
✅ BUILD SUCCEEDED
✅ App installed and running
```

---

## Implementation Plan (Safe Order)

Based on research into iOS best practices, here's the recommended order for implementing fixes while maintaining functionality:

### Phase 0: Infrastructure Setup (Before Any Code Changes)

**Goal:** Establish proper versioning and branching strategy

#### 0.1 Semantic Versioning
```
Version Format: MAJOR.MINOR.PATCH (e.g., 1.0.0)

MAJOR: Breaking changes (API incompatible)
MINOR: New features (backwards compatible)
PATCH: Bug fixes (backwards compatible)
```

**Current State:** No version tags in git
**Action:** Tag current working state as `v1.0.0`

#### 0.2 Branching Strategy (GitHub Flow - Recommended for this project size)
```
main (production-ready)
  └── feature/* (new features)
  └── fix/* (bug fixes)
  └── refactor/* (code improvements)
```

**Why GitHub Flow over Gitflow:**
- Single developer/small team
- Simpler than full Gitflow
- `main` always deployable
- Feature branches merged via PR

#### 0.3 Create Safety Branch
```bash
git checkout -b refactor/audit-fixes
```

---

### Phase 1: Non-Breaking Fixes (Safe - No Functionality Impact)

These changes don't affect runtime behavior:

| Order | Task | Risk | Verification |
|-------|------|------|--------------|
| 1.1 | Delete `iMessageClone/AppConfig.swift` (duplicate) | None | Build succeeds |
| 1.2 | Rename `UserSwitcherView.swift` → `ProfileView.swift` | None | Build succeeds |
| 1.3 | Add `scripts/README.md` | None | N/A |
| 1.4 | Update `docs/REPO_INDEX.md` | None | N/A |
| 1.5 | Update `docs/PRD.md` task statuses | None | N/A |

**Commit after Phase 1:** `fix: cleanup duplicate files and update documentation`

---

### Phase 2: Code Safety Fixes (Low Risk)

These fix potential crashes but don't change behavior:

| Order | Task | File | Risk | Verification |
|-------|------|------|------|--------------|
| 2.1 | Fix force unwrap URL | `SupabaseClient.swift:15` | Low | Build + app launches |
| 2.2 | Fix `[unowned self]` → `[weak self]` | `iMessageViewFactory+MessageList.swift:53` | Low | Build + send message |

**Commit after Phase 2:** `fix: resolve potential crash issues`

---

### Phase 3: Deprecation Updates (Low Risk)

Update deprecated APIs - functionality unchanged:

| Order | Task | Files | Risk | Verification |
|-------|------|-------|------|--------------|
| 3.1 | Update `PreviewProvider` → `#Preview` | 3 files | Low | Previews work in Xcode |
| 3.2 | Update `autocapitalization` → `textInputAutocapitalization` | `AuthView.swift` | Low | Sign-in form works |
| 3.3 | Update `onChange(of:)` syntax | `StandardUserView.swift` | Low | User switching works |

**Commit after Phase 3:** `refactor: update deprecated SwiftUI APIs`

---

### Phase 4: Code Refactoring (Medium Risk)

Structural changes - test thoroughly:

| Order | Task | Risk | Verification |
|-------|------|------|--------------|
| 4.1 | Extract `SignOutButton` component | Medium | Sign-out works in both views |
| 4.2 | Extract `AuthTextFieldStyle` to separate file | Low | Auth form renders correctly |
| 4.3 | Split `StandardUserViewFactory` to separate file | Low | Standard user view works |

**Commit after Phase 4:** `refactor: extract shared components`

---

### Phase 5: Infrastructure (CI/CD)

Add automation without changing app code:

| Order | Task | Risk | Verification |
|-------|------|------|--------------|
| 5.1 | Add `.github/workflows/build.yml` | None | GitHub Action runs |
| 5.2 | Add basic build verification | None | CI passes |

**Commit after Phase 5:** `ci: add GitHub Actions build workflow`

---

### Phase 6: Testing Infrastructure

Add tests without changing app code:

| Order | Task | Risk | Verification |
|-------|------|------|--------------|
| 6.1 | Add XCTest target | None | Tests run |
| 6.2 | Add basic AuthManager tests | None | Tests pass |
| 6.3 | Add UI test target | None | UI tests run |

**Commit after Phase 6:** `test: add unit and UI test infrastructure`

---

### Phase 7: Major Restructure (High Risk - Optional)

Full folder restructure - do separately:

| Order | Task | Risk | Verification |
|-------|------|------|--------------|
| 7.1 | Create new folder structure | High | Full app test |
| 7.2 | Move files to new locations | High | Full app test |
| 7.3 | Update Xcode project references | High | Build succeeds |

**Recommendation:** Do Phase 7 in a separate PR after Phases 1-6 are stable.

---

## Git Commands for Implementation

```bash
# Phase 0: Setup
git tag -a v1.0.0 -m "Release 1.0.0 - Pre-refactor baseline"
git push origin v1.0.0
git checkout -b refactor/audit-fixes

# After each phase
git add .
git commit -m "phase X: description"

# When complete
git push origin refactor/audit-fixes
# Create PR to main
# After merge, tag new version
git tag -a v1.1.0 -m "Release 1.1.0 - Audit fixes"
```

---

## GitHub Actions Workflow (Phase 5)

Create `.github/workflows/build.yml`:

```yaml
name: iOS Build

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: macos-latest
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Select Xcode
      run: sudo xcode-select -s /Applications/Xcode.app
    
    - name: Create Secrets.plist
      run: |
        cat > iMessageClone/Config/Secrets.plist << EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>SupabaseURL</key>
            <string>\${{ secrets.SUPABASE_URL }}</string>
            <key>SupabaseAnonKey</key>
            <string>\${{ secrets.SUPABASE_ANON_KEY }}</string>
            <key>StreamAPIKey</key>
            <string>\${{ secrets.STREAM_API_KEY }}</string>
            <key>StreamAppId</key>
            <string>\${{ secrets.STREAM_APP_ID }}</string>
            <key>StreamAPISecret</key>
            <string>\${{ secrets.STREAM_API_SECRET }}</string>
        </dict>
        </plist>
        EOF
    
    - name: Build
      run: |
        xcodebuild build \
          -project iMessageClone.xcodeproj \
          -scheme iMessageClone \
          -destination 'platform=iOS Simulator,name=iPhone 16' \
          CODE_SIGNING_ALLOWED=NO
```

---

## Appendix: File Count Summary

| Category | Count |
|----------|-------|
| Swift files | 33 |
| Documentation files | 5 |
| Script files | 6 |
| Configuration files | 3 |
| **Total tracked files** | ~47 |
