# Repository Audit Plan

## Task 1 – Repository & Architecture Overview
- [x] **Inventory top-level structure**
  - Primary app code in `iMessageClone/`; supporting docs/scripts present; no unexpected binaries.
- [x] **Entry points & runtime wiring**
  - `iMessageCloneApp` loads `RootView`, which branches between auth/admin/standard flows.

## Task 2 – Build & Tooling Diagnostics
- [x] **SPM dependency resolution**
  - `xcodebuild` resolves StreamChatSwiftUI 4.94.0, Supabase 2.38.1, and related packages without checksum errors.
- [x] **iOS device build (generic/platform=iOS)**
  - Succeeds; app signs with Team `8769U6225R` and bundle id `com.weldonmakori.imessageclone`.
- [ ] **Simulator build**
  - Blocked: CoreSimulator framework on host macOS is outdated (`Current version 1051.9.4` < `Xcode-required 1051.17.7`). Need macOS/Xcode component updates before simulator testing.
- [ ] **Automated tests**
  - No XCTest targets present. Recommend adding sign-in, messaging, and UI snapshot tests.

## Task 3 – Authentication & Supabase Integration
- [x] **Supabase client configuration**
  - Defined in `Core/Supabase/SupabaseClient.swift`. Uses production URL + anon key embedded in source. Risk: secrets in repo; move to secure config.
- [x] **AuthManager workflow**
  - Handles email/password auth, user-type detection (admin vs standard), Stream token generation.
  - Added `session.isExpired` guard prevents stale logins. Optional improvement: set `emitLocalSessionAsInitialSession: true` when safe.
- [ ] **Security review**
  - No rate limiting, lockout, or telemetry around auth failures.

## Task 4 – Stream Chat & Messaging Logic
- [x] **Chat client initialization**
  - `AppDelegate` configures Stream API key (from Secrets.plist) and app group. Ensure secrets align with production practices.
- [x] **Standard user flow**
  - `StandardUserView` creates DM channel to admin, names channel after user, and uses custom header/info sheet.
- [x] **Admin flow**
  - `AdminChannelListView` uses Stream list components; relies on channel metadata for names. Needs on-device verification for new users.

## Task 5 – UI/UX Consistency & Assets
- [x] **Root navigation states**
  - Launch screen → Auth → Admin or Standard flows verified.
- [ ] **Design polish**
  - No automated UI tooling; manual QA required to ensure consistent header/menu behavior.

## Task 6 – Configuration, Signing, and Deployment
- [x] **Xcode project sanity**
  - Signing configs aligned to Team `8769U6225R`; Supabase package reference reinstated.
- [ ] **Distribution readiness**
  - No CI/release documentation or provisioning guidance checked into repo.

## Task 7 – Documentation & Scripts
- [x] **README accuracy**
  - Still references tutorial; does not mention Supabase auth or weldon.vip changes—needs update.
- [ ] **Scripts folder**
  - Not reviewed. Validate any automation scripts before use.

---
### Open Issues / Follow-ups
1. **Simulator build failure** – Update macOS/Xcode components so CoreSimulator matches required version.
2. **Secrets in source control** – Supabase and Stream keys are hard-coded; migrate to configuration files or secrets management.
3. **No automated tests** – Add XCTest/UI coverage for auth and messaging scenarios.
4. **Supabase warning opt-in** – Consider enabling `emitLocalSessionAsInitialSession` and keep `session.isExpired` guard.
5. **Documentation gaps** – README should explain Supabase setup, Stream credentials, device signing steps, and simulator requirement.
