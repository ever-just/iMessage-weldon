//
//  AppConfig.swift
//  iMessageClone
//
//  weldon.vip - Development
//

import Foundation

enum AppConfig {
    // MARK: - Stream Chat
    static let streamAPIKey = "229zp48dkgz2"
    static let streamAppId = "1459583"
    
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
