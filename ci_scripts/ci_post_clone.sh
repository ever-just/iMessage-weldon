#!/bin/bash

# ci_post_clone.sh
# This script runs after Xcode Cloud clones the repository.
# It generates Secrets.plist from environment variables.

set -e

echo "🔐 Generating Secrets.plist from environment variables..."

SECRETS_PATH="$CI_PRIMARY_REPOSITORY_PATH/iMessageClone/Config/Secrets.plist"

# Check if required environment variables are set
if [ -z "$SUPABASE_URL" ] || [ -z "$SUPABASE_ANON_KEY" ] || [ -z "$STREAM_API_KEY" ]; then
    echo "❌ Error: Required environment variables are not set."
    echo "Please set: SUPABASE_URL, SUPABASE_ANON_KEY, STREAM_API_KEY, STREAM_APP_ID, STREAM_API_SECRET"
    exit 1
fi

# Generate Secrets.plist
cat > "$SECRETS_PATH" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>SupabaseURL</key>
    <string>${SUPABASE_URL}</string>
    <key>SupabaseAnonKey</key>
    <string>${SUPABASE_ANON_KEY}</string>
    <key>StreamAPIKey</key>
    <string>${STREAM_API_KEY}</string>
    <key>StreamAppId</key>
    <string>${STREAM_APP_ID}</string>
    <key>StreamAPISecret</key>
    <string>${STREAM_API_SECRET}</string>
</dict>
</plist>
EOF

echo "✅ Secrets.plist generated successfully at $SECRETS_PATH"
