//
//  CustomChannelInfoView.swift
//  iMessageClone
//
//  weldon.vip - Custom channel info with Sign Out, without Pinned Messages/Mute User
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct CustomChannelInfoView: View {
    let channel: ChatChannel
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var isSigningOut = false
    
    private var isAdmin: Bool {
        authManager.currentUser?.id == AppConfig.adminUserId
    }
    
    private var otherMembers: [ChatChannelMember] {
        channel.lastActiveMembers.filter { $0.id != authManager.currentUser?.id }
    }
    
    var body: some View {
        NavigationView {
            List {
                // Channel Members Section
                Section {
                    ForEach(channel.lastActiveMembers, id: \.id) { member in
                        MemberRow(member: member, isCurrentUser: member.id == authManager.currentUser?.id)
                    }
                }
                
                // Photos & Videos Section
                Section {
                    NavigationLink {
                        Text("Photos & Videos")
                    } label: {
                        HStack {
                            Image(systemName: "photo.on.rectangle")
                                .foregroundColor(.gray)
                            Text("Photos & Videos")
                        }
                    }
                }
                
                // Files Section
                Section {
                    NavigationLink {
                        Text("Files")
                    } label: {
                        HStack {
                            Image(systemName: "doc")
                                .foregroundColor(.gray)
                            Text("Files")
                        }
                    }
                }
                
                // Your Account Section
                Section {
                    if let user = authManager.currentUser {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                            VStack(alignment: .leading, spacing: 2) {
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

// MARK: - Member Row
private struct MemberRow: View {
    let member: ChatChannelMember
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            if let imageURL = member.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.blue)
                        .overlay(
                            Text(String(member.name?.prefix(1).uppercased() ?? "?"))
                                .font(.headline)
                                .foregroundColor(.white)
                        )
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Text(String(member.name?.prefix(1).uppercased() ?? "?"))
                            .font(.headline)
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(member.name ?? member.id)
                        .font(.body)
                    if isCurrentUser {
                        Text("(You)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Online status
                if member.isOnline {
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if let lastActive = member.lastActiveAt {
                    Text("last seen \(lastActive.formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
