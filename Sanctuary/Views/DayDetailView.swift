import SwiftUI

struct DayDetailView: View {
    let day: WeekDay
    let dayIndex: Int
    @Environment(\.dismiss) private var dismiss

    private var dayName: String {
        let names = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
        guard dayIndex >= 0 && dayIndex < names.count else { return "Day" }
        return names[dayIndex]
    }

    private var statusText: String {
        if day.isCompleted { return "Completed" }
        if day.isCurrent { return "In Progress" }
        if day.isFuture { return "Upcoming" }
        return "Missed"
    }

    private var statusColor: Color {
        if day.isCompleted { return Theme.goldAccent }
        if day.isCurrent { return Theme.cardBrown }
        if day.isFuture { return Theme.textLight }
        return Theme.textLight.opacity(0.5)
    }

    private var activities: [(name: String, done: Bool, icon: String)] {
        if day.isFuture {
            return [
                ("Morning Prayer", false, "sparkles"),
                ("Scripture Reading", false, "book.fill"),
                ("Daily Reflection", false, "chart.line.uptrend.xyaxis"),
            ]
        }
        let prayerDone = day.percentage >= 0.25
        let readingDone = day.percentage >= 0.50
        let reflectionDone = day.percentage >= 0.75
        return [
            ("Morning Prayer", prayerDone, "sparkles"),
            ("Scripture Reading", readingDone, "book.fill"),
            ("Daily Reflection", reflectionDone, "chart.line.uptrend.xyaxis"),
        ]
    }

    var body: some View {
        VStack(spacing: 20) {
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
            .padding(.top, 4)

            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.12), lineWidth: 4)
                    .frame(width: 72, height: 72)

                Circle()
                    .trim(from: 0, to: day.percentage)
                    .stroke(statusColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 72, height: 72)
                    .rotationEffect(.degrees(-90))

                Image(systemName: "flame.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(day.isCompleted ? Theme.divineGold : Theme.textLight.opacity(0.4))
            }

            VStack(spacing: 4) {
                Text(dayName)
                    .font(.system(size: 22, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                HStack(spacing: 6) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 6, height: 6)
                    Text(statusText)
                        .font(.system(size: 13, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                }
            }

            Text("\(Int(day.percentage * 100))% complete")
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            VStack(spacing: 0) {
                ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(activity.done ? Theme.goldAccent.opacity(0.12) : Theme.sandLight.opacity(0.5))
                                .frame(width: 36, height: 36)
                            Image(systemName: activity.done ? "checkmark" : activity.icon)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(activity.done ? Theme.goldAccent : Theme.textLight)
                        }

                        Text(activity.name)
                            .font(.system(size: 15, weight: .medium, design: .serif))
                            .foregroundStyle(activity.done ? Theme.textDark : Theme.textMedium)

                        Spacer()

                        if activity.done {
                            Text("Done")
                                .font(.system(size: 12, weight: .medium, design: .serif))
                                .foregroundStyle(Theme.goldAccent)
                        } else if !day.isFuture {
                            Text("Incomplete")
                                .font(.system(size: 12, design: .serif))
                                .foregroundStyle(Theme.textLight)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < activities.count - 1 {
                        Divider()
                            .background(Theme.sandDark.opacity(0.1))
                            .padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.activityCardBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.sandDark.opacity(0.1), lineWidth: 1)
                    )
            )

            Spacer()
        }
        .padding(.horizontal, 20)
        .background(Theme.cream.ignoresSafeArea())
    }
}
