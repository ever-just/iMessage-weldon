//
//  AppConfig.swift
//  iMessageClone
//
//  weldon.vip - Development
//

import Foundation

enum AppConfig {
    
    // MARK: - Secrets Loading
    private static let secrets: [String: Any] = {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: Any] else {
            fatalError("Secrets.plist not found. Copy Secrets.template.plist to Secrets.plist and fill in your credentials.")
        }
        return dict
    }()
    
    // MARK: - Stream Chat
    static var streamAPIKey: String {
        secrets["StreamAPIKey"] as? String ?? ""
    }
    
    static var streamAppId: String {
        secrets["StreamAppId"] as? String ?? ""
    }
    
    static var streamAPISecret: String {
        secrets["StreamAPISecret"] as? String ?? ""
    }
    
    // MARK: - Supabase
    static var supabaseURL: String {
        secrets["SupabaseURL"] as? String ?? ""
    }
    
    static var supabaseAnonKey: String {
        secrets["SupabaseAnonKey"] as? String ?? ""
    }
    
    // MARK: - Admin User
    static let adminUserId = "weldon_admin"
    static let adminDisplayName = "Weldon"
    
    // MARK: - Environment
    #if DEBUG
    static let environment = "development"
    static let isDebug = true
    #else
    static let environment = "production"
    static let isDebug = false
    #endif
    
    // MARK: - Channel Naming
    static func dmChannelId(for userId: String) -> String {
        return "dm_weldon_\(userId)"
    }
    
    // MARK: - Anonymous User
    static func anonymousUserId(deviceId: String) -> String {
        return "anon_\(deviceId)"
    }
}
