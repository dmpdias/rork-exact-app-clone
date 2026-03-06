import SwiftUI

struct CourseDetailView: View {
    let item: JourneyContentItem
    let category: JourneyCategory
    let onBack: () -> Void

    @State private var hasAppeared: Bool = false
    @State private var isBeginPressed: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            courseHeader

            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    synopsisSection
                        .padding(.top, 20)
                        .padding(.horizontal, 24)

                    statsGrid
                        .padding(.top, 28)
                        .padding(.horizontal, 24)

                    communityPulse
                        .padding(.top, 28)
                        .padding(.horizontal, 24)

                    whatYoullFind
                        .padding(.top, 28)
                        .padding(.horizontal, 24)

                    beginButton
                        .padding(.top, 36)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 60)
                }
            }
            .scrollIndicators(.hidden)
        }
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 8)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                hasAppeared = true
            }
        }
    }

    private var courseHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text(category.rawValue)
                            .font(.system(size: 14, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(Theme.goldAccent)
                }
                Spacer()
                Button {} label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.textLight)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 20)

            ZStack {
                Circle()
                    .fill(Theme.goldAccent.opacity(0.08))
                    .frame(width: 88, height: 88)

                Circle()
                    .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                    .frame(width: 76, height: 76)

                Circle()
                    .fill(Theme.textDark)
                    .frame(width: 64, height: 64)

                Image(systemName: item.icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(Theme.cream)
            }
            .padding(.bottom, 16)

            Text(item.title)
                .font(.system(size: 24, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Text(item.subtitle)
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .padding(.top, 4)

            HStack(spacing: 16) {
                DetailPill(icon: "clock", text: item.duration)
                DetailPill(icon: "chart.bar.fill", text: item.difficulty)
                DetailPill(icon: "book.closed", text: "\(item.chapters) parts")
            }
            .padding(.top, 16)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Theme.goldAccent.opacity(0.0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.top, 20)
        }
    }

    private var synopsisSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "text.quote")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.goldAccent)
                Text("ABOUT THIS JOURNEY")
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Theme.goldAccent)
            }

            Text(item.synopsis)
                .font(.system(size: 15, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark.opacity(0.85))
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var statsGrid: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "chart.dots.scatter")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.goldAccent)
                Text("COMMUNITY ENGAGEMENT")
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Theme.goldAccent)
            }

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                StatCard(
                    icon: "hands.sparkles.fill",
                    value: formattedNumber(item.prayers),
                    label: "Prayers Lifted",
                    bgColor: Theme.prayerPink.opacity(0.4),
                    iconColor: Theme.prayerIcon
                )
                StatCard(
                    icon: "book.fill",
                    value: formattedNumber(item.reads),
                    label: "Reads Completed",
                    bgColor: Theme.readingTeal.opacity(0.4),
                    iconColor: Theme.readingIcon
                )
                StatCard(
                    icon: "sparkles",
                    value: formattedNumber(item.reflections),
                    label: "Reflections",
                    bgColor: Theme.reflectionGreen.opacity(0.4),
                    iconColor: Theme.reflectionIcon
                )
                StatCard(
                    icon: "calendar",
                    value: item.duration,
                    label: "Duration",
                    bgColor: Theme.bonusPeach.opacity(0.4),
                    iconColor: Theme.bonusIcon
                )
            }
        }
    }

    private var communityPulse: some View {
        HStack(spacing: 14) {
            ZStack {
                ForEach(0..<3) { i in
                    Circle()
                        .fill(Theme.warmBeige)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Theme.cream, lineWidth: 2)
                        )
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 11))
                                .foregroundStyle(Theme.textLight)
                        )
                        .offset(x: CGFloat(i) * 16)
                }
            }
            .frame(width: 60, alignment: .leading)

            VStack(alignment: .leading, spacing: 2) {
                Text("\(formattedNumber(item.prayers + item.reads)) souls have walked this path")
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textDark)
                Text("\(Int.random(in: 12...89)) are on this journey right now")
                    .font(.system(size: 12, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
            }

            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Theme.sandLight.opacity(0.6), Theme.cream.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 14))
    }

    private var whatYoullFind: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "list.star")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Theme.goldAccent)
                Text("WHAT YOU'LL FIND")
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Theme.goldAccent)
            }

            VStack(alignment: .leading, spacing: 10) {
                FeatureRow(icon: "book.closed.fill", text: "\(item.chapters) guided chapters")
                FeatureRow(icon: "hands.sparkles.fill", text: "Prayers woven into each day")
                FeatureRow(icon: "pencil.line", text: "Reflection prompts for journaling")
                FeatureRow(icon: "person.2.fill", text: "Join a community of seekers")
            }
        }
    }

    private var beginButton: some View {
        Button {
            isBeginPressed = true
        } label: {
            HStack(spacing: 10) {
                Text("Begin This Journey")
                    .font(.system(size: 16, weight: .medium, design: .serif))

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(Theme.cream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Theme.textDark, Theme.textDark.opacity(0.85)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .overlay(
                Capsule()
                    .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isBeginPressed)
    }

    private func formattedNumber(_ n: Int) -> String {
        if n >= 1000 {
            let thousands = Double(n) / 1000.0
            if thousands.truncatingRemainder(dividingBy: 1) == 0 {
                return "\(Int(thousands))k"
            }
            return String(format: "%.1fk", thousands)
        }
        return "\(n)"
    }
}

private struct DetailPill: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Theme.goldAccent)
            Text(text)
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textMedium)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Theme.warmBeige.opacity(0.4))
        )
    }
}

private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let bgColor: Color
    let iconColor: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(bgColor)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(iconColor)
            }

            Text(value)
                .font(.system(size: 20, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text(label)
                .font(.system(size: 11, design: .serif))
                .foregroundStyle(Theme.textLight)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Theme.sandLight.opacity(0.5), Theme.cream.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 14))
    }
}

private struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Theme.goldAccent)
                .frame(width: 20)

            Text(text)
                .font(.system(size: 14, design: .serif))
                .foregroundStyle(Theme.textMedium)
        }
    }
}
