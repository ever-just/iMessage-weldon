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

let supabase: SupabaseClient = {
    guard let url = URL(string: AppConfig.supabaseURL) else {
        fatalError("Invalid Supabase URL in Secrets.plist. Please check your configuration.")
    }
    return SupabaseClient(
        supabaseURL: url,
        supabaseKey: AppConfig.supabaseAnonKey,
        options: SupabaseClientOptions(
            auth: SupabaseClientOptions.AuthOptions(
                emitLocalSessionAsInitialSession: true
            )
        )
    )
}()
