//
//  AppConfig.swift
//  iMessageClone
//
//  weldon.vip - Development
//

import Foundation

enum AppConfigLegacy {
    // MARK: - Admin User
    static let adminUserId = "weldon_admin"
    static let adminDisplayName = "Weldon"
    
    // MARK: - Channel Naming
    static func dmChannelId(for userId: String) -> String {
        return "dm_weldon_\(userId)"
    }
    
    // MARK: - Anonymous User
    static func anonymousUserId(deviceId: String) -> String {
        return "anon_\(deviceId)"
    }
}
