#!/usr/bin/env node
/**
 * Test User Interactions for weldon.vip
 * Demonstrates admin vs standard user experiences
 * 
 * Run: node scripts/test-user-interactions.js
 */

const { StreamChat } = require('stream-chat');

const API_KEY = process.env.STREAM_API_KEY;
const API_SECRET = process.env.STREAM_API_SECRET;

if (!API_KEY || !API_SECRET) {
  console.error('Missing Stream credentials. Set STREAM_API_KEY and STREAM_API_SECRET.');
  process.exit(1);
}

// User IDs
const ADMIN_USER_ID = 'weldon_admin';
const STANDARD_USER_1 = 'user_alice_123';
const STANDARD_USER_2 = 'user_bob_456';
const ANON_USER = 'anon_device_xyz789';

async function testUserInteractions() {
  console.log('═══════════════════════════════════════════════════════════');
  console.log('   weldon.vip - User Interaction Test');
  console.log('═══════════════════════════════════════════════════════════\n');

  const serverClient = StreamChat.getInstance(API_KEY, API_SECRET);

  try {
    // ═══════════════════════════════════════════════════════════
    // STEP 1: Create Users
    // ═══════════════════════════════════════════════════════════
    console.log('📋 STEP 1: Creating Users\n');

    // Admin user (Weldon)
    await serverClient.upsertUser({
      id: ADMIN_USER_ID,
      name: 'Weldon',
      role: 'admin',
      image: 'https://ui-avatars.com/api/?name=Weldon&background=007AFF&color=fff',
      userType: 'admin'
    });
    console.log('   ✅ Admin: weldon_admin');

    // Standard user 1 (Alice - authenticated)
    await serverClient.upsertUser({
      id: STANDARD_USER_1,
      name: 'Alice',
      role: 'user',
      image: 'https://ui-avatars.com/api/?name=Alice&background=34C759&color=fff',
      userType: 'standard',
      isAnonymous: false
    });
    console.log('   ✅ Standard User: Alice (authenticated)');

    // Standard user 2 (Bob - authenticated)
    await serverClient.upsertUser({
      id: STANDARD_USER_2,
      name: 'Bob',
      role: 'user',
      image: 'https://ui-avatars.com/api/?name=Bob&background=FF9500&color=fff',
      userType: 'standard',
      isAnonymous: false
    });
    console.log('   ✅ Standard User: Bob (authenticated)');

    // Anonymous user
    await serverClient.upsertUser({
      id: ANON_USER,
      name: 'Anonymous',
      role: 'user',
      image: 'https://ui-avatars.com/api/?name=?&background=8E8E93&color=fff',
      userType: 'standard',
      isAnonymous: true
    });
    console.log('   ✅ Anonymous User: anon_device_xyz789\n');

    // ═══════════════════════════════════════════════════════════
    // STEP 2: Create DM Channels (each user -> admin)
    // ═══════════════════════════════════════════════════════════
    console.log('📋 STEP 2: Creating DM Channels\n');

    // Alice <-> Weldon
    const aliceChannel = serverClient.channel('messaging', `dm_weldon_${STANDARD_USER_1}`, {
      members: [ADMIN_USER_ID, STANDARD_USER_1],
      created_by_id: STANDARD_USER_1,
      name: 'Alice → Weldon'
    });
    await aliceChannel.create();
    console.log('   ✅ Channel: dm_weldon_user_alice_123');

    // Bob <-> Weldon
    const bobChannel = serverClient.channel('messaging', `dm_weldon_${STANDARD_USER_2}`, {
      members: [ADMIN_USER_ID, STANDARD_USER_2],
      created_by_id: STANDARD_USER_2,
      name: 'Bob → Weldon'
    });
    await bobChannel.create();
    console.log('   ✅ Channel: dm_weldon_user_bob_456');

    // Anon <-> Weldon
    const anonChannel = serverClient.channel('messaging', `dm_weldon_${ANON_USER}`, {
      members: [ADMIN_USER_ID, ANON_USER],
      created_by_id: ANON_USER,
      name: 'Anonymous → Weldon'
    });
    await anonChannel.create();
    console.log('   ✅ Channel: dm_weldon_anon_device_xyz789\n');

    // ═══════════════════════════════════════════════════════════
    // STEP 3: Send Test Messages
    // ═══════════════════════════════════════════════════════════
    console.log('📋 STEP 3: Sending Test Messages\n');

    // Alice sends message to Weldon
    await aliceChannel.sendMessage({
      text: 'Hey Weldon! This is Alice. I signed up for your app!',
      user_id: STANDARD_USER_1
    });
    console.log('   📨 Alice → Weldon: "Hey Weldon! This is Alice..."');

    // Weldon replies to Alice
    await aliceChannel.sendMessage({
      text: 'Welcome Alice! Great to have you here. How can I help?',
      user_id: ADMIN_USER_ID
    });
    console.log('   📨 Weldon → Alice: "Welcome Alice! Great to have you..."');

    // Bob sends message to Weldon
    await bobChannel.sendMessage({
      text: 'Hi! I have a question about the service.',
      user_id: STANDARD_USER_2
    });
    console.log('   📨 Bob → Weldon: "Hi! I have a question..."');

    // Anonymous user sends message
    await anonChannel.sendMessage({
      text: 'Hello, I want to try the app before signing up.',
      user_id: ANON_USER
    });
    console.log('   📨 Anonymous → Weldon: "Hello, I want to try..."');

    // Weldon replies to anonymous
    await anonChannel.sendMessage({
      text: 'Of course! Feel free to ask anything. You can sign up anytime to save your messages.',
      user_id: ADMIN_USER_ID
    });
    console.log('   📨 Weldon → Anonymous: "Of course! Feel free..."\n');

    // ═══════════════════════════════════════════════════════════
    // STEP 4: Demonstrate Channel Access Differences
    // ═══════════════════════════════════════════════════════════
    console.log('═══════════════════════════════════════════════════════════');
    console.log('   USER EXPERIENCE COMPARISON');
    console.log('═══════════════════════════════════════════════════════════\n');

    // Query all channels (what admin sees)
    const adminChannels = await serverClient.queryChannels(
      { members: { $in: [ADMIN_USER_ID] } },
      { last_message_at: -1 },
      { user_id: ADMIN_USER_ID }
    );

    console.log('👑 ADMIN VIEW (Weldon):');
    console.log('   Can see ALL channels:');
    adminChannels.forEach((ch, i) => {
      const otherMember = ch.state.members ? 
        Object.keys(ch.state.members).find(m => m !== ADMIN_USER_ID) : 'unknown';
      const isAnon = otherMember?.startsWith('anon_');
      console.log(`   ${i + 1}. ${ch.id} ${isAnon ? '(Anonymous)' : ''}`);
    });
    console.log(`   Total: ${adminChannels.length} conversations\n`);

    // Query channels for Alice (what standard user sees)
    const aliceChannels = await serverClient.queryChannels(
      { members: { $in: [STANDARD_USER_1] } },
      { last_message_at: -1 },
      { user_id: STANDARD_USER_1 }
    );

    console.log('👤 STANDARD USER VIEW (Alice):');
    console.log('   Can only see their own channel:');
    aliceChannels.forEach((ch, i) => {
      console.log(`   ${i + 1}. ${ch.id}`);
    });
    console.log(`   Total: ${aliceChannels.length} conversation(s)\n`);

    // Query channels for Anonymous
    const anonChannels = await serverClient.queryChannels(
      { members: { $in: [ANON_USER] } },
      { last_message_at: -1 },
      { user_id: ANON_USER }
    );

    console.log('👻 ANONYMOUS USER VIEW:');
    console.log('   Can only see their own channel:');
    anonChannels.forEach((ch, i) => {
      console.log(`   ${i + 1}. ${ch.id}`);
    });
    console.log(`   Total: ${anonChannels.length} conversation(s)\n`);

    // ═══════════════════════════════════════════════════════════
    // STEP 5: Generate Tokens for Testing
    // ═══════════════════════════════════════════════════════════
    console.log('═══════════════════════════════════════════════════════════');
    console.log('   TOKENS FOR TESTING IN iOS APP');
    console.log('═══════════════════════════════════════════════════════════\n');

    const adminToken = serverClient.createToken(ADMIN_USER_ID);
    const aliceToken = serverClient.createToken(STANDARD_USER_1);
    const bobToken = serverClient.createToken(STANDARD_USER_2);
    const anonToken = serverClient.createToken(ANON_USER);

    console.log('Admin (weldon_admin):');
    console.log(`   ${adminToken}\n`);
    console.log('Alice (user_alice_123):');
    console.log(`   ${aliceToken}\n`);
    console.log('Bob (user_bob_456):');
    console.log(`   ${bobToken}\n`);
    console.log('Anonymous (anon_device_xyz789):');
    console.log(`   ${anonToken}\n`);

    // ═══════════════════════════════════════════════════════════
    // Summary
    // ═══════════════════════════════════════════════════════════
    console.log('═══════════════════════════════════════════════════════════');
    console.log('   SUMMARY: UI EXPERIENCE DIFFERENCES');
    console.log('═══════════════════════════════════════════════════════════\n');
    console.log('┌─────────────────┬────────────────────────────────────────┐');
    console.log('│ Feature         │ Admin (Weldon)  │ Standard User        │');
    console.log('├─────────────────┼─────────────────┼──────────────────────┤');
    console.log('│ Channel List    │ See ALL users   │ See ONLY admin chat  │');
    console.log('│ Start Chat      │ With anyone     │ Only with admin      │');
    console.log('│ View Messages   │ All channels    │ Own channel only     │');
    console.log('│ User Info       │ See all users   │ See admin only       │');
    console.log('│ Notifications   │ From all users  │ From admin only      │');
    console.log('└─────────────────┴─────────────────┴──────────────────────┘\n');

    console.log('✅ Test complete! You can now test in the iOS app by:');
    console.log('   1. Use admin token in AppDelegate to see all channels');
    console.log('   2. Switch to Alice/Bob token to see single channel view');
    console.log('   3. Messages will sync in real-time between users\n');

  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.response) {
      console.error('   Details:', JSON.stringify(error.response.data, null, 2));
    }
  }
}

testUserInteractions();
