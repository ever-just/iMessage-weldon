# iMessageClone Tests

## Setup Instructions

To add the test target to Xcode:

1. Open `iMessageClone.xcodeproj` in Xcode
2. Go to **File > New > Target**
3. Select **iOS > Unit Testing Bundle**
4. Name it `iMessageCloneTests`
5. Ensure "Target to be Tested" is set to `iMessageClone`
6. Click **Finish**
7. Delete the auto-generated test file
8. Drag `iMessageCloneTests.swift` into the test target

## Running Tests

- Press `Cmd + U` to run all tests
- Or use **Product > Test**

## Test Coverage

Current tests cover:
- `AppConfig` - Admin user ID, channel prefix
- `AuthManager` - Singleton pattern

## Adding New Tests

Add new test methods to `iMessageCloneTests.swift` or create new test files in this folder.
