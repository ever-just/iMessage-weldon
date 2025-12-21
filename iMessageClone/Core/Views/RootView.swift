//
//  RootView.swift
//  iMessageClone
//
//  weldon.vip - Root View with Supabase Auth
//

import SwiftUI
import StreamChat
import StreamChatSwiftUI

struct RootView: View {
    @StateObject var authManager = AuthManager.shared
    
    var body: some View {
        Group {
            if authManager.isLoading {
                LaunchView()
            } else if !authManager.isAuthenticated {
                AuthView()
            } else if authManager.isAdmin {
                AdminChannelListView()
            } else {
                StandardUserView()
            }
        }
    }
}

struct LaunchView: View {
    var body: some View {
        VStack {
            Image(systemName: "message.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("weldon.vip")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 8)
            ProgressView()
                .padding(.top, 16)
        }
    }
}

#Preview {
    RootView()
}
