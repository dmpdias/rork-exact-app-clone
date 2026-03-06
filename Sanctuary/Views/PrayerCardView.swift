import SwiftUI

struct PrayerCardView: View {
    let prayer: PrayerCard
    let timeAgo: String
    let isPulsing: Bool
    let onPray: () -> Void

    @State private var appeared: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 10) {
                Text(prayer.initials)
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.cardBrown)
                    .frame(width: 36, height: 36)
                    .background(Theme.warmBeige.opacity(0.6))
                    .clipShape(Circle())

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

            Text(prayer.text)
                .font(.system(size: 15, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark.opacity(0.85))
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)

            HStack {
                Spacer()

                Button {
                    onPray()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: prayer.isPrayingByMe ? "hands.clap.fill" : "hands.clap")
                            .font(.system(size: 13, weight: .medium))
                            .symbolEffect(.bounce, value: isPulsing)

                        Text("I'm Praying")
                            .font(.system(size: 12, weight: .medium, design: .serif))

                        if prayer.prayingCount > 0 {
                            Text("·")
                                .font(.system(size: 12, weight: .bold))
                            Text("\(prayer.prayingCount)")
                                .font(.system(size: 12, weight: .semibold, design: .serif))
                        }
                    }
                    .foregroundStyle(prayer.isPrayingByMe ? Theme.goldDark : Theme.textMedium)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(prayer.isPrayingByMe ? Theme.goldAccent.opacity(0.15) : Color.clear)
                    )
                    .overlay(
                        Capsule()
                            .stroke(prayer.isPrayingByMe ? Theme.goldAccent : Theme.sandDark.opacity(0.4), lineWidth: 1)
                    )
                }
                .sensoryFeedback(.impact(flexibility: .soft), trigger: prayer.isPrayingByMe)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.white.opacity(0.75))
                .shadow(color: Theme.sandDark.opacity(0.06), radius: 16, y: 6)
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                appeared = true
            }
        }
    }
}
