import SwiftUI

struct SanctuaryRoomInteriorView: View {
    let room: PrayerRoom
    @Environment(\.dismiss) private var dismiss

    @State private var hasEntered: Bool = false
    @State private var haloPulse: Bool = false
    @State private var showControls: Bool = true
    @State private var isMuted: Bool = false
    @State private var prayerLifted: Bool = false
    @State private var bloomScale: CGFloat = 0.0
    @State private var bloomOpacity: Double = 0.0
    @State private var waveformPhase: CGFloat = 0
    @State private var orbitAngle: Double = 0
    @State private var particleDensity: Int = 80
    @State private var litAvatarIndex: Int? = nil

    private let scriptureLines: [String] = [
        "\"The Lord is my shepherd; I shall not want.\"",
        "\"He makes me lie down in green pastures.\"",
        "\"He leads me beside still waters.\"",
        "\"He restores my soul.\"",
        "\"Even though I walk through the valley of the shadow of death,\"",
        "\"I will fear no evil, for you are with me.\""
    ]
    @State private var currentLineIndex: Int = 0

    private let constellationCount: Int = 12

    var body: some View {
        ZStack {
            backgroundLayer

            constellationLayer

            centralHaloView

            VStack {
                topControls
                Spacer()
                scriptureText
                waveformBar
                    .padding(.bottom, 8)
                liftPrayerButton
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)

            if bloomScale > 0 {
                bloomEffect
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .onAppear {
            withAnimation(.easeOut(duration: 1.2)) {
                hasEntered = true
            }
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                haloPulse = true
            }
            withAnimation(.linear(duration: 120).repeatForever(autoreverses: false)) {
                orbitAngle = 360
            }
            startScriptureRotation()
            startWaveformAnimation()
            autoHideControls()
        }
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.3)) {
                showControls = true
            }
            autoHideControls()
        }
    }

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.10, blue: 0.08),
                    Color(red: 0.18, green: 0.15, blue: 0.12),
                    Color(red: 0.14, green: 0.12, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            SanctuaryParticleField(density: particleDensity)
                .ignoresSafeArea()
                .opacity(hasEntered ? 0.7 : 0.0)
        }
    }

    private var centralHaloView: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.goldAccent.opacity(0.06),
                            Theme.goldAccent.opacity(0.02),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 40,
                        endRadius: 180
                    )
                )
                .frame(width: 360, height: 360)
                .scaleEffect(haloPulse ? 1.08 : 0.95)
                .opacity(hasEntered ? 1 : 0)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.goldAccent.opacity(0.12),
                            Theme.goldAccent.opacity(0.04),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 20,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .scaleEffect(haloPulse ? 1.05 : 0.98)
                .opacity(hasEntered ? 1 : 0)

            Circle()
                .stroke(Theme.goldAccent.opacity(0.2), lineWidth: 1)
                .frame(width: 160, height: 160)
                .scaleEffect(haloPulse ? 1.03 : 0.97)

            Circle()
                .stroke(Theme.goldAccent.opacity(0.1), lineWidth: 0.5)
                .frame(width: 200, height: 200)
                .scaleEffect(haloPulse ? 1.06 : 0.94)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.goldAccent.opacity(0.25),
                                Theme.goldAccent.opacity(0.08),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: 50
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: room.icon)
                    .font(.system(size: 36, weight: .light))
                    .foregroundStyle(Theme.goldAccent)
            }
            .opacity(hasEntered ? 1 : 0)
            .scaleEffect(hasEntered ? 1 : 0.5)
        }
        .offset(y: -40)
    }

    private var constellationLayer: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2 - 40)
            let radius: CGFloat = 140

            ForEach(0..<constellationCount, id: \.self) { index in
                let baseAngle = (Double(index) / Double(constellationCount)) * 360.0
                let angle = baseAngle + orbitAngle * (index.isMultiple(of: 2) ? 0.3 : 0.2)
                let rad = angle * .pi / 180
                let x = center.x + radius * cos(rad) + CGFloat(index * 3 % 20) - 10
                let y = center.y + radius * sin(rad) + CGFloat(index * 7 % 16) - 8

                ConstellationAvatar(
                    index: index,
                    isLit: litAvatarIndex == index
                )
                .position(x: x, y: y)
                .opacity(hasEntered ? 1 : 0)
                .animation(.easeOut(duration: 0.8).delay(Double(index) * 0.08), value: hasEntered)
            }
        }
        .allowsHitTesting(false)
    }

    private var topControls: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textCream.opacity(0.6))
                    .frame(width: 40, height: 40)
            }

            Spacer()

            VStack(spacing: 2) {
                Text(room.name)
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textCream.opacity(0.7))

                HStack(spacing: 4) {
                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 5, height: 5)
                    Text("\(room.activeNow) present")
                        .font(.system(size: 11, design: .serif))
                        .foregroundStyle(Theme.textCream.opacity(0.4))
                }
            }

            Spacer()

            Button {
                isMuted.toggle()
            } label: {
                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Theme.textCream.opacity(0.6))
                    .frame(width: 40, height: 40)
            }
        }
        .padding(.top, 56)
        .opacity(showControls ? 1 : 0.15)
        .animation(.easeInOut(duration: 0.4), value: showControls)
    }

    private var scriptureText: some View {
        VStack(spacing: 12) {
            Text(scriptureLines[currentLineIndex])
                .font(.system(size: 18, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(Theme.textCream.opacity(0.8))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .id(currentLineIndex)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .offset(y: 8)),
                    removal: .opacity.combined(with: .offset(y: -8))
                ))
                .animation(.easeInOut(duration: 0.8), value: currentLineIndex)

            Text("— Psalm 23")
                .font(.system(size: 13, design: .serif))
                .foregroundStyle(Theme.goldAccent.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    private var waveformBar: some View {
        HStack(spacing: 2) {
            ForEach(0..<40, id: \.self) { index in
                let height = waveformHeight(for: index)
                RoundedRectangle(cornerRadius: 1)
                    .fill(Theme.goldAccent.opacity(0.35))
                    .frame(width: 3, height: height)
            }
        }
        .frame(height: 20)
        .opacity(isMuted ? 0.2 : 0.6)
        .animation(.easeInOut(duration: 0.3), value: isMuted)
    }

    private var liftPrayerButton: some View {
        Button {
            triggerPrayerBloom()
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "hands.and.sparkles.fill")
                    .font(.system(size: 16))
                Text("Lift in Prayer")
                    .font(.system(size: 16, weight: .medium, design: .serif))
            }
            .foregroundStyle(Theme.goldAccent)
            .padding(.horizontal, 36)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .stroke(Theme.goldAccent.opacity(prayerLifted ? 0.8 : 0.4), lineWidth: 1)
                    .background(
                        Capsule()
                            .fill(Theme.goldAccent.opacity(prayerLifted ? 0.12 : 0.04))
                    )
            )
        }
        .sensoryFeedback(.impact(weight: .medium, intensity: 0.7), trigger: prayerLifted)
    }

    private var bloomEffect: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.goldAccent.opacity(0.3),
                        Theme.goldAccent.opacity(0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 200
                )
            )
            .frame(width: 400, height: 400)
            .scaleEffect(bloomScale)
            .opacity(bloomOpacity)
            .offset(y: -40)
            .allowsHitTesting(false)
    }

    private func waveformHeight(for index: Int) -> CGFloat {
        let base = sin(CGFloat(index) * 0.5 + waveformPhase) * 6 + 8
        let variation = cos(CGFloat(index) * 0.3 + waveformPhase * 1.3) * 3
        return max(2, base + variation)
    }

    private func triggerPrayerBloom() {
        prayerLifted = true
        bloomScale = 0.1
        bloomOpacity = 1.0

        let randomAvatar = Int.random(in: 0..<constellationCount)
        litAvatarIndex = randomAvatar

        withAnimation(.easeOut(duration: 1.5)) {
            bloomScale = 1.5
            bloomOpacity = 0.0
        }

        Task {
            try? await Task.sleep(for: .seconds(1.5))
            bloomScale = 0
            prayerLifted = false
            litAvatarIndex = nil
        }
    }

    private func startScriptureRotation() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(6.0))
                withAnimation {
                    currentLineIndex = (currentLineIndex + 1) % scriptureLines.count
                }
            }
        }
    }

    private func startWaveformAnimation() {
        Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(80))
                waveformPhase += 0.15
            }
        }
    }

    private func autoHideControls() {
        Task {
            try? await Task.sleep(for: .seconds(4.0))
            withAnimation(.easeInOut(duration: 0.6)) {
                showControls = false
            }
        }
    }
}

