//
//  StandardUserChannelInfoView.swift
//  iMessageClone
//
//  weldon.vip - Simplified channel info for standard users with sign out
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct StandardUserChannelInfoView: View {
    let channel: ChatChannel
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var isSigningOut = false
    
    var body: some View {
        NavigationView {
            List {
                // User Info Section
                Section {
                    HStack(spacing: 16) {
                        // Admin avatar
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Text("W")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Weldon")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Online")
                                .font(.subheadline)
                                .foregroundColor(.green)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
                
                // Your Account Section
                Section {
                    if let user = authManager.currentUser {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.body)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                } header: {
                    Text("Your Account")
                }
                
                // Sign Out Section
                Section {
                    Button(role: .destructive) {
                        signOut()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sign Out")
                        }
                    }
                    .disabled(isSigningOut)
                }
            }
            .navigationTitle("Chat Info")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if isSigningOut {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                    ProgressView("Signing out...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                }
            }
        }
    }
    
    private func signOut() {
        isSigningOut = true
        Task {
            await authManager.signOut()
            await MainActor.run {
                isSigningOut = false
                dismiss()
            }
        }
    }
}
