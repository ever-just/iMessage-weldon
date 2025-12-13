//
//  AuthManager.swift
//  iMessageClone
//
//  weldon.vip - Authentication Manager with Supabase
//

import Foundation
import SwiftUI
import StreamChat
import StreamChatSwiftUI
import CommonCrypto
import Supabase

enum UserType: String, Codable {
    case admin
    case standard
}

struct AppUser: Codable {
    let id: String
    let email: String
    let name: String
    let userType: UserType
    let imageURL: String?
    
    var streamUserInfo: UserInfo {
        UserInfo(
            id: id,
            name: name,
            imageURL: imageURL.flatMap { URL(string: $0) }
        )
    }
}

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    
    @Injected(\.chatClient) var chatClient: ChatClient
    
    @Published var currentUser: AppUser?
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    
    private let userDefaultsKey = "weldon_current_user"
    private let adminUserIdKey = "weldon_admin_user_id"
    
    // Stream API Secret for generating tokens
    private var streamApiSecret: String { AppConfig.streamAPISecret }
    
    // Admin email for checking admin status
    private let adminEmail = "weldon@weldon.vip"
    
    // Fixed admin Stream ID - used for channel creation
    static let adminStreamId = "weldon_admin"
    
    private init() {
        Task {
            await checkExistingSession()
        }
    }
    
    // MARK: - Supabase Auth
    
    func signUpWithEmail(email: String, password: String, name: String) async throws {
        await MainActor.run { isLoading = true }
        
        do {
            // Sign up with Supabase
            let response = try await supabase.auth.signUp(
                email: email,
                password: password,
                data: ["name": .string(name)]
            )
            
            let supabaseUserId = response.user.id.uuidString
            
            // Determine user type
            let userType: UserType = email.lowercased() == adminEmail.lowercased() ? .admin : .standard
            
            // Use fixed admin ID for Stream, or Supabase UUID for standard users
            let streamUserId = userType == .admin ? AuthManager.adminStreamId : supabaseUserId
            
            // Create app user
            let user = AppUser(
                id: streamUserId,
                email: email,
                name: name,
                userType: userType,
                imageURL: "https://ui-avatars.com/api/?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "User")&background=007AFF&color=fff"
            )
            
            // Connect to Stream
            try await connectToStream(user: user)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
                self.saveUser(user)
            }
        } catch {
            await MainActor.run { isLoading = false }
            throw error
        }
    }
    
    func signInWithEmail(email: String, password: String) async throws {
        await MainActor.run { isLoading = true }
        
        do {
            // Sign in with Supabase
            let session = try await supabase.auth.signIn(
                email: email,
                password: password
            )
            
            let supabaseUserId = session.user.id.uuidString
            let name = session.user.userMetadata["name"]?.stringValue ?? email.components(separatedBy: "@").first ?? "User"
            
            // Determine user type
            let userType: UserType = email.lowercased() == adminEmail.lowercased() ? .admin : .standard
            
            // Use fixed admin ID for Stream, or Supabase UUID for standard users
            let streamUserId = userType == .admin ? AuthManager.adminStreamId : supabaseUserId
            
            // Create app user
            let user = AppUser(
                id: streamUserId,
                email: email,
                name: name,
                userType: userType,
                imageURL: "https://ui-avatars.com/api/?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "User")&background=007AFF&color=fff"
            )
            
            // Connect to Stream
            try await connectToStream(user: user)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
                self.isLoading = false
                self.saveUser(user)
            }
        } catch {
            await MainActor.run { isLoading = false }
            throw error
        }
    }
    
    func signOut() async {
        do {
            try await supabase.auth.signOut()
        } catch {
            print("Supabase sign out error: \(error)")
        }
        
        await chatClient.logout()
        
        await MainActor.run {
            currentUser = nil
            isAuthenticated = false
            clearSavedUser()
        }
    }
    
    // MARK: - Session Management
    
    private func checkExistingSession() async {
        do {
            let session = try await supabase.auth.session
            if session.isExpired {
                do {
                    try await supabase.auth.signOut()
                } catch {
                    print("Supabase sign out error: \(error)")
                }

                await MainActor.run {
                    self.currentUser = nil
                    self.isAuthenticated = false
                }
                return
            }
            let supabaseUserId = session.user.id.uuidString
            let email = session.user.email ?? ""
            let name = session.user.userMetadata["name"]?.stringValue ?? email.components(separatedBy: "@").first ?? "User"
            let userType: UserType = email.lowercased() == adminEmail.lowercased() ? .admin : .standard
            
            // Use fixed admin ID for Stream, or Supabase UUID for standard users
            let streamUserId = userType == .admin ? AuthManager.adminStreamId : supabaseUserId
            
            let user = AppUser(
                id: streamUserId,
                email: email,
                name: name,
                userType: userType,
                imageURL: "https://ui-avatars.com/api/?name=\(name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "User")&background=007AFF&color=fff"
            )
            
            try await connectToStream(user: user)
            
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
            }
        } catch {
            // No existing session or session expired
            await MainActor.run {
                self.isAuthenticated = false
            }
        }
    }
    
    // MARK: - Stream Connection
    
    private func connectToStream(user: AppUser) async throws {
        let tokenString = generateStreamToken(for: user.id)
        let streamToken = try Token(rawValue: tokenString)
        
        return try await withCheckedThrowingContinuation { continuation in
            chatClient.connectUser(
                userInfo: user.streamUserInfo,
                token: streamToken
            ) { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    private func generateStreamToken(for userId: String) -> String {
        let header = "{\"alg\":\"HS256\",\"typ\":\"JWT\"}"
        let payload = "{\"user_id\":\"\(userId)\"}"
        
        let headerBase64 = Data(header.utf8).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        let payloadBase64 = Data(payload.utf8).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
        
        let signatureInput = "\(headerBase64).\(payloadBase64)"
        let signature = hmacSHA256(signatureInput, key: streamApiSecret)
        
        return "\(headerBase64).\(payloadBase64).\(signature)"
    }
    
    private func hmacSHA256(_ message: String, key: String) -> String {
        let keyData = key.data(using: .utf8)!
        let messageData = message.data(using: .utf8)!
        
        var hmac = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        keyData.withUnsafeBytes { keyBytes in
            messageData.withUnsafeBytes { messageBytes in
                CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256),
                       keyBytes.baseAddress, keyData.count,
                       messageBytes.baseAddress, messageData.count,
                       &hmac)
            }
        }
        
        return Data(hmac).base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }
    
    // MARK: - Persistence
    
    private func saveUser(_ user: AppUser) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func clearSavedUser() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
    
    // MARK: - Helpers
    
    var isAdmin: Bool {
        currentUser?.userType == .admin
    }
}

enum AuthError: LocalizedError {
    case signUpFailed
    case signInFailed
    case connectionFailed
    
    var errorDescription: String? {
        switch self {
        case .signUpFailed:
            return "Failed to create account"
        case .signInFailed:
            return "Failed to sign in"
        case .connectionFailed:
            return "Failed to connect to chat service"
        }
    }
}
