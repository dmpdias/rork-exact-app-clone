import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var verificationCode: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var breathe: Bool = false
    @State private var authMode: AuthMode = .email
    @State private var showVerificationField: Bool = false
    var onLogin: () -> Void
    var onShowOnboarding: () -> Void

    private enum AuthMode: String, CaseIterable {
        case email = "Email"
        case phone = "Phone"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.88, blue: 0.82),
                    Color(red: 0.94, green: 0.90, blue: 0.84)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Spacer().frame(height: 60)

                    brandingSection

                    Spacer().frame(height: 36)

                    appleSignInSection

                    Spacer().frame(height: 20)

                    divider

                    Spacer().frame(height: 20)

                    authModePicker

                    Spacer().frame(height: 20)

                    if authMode == .email {
                        emailFormSection
                    } else {
                        phoneFormSection
                    }

                    Spacer().frame(height: 20)

                    loginButton

                    if authMode == .email {
                        Spacer().frame(height: 14)
                        forgotPassword
                    }

                    Spacer().frame(height: 36)

                    secondDivider

                    Spacer().frame(height: 24)

                    createAccountButton

                    Spacer().frame(height: 60)
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .scrollIndicators(.hidden)
        }
        .alert("Sign In Error", isPresented: $showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }

    private var brandingSection: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.goldLight.opacity(0.25), Theme.goldAccent.opacity(0.03)],
                            center: .center,
                            startRadius: 15,
                            endRadius: 60
                        )
                    )
                    .frame(width: 110, height: 110)
                    .scaleEffect(breathe ? 1.05 : 1.0)
                    .opacity(breathe ? 1 : 0.7)

                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Theme.goldLight, Theme.goldDark],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    breathe = true
                }
            }

            VStack(spacing: 6) {
                Text("Welcome back")
                    .font(.system(size: 15, design: .serif))
                    .foregroundStyle(Theme.textMedium)

                Text("Amave")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }
        }
    }

    private var appleSignInSection: some View {
        VStack(spacing: 12) {
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success:
                    onLogin()
                case .failure:
                    errorMessage = "Apple Sign In failed. Please try again."
                    showError = true
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(height: 52)
            .clipShape(.rect(cornerRadius: 26))
            .padding(.horizontal, 32)
        }
    }

    private var authModePicker: some View {
        HStack(spacing: 4) {
            ForEach(AuthMode.allCases, id: \.rawValue) { mode in
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        authMode = mode
                        showVerificationField = false
                    }
                } label: {
                    Text(mode.rawValue)
                        .font(.system(.subheadline, design: .serif))
                        .fontWeight(.medium)
                        .foregroundStyle(authMode == mode ? Theme.cream : Theme.textMedium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(authMode == mode ? Theme.cardBrown : Color.clear)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(
            Capsule()
                .fill(Theme.sandLight.opacity(0.8))
                .strokeBorder(Theme.sandDark.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 32)
    }

    private var emailFormSection: some View {
        VStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("EMAIL")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textLight)

                HStack(spacing: 12) {
                    Image(systemName: "envelope")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.textLight)

                    TextField("", text: $email, prompt: Text("your@email.com").foregroundStyle(Theme.textLight.opacity(0.5)))
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.sandLight.opacity(0.6))
                        .strokeBorder(Theme.sandDark.opacity(0.2), lineWidth: 1)
                )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("PASSWORD")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textLight)

                HStack(spacing: 12) {
                    Image(systemName: "lock")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.textLight)

                    SecureField("", text: $password, prompt: Text("Your password").foregroundStyle(Theme.textLight.opacity(0.5)))
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .textContentType(.password)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.sandLight.opacity(0.6))
                        .strokeBorder(Theme.sandDark.opacity(0.2), lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, 32)
    }

    private var phoneFormSection: some View {
        VStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("PHONE NUMBER")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textLight)

                HStack(spacing: 12) {
                    Image(systemName: "phone")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.textLight)

                    TextField("", text: $phoneNumber, prompt: Text("+1 (555) 000-0000").foregroundStyle(Theme.textLight.opacity(0.5)))
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Theme.sandLight.opacity(0.6))
                        .strokeBorder(Theme.sandDark.opacity(0.2), lineWidth: 1)
                )
            }

            if showVerificationField {
                VStack(alignment: .leading, spacing: 6) {
                    Text("VERIFICATION CODE")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)

                    HStack(spacing: 12) {
                        Image(systemName: "number")
                            .font(.system(size: 15))
                            .foregroundStyle(Theme.textLight)

                        TextField("", text: $verificationCode, prompt: Text("Enter 6-digit code").foregroundStyle(Theme.textLight.opacity(0.5)))
                            .font(.system(size: 22, weight: .medium, design: .monospaced))
                            .foregroundStyle(Theme.textDark)
                            .textContentType(.oneTimeCode)
                            .keyboardType(.numberPad)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Theme.sandLight.opacity(0.6))
                            .strokeBorder(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                    )
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .padding(.horizontal, 32)
    }

    private var loginButton: some View {
        Button {
            signIn()
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                        .tint(Theme.cream)
                } else {
                    Text(authMode == .phone && !showVerificationField ? "Send Code" : "Sign In")
                        .font(.system(.body, design: .serif))
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(Theme.cream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: canSignIn ? [Theme.cardBrown, Theme.cardOlive] : [Theme.sandDark.opacity(0.3), Theme.sandDark.opacity(0.25)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .disabled(!canSignIn || isLoading)
        .padding(.horizontal, 32)
        .animation(.spring(response: 0.3), value: canSignIn)
    }

    private var forgotPassword: some View {
        Button {
        } label: {
            Text("Forgot your password?")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.goldDark)
        }
    }

    private var divider: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Theme.sandDark.opacity(0.2))
                .frame(height: 1)

            Text("or sign in with")
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(Theme.sandDark.opacity(0.2))
                .frame(height: 1)
        }
        .padding(.horizontal, 40)
    }

    private var secondDivider: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Theme.sandDark.opacity(0.2))
                .frame(height: 1)

            Text("NEW HERE?")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(Theme.sandDark.opacity(0.2))
                .frame(height: 1)
        }
        .padding(.horizontal, 40)
    }

    private var createAccountButton: some View {
        VStack(spacing: 12) {
            Button {
                onShowOnboarding()
            } label: {
                HStack(spacing: 10) {
                    Text("Create an Account")
                        .font(.system(.body, design: .serif))
                        .fontWeight(.medium)

                    Image(systemName: "arrow.right")
                        .font(.system(size: 13, weight: .medium))
                }
                .foregroundStyle(Theme.cardBrown)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    Capsule()
                        .strokeBorder(Theme.cardBrown.opacity(0.5), lineWidth: 1.5)
                )
            }
            .padding(.horizontal, 32)

            Text("Begin your spiritual journey")
                .font(.system(size: 13, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
        }
    }

    private var canSignIn: Bool {
        switch authMode {
        case .email:
            return !email.trimmingCharacters(in: .whitespaces).isEmpty && !password.isEmpty
        case .phone:
            if showVerificationField {
                return verificationCode.count >= 6
            }
            return phoneNumber.trimmingCharacters(in: .whitespaces).count >= 7
        }
    }

    private func signIn() {
        guard canSignIn else { return }

        if authMode == .phone && !showVerificationField {
            isLoading = true
            Task {
                try? await Task.sleep(for: .seconds(1))
                isLoading = false
                withAnimation(.spring(response: 0.4)) {
                    showVerificationField = true
                }
            }
            return
        }

        isLoading = true
        Task {
            try? await Task.sleep(for: .seconds(1))
            isLoading = false
            onLogin()
        }
    }
}
