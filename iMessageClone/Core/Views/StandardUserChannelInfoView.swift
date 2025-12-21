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
    @State private var showDeleteAccountAlert = false
    @State private var showDeleteAccountConfirmation = false
    
    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section {
                    if let user = authManager.currentUser {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                                Text(user.email)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                        
                        Button(role: .destructive) {
                            showDeleteAccountAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "trash")
                                Text("Delete Account")
                            }
                        }
                    }
                } header: {
                    Text("Account")
                } footer: {
                    Text("Deleting your account will permanently remove all your data and cannot be undone.")
                }
                
                // Privacy & Legal Section
                Section {
                    Link(destination: URL(string: "https://weldon.vip/privacy")!) {
                        HStack {
                            Image(systemName: "hand.raised.fill")
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://weldon.vip/terms")!) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://weldon.vip/support")!) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Support & Help")
                            Spacer()
                            Image(systemName: "arrow.up.forward")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Privacy & Legal")
                }
                
                // About Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.1.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
                
                // Sign Out Section
                Section {
                    SignOutButton()
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Delete Account?", isPresented: $showDeleteAccountAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    showDeleteAccountConfirmation = true
                }
            } message: {
                Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently removed.")
            }
            .alert("Confirm Deletion", isPresented: $showDeleteAccountConfirmation) {
                Button("Cancel", role: .cancel) { }
                Button("I Understand, Delete My Account", role: .destructive) {
                    deleteAccount()
                }
            } message: {
                Text("This is your final confirmation. Type your email to confirm deletion.")
            }
        }
    }
    
    private func deleteAccount() {
        Task {
            do {
                // Delete user from Supabase
                try await SupabaseClient.shared.supabase.auth.admin.deleteUser(id: authManager.currentUser?.id ?? "")
                
                // Sign out
                await authManager.signOut()
                
                dismiss()
            } catch {
                print("Error deleting account: \(error)")
            }
        }
    }
}
