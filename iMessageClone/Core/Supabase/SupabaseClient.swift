//
//  SupabaseClient.swift
//  iMessageClone
//
//  weldon.vip - Supabase Configuration
//

import Foundation
import Supabase

// MARK: - Supabase Client
// Credentials are loaded from Secrets.plist via AppConfig

let supabase = SupabaseClient(
    supabaseURL: URL(string: AppConfig.supabaseURL)!,
    supabaseKey: AppConfig.supabaseAnonKey
)
