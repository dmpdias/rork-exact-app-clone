import SwiftUI

struct CathedralBackgroundView: View {
    let glowIntensity: Double
    @State private var particleDrift: Bool = false

    private let dustMotes: [DustMote] = (0..<25).map { _ in
        DustMote(
            x: Double.random(in: 0...1),
            y: Double.random(in: 0...1),
            size: Double.random(in: 1.5...4),
            baseOpacity: Double.random(in: 0.08...0.25),
            driftX: Double.random(in: -0.02...0.02),
            driftY: Double.random(in: -0.015...0.005),
            speed: Double.random(in: 4...8)
        )
    }

    var body: some View {
        ZStack {
            Color(red: 0.92, green: 0.86, blue: 0.78)
                .ignoresSafeArea()

            GeometryReader { geo in
                Image("CathedralBG")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .blur(radius: 2 * (1.0 - glowIntensity * 0.3))
            }
            .ignoresSafeArea()

            Color(red: 0.18, green: 0.14, blue: 0.10)
                .opacity(0.35)
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    Theme.goldAccent.opacity(0.15 * glowIntensity),
                    Theme.goldDark.opacity(0.08 * glowIntensity),
                    Color.clear
                ],
                center: .init(x: 0.5, y: 0.3),
                startRadius: 40,
                endRadius: 300
            )
            .ignoresSafeArea()

            Canvas { context, size in
                for mote in dustMotes {
                    let drift = particleDrift ? 1.0 : 0.0
                    let x = (mote.x + mote.driftX * drift) * size.width
                    let y = (mote.y + mote.driftY * drift) * size.height
                    let wrappedX = x.truncatingRemainder(dividingBy: size.width)
                    let wrappedY = y.truncatingRemainder(dividingBy: size.height)
                    let flickerOpacity = mote.baseOpacity * (particleDrift ? 0.7 : 1.0)

                    context.opacity = flickerOpacity * glowIntensity
                    context.fill(
                        Circle().path(in: CGRect(
                            x: wrappedX - mote.size / 2,
                            y: wrappedY - mote.size / 2,
                            width: mote.size,
                            height: mote.size
                        )),
                        with: .color(Theme.particleGold)
                    )
                }
            }
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 6).repeatForever(autoreverses: true), value: particleDrift)
        }
        .onAppear {
            particleDrift = true
        }
    }
}

nonisolated struct DustMote: Sendable {
    let x: Double
    let y: Double
    let size: Double
    let baseOpacity: Double
    let driftX: Double
    let driftY: Double
    let speed: Double
}
