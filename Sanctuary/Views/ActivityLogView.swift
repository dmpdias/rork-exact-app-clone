import SwiftUI

struct ActivityLogView: View {
    @State private var appeared: Bool = false

    let activities: [ActivityItem] = [
        ActivityItem(
            title: "Morning Prayer",
            category: "PRAYER",
            points: 24,
            iconName: "sparkles",
            iconColor: Theme.prayerIcon,
            bgColor: Theme.prayerPink,
            categoryColor: Theme.prayerLabel
        ),
        ActivityItem(
            title: "Scripture Reading",
            category: "READING",
            points: 20,
            iconName: "book.fill",
            iconColor: Theme.readingIcon,
            bgColor: Theme.readingTeal,
            categoryColor: Theme.readingLabel
        ),
        ActivityItem(
            title: "Daily Reflection",
            category: "REFLECTION",
            points: 11,
            iconName: "chart.line.uptrend.xyaxis",
            iconColor: Theme.reflectionIcon,
            bgColor: Theme.reflectionGreen,
            categoryColor: Theme.reflectionLabel
        ),
        ActivityItem(
            title: "Week Streak",
            category: "BONUS",
            points: 18,
            iconName: "star",
            iconColor: Theme.bonusIcon,
            bgColor: Theme.bonusPeach,
            categoryColor: Theme.bonusLabel
        ),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(label: "ACTIVITY LOG", title: "Your journey today.")
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            VStack(spacing: 0) {
                ForEach(Array(activities.enumerated()), id: \.element.id) { index, activity in
                    ActivityRowView(activity: activity)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 12)
                        .animation(.easeOut(duration: 0.35).delay(Double(index) * 0.08), value: appeared)

                    if activity.id != activities.last?.id {
                        Divider()
                            .background(Theme.sandDark.opacity(0.2))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .onAppear { appeared = true }
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.activityCardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Theme.sandDark.opacity(0.15), lineWidth: 1)
                    )
            )
            .padding(.horizontal, 20)

            Text("73 devotion points today")
                .font(.system(.footnote, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
        }
    }
}

struct ActivityRowView: View {
    let activity: ActivityItem

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(activity.bgColor.opacity(0.5))
                    .frame(width: 44, height: 44)

                Image(systemName: activity.iconName)
                    .font(.system(size: 17))
                    .foregroundStyle(activity.iconColor)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(activity.title)
                    .font(.system(.body, design: .serif))
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.textDark)

                Text(activity.category)
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1)
                    .foregroundStyle(activity.categoryColor)
            }

            Spacer()

            Text("+\(activity.points) pts")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Theme.sandLight.opacity(0.6))
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
