import SwiftUI

struct PrayerCardView: View {
    let prayer: PrayerCard
    let timeAgo: String
    let isPulsing: Bool
    let onPray: () -> Void

    @State private var appeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 20) {
                Image(systemName: "quote.opening")
                    .font(.system(size: 28, weight: .ultraLight))
                    .foregroundStyle(Theme.goldAccent.opacity(0.5))
                    .padding(.top, 4)

                Text(prayer.text)
                    .font(.system(size: 18, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textDark.opacity(0.9))
                    .lineSpacing(7)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 8)

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent.opacity(0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 60, height: 1)
            }
            .padding(.top, 28)

            Spacer(minLength: 16)

            VStack(spacing: 16) {
                HStack(spacing: 10) {
                    Text(prayer.initials)
                        .font(.system(size: 14, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.cardBrown)
                        .frame(width: 40, height: 40)
                        .background(Theme.warmBeige.opacity(0.5))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
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

                    Text("\(prayer.prayingCount) praying")
                        .font(.system(size: 11, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }

                Button {
                    onPray()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: prayer.isPrayingByMe ? "hands.clap.fill" : "hands.clap")
                            .font(.system(size: 15, weight: .medium))
                            .symbolEffect(.bounce, value: isPulsing)

                        Text(prayer.isPrayingByMe ? "Praying with them" : "I'm Praying")
                            .font(.system(size: 14, weight: .semibold, design: .serif))
                    }
                    .foregroundStyle(prayer.isPrayingByMe ? .white : Theme.goldDark)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Group {
                            if prayer.isPrayingByMe {
                                LinearGradient(
                                    colors: [Theme.goldAccent, Theme.goldDark],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            } else {
                                Color.clear
                            }
                        }
                    )
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(
                                prayer.isPrayingByMe ? Color.clear : Theme.goldAccent.opacity(0.5),
                                lineWidth: 1.5
                            )
                    )
                }
                .sensoryFeedback(.impact(flexibility: .soft), trigger: prayer.isPrayingByMe)
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .frame(maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.8))
                .shadow(color: Theme.sandDark.opacity(0.08), radius: 24, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Theme.goldAccent.opacity(0.12), lineWidth: 1)
                )
        )
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.95)
        .onAppear {
            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                appeared = true
            }
        }
    }
}
