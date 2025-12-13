//
//  StandardUserView.swift
//  iMessageClone
//
//  weldon.vip - Standard User Experience (Single Channel to Admin)
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct StandardUserView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Injected(\.chatClient) var chatClient
    @State private var channelController: ChatChannelController?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    VStack {
                        ProgressView()
                        Text("Connecting to Weldon...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)
                    }
                } else if let controller = channelController {
                    let factory = StandardUserViewFactory()
                    let _ = factory.channelId = controller.cid
                    ChatChannelView(
                        viewFactory: factory,
                        channelController: controller
                    )
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text("Start a conversation with Weldon")
                            .font(.headline)
                        Button("Send First Message") {
                            createChannelWithAdmin()
                        }
                        .buttonStyle(.borderedProminent)
                        
                        if let error = errorMessage {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
            }
            .onAppear {
                loadOrCreateChannel()
            }
            .onChange(of: authManager.currentUser?.id) { _ in
                // Reload channel when user changes (e.g., after sign in)
                loadOrCreateChannel()
            }
        }
    }
    
    private func loadOrCreateChannel() {
        guard let userId = authManager.currentUser?.id else {
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        let channelId = ChannelId(type: .messaging, id: "dm_weldon_\(userId)")
        let userName = authManager.currentUser?.name ?? "User"
        
        // Try to create the channel with admin as member
        do {
            let controller = try chatClient.channelController(
                createChannelWithId: channelId,
                name: userName,
                imageURL: nil,
                members: [userId, AuthManager.adminStreamId],
                isCurrentUserMember: true
            )
            
            controller.synchronize { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Channel sync error: \(error)")
                        self.errorMessage = error.localizedDescription
                    } else {
                        self.channelController = controller
                    }
                    self.isLoading = false
                }
            }
        } catch {
            print("Channel creation error: \(error)")
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func createChannelWithAdmin() {
        loadOrCreateChannel()
    }
}

#Preview {
    StandardUserView()
}
