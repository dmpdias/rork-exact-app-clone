import SwiftUI

struct DevotionScoreView: View {
    let score: Int = 73
    @State private var animatedProgress: Double = 0
    @State private var scoreOpacity: Double = 0
    @State private var unfillPulse: Bool = false
    @State private var glowHeadPulse: Bool = false

    private let dotCount = 60
    private let startAngle: Double = -90
    private let totalArc: Double = 360

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(label: "DEVOTION", title: "Your devotion, reflected.")
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

            VStack(spacing: 20) {
                ZStack {
                    Canvas { context, size in
                        drawRing(context: context, size: size)
                    }
                    .frame(width: 240, height: 240)

                    glowHeadView
                        .frame(width: 240, height: 240)

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
                    withAnimation(.easeOut(duration: 1.4).delay(0.15)) {
                        animatedProgress = Double(score) / 100.0
                    }
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        unfillPulse = true
                    }
                    withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true).delay(1.6)) {
                        glowHeadPulse = true
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

    private var glowHeadView: some View {
        GeometryReader { _ in
            let radius: CGFloat = 100
            let center = CGPoint(x: 120, y: 120)
            let headAngleDeg = startAngle + animatedProgress * totalArc
            let headAngleRad = headAngleDeg * .pi / 180
            let hx = center.x + radius * cos(headAngleRad)
            let hy = center.y + radius * sin(headAngleRad)
            let glowScale = glowHeadPulse ? 1.3 : 0.9

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.goldAccent.opacity(0.8),
                            Theme.goldLight.opacity(0.3),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 16
                    )
                )
                .frame(width: 32, height: 32)
                .scaleEffect(glowScale)
                .position(x: hx, y: hy)
                .opacity(animatedProgress > 0.02 ? 1 : 0)
        }
        .allowsHitTesting(false)
    }

    private func drawRing(context: GraphicsContext, size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius: CGFloat = 100
        let progress = animatedProgress
        let pulseAmount = unfillPulse ? 0.35 : 0.12

        for i in 0..<dotCount {
            let fraction = Double(i) / Double(dotCount)
            let angleDeg = startAngle + fraction * totalArc
            let angleRad = angleDeg * .pi / 180

            let x = center.x + radius * cos(angleRad)
            let y = center.y + radius * sin(angleRad)

            let isActive = fraction <= progress

            if isActive {
                let t = fraction / max(progress, 0.001)
                let warmth = t
                let baseColor = blendColor(from: Theme.goldDark, to: Theme.goldAccent, t: warmth)
                let dotSize: CGFloat = 4.0 + t * 2.5
                let opacity = 0.4 + t * 0.6

                let rect = CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)
                context.fill(Circle().path(in: rect), with: .color(baseColor.opacity(opacity)))

                if t > 0.7 {
                    let glowSize = dotSize * 2.5
                    let glowRect = CGRect(x: x - glowSize / 2, y: y - glowSize / 2, width: glowSize, height: glowSize)
                    let glowOpacity = (t - 0.7) / 0.3 * 0.2
                    context.fill(Circle().path(in: glowRect), with: .color(Theme.goldLight.opacity(glowOpacity)))
                }
            } else {
                let dotSize: CGFloat = 2.8
                let opacity = pulseAmount

                let rect = CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)
                context.fill(Circle().path(in: rect), with: .color(Theme.sandDark.opacity(opacity)))
            }
        }

        let shadowDotCount = 8
        let shadowStart = progress
        let shadowSpan = 0.08
        for i in 0..<shadowDotCount {
            let frac = Double(i) / Double(shadowDotCount)
            let fraction = shadowStart + frac * shadowSpan
            guard fraction <= 1.0 else { continue }

            let angleDeg = startAngle + fraction * totalArc
            let angleRad = angleDeg * .pi / 180
            let x = center.x + radius * cos(angleRad)
            let y = center.y + radius * sin(angleRad)

            let fadeOpacity = 0.25 * (1.0 - frac)
            let dotSize: CGFloat = 4.0 * (1.0 - frac * 0.5)

            let rect = CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)
            context.fill(Circle().path(in: rect), with: .color(Theme.goldAccent.opacity(fadeOpacity)))
        }
    }

    private func blendColor(from: Color, to: Color, t: Double) -> Color {
        let clamped = min(max(t, 0), 1)
        let fromComponents = UIColor(from).rgba
        let toComponents = UIColor(to).rgba

        return Color(
            red: fromComponents.r + (toComponents.r - fromComponents.r) * clamped,
            green: fromComponents.g + (toComponents.g - fromComponents.g) * clamped,
            blue: fromComponents.b + (toComponents.b - fromComponents.b) * clamped
        )
    }
}

private extension UIColor {
    var rgba: (r: Double, g: Double, b: Double, a: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b), Double(a))
    }
}
