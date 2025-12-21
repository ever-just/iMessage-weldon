//
//  CreateChannelView.swift
//  iMessageClone
//
//  weldon.vip - New Message (Direct Message to User)
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct CreateChannelView: View {
    @Environment(\.dismiss) var dismiss
    @Injected(\.chatClient) var chatClient: ChatClient
    
    @State private var searchText = ""
    @State private var users: [ChatUser] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var filteredUsers: [ChatUser] {
        if searchText.isEmpty {
            return users
        }
        return users.filter { user in
            let name = user.name ?? ""
            let id = user.id
            return name.localizedCaseInsensitiveContains(searchText) ||
                   id.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.top, 8)
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding()
                }
                
                if isLoading {
                    Spacer()
                    ProgressView("Loading users...")
                    Spacer()
                } else if filteredUsers.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "person.2.slash")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        Text(searchText.isEmpty ? "No users found" : "No matching users")
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                } else {
                    List {
                        ForEach(filteredUsers, id: \.id) { user in
                            Button {
                                startConversation(with: user)
                            } label: {
                                UserRow(user: user)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadUsers()
            }
        }
    }
    
    private func loadUsers() {
        isLoading = true
        errorMessage = nil
        
        // Query users from existing channels (people who have messaged before)
        let channelListController = chatClient.channelListController(
            query: .init(
                filter: .containMembers(userIds: [chatClient.currentUserId ?? ""]),
                sort: [.init(key: .lastMessageAt, isAscending: false)]
            )
        )
        
        channelListController.synchronize { error in
            DispatchQueue.main.async {
                isLoading = false
                
                if let error = error {
                    errorMessage = "Failed to load users: \(error.localizedDescription)"
                    return
                }
                
                // Extract unique users from channels (excluding current user)
                var uniqueUsers: [String: ChatUser] = [:]
                let currentUserId = chatClient.currentUserId ?? ""
                
                for channel in channelListController.channels {
                    for member in channel.lastActiveMembers {
                        if member.id != currentUserId {
                            uniqueUsers[member.id] = member
                        }
                    }
                }
                
                users = Array(uniqueUsers.values).sorted { ($0.name ?? $0.id) < ($1.name ?? $1.id) }
            }
        }
    }
    
    private func startConversation(with user: ChatUser) {
        // Create or get existing 1:1 DM channel
        let currentUserId = chatClient.currentUserId ?? ""
        
        // Create a deterministic channel ID for 1:1 DMs
        let sortedIds = [currentUserId, user.id].sorted()
        let channelId = ChannelId(type: .messaging, id: "dm-\(sortedIds.joined(separator: "-"))")
        
        do {
            let controller = try chatClient.channelController(
                createChannelWithId: channelId,
                name: nil,
                members: Set([currentUserId, user.id]),
                isCurrentUserMember: true
            )
            
            controller.synchronize { error in
                DispatchQueue.main.async {
                    if let error = error {
                        errorMessage = "Failed to start conversation: \(error.localizedDescription)"
                    } else {
                        dismiss()
                    }
                }
            }
        } catch {
            errorMessage = "Failed to start conversation: \(error.localizedDescription)"
        }
    }
}

// MARK: - User Row

private struct UserRow: View {
    let user: ChatUser
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            if let imageURL = user.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    userInitialsView
                }
                .frame(width: 44, height: 44)
                .clipShape(Circle())
            } else {
                userInitialsView
            }
            
            // Name and status
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name ?? user.id)
                    .font(.body)
                    .foregroundColor(.primary)
                
                if user.isOnline {
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                } else if let lastActive = user.lastActiveAt {
                    Text("Last seen \(lastActive.formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
    
    private var userInitialsView: some View {
        Circle()
            .fill(Color.blue)
            .frame(width: 44, height: 44)
            .overlay(
                Text(initials)
                    .font(.headline)
                    .foregroundColor(.white)
            )
    }
    
    private var initials: String {
        let name = user.name ?? user.id
        let components = name.components(separatedBy: " ")
        if components.count >= 2 {
            return String(components[0].prefix(1) + components[1].prefix(1)).uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }
}

#Preview {
    CreateChannelView()
}
