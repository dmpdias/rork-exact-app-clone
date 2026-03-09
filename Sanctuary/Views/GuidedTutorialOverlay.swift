import SwiftUI

struct TutorialStep {
    let icon: String
    let title: String
    let description: String
    let highlightTab: Int?
}

struct GuidedTutorialOverlay: View {
    @State private var currentStep: Int = 0
    @State private var appeared: Bool = false
    @State private var pulseScale: CGFloat = 1.0
    var onComplete: () -> Void

    private let steps: [TutorialStep] = [
        TutorialStep(
            icon: "hand.wave.fill",
            title: "Welcome to Your Sanctuary",
            description: "This is your sacred home — a personalized space where prayer, scripture, and growth come together every day.",
            highlightTab: nil
        ),
        TutorialStep(
            icon: "house.fill",
            title: "Your Daily Sanctuary",
            description: "Start each day here. Your spiritual moment, weekly streak, devotion score, and daily scripture all live on this screen.",
            highlightTab: 0
        ),
        TutorialStep(
            icon: "heart",
            title: "Your Spiritual Counselor",
            description: "A wise, compassionate guide ready to listen. Ask questions about faith, life, or anything weighing on your heart.",
            highlightTab: 1
        ),
        TutorialStep(
            icon: "person.2",
            title: "Your Community",
            description: "You're never alone. Share prayer requests, pray for others on the wall, and grow alongside fellow believers.",
            highlightTab: 2
        ),
        TutorialStep(
            icon: "book",
            title: "Your Journey",
            description: "Structured courses, scripture studies, and growth paths. Deepen your knowledge at your own pace.",
            highlightTab: 3
        ),
        TutorialStep(
            icon: "sparkles",
            title: "You're All Set!",
            description: "Your personalized plan is active. Start with today's spiritual moment — God is waiting for you.",
            highlightTab: nil
        )
    ]

    private var step: TutorialStep {
        steps[currentStep]
    }

    private var isLastStep: Bool {
        currentStep == steps.count - 1
    }

    var body: some View {
        ZStack {
            Color.black.opacity(appeared ? 0.55 : 0)
                .ignoresSafeArea()
                .allowsHitTesting(true)

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.goldLight.opacity(0.3), Theme.goldAccent.opacity(0.05)],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 50
                                )
                            )
                            .frame(width: 100, height: 100)
                            .scaleEffect(pulseScale)

                        Image(systemName: step.icon)
                            .font(.system(size: 38))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldLight, Theme.goldDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .contentTransition(.symbolEffect(.replace.downUp))
                    }

                    VStack(spacing: 10) {
                        Text(step.title)
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)

                        Text(step.description)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(.white.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.horizontal, 24)

                    HStack(spacing: 6) {
                        ForEach(0..<steps.count, id: \.self) { i in
                            Capsule()
                                .fill(i <= currentStep ? Theme.goldAccent : Color.white.opacity(0.25))
                                .frame(width: i == currentStep ? 24 : 8, height: 4)
                                .animation(.spring(response: 0.3), value: currentStep)
                        }
                    }
                }
                .padding(32)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                )
                .padding(.horizontal, 24)
                .offset(y: appeared ? 0 : 40)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: 24)

                if let tabIndex = step.highlightTab {
                    tabHighlightIndicator(tabIndex: tabIndex)
                        .padding(.bottom, 8)
                }

                VStack(spacing: 14) {
                    Button {
                        advanceStep()
                    } label: {
                        HStack(spacing: 8) {
                            Text(isLastStep ? "Begin Your Journey" : "Next")
                                .font(.system(.body, design: .serif))
                                .fontWeight(.semibold)

                            Image(systemName: isLastStep ? "arrow.right" : "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                        }
                        .foregroundStyle(Theme.cream)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.cardBrown, Theme.cardOlive],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.horizontal, 32)

                    if !isLastStep {
                        Button {
                            onComplete()
                        } label: {
                            Text("Skip tutorial")
                                .font(.system(.subheadline, design: .serif))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .padding(.bottom, 100)
                .opacity(appeared ? 1 : 0)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.85)) {
                appeared = true
            }
            startPulse()
        }
    }

    private func advanceStep() {
        if isLastStep {
            withAnimation(.spring(response: 0.4)) {
                appeared = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                onComplete()
            }
        } else {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                currentStep += 1
            }
        }
    }

    private func startPulse() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            pulseScale = 1.08
        }
    }

    private func tabHighlightIndicator(tabIndex: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { i in
                ZStack {
                    if i == tabIndex {
                        Circle()
                            .fill(Theme.goldAccent)
                            .frame(width: 10, height: 10)

                        Circle()
                            .strokeBorder(Theme.goldAccent.opacity(0.4), lineWidth: 2)
                            .frame(width: 22, height: 22)
                    } else {
                        Circle()
                            .fill(Color.white.opacity(0.15))
                            .frame(width: 6, height: 6)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 40)
    }
}
