import SwiftUI

struct DevotionScoreView: View {
    let score: Int = 73
    @State private var animatedProgress: Double = 0
    @State private var scoreOpacity: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(label: "DEVOTION", title: "Your devotion, reflected.")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

            VStack(spacing: 20) {
                ZStack {
                    DevotionArcView(progress: animatedProgress)
                        .frame(height: 220)

                    VStack(spacing: 4) {
                        Text("\(Int(animatedProgress * 100))")
                            .font(.system(size: 64, weight: .bold, design: .serif))
                            .foregroundStyle(Theme.textDark)
                            .contentTransition(.numericText(value: animatedProgress))

                        Text("D E V O T I O N")
                            .font(.system(size: 11, weight: .medium))
                            .tracking(3)
                            .foregroundStyle(Theme.textLight)
                    }
                    .opacity(scoreOpacity)
                }
                .onAppear {
                    withAnimation(.easeOut(duration: 0.4)) {
                        scoreOpacity = 1
                    }
                    withAnimation(.easeOut(duration: 1.2).delay(0.15)) {
                        animatedProgress = Double(score) / 100.0
                    }
                }

                Text("You're doing well, David — a little more grace\nand today becomes extraordinary.")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)

                Button(action: {}) {
                    Text("See what builds your score")
                        .font(.system(.subheadline, design: .serif))
                        .fontWeight(.medium)
                        .foregroundStyle(Theme.textDark)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .strokeBorder(Theme.sandDark.opacity(0.4), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct DevotionArcView: View, Animatable {
    var progress: Double

    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height * 0.55)
            let radius: CGFloat = min(size.width, size.height) * 0.42
            let startAngle: Double = -210
            let endAngle: Double = 30
            let totalArc = endAngle - startAngle
            let dotCount = 40

            for i in 0..<dotCount {
                let fraction = Double(i) / Double(dotCount - 1)
                let angleDeg = startAngle + fraction * totalArc
                let angleRad = angleDeg * .pi / 180

                let x = center.x + radius * cos(angleRad)
                let y = center.y + radius * sin(angleRad)

                let isActive = fraction <= progress
                let dotSize: CGFloat = isActive ? 5 : 3.5
                let opacity: Double = isActive ? (0.5 + fraction * 0.5) : 0.2

                let color: Color = isActive ? Theme.devotionArcGlow : Theme.particleDot

                let rect = CGRect(
                    x: x - dotSize / 2,
                    y: y - dotSize / 2,
                    width: dotSize,
                    height: dotSize
                )
                context.fill(Circle().path(in: rect), with: .color(color.opacity(opacity)))

                if isActive && fraction > 0.6 {
                    let glowRect = CGRect(
                        x: x - dotSize,
                        y: y - dotSize,
                        width: dotSize * 2,
                        height: dotSize * 2
                    )
                    context.fill(
                        Circle().path(in: glowRect),
                        with: .color(Theme.particleGold.opacity(0.15))
                    )
                }
            }
        }
    }
}
