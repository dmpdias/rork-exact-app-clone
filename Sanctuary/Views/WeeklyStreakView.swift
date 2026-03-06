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
                    let showDottedLeft = index > 0 && !(days[index - 1].isCompleted && day.isCompleted) && !day.isFuture && !days[index - 1].isFuture
                    let showDottedRight = index < days.count - 1 && !(days[index + 1].isCompleted && day.isCompleted) && !day.isFuture && !days[index + 1].isFuture

                    ConstellationDayView(
                        day: day,
                        showChainLeft: showChainLeft,
                        showChainRight: showChainRight,
                        showDottedLeft: showDottedLeft,
                        showDottedRight: showDottedRight,
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

struct ConstellationDayView: View {
    let day: WeekDay
    let showChainLeft: Bool
    let showChainRight: Bool
    let showDottedLeft: Bool
    let showDottedRight: Bool
    let animateIn: Bool

    @State private var glowOpacity: Double = 0.2
    @State private var glowScale: CGFloat = 1.0

    private let circleSize: CGFloat = 40
    private let outerRingSize: CGFloat = 48
    private let iconSize: CGFloat = 14

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                connectionLines

                if day.isCurrent {
                    breathingGlow
                }

                if day.isCompleted {
                    goldenMedalRing
                }

                circleBody

                flameIcon
            }
            .frame(width: outerRingSize + 8, height: outerRingSize + 8)

            Text(day.label)
                .font(.system(.caption, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(day.isCurrent ? Theme.textDark : Theme.textMedium)
        }
    }

    private var connectionLines: some View {
        GeometryReader { geo in
            let centerY = geo.size.height / 2
            let centerX = geo.size.width / 2
            let ringRadius = outerRingSize / 2

            if showChainLeft {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: centerY))
                    path.addLine(to: CGPoint(x: centerX - ringRadius, y: centerY))
                }
                .stroke(
                    Theme.divineGold.opacity(0.6),
                    style: StrokeStyle(lineWidth: 1, lineCap: .round)
                )
                .opacity(animateIn ? 1 : 0)
            }

            if showChainRight {
                Path { path in
                    path.move(to: CGPoint(x: centerX + ringRadius, y: centerY))
                    path.addLine(to: CGPoint(x: geo.size.width, y: centerY))
                }
                .stroke(
                    Theme.divineGold.opacity(0.6),
                    style: StrokeStyle(lineWidth: 1, lineCap: .round)
                )
                .opacity(animateIn ? 1 : 0)
            }

            if showDottedLeft {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: centerY))
                    path.addLine(to: CGPoint(x: centerX - ringRadius, y: centerY))
                }
                .stroke(
                    Theme.divineGold.opacity(0.15),
                    style: StrokeStyle(lineWidth: 0.5, lineCap: .round, dash: [3, 4])
                )
                .opacity(animateIn ? 1 : 0)
            }

            if showDottedRight {
                Path { path in
                    path.move(to: CGPoint(x: centerX + ringRadius, y: centerY))
                    path.addLine(to: CGPoint(x: geo.size.width, y: centerY))
                }
                .stroke(
                    Theme.divineGold.opacity(0.15),
                    style: StrokeStyle(lineWidth: 0.5, lineCap: .round, dash: [3, 4])
                )
                .opacity(animateIn ? 1 : 0)
            }
        }
    }

    private var breathingGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.divineGold.opacity(glowOpacity * 0.4),
                        Theme.divineGold.opacity(glowOpacity * 0.15),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: circleSize / 2 - 2,
                    endRadius: outerRingSize / 2 + 6
                )
            )
            .frame(width: outerRingSize + 16, height: outerRingSize + 16)
            .scaleEffect(glowScale)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true)
                ) {
                    glowOpacity = 0.7
                    glowScale = 1.06
                }
            }
    }

    private var goldenMedalRing: some View {
        Circle()
            .strokeBorder(
                AngularGradient(
                    colors: [
                        Theme.divineGold.opacity(0.7),
                        Theme.divineGoldLight.opacity(0.9),
                        Theme.divineGold,
                        Theme.chainGold.opacity(0.8),
                        Theme.divineGold.opacity(0.7)
                    ],
                    center: .center
                ),
                lineWidth: 1.5
            )
            .frame(width: outerRingSize, height: outerRingSize)
            .shadow(color: Theme.divineGold.opacity(0.3), radius: 6, x: 0, y: 0)
    }

    private var circleBody: some View {
        ZStack {
            Circle()
                .strokeBorder(circleStrokeColor, lineWidth: day.isFuture ? 0.5 : 1)
                .background(Circle().fill(Color.clear))
                .frame(width: circleSize, height: circleSize)

            if day.percentage > 0 && day.percentage < 1.0 {
                CircularFillArc(percentage: animateIn ? day.percentage : 0)
                    .stroke(
                        AngularGradient(
                            colors: [
                                Theme.divineGold.opacity(0.1),
                                Theme.divineGold.opacity(0.5),
                                Theme.divineGoldLight.opacity(0.6)
                            ],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(-90 + 360 * day.percentage)
                        ),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: circleSize - 4, height: circleSize - 4)
                    .animation(.easeOut(duration: 1.2).delay(0.3), value: animateIn)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.divineGold.opacity(animateIn ? 0.12 : 0),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: circleSize / 2 - 4
                        )
                    )
                    .frame(width: circleSize - 6, height: circleSize - 6)
                    .animation(.easeOut(duration: 1.2).delay(0.3), value: animateIn)
            }

            if day.isCompleted {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.divineGold.opacity(0.15),
                                Theme.divineGold.opacity(0.05),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: circleSize / 2
                        )
                    )
                    .frame(width: circleSize - 2, height: circleSize - 2)
            }
        }
    }

    private var circleStrokeColor: Color {
        if day.isCompleted {
            return Theme.divineGold.opacity(0.3)
        } else if day.isCurrent {
            return Theme.divineGold.opacity(0.25)
        } else if day.isFuture {
            return Theme.sandDark.opacity(0.15)
        } else {
            return Theme.sandDark.opacity(0.2)
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
            return Theme.divineGold.opacity(0.7)
        } else if day.isFuture {
            return Theme.sandDark.opacity(0.12)
        } else {
            return Theme.sandDark.opacity(0.25)
        }
    }
}

struct CircularFillArc: Shape, Animatable {
    var percentage: Double

    var animatableData: Double {
        get { percentage }
        set { percentage = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(-90),
            endAngle: .degrees(-90 + 360 * percentage),
            clockwise: false
        )
        return path
    }
}
