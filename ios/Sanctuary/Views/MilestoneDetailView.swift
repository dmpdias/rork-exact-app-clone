import SwiftUI

struct MilestoneDetailView: View {
    let milestone: ProfileMilestone
    @Environment(\.dismiss) private var dismiss
    @State private var ringAnimated: Bool = false
    @State private var glowPulse: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 77)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerControls

                    milestoneHero
                        .padding(.top, 20)

                    progressSection
                        .padding(.top, 32)

                    detailCards
                        .padding(.top, 28)

                    if milestone.isUnlocked {
                        unlockedBanner
                            .padding(.top, 28)
                    } else {
                        encouragementBanner
                            .padding(.top, 28)
                    }

                    Spacer().frame(height: 40)
                }
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                ringAnimated = true
            }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }

    private var headerControls: some View {
        HStack {
            Spacer()
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.textMedium)
                    .frame(width: 32, height: 32)
                    .background(Circle().fill(Theme.sandLight))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var milestoneHero: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.1), lineWidth: 5)
                    .frame(width: 140, height: 140)

                Circle()
                    .trim(from: 0, to: ringAnimated ? milestone.progress : 0)
                    .stroke(
                        AngularGradient(
                            colors: milestone.isUnlocked
                                ? [Theme.divineGold, Theme.divineGoldLight, Theme.chainGold, Theme.divineGold]
                                : [Theme.goldAccent.opacity(0.6), Theme.goldAccent.opacity(0.3)],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 5, lineCap: .round)
                    )
                    .frame(width: 140, height: 140)
                    .rotationEffect(.degrees(-90))

                Circle()
                    .fill(
                        milestone.isUnlocked
                            ? LinearGradient(colors: [Theme.divineGold.opacity(0.15), Theme.divineGoldLight.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [Theme.sandLight, Theme.cream], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: milestone.icon)
                    .font(.system(size: 44))
                    .foregroundStyle(milestone.isUnlocked ? Theme.divineGold : Theme.textLight)
                    .shadow(color: milestone.isUnlocked ? Theme.divineGold.opacity(glowPulse ? 0.5 : 0.15) : .clear, radius: glowPulse ? 12 : 4)
            }

            VStack(spacing: 8) {
                Text(milestone.title)
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text(milestone.subtitle)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textMedium)
            }
        }
        .padding(.horizontal, 20)
    }

    private var progressSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("PROGRESS")
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textLight)
                Spacer()
                Text("\(Int(milestone.progress * 100))%")
                    .font(.system(.subheadline, design: .serif, weight: .bold))
                    .foregroundStyle(milestone.isUnlocked ? Theme.divineGold : Theme.goldDark)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Theme.sandDark.opacity(0.12))
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(
                            LinearGradient(
                                colors: milestone.isUnlocked ? [Theme.divineGold, Theme.divineGoldLight] : [Theme.goldAccent, Theme.goldLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * (ringAnimated ? milestone.progress : 0), height: 8)
                }
            }
            .frame(height: 8)

            Text(milestone.requirement)
                .font(.system(.caption, design: .serif))
                .foregroundStyle(Theme.textLight)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
    }

    private var detailCards: some View {
        VStack(spacing: 12) {
            detailRow(icon: "text.quote", label: "ABOUT", content: milestone.description)
            detailRow(icon: "gift.fill", label: "REWARD", content: milestone.reward)

            if let date = milestone.dateUnlocked {
                detailRow(icon: "calendar", label: "UNLOCKED", content: date)
            }
        }
        .padding(.horizontal, 20)
    }

    private func detailRow(icon: String, label: String, content: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.sandLight)
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.goldAccent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(1.2)
                    .foregroundStyle(Theme.textLight)

                Text(content)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.sandLight.opacity(0.6))
                .strokeBorder(Theme.sandDark.opacity(0.1), lineWidth: 1)
        )
    }

    private var unlockedBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 24))
                .foregroundStyle(Theme.divineGold)

            VStack(alignment: .leading, spacing: 2) {
                Text("Milestone Achieved")
                    .font(.system(.subheadline, design: .serif, weight: .semibold))
                    .foregroundStyle(Theme.textDark)

                Text("This milestone shines in your sacred journey.")
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textMedium)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.divineGold.opacity(0.08))
                .strokeBorder(Theme.divineGold.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    private var encouragementBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "sparkles")
                .font(.system(size: 24))
                .foregroundStyle(Theme.goldAccent)

            VStack(alignment: .leading, spacing: 2) {
                Text("Keep Going")
                    .font(.system(.subheadline, design: .serif, weight: .semibold))
                    .foregroundStyle(Theme.textDark)

                Text("You're \(Int((1.0 - milestone.progress) * 100))% away from unlocking this milestone.")
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textMedium)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.sandLight.opacity(0.8))
                .strokeBorder(Theme.goldAccent.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
