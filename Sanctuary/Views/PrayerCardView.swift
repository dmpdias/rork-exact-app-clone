import SwiftUI

struct PrayerCardView: View {
    let prayer: PrayerCard
    let timeAgo: String
    let isPulsing: Bool
    let isActive: Bool
    let onPray: () -> Void

    @State private var appeared: Bool = false
    @State private var bloomActive: Bool = false
    @State private var breathePhase: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                categoryTag

                Text(prayer.text)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 28)
            .padding(.horizontal, 24)

            Spacer(minLength: 20)

            VStack(spacing: 14) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent.opacity(0), Theme.goldAccent.opacity(0.25), Theme.goldAccent.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 0.5)
                    .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    Text(prayer.initials)
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.cardBrown)
                        .frame(width: 38, height: 38)
                        .background(Theme.warmBeige.opacity(0.5))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Theme.goldAccent.opacity(0.25), lineWidth: 1)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(prayer.displayName)
                            .font(.system(size: 14, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.textDark)

                        Text(timeAgo)
                            .font(.system(size: 11, design: .serif))
                            .foregroundStyle(Theme.textLight)
                    }

                    Spacer()
                }
                .padding(.horizontal, 24)

                HStack(spacing: 12) {
                    prayButton

                    prayingCountBadge
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 24)
        }
        .frame(maxHeight: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(.white.opacity(0.85))

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: categoryGradientTop.opacity(0.12), location: 0),
                                .init(color: .white.opacity(0.01), location: 0.6),
                                .init(color: categoryGradientBottom.opacity(0.06), location: 1),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Theme.goldAccent.opacity(0.1), lineWidth: 1)
            }
            .shadow(color: Theme.sandDark.opacity(0.08), radius: 24, y: 10)
        )
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.95)
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                appeared = true
            }
            breathePhase = true
        }
    }

    private var categoryTag: some View {
        Text(prayer.category.rawValue)
            .font(.system(size: 12, weight: .semibold, design: .serif))
            .foregroundStyle(categoryTagColor)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(categoryTagColor.opacity(0.1))
            )
            .overlay(
                Capsule()
                    .stroke(categoryTagColor.opacity(0.2), lineWidth: 0.5)
            )
    }

    private var categoryTagColor: Color {
        switch prayer.category {
        case .all: return Theme.goldAccent
        case .healing: return Color(red: 0.75, green: 0.42, blue: 0.42)
        case .guidance: return Color(red: 0.42, green: 0.55, blue: 0.72)
        case .gratitude: return Color(red: 0.72, green: 0.62, blue: 0.32)
        case .family: return Color(red: 0.55, green: 0.65, blue: 0.45)
        case .faith: return Color(red: 0.62, green: 0.48, blue: 0.68)
        case .strength: return Color(red: 0.70, green: 0.50, blue: 0.38)
        }
    }

    private var categoryGradientTop: Color {
        switch prayer.category {
        case .all: return Theme.goldLight
        case .healing: return Color(red: 0.90, green: 0.75, blue: 0.75)
        case .guidance: return Color(red: 0.75, green: 0.82, blue: 0.92)
        case .gratitude: return Color(red: 0.92, green: 0.88, blue: 0.70)
        case .family: return Color(red: 0.78, green: 0.88, blue: 0.72)
        case .faith: return Color(red: 0.85, green: 0.78, blue: 0.90)
        case .strength: return Color(red: 0.92, green: 0.82, blue: 0.72)
        }
    }

    private var categoryGradientBottom: Color {
        switch prayer.category {
        case .all: return Theme.warmBeige
        case .healing: return Color(red: 0.92, green: 0.80, blue: 0.78)
        case .guidance: return Color(red: 0.80, green: 0.85, blue: 0.92)
        case .gratitude: return Color(red: 0.90, green: 0.85, blue: 0.72)
        case .family: return Color(red: 0.80, green: 0.88, blue: 0.78)
        case .faith: return Color(red: 0.88, green: 0.82, blue: 0.90)
        case .strength: return Color(red: 0.90, green: 0.82, blue: 0.75)
        }
    }

    private var prayButton: some View {
        Button {
            onPray()
            if !prayer.isPrayingByMe {
                triggerBloom()
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: prayer.isPrayingByMe ? "hands.clap.fill" : "hands.clap")
                    .font(.system(size: 14, weight: .medium))
                    .symbolEffect(.bounce, value: isPulsing)

                Text(prayer.isPrayingByMe ? "Praying" : "I'm Praying")
                    .font(.system(size: 13, weight: .semibold, design: .serif))
            }
            .foregroundStyle(prayer.isPrayingByMe ? .white : Theme.goldDark)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    if prayer.isPrayingByMe {
                        LinearGradient(
                            colors: [Theme.goldAccent, Theme.goldDark],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    } else {
                        Color.clear
                    }

                    if bloomActive {
                        Capsule()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Theme.divineGold.opacity(0.6),
                                        Theme.divineGoldLight.opacity(0.3),
                                        Theme.goldAccent.opacity(0)
                                    ],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 120
                                )
                            )
                            .blur(radius: 16)
                            .scaleEffect(bloomActive ? 1.8 : 0.5)
                            .opacity(bloomActive ? 0 : 0.8)
                    }
                }
            )
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        prayer.isPrayingByMe ? Theme.divineGold : Theme.goldAccent.opacity(0.45),
                        lineWidth: prayer.isPrayingByMe ? 1.5 : 1
                    )
            )
        }
        .sensoryFeedback(.impact(flexibility: .soft), trigger: prayer.isPrayingByMe)
    }

    private var prayingCountBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: "person.2.fill")
                .font(.system(size: 10))
            Text("\(prayer.prayingCount)")
                .font(.system(size: 12, weight: .medium, design: .serif))
        }
        .foregroundStyle(Theme.textLight)
    }

    private func triggerBloom() {
        withAnimation(.easeOut(duration: 0.6)) {
            bloomActive = true
        }
        Task {
            try? await Task.sleep(for: .milliseconds(650))
            bloomActive = false
        }
    }
}
