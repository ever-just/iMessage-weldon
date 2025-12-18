//
//  SignOutButton.swift
//  iMessageClone
//
//  weldon.vip - Shared sign-out button component
//

import SwiftUI

struct SignOutButton: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var isSigningOut = false
    
    var body: some View {
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

struct SignOutOverlay: View {
    let isSigningOut: Bool
    
    var body: some View {
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

#Preview {
    SignOutButton()
}
