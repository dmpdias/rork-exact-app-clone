import SwiftUI

struct WeeklyStreakView: View {
    let days: [WeekDay] = [
        WeekDay(label: "M", percentage: 1.0, isCurrent: false, isFuture: false),
        WeekDay(label: "T", percentage: 1.0, isCurrent: false, isFuture: false),
        WeekDay(label: "W", percentage: 1.0, isCurrent: false, isFuture: false),
        WeekDay(label: "T", percentage: 0.73, isCurrent: true, isFuture: false),
        WeekDay(label: "F", percentage: 0.0, isCurrent: false, isFuture: true),
        WeekDay(label: "S", percentage: 0.0, isCurrent: false, isFuture: true),
        WeekDay(label: "S", percentage: 0.0, isCurrent: false, isFuture: true),
    ]

    @State private var animateIn: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(label: "THIS WEEK", title: "Three faithful days so far.")

            HStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.element.id) { index, day in
                    let showChainLeft = index > 0 && days[index - 1].isCompleted && day.isCompleted
                    let showChainRight = index < days.count - 1 && days[index + 1].isCompleted && day.isCompleted

                    DayChainCircleView(
                        day: day,
                        showChainLeft: showChainLeft,
                        showChainRight: showChainRight,
                        animateIn: animateIn
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 20)
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.2)) {
                animateIn = true
            }
        }
    }
}

struct DayChainCircleView: View {
    let day: WeekDay
    let showChainLeft: Bool
    let showChainRight: Bool
    let animateIn: Bool

    @State private var pulseScale: CGFloat = 1.0
    @State private var pulseOpacity: Double = 0.5

    private let circleSize: CGFloat = 46
    private let medalRingSize: CGFloat = 56
    private let iconSize: CGFloat = 16

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                chainLines

                if day.isCurrent {
                    pulsingRing
                }

                if day.isCompleted {
                    medalRing
                }

                circleBackground

                flameIcon
            }
            .frame(width: medalRingSize + 4, height: medalRingSize + 4)

            Text(day.label)
                .font(.system(.caption, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(day.isCurrent ? Theme.textDark : Theme.textMedium)
        }
    }

    private var chainLines: some View {
        GeometryReader { geo in
            let centerY = geo.size.height / 2
            let centerX = geo.size.width / 2
            let ringRadius = medalRingSize / 2

            if showChainLeft {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: centerY))
                    path.addLine(to: CGPoint(x: centerX - ringRadius, y: centerY))
                }
                .stroke(
                    LinearGradient(
                        colors: [Theme.chainGold.opacity(0.4), Theme.divineGold],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .opacity(animateIn ? 1 : 0)
            }

            if showChainRight {
                Path { path in
                    path.move(to: CGPoint(x: centerX + ringRadius, y: centerY))
                    path.addLine(to: CGPoint(x: geo.size.width, y: centerY))
                }
                .stroke(
                    LinearGradient(
                        colors: [Theme.divineGold, Theme.chainGold.opacity(0.4)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                .opacity(animateIn ? 1 : 0)
            }
        }
    }

    private var pulsingRing: some View {
        Circle()
            .strokeBorder(Theme.divineGold.opacity(pulseOpacity), lineWidth: 2)
            .frame(width: medalRingSize, height: medalRingSize)
            .scaleEffect(pulseScale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.6)
                    .repeatForever(autoreverses: true)
                ) {
                    pulseScale = 1.08
                    pulseOpacity = 0.9
                }
            }
    }

    private var medalRing: some View {
        Circle()
            .strokeBorder(
                LinearGradient(
                    colors: [Theme.divineGoldLight, Theme.divineGold, Theme.chainGold],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 2.5
            )
            .frame(width: medalRingSize, height: medalRingSize)
            .shadow(color: Theme.divineGold.opacity(0.4), radius: 4, x: 0, y: 0)
    }

    private var circleBackground: some View {
        ZStack {
            Circle()
                .fill(day.isFuture ? Theme.ghostedCircle.opacity(0.3) : Theme.deepCharcoal)
                .frame(width: circleSize, height: circleSize)

            if day.percentage > 0 && day.percentage < 1.0 {
                PartialFillCircle(percentage: animateIn ? day.percentage : 0)
                    .fill(
                        LinearGradient(
                            colors: [Theme.divineGold.opacity(0.15), Theme.divineGold.opacity(0.4)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: circleSize, height: circleSize)
                    .clipShape(Circle())
                    .animation(.easeOut(duration: 1.0).delay(0.3), value: animateIn)
            }
        }
    }

    private var flameIcon: some View {
        Image(systemName: "flame.fill")
            .font(.system(size: iconSize))
            .foregroundStyle(flameColor)
    }

    private var flameColor: Color {
        if day.isCompleted {
            return Theme.divineGold
        } else if day.isCurrent {
            return Theme.divineGold.opacity(0.8)
        } else if day.isFuture {
            return Theme.textLight.opacity(0.2)
        } else {
            return Theme.textLight.opacity(0.35)
        }
    }
}

struct PartialFillCircle: Shape, Animatable {
    var percentage: Double

    var animatableData: Double {
        get { percentage }
        set { percentage = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let fillHeight = rect.height * percentage
        let yOffset = rect.maxY - fillHeight
        path.addRect(CGRect(x: rect.minX, y: yOffset, width: rect.width, height: fillHeight))
        return path
    }
}
