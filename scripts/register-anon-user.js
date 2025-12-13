#!/usr/bin/env node
/**
 * Register an anonymous user on Stream
 * Usage: node register-anon-user.js <user_id>
 */

const { StreamChat } = require('stream-chat');

const API_KEY = process.env.STREAM_API_KEY;
const API_SECRET = process.env.STREAM_API_SECRET;

if (!API_KEY || !API_SECRET) {
  console.error('Missing Stream credentials. Set STREAM_API_KEY and STREAM_API_SECRET.');
  process.exit(1);
}

const userId = process.argv[2];

if (!userId) {
  console.log('Usage: node register-anon-user.js <user_id>');
  console.log('Example: node register-anon-user.js anon_ABC12345');
  process.exit(1);
}

async function registerUser() {
  console.log(`Registering user: ${userId}\n`);
  
  const serverClient = StreamChat.getInstance(API_KEY, API_SECRET);
  
  try {
    // Create/update user
    await serverClient.upsertUser({
      id: userId,
      name: userId.startsWith('anon_') ? 'Anonymous' : userId,
      role: 'user',
      image: 'https://ui-avatars.com/api/?name=?&background=8E8E93&color=fff'
    });
    console.log('✅ User registered');
    
    // Create channel with admin
    const channelId = `dm_weldon_${userId}`;
    const channel = serverClient.channel('messaging', channelId, {
      members: ['weldon_admin', userId],
      created_by_id: userId
    });
    await channel.create();
    console.log(`✅ Channel created: ${channelId}`);
    
    // Generate token
    const token = serverClient.createToken(userId);
    console.log(`\n📝 Token for ${userId}:`);
    console.log(token);
    
  } catch (error) {
    console.error('❌ Error:', error.message);
  }
}

registerUser();
