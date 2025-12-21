//
//  CreateChannelView.swift
//  iMessageClone
//
//  weldon.vip - Create New Channel
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct CreateChannelView: View {
    @Environment(\.dismiss) var dismiss
    @Injected(\.chatClient) var chatClient: ChatClient
    
    @State private var channelName = ""
    @State private var selectedUserIds: Set<String> = []
    @State private var searchText = ""
    @State private var isCreating = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .padding()
                }
                
                Form {
                    Section(header: Text("Channel Name")) {
                        TextField("Enter channel name", text: $channelName)
                    }
                    
                    Section(header: Text("Add Users")) {
                        TextField("Search users by name or ID", text: $searchText)
                            .textInputAutocapitalization(.never)
                        
                        if !selectedUserIds.isEmpty {
                            ForEach(Array(selectedUserIds), id: \.self) { userId in
                                HStack {
                                    Text(userId)
                                    Spacer()
                                    Button {
                                        selectedUserIds.remove(userId)
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        
                        Button {
                            addUserBySearch()
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add User")
                            }
                        }
                        .disabled(searchText.isEmpty)
                    }
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
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        createChannel()
                    }
                    .disabled(channelName.isEmpty || selectedUserIds.isEmpty || isCreating)
                }
            }
        }
    }
    
    private func addUserBySearch() {
        let userId = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !userId.isEmpty else { return }
        
        selectedUserIds.insert(userId)
        searchText = ""
    }
    
    private func createChannel() {
        isCreating = true
        errorMessage = nil
        
        let channelId = ChannelId(
            type: .messaging,
            id: UUID().uuidString
        )
        
        do {
            let controller = try chatClient.channelController(
                createChannelWithId: channelId,
                name: channelName,
                members: selectedUserIds,
                isCurrentUserMember: true
            )
            
            controller.synchronize { error in
                DispatchQueue.main.async {
                    isCreating = false
                    
                    if let error = error {
                        errorMessage = "Failed to create channel: \(error.localizedDescription)"
                    } else {
                        dismiss()
                    }
                }
            }
        } catch {
            isCreating = false
            errorMessage = "Failed to create channel: \(error.localizedDescription)"
        }
    }
}

#Preview {
    CreateChannelView()
}
