import SwiftUI

struct MemberDetailSheet: View {
    let member: FellowshipMember
    let virtue: Virtue
    let timePeriod: FellowshipTimePeriod
    let isBlessed: Bool
    let onBless: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            avatarSection
                .padding(.top, 24)

            statsGrid

            virtueRow

            if !member.isCurrentUser {
                blessButton
            }

            Spacer()
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 10) {
            ZStack {
                if member.isTopThree {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.divineGoldLight.opacity(0.4), Theme.divineGold.opacity(0)],
                                center: .center, startRadius: 20, endRadius: 50
                            )
                        )
                        .frame(width: 100, height: 100)
                }

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent, Theme.goldDark],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 64, height: 64)
                    .overlay(
                        Text(String(member.displayName.prefix(1)))
                            .font(.system(size: 24, weight: .bold, design: .serif))
                            .foregroundStyle(.white)
                    )
                    .overlay(alignment: .bottomTrailing) {
                        if member.isActive {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 14, height: 14)
                                .overlay(Circle().stroke(Theme.cream, lineWidth: 2))
                        }
                    }
            }

            Text(member.displayName)
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)

            HStack(spacing: 12) {
                Label("#\(member.rank)", systemImage: "trophy.fill")
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.goldDark)

                if member.hasLongStreak {
                    Label("\(member.streakDays)-day streak", systemImage: "flame.fill")
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.goldAccent)
                }

                Label(member.country.rawValue, systemImage: "globe")
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
        }
    }

    private var statsGrid: some View {
        HStack(spacing: 12) {
            statCard(title: "Weekly", value: "\(member.weeklyScore)", icon: "calendar")
            statCard(title: "Monthly", value: "\(member.monthlyScore)", icon: "calendar.badge.clock")
            statCard(title: "All Time", value: "\(member.allTimeScore)", icon: "infinity")
        }
        .padding(.horizontal, 20)
    }

    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(Theme.goldAccent)

            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textDark)

            Text(title)
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.sandLight)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.goldAccent.opacity(0.12), lineWidth: 0.5)
                )
        )
    }

    private var virtueRow: some View {
        HStack(spacing: 8) {
            Image(systemName: virtue.icon)
                .font(.system(size: 13))
                .foregroundStyle(Theme.goldDark)
            Text(member.whisper(for: virtue))
                .font(.system(size: 14, weight: .medium, design: .serif))
                .italic()
                .foregroundStyle(Theme.textMedium)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Theme.divineGoldLight.opacity(0.15))
        )
    }

    private var blessButton: some View {
        Button {
            onBless()
        } label: {
            HStack(spacing: 8) {
                Image(systemName: isBlessed ? "sparkle" : "sparkles")
                    .font(.system(size: 15, weight: .medium))
                Text(isBlessed ? "Blessed" : "Send a Blessing")
                    .font(.system(size: 15, weight: .semibold, design: .serif))
            }
            .foregroundStyle(isBlessed ? Theme.goldDark : .white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                Capsule()
                    .fill(
                        isBlessed
                            ? AnyShapeStyle(Theme.divineGoldLight.opacity(0.2))
                            : AnyShapeStyle(LinearGradient(
                                colors: [Theme.goldAccent, Theme.goldDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                    )
            )
        }
        .disabled(isBlessed)
        .padding(.horizontal, 20)
        .sensoryFeedback(.success, trigger: isBlessed)
    }
}
