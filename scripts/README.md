# Scripts

Development and debugging scripts for the weldon.vip iMessage Clone.

## Prerequisites

```bash
cd scripts
npm install
```

## Environment Variables

All scripts require Stream Chat credentials:

```bash
export STREAM_API_KEY="your_api_key"
export STREAM_API_SECRET="your_api_secret"
export STREAM_APP_ID="your_app_id"  # Only for setup-stream.js
```

## Available Scripts

### setup-stream.js

Initial setup script for Stream Chat. Creates admin user, test users, and test channels.

```bash
node setup-stream.js
```

**What it does:**
- Creates `weldon_admin` user with admin role
- Creates test anonymous user
- Creates test DM channel
- Generates tokens for testing

### debug-messages.js

Debug message sending issues between users.

```bash
node debug-messages.js
```

**What it does:**
- Verifies users exist
- Checks channel membership
- Tests message sending as a user
- Queries recent messages

### register-anon-user.js

Register a new anonymous user and create their DM channel with admin.

```bash
node register-anon-user.js <user_id>
```

**Example:**
```bash
node register-anon-user.js anon_ABC12345
```

**What it does:**
- Creates/updates user in Stream
- Creates DM channel with admin
- Generates and outputs user token

### test-user-interactions.js

Comprehensive test of admin vs standard user experiences.

```bash
node test-user-interactions.js
```

**What it does:**
- Creates admin, authenticated users, and anonymous user
- Creates DM channels for each user
- Sends test messages
- Demonstrates channel access differences
- Generates tokens for all test users

## Output

All scripts output tokens that can be used for testing in the iOS app. Copy the relevant token and use it in your development environment.