struct ConstellationAvatar: View {
    let index: Int
    let isLit: Bool

    @State private var driftPhase: Bool = false

    private var avatarColor: Color {
        let colors: [Color] = [
            Color(red: 0.72, green: 0.62, blue: 0.52),
            Color(red: 0.62, green: 0.55, blue: 0.48),
            Color(red: 0.78, green: 0.68, blue: 0.58),
            Color(red: 0.68, green: 0.58, blue: 0.50),
        ]
        return colors[index % colors.count]
    }

    var body: some View {
        ZStack {
            if isLit {
                Circle()
                    .fill(Theme.goldAccent.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .transition(.scale.combined(with: .opacity))
            }

            Circle()
                .fill(avatarColor.opacity(0.4))
                .frame(width: 26, height: 26)
                .overlay(
                    Circle()
                        .stroke(
                            isLit ? Theme.goldAccent.opacity(0.8) : Theme.goldAccent.opacity(0.15),
                            lineWidth: isLit ? 1.5 : 0.5
                        )
                )
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(Theme.textCream.opacity(0.5))
                )
        }
        .offset(y: driftPhase ? -3 : 3)
        .animation(.easeInOut(duration: Double(2 + index % 3)).repeatForever(autoreverses: true), value: driftPhase)
        .onAppear {
            driftPhase = true
        }
        .animation(.easeInOut(duration: 0.4), value: isLit)
    }
}

struct SanctuaryParticleField: View {
    let density: Int

    private let particles: [SanctuaryDust]

    init(density: Int) {
        self.density = density
        var rng = SeededRNG(seed: 99)
        var items: [SanctuaryDust] = []
        for i in 0..<density {
            items.append(SanctuaryDust(
                id: i,
                x: CGFloat.random(in: 0...1, using: &rng),
                y: CGFloat.random(in: 0...1, using: &rng),
                size: CGFloat.random(in: 1.5...4, using: &rng),
                baseOpacity: Double.random(in: 0.1...0.4, using: &rng)
            ))
        }
        self.particles = items
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles, id: \.id) { p in
                SanctuaryDustView(dust: p, geoSize: geo.size)
            }
        }
    }
}

nonisolated struct SanctuaryDust: Sendable {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let baseOpacity: Double
}

struct SanctuaryDustView: View {
    let dust: SanctuaryDust
    let geoSize: CGSize

    @State private var shimmer: Bool = false

    var body: some View {
        Circle()
            .fill(Theme.goldAccent)
            .frame(width: dust.size, height: dust.size)
            .opacity(shimmer ? dust.baseOpacity * 1.5 : dust.baseOpacity * 0.5)
            .position(x: dust.x * geoSize.width, y: dust.y * geoSize.height)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2.0...4.0))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2))
                ) {
                    shimmer = true
                }
            }
    }
}
