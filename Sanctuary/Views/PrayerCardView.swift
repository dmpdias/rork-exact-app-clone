import SwiftUI

struct PrayerCardView: View {
    let prayer: PrayerRequest
    let onPray: () -> Void
    @State private var showHeart: Bool = false
    @State private var heartScale: CGFloat = 0.3

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    Text(prayer.authorInitials)
                        .font(.system(size: 14, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 38, height: 38)
                        .background(Theme.sandLight)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 1) {
                        Text(prayer.authorName)
                            .font(.system(size: 15, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.textDark)

                        Text(prayer.timeAgo)
                            .font(.system(size: 12, design: .serif))
                            .foregroundStyle(Theme.textLight)
                    }

                    Spacer()

                    Image(systemName: prayer.category.icon)
                        .font(.system(size: 13))
                        .foregroundStyle(prayer.category.color.opacity(0.7))
                }

                Text(prayer.title)
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .lineSpacing(2)

                Text(prayer.body)
                    .font(.system(size: 16, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(24)

            Spacer(minLength: 0)

            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.goldAccent)

                    Text("\(prayer.prayerCount)")
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }

                Spacer()

                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.6)) {
                        onPray()
                        if !prayer.isPrayedFor {
                            showHeart = true
                            heartScale = 1.2
                        }
                    }
                    if !prayer.isPrayedFor {
                        Task {
                            try? await Task.sleep(for: .milliseconds(300))
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                heartScale = 1.0
                            }
                            try? await Task.sleep(for: .milliseconds(900))
                            withAnimation(.easeOut(duration: 0.3)) {
                                showHeart = false
                            }
                        }
                    }
                }) {
                    HStack(spacing: 7) {
                        Image(systemName: prayer.isPrayedFor ? "hands.sparkles.fill" : "hands.sparkles")
                            .font(.system(size: 14))

                        Text(prayer.isPrayedFor ? "Prayed" : "Pray")
                            .font(.system(size: 14, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(prayer.isPrayedFor ? .white : Theme.textDark)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(prayer.isPrayedFor
                                  ? AnyShapeStyle(LinearGradient(colors: [Theme.goldAccent, Theme.goldDark], startPoint: .leading, endPoint: .trailing))
                                  : AnyShapeStyle(Theme.sandLight))
                    )
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .sensoryFeedback(.impact(weight: .medium), trigger: prayer.isPrayedFor)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.7))
                .shadow(color: Theme.sandDark.opacity(0.06), radius: 16, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(Theme.sandDark.opacity(0.06), lineWidth: 0.5)
        )
        .overlay {
            if showHeart {
                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(Theme.goldAccent)
                    .scaleEffect(heartScale)
                    .transition(.opacity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
