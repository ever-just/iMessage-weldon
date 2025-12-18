//
//  ProfileView.swift
//  iMessageClone
//
//  weldon.vip - Profile & Sign Out
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var authManager = AuthManager.shared
    @Environment(\.dismiss) var dismiss
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            List {
                // Current User Section
                Section {
                    if let user = authManager.currentUser {
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: user.imageURL ?? "")) { image in
                                image.resizable()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text(user.userType == .admin ? "Admin" : "Member")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(user.userType == .admin ? Color.blue : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
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
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
            }
        }
    }
    
    private func signOut() {
        isLoading = true
        Task {
            await authManager.signOut()
            await MainActor.run {
                isLoading = false
                dismiss()
            }
        }
    }
}

#Preview {
    ProfileView()
}
