//
//  AdminChannelListView.swift
//  iMessageClone
//
//  weldon.vip - Admin Experience (See All Channels)
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct AdminChannelListView: View {
    @ObservedObject var authManager = AuthManager.shared
    @State private var showProfile = false
    
    var body: some View {
        iMessageChannelList(viewFactory: iMessageViewFactory())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showProfile = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("Admin")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
    }
}

#Preview {
    AdminChannelListView()
}
