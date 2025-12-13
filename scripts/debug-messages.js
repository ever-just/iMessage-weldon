#!/usr/bin/env node
/**
 * Debug message sending between users
 */

const { StreamChat } = require('stream-chat');

const API_KEY = process.env.STREAM_API_KEY;
const API_SECRET = process.env.STREAM_API_SECRET;

if (!API_KEY || !API_SECRET) {
  console.error('Missing Stream credentials. Set STREAM_API_KEY and STREAM_API_SECRET.');
  process.exit(1);
}

async function debug() {
  console.log('🔍 Debugging message sending...\n');
  
  const serverClient = StreamChat.getInstance(API_KEY, API_SECRET);
  
  try {
    // 1. Check users exist
    console.log('1. Checking users...');
    const { users } = await serverClient.queryUsers({
      id: { $in: ['weldon_admin', 'user_alice_123'] }
    });
    
    users.forEach(u => {
      console.log(`   ✅ ${u.id} - role: ${u.role}, banned: ${u.banned || false}`);
    });
    
    // 2. Check channel exists and members
    console.log('\n2. Checking channel dm_weldon_user_alice_123...');
    const channel = serverClient.channel('messaging', 'dm_weldon_user_alice_123');
    await channel.watch();
    
    console.log(`   Members: ${Object.keys(channel.state.members).join(', ')}`);
    console.log(`   Channel data:`, JSON.stringify(channel.data, null, 2));
    
    // 3. Check channel type permissions
    console.log('\n3. Checking messaging channel type permissions...');
    const { channel_types } = await serverClient.getChannelType('messaging');
    console.log('   Permissions:', JSON.stringify(channel_types?.messaging?.permissions || 'default', null, 2));
    
    // 4. Test sending message as Alice
    console.log('\n4. Testing message send as Alice...');
    const aliceClient = StreamChat.getInstance(API_KEY, API_SECRET);
    const aliceToken = serverClient.createToken('user_alice_123');
    
    await aliceClient.connectUser(
      { id: 'user_alice_123', name: 'Alice' },
      aliceToken
    );
    
    const aliceChannel = aliceClient.channel('messaging', 'dm_weldon_user_alice_123');
    await aliceChannel.watch();
    
    const response = await aliceChannel.sendMessage({
      text: `Test message from Alice at ${new Date().toISOString()}`
    });
    
    console.log('   ✅ Message sent successfully!');
    console.log('   Message ID:', response.message.id);
    
    // 5. Query recent messages
    console.log('\n5. Recent messages in channel:');
    const messages = await aliceChannel.query({ messages: { limit: 5 } });
    messages.messages.forEach(m => {
      console.log(`   - [${m.user.id}]: ${m.text}`);
    });
    
    await aliceClient.disconnectUser();
    
    console.log('\n✅ Debug complete - messages should be working!');
    
  } catch (error) {
    console.error('\n❌ Error:', error.message);
    if (error.code) console.error('   Code:', error.code);
    if (error.response?.data) {
      console.error('   Details:', JSON.stringify(error.response.data, null, 2));
    }
  }
}

debug();
