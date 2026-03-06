import SwiftUI

struct PrayerCardView: View {
    let prayer: PrayerRequest
    let onPray: () -> Void
    @State private var showHeart: Bool = false
    @State private var heartScale: CGFloat = 0.3

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(prayer.category.color.opacity(0.2))
                        .frame(width: 44, height: 44)

                    Text(prayer.authorInitials)
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .foregroundStyle(prayer.category.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(prayer.authorName)
                        .font(.system(size: 16, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text(prayer.timeAgo)
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }

                Spacer()

                CategoryPill(category: prayer.category)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 12) {
                Text(prayer.title)
                    .font(.system(size: 24, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .lineSpacing(2)

                Text(prayer.body)
                    .font(.system(size: 17, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 24)

            Spacer(minLength: 24)

            VStack(spacing: 16) {
                Rectangle()
                    .fill(Theme.sandDark.opacity(0.2))
                    .frame(height: 1)
                    .padding(.horizontal, 24)

                HStack(spacing: 0) {
                    HStack(spacing: 6) {
                        Image(systemName: "hands.sparkles.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.goldAccent)

                        Text("\(prayer.prayerCount) prayers")
                            .font(.system(size: 14, weight: .medium, design: .serif))
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                    heartScale = 1.0
                                }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    showHeart = false
                                }
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: prayer.isPrayedFor ? "hands.sparkles.fill" : "hands.sparkles")
                                .font(.system(size: 16))

                            Text(prayer.isPrayedFor ? "Prayed" : "Pray for this")
                                .font(.system(size: 15, weight: .semibold, design: .serif))
                        }
                        .foregroundStyle(prayer.isPrayedFor ? .white : Theme.textDark)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(prayer.isPrayedFor
                                      ? LinearGradient(colors: [Theme.goldAccent, Theme.goldDark], startPoint: .leading, endPoint: .trailing)
                                      : LinearGradient(colors: [Theme.sandLight, Theme.warmBeige], startPoint: .leading, endPoint: .trailing)
                                )
                        )
                        .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                    .sensoryFeedback(.impact(weight: .medium), trigger: prayer.isPrayedFor)
                }
                .padding(.horizontal, 24)
            }
            .padding(.bottom, 24)
        }
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Theme.scriptureCardBg)
                .shadow(color: Theme.cardBrown.opacity(0.08), radius: 20, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(Theme.sandDark.opacity(0.1), lineWidth: 1)
        )
        .overlay {
            if showHeart {
                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Theme.goldAccent)
                    .scaleEffect(heartScale)
                    .transition(.opacity)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 28))
    }
}

struct CategoryPill: View {
    let category: PrayerCategory

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: category.icon)
                .font(.system(size: 11))

            Text(category.rawValue)
                .font(.system(size: 12, weight: .medium, design: .serif))
        }
        .foregroundStyle(category.color)
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(category.bgColor)
        )
    }
}
