import SwiftUI

struct WeeklyStreakView: View {
    let days: [WeekDay] = [
        WeekDay(label: "M", isCompleted: true, isCurrent: false),
        WeekDay(label: "T", isCompleted: true, isCurrent: false),
        WeekDay(label: "W", isCompleted: true, isCurrent: false),
        WeekDay(label: "T", isCompleted: false, isCurrent: true),
        WeekDay(label: "F", isCompleted: false, isCurrent: false),
        WeekDay(label: "S", isCompleted: false, isCurrent: false),
        WeekDay(label: "S", isCompleted: false, isCurrent: false),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(label: "THIS WEEK", title: "Three faithful days so far.")

            HStack(spacing: 0) {
                ForEach(days) { day in
                    DayCircleView(day: day)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct DayCircleView: View {
    let day: WeekDay
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if day.isCurrent {
                    Circle()
                        .strokeBorder(Theme.flameRing.opacity(0.5), lineWidth: 2)
                        .frame(width: 56, height: 56)
                        .scaleEffect(pulseScale)
                        .onAppear {
                            withAnimation(
                                .easeInOut(duration: 1.6)
                                .repeatForever(autoreverses: true)
                            ) {
                                pulseScale = 1.06
                            }
                        }
                }

                Circle()
                    .fill(day.isCompleted || day.isCurrent ? Theme.flameDark : Theme.sandDark.opacity(0.25))
                    .frame(width: 46, height: 46)

                Image(systemName: "flame.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(
                        day.isCompleted ? Theme.goldAccent :
                        day.isCurrent ? Theme.goldAccent.opacity(0.7) :
                        Theme.textLight.opacity(0.4)
                    )
            }

            Text(day.label)
                .font(.system(.caption, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(day.isCurrent ? Theme.textDark : Theme.textMedium)
        }
    }
}
