import SwiftUI

@main
struct SanctuaryApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var showLogin: Bool = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else if showLogin {
                LoginView(
                    onLogin: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            hasCompletedOnboarding = true
                        }
                    },
                    onShowOnboarding: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            showLogin = false
                        }
                    }
                )
            } else {
                OnboardingView(
                    onComplete: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            hasCompletedOnboarding = true
                        }
                    },
                    onShowLogin: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            showLogin = true
                        }
                    }
                )
            }
        }
    }
}
