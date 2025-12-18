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
    @State private var showForgotPassword = false
    @State private var forgotPasswordEmail = ""
    @State private var forgotPasswordMessage: String?
    
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
                                .textInputAutocapitalization(.words)
                        }
                        
                        TextField("Email", text: $email)
                            .textFieldStyle(AuthTextFieldStyle())
                            .textContentType(.emailAddress)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
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
                            forgotPasswordEmail = email
                            showForgotPassword = true
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
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordSheet(
                    email: $forgotPasswordEmail,
                    message: $forgotPasswordMessage,
                    isPresented: $showForgotPassword
                )
            }
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

// MARK: - Forgot Password Sheet

struct ForgotPasswordSheet: View {
    @Binding var email: String
    @Binding var message: String?
    @Binding var isPresented: Bool
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Image(systemName: "key.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                    .padding(.top, 40)
                
                Text("Reset Password")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Enter your email address and we'll send you a link to reset your password.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textFieldStyle(AuthTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 32)
                
                if let message = message {
                    Text(message)
                        .font(.footnote)
                        .foregroundColor(message.contains("sent") ? .green : .red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    sendResetEmail()
                } label: {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Send Reset Link")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(!email.isEmpty ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                .disabled(email.isEmpty || isLoading)
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
        }
    }
    
    private func sendResetEmail() {
        isLoading = true
        message = nil
        
        Task {
            do {
                try await supabase.auth.resetPasswordForEmail(email)
                await MainActor.run {
                    message = "Password reset link sent! Check your email."
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    message = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    AuthView()
}
