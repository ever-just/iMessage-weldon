//
//  AuthView.swift
//  iMessageClone
//
//  weldon.vip - Professional Sign In / Sign Up View
//

import SwiftUI

enum AuthMode {
    case signIn
    case signUp
}

struct AuthView: View {
    @ObservedObject var authManager = AuthManager.shared
    @State private var mode: AuthMode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var name = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Logo
                    VStack(spacing: 8) {
                        Image(systemName: "message.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        Text("weldon.vip")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("Message Weldon directly")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 40)
                    
                    // Mode Picker
                    Picker("", selection: $mode) {
                        Text("Sign In").tag(AuthMode.signIn)
                        Text("Sign Up").tag(AuthMode.signUp)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 32)
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        if mode == .signUp {
                            TextField("Name", text: $name)
                                .textFieldStyle(AuthTextFieldStyle())
                                .textContentType(.name)
                                .autocapitalization(.words)
                        }
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(AuthTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(AuthTextFieldStyle())
                            .textContentType(mode == .signUp ? .newPassword : .password)
                        
                        if mode == .signUp {
                            SecureField("Confirm Password", text: $confirmPassword)
                                .textFieldStyle(AuthTextFieldStyle())
                                .textContentType(.newPassword)
                        }
                    }
                    .padding(.horizontal, 32)
                    
                    // Error Message
                    if let error = errorMessage {
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    
                    // Submit Button
                    Button {
                        submit()
                    } label: {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(mode == .signIn ? "Sign In" : "Create Account")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(!isFormValid || isLoading)
                    .padding(.horizontal, 32)
                    
                    // Forgot Password (Sign In only)
                    if mode == .signIn {
                        Button {
                            // TODO: Implement forgot password
                        } label: {
                            Text("Forgot Password?")
                                .font(.footnote)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var isFormValid: Bool {
        if mode == .signIn {
            return !email.isEmpty && !password.isEmpty && password.count >= 6
        } else {
            return !email.isEmpty && !password.isEmpty && !name.isEmpty &&
                   password.count >= 6 && password == confirmPassword
        }
    }
    
    private func submit() {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                if mode == .signIn {
                    try await authManager.signInWithEmail(email: email, password: password)
                } else {
                    try await authManager.signUpWithEmail(email: email, password: password, name: name)
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }
}

struct AuthTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}

#Preview {
    AuthView()
}
