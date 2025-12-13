#!/usr/bin/env node
/**
 * Stream Chat Setup Script for weldon.vip
 * Run: node scripts/setup-stream.js
 */

const { StreamChat } = require('stream-chat');

const API_KEY = process.env.STREAM_API_KEY;
const API_SECRET = process.env.STREAM_API_SECRET;
const APP_ID = process.env.STREAM_APP_ID;

if (!API_KEY || !API_SECRET || !APP_ID) {
  console.error('Missing Stream credentials. Set STREAM_API_KEY, STREAM_API_SECRET, and STREAM_APP_ID.');
  process.exit(1);
}

async function setupStream() {
  console.log('🚀 Setting up Stream Chat for weldon.vip...\n');
  
  const serverClient = StreamChat.getInstance(API_KEY, API_SECRET);

  try {
    // 1. Create Admin User (Weldon)
    console.log('1️⃣ Creating admin user: weldon_admin');
    await serverClient.upsertUser({
      id: 'weldon_admin',
      name: 'Weldon',
      role: 'admin',
      image: 'https://ui-avatars.com/api/?name=Weldon&background=007AFF&color=fff'
    });
    console.log('   ✅ Admin user created\n');

    // 2. Create a test anonymous user
    console.log('2️⃣ Creating test anonymous user');
    await serverClient.upsertUser({
      id: 'anon_test_device_123',
      name: 'Anonymous User',
      role: 'user',
      isAnonymous: true
    });
    console.log('   ✅ Test anonymous user created\n');

    // 3. Create DM channel type if needed (messaging is default)
    console.log('3️⃣ Checking channel types...');
    const channelTypes = await serverClient.listChannelTypes();
    console.log('   Available types:', Object.keys(channelTypes.channel_types).join(', '));
    console.log('   ✅ Using "messaging" channel type\n');

    // 4. Create test DM channel between admin and anon user
    console.log('4️⃣ Creating test DM channel');
    const channel = serverClient.channel('messaging', 'dm_weldon_anon_test_device_123', {
      members: ['weldon_admin', 'anon_test_device_123'],
      created_by_id: 'anon_test_device_123'
    });
    await channel.create();
    console.log('   ✅ Test channel created: dm_weldon_anon_test_device_123\n');

    // 5. Generate tokens
    console.log('5️⃣ Generating tokens...');
    const adminToken = serverClient.createToken('weldon_admin');
    const anonToken = serverClient.createToken('anon_test_device_123');
    
    console.log('\n📋 TOKENS (save these for testing):\n');
    console.log('Admin Token (weldon_admin):');
    console.log(adminToken);
    console.log('\nAnon Token (anon_test_device_123):');
    console.log(anonToken);

    // 6. Get app settings
    console.log('\n6️⃣ Current app settings:');
    const settings = await serverClient.getAppSettings();
    console.log('   - Push notifications:', settings.app?.push_notifications?.version || 'v1');
    console.log('   - Multi-tenant:', settings.app?.multi_tenant_enabled || false);

    console.log('\n✅ Stream Chat setup complete for weldon.vip!');
    console.log('\n📝 Next steps:');
    console.log('   1. Update AppDelegate.swift with your Stream API key');
    console.log('   2. Use the admin token for Weldon\'s device');
    console.log('   3. Generate tokens server-side for production');

  } catch (error) {
    console.error('❌ Error:', error.message);
    if (error.response) {
      console.error('   Details:', JSON.stringify(error.response.data, null, 2));
    }
  }
}

setupStream();
