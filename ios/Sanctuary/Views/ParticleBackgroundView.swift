import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let opacity: Double
    let color: Color
}

struct ParticleBackgroundView: View {
    let particles: [Particle]

    init(seed: Int = 42) {
        var rng = SeededRNG(seed: UInt64(seed))
        var items: [Particle] = []
        for _ in 0..<60 {
            let colors: [Color] = [Theme.particleDot, Theme.particleDotLight, Theme.particleGold, Theme.warmBeige]
            items.append(Particle(
                x: CGFloat.random(in: 0...1, using: &rng),
                y: CGFloat.random(in: 0...1, using: &rng),
                size: CGFloat.random(in: 2...5, using: &rng),
                opacity: Double.random(in: 0.15...0.5, using: &rng),
                color: colors[Int.random(in: 0..<colors.count, using: &rng)]
            ))
        }
        self.particles = items
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles) { p in
                Circle()
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .opacity(p.opacity)
                    .position(x: p.x * geo.size.width, y: p.y * geo.size.height)
            }
        }
    }
}

nonisolated struct SeededRNG: RandomNumberGenerator, Sendable {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
