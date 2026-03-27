import SwiftUI

struct DevotionBreakdownView: View {
    @Environment(\.dismiss) private var dismiss

    private let breakdownItems: [(label: String, category: String, points: Int, icon: String, color: Color, description: String)] = [
        ("Morning Prayer", "PRAYER", 24, "sparkles", Theme.prayerPink, "Complete your morning prayer session"),
        ("Scripture Reading", "READING", 20, "book.fill", Theme.readingTeal, "Read today's assigned scripture passage"),
        ("Daily Reflection", "REFLECTION", 11, "chart.line.uptrend.xyaxis", Theme.reflectionGreen, "Write or meditate on a reflection"),
        ("Week Streak Bonus", "BONUS", 18, "star", Theme.bonusPeach, "Maintain consecutive daily devotions"),
        ("Community Prayer", "COMMUNITY", 10, "person.2.fill", Theme.prayerPink, "Pray for someone on the Prayer Wall"),
        ("Evening Vespers", "EVENING", 8, "moon.stars.fill", Theme.readingTeal, "Complete an evening prayer session"),
        ("Journal Entry", "JOURNAL", 5, "note.text", Theme.reflectionGreen, "Write a journal entry about your day"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 16) {
                    currentScoreCard
                    tipsSection
                    breakdownList
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background(Theme.cream.ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 32, height: 32)
                        .background(Theme.sandLight.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            Text("Devotion Score")
                .font(.system(size: 24, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text("How your score is built")
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(LinearGradient(colors: [Theme.goldAccent.opacity(0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.top, 4)
        }
        .padding(.bottom, 8)
    }

    private var currentScoreCard: some View {
        HStack(spacing: 20) {
            VStack(spacing: 2) {
                Text("73")
                    .font(.system(size: 44, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)
                Text("Today")
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }

            Rectangle()
                .fill(Theme.sandDark.opacity(0.15))
                .frame(width: 1, height: 50)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.green)
                    Text("+12 from yesterday")
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                }
                Text("Best this week: 89")
                    .font(.system(size: 12, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Theme.sandLight.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Theme.goldAccent.opacity(0.15), lineWidth: 1)
                )
        )
    }

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.goldAccent)
                Text("Reach 100 today")
                    .font(.system(size: 14, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }

            Text("Complete your Evening Vespers (+8) and write a Journal Entry (+5) to reach a score of 86. Add a Community Prayer (+10) to hit 96!")
                .font(.system(size: 13, design: .serif))
                .foregroundStyle(Theme.textMedium)
                .lineSpacing(4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.goldAccent.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.goldAccent.opacity(0.12), lineWidth: 1)
                )
        )
    }

    private var breakdownList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("POINT BREAKDOWN")
                .font(.system(size: 11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.sectionHeader)

            VStack(spacing: 0) {
                ForEach(Array(breakdownItems.enumerated()), id: \.offset) { index, item in
                    breakdownRow(item: item, isEarned: index < 4)

                    if index < breakdownItems.count - 1 {
                        Divider()
                            .background(Theme.sandDark.opacity(0.15))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Theme.activityCardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(Theme.sandDark.opacity(0.1), lineWidth: 1)
                    )
            )
        }
    }

    private func breakdownRow(item: (label: String, category: String, points: Int, icon: String, color: Color, description: String), isEarned: Bool) -> some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(item.color.opacity(isEarned ? 0.5 : 0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: item.icon)
                    .font(.system(size: 15))
                    .foregroundStyle(isEarned ? Theme.textDark : Theme.textLight)
            }

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(item.label)
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(isEarned ? Theme.textDark : Theme.textMedium)

                    if isEarned {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(Theme.goldAccent)
                    }
                }

                Text(item.description)
                    .font(.system(size: 11, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .lineLimit(1)
            }

            Spacer()

            Text("+\(item.points)")
                .font(.system(size: 15, weight: .semibold, design: .serif))
                .foregroundStyle(isEarned ? Theme.goldAccent : Theme.textLight)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(isEarned ? Theme.goldAccent.opacity(0.1) : Theme.sandLight.opacity(0.4))
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .opacity(isEarned ? 1 : 0.7)
    }
}
