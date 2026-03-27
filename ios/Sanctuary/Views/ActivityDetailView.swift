import SwiftUI

struct ActivityDetailView: View {
    let activity: ActivityItem
    @Environment(\.dismiss) private var dismiss

    private var detailData: (description: String, time: String, verses: Int, duration: String) {
        switch activity.category {
        case "PRAYER":
            return ("You completed a guided morning prayer session, lifting your intentions and seeking God's presence to start the day.", "6:45 AM", 5, "12 min")
        case "READING":
            return ("You read through today's assigned scripture passage, meditating on God's word and allowing it to transform your heart.", "7:30 AM", 8, "18 min")
        case "REFLECTION":
            return ("You spent time in quiet reflection, journaling your thoughts and insights from today's reading and prayer.", "8:00 AM", 0, "10 min")
        case "BONUS":
            return ("You maintained your weekly devotion streak! Consistency in faith builds a strong spiritual foundation.", "All Day", 0, "—")
        default:
            return ("Spiritual activity completed.", "Today", 0, "—")
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 24) {
                    detailCard
                    statsRow
                    encouragement
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background(Theme.cream.ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 16) {
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

            ZStack {
                Circle()
                    .fill(activity.bgColor.opacity(0.5))
                    .frame(width: 64, height: 64)
                Image(systemName: activity.iconName)
                    .font(.system(size: 26))
                    .foregroundStyle(activity.iconColor)
            }

            Text(activity.title)
                .font(.system(size: 24, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            HStack(spacing: 6) {
                Text(activity.category)
                    .font(.system(size: 11, weight: .semibold))
                    .tracking(1.5)
                    .foregroundStyle(activity.categoryColor)
                Text("•")
                    .foregroundStyle(Theme.textLight)
                Text("+\(activity.points) pts")
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.goldAccent)
            }

            Rectangle()
                .fill(LinearGradient(colors: [Theme.goldAccent.opacity(0), Theme.goldAccent.opacity(0.3), Theme.goldAccent.opacity(0)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 1)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 8)
    }

    private var detailCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(detailData.description)
                .font(.system(size: 15, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textMedium)
                .lineSpacing(5)

            HStack(spacing: 6) {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.textLight)
                Text("Completed at \(detailData.time)")
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.sandLight.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Theme.sandDark.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            if detailData.verses > 0 {
                statItem(value: "\(detailData.verses)", label: "Verses", icon: "book.closed.fill")
            }
            statItem(value: detailData.duration, label: "Duration", icon: "timer")
            statItem(value: "+\(activity.points)", label: "Points", icon: "star.fill")
        }
    }

    private func statItem(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.goldAccent)
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.activityCardBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
                )
        )
    }

    private var encouragement: some View {
        VStack(spacing: 8) {
            Image(systemName: "hands.sparkles.fill")
                .font(.system(size: 20))
                .foregroundStyle(Theme.goldAccent.opacity(0.6))

            Text(encouragementText)
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
        }
        .padding(.top, 8)
    }

    private var encouragementText: String {
        switch activity.category {
        case "PRAYER": return "\"Devote yourselves to prayer, being watchful and thankful.\"\n— Colossians 4:2"
        case "READING": return "\"Your word is a lamp for my feet, a light on my path.\"\n— Psalm 119:105"
        case "REFLECTION": return "\"Be still, and know that I am God.\"\n— Psalm 46:10"
        case "BONUS": return "\"Let us not become weary in doing good, for at the proper time we will reap a harvest.\"\n— Galatians 6:9"
        default: return "\"Whatever you do, work at it with all your heart.\"\n— Colossians 3:23"
        }
    }
}
