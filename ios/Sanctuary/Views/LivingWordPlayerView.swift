import SwiftUI

struct LivingWordPlayerView: View {
    let item: JourneyContentItem
    let onDismiss: () -> Void

    @State private var viewModel: LivingWordPlayerViewModel

    init(item: JourneyContentItem, onDismiss: @escaping () -> Void) {
        self.item = item
        self.onDismiss = onDismiss
        let session = ScriptureSession.session(for: item.title)
        _viewModel = State(initialValue: LivingWordPlayerViewModel(session: session))
    }

    var body: some View {
        ZStack {
            playerBackground
            goldenDustLayer
            centralHaloComposition
            controlsOverlay
            if viewModel.isComplete {
                completionOverlay
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .onAppear { viewModel.beginSession() }
        .onDisappear { viewModel.cleanup() }
        .onTapGesture { viewModel.revealControls() }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.4), trigger: viewModel.heartbeatTrigger)
    }

    private var playerBackground: some View {
        ZStack {
            Color(red: 0.96 + viewModel.backgroundWarmth,
                  green: 0.93 - viewModel.backgroundWarmth * 0.3,
                  blue: 0.87 - viewModel.backgroundWarmth * 0.6)
                .ignoresSafeArea()

            RadialGradient(
                colors: [
                    Theme.goldAccent.opacity(0.04 + viewModel.backgroundWarmth * 0.12),
                    Color.clear
                ],
                center: .center,
                startRadius: 60,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }

    private var goldenDustLayer: some View {
        LivingWordParticleField(density: 50)
            .ignoresSafeArea()
            .opacity(viewModel.hasEntered ? 0.5 : 0)
            .animation(.easeIn(duration: 1.5), value: viewModel.hasEntered)
    }

    private var centralHaloComposition: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.38)
            let haloSize: CGFloat = min(geo.size.width * 0.65, 280)

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
                            startRadius: 20,
                            endRadius: haloSize * 0.9
                        )
                    )
                    .frame(width: haloSize * 1.6, height: haloSize * 1.6)
                    .scaleEffect(viewModel.haloPulse ? 1.06 : 0.96)

                progressRing(size: haloSize)

                Circle()
                    .stroke(Theme.goldAccent.opacity(0.12), lineWidth: 0.5)
                    .frame(width: haloSize * 0.7, height: haloSize * 0.7)
                    .scaleEffect(viewModel.haloPulse ? 1.04 : 0.97)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.goldAccent.opacity(0.18),
                                Theme.goldAccent.opacity(0.06),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: haloSize * 0.25
                        )
                    )
                    .frame(width: haloSize * 0.5, height: haloSize * 0.5)

                Image(systemName: item.icon)
                    .font(.system(size: haloSize * 0.12, weight: .light))
                    .foregroundStyle(Theme.goldAccent.opacity(0.7))
            }
            .position(center)
            .opacity(viewModel.hasEntered ? 1 : 0)
            .scaleEffect(viewModel.hasEntered ? 1 : 0.6)
            .animation(.spring(duration: 1.0, bounce: 0.2), value: viewModel.hasEntered)
        }
        .allowsHitTesting(false)
    }

    private func progressRing(size: CGFloat) -> some View {
        ZStack {
            Circle()
                .stroke(Theme.sandDark.opacity(0.08), lineWidth: 2)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: viewModel.progressArc)
                .stroke(
                    AngularGradient(
                        colors: [
                            Theme.goldAccent.opacity(0.2),
                            Theme.goldAccent.opacity(0.8),
                            Theme.goldLight
                        ],
                        center: .center,
                        startAngle: .degrees(-90),
                        endAngle: .degrees(270)
                    ),
                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))

            if viewModel.progressArc > 0 {
                Circle()
                    .fill(Theme.goldAccent)
                    .frame(width: 6, height: 6)
                    .shadow(color: Theme.goldAccent.opacity(0.5), radius: 4)
                    .offset(y: -size / 2)
                    .rotationEffect(.degrees(360 * viewModel.progressArc - 90))
            }
        }
    }

    private var controlsOverlay: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.top, 60)
                .padding(.horizontal, 24)
                .opacity(viewModel.showControls ? 1 : 0.1)

            Spacer()

            communityWhisper
                .padding(.bottom, 8)

            verseDisplay
                .padding(.horizontal, 32)
                .padding(.bottom, 24)

            verseNavigation
                .padding(.bottom, 20)

            waveformVisualizer
                .padding(.horizontal, 40)
                .padding(.bottom, 16)

            sliderControls
                .padding(.horizontal, 32)
                .padding(.bottom, 50)
        }
    }

    private var topBar: some View {
        HStack(alignment: .top) {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Theme.textMedium.opacity(0.7))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Theme.warmBeige.opacity(0.5))
                    )
            }

            Spacer()

            VStack(spacing: 3) {
                Text(viewModel.session.title)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textDark.opacity(0.8))
                Text(viewModel.session.subtitle)
                    .font(.system(size: 12, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
            }

            Spacer()

            Button {
                viewModel.isMuted.toggle()
            } label: {
                Image(systemName: viewModel.isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(Theme.textMedium.opacity(0.7))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Theme.warmBeige.opacity(0.5))
                    )
            }
        }
        .animation(.easeInOut(duration: 0.4), value: viewModel.showControls)
    }

    private var communityWhisper: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(Theme.goldAccent.opacity(0.6))
                .frame(width: 5, height: 5)
            Text("You are reading this with \(viewModel.session.readingWith) others right now")
                .font(.system(size: 12, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
        }
        .opacity(viewModel.hasEntered ? 0.8 : 0)
        .animation(.easeIn(duration: 1.0).delay(1.2), value: viewModel.hasEntered)
    }

    private var verseDisplay: some View {
        VStack(spacing: 16) {
            Text(viewModel.currentVerse.text)
                .font(.system(size: 20, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(Theme.textDark.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .id(viewModel.currentVerseIndex)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .offset(y: 12)).combined(with: .scale(scale: 0.98)),
                    removal: .opacity.combined(with: .offset(y: -12)).combined(with: .scale(scale: 0.98))
                ))
                .animation(.easeInOut(duration: 0.9), value: viewModel.currentVerseIndex)

            Text(viewModel.currentVerse.reference)
                .font(.system(size: 12, weight: .semibold, design: .serif))
                .tracking(1.2)
                .foregroundStyle(Theme.goldAccent.opacity(0.7))
                .id("ref-\(viewModel.currentVerseIndex)")
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.6).delay(0.2), value: viewModel.currentVerseIndex)
        }
        .frame(minHeight: 120)
    }

    private var verseNavigation: some View {
        HStack(spacing: 40) {
            Button {
                viewModel.retreat()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(viewModel.currentVerseIndex > 0 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Theme.warmBeige.opacity(0.4))
                    )
            }
            .disabled(viewModel.currentVerseIndex == 0)

            Button {
                viewModel.togglePlayPause()
            } label: {
                Image(systemName: viewModel.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.goldAccent)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(Theme.goldAccent.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                            )
                    )
            }

            Button {
                viewModel.advanceVerse()
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(viewModel.currentVerseIndex < viewModel.totalVerses - 1 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Theme.warmBeige.opacity(0.4))
                    )
            }
            .disabled(viewModel.currentVerseIndex >= viewModel.totalVerses - 1)
        }
    }

    private var waveformVisualizer: some View {
        HStack(spacing: 2.5) {
            ForEach(0..<36, id: \.self) { index in
                let height = waveformHeight(for: index)
                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.goldAccent.opacity(0.25),
                                Theme.goldAccent.opacity(0.5)
                            ],
                            startPoint: .bottom,
                            endPoint: .top
                        )
                    )
                    .frame(width: 3, height: height)
            }
        }
        .frame(height: 24)
        .opacity(viewModel.isMuted ? 0.15 : 0.5)
        .animation(.easeInOut(duration: 0.3), value: viewModel.isMuted)
    }

    private var sliderControls: some View {
        HStack(spacing: 20) {
            PlayerSlider(
                label: "Ambient",
                icon: "leaf.fill",
                value: $viewModel.ambientLevel
            )

            PlayerSlider(
                label: "Focus",
                icon: "eye.fill",
                value: $viewModel.focusLevel
            )
        }
        .opacity(viewModel.showControls ? 1 : 0.2)
        .animation(.easeInOut(duration: 0.4), value: viewModel.showControls)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.0001)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Theme.goldAccent.opacity(0.1))
                        .frame(width: 80, height: 80)

                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(Theme.goldAccent)
                }

                Text("Reading Complete")
                    .font(.system(size: 24, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("You read \(viewModel.totalVerses) verses")
                    .font(.system(size: 15, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)

                Button(action: onDismiss) {
                    HStack(spacing: 10) {
                        Text("Return to Journey")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(Theme.cream)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Theme.textDark)
                    )
                    .overlay(
                        Capsule()
                            .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.top, 8)
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(Theme.cream)
                    .shadow(color: Theme.sandDark.opacity(0.15), radius: 30, y: 10)
            )
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .animation(.spring(duration: 0.6, bounce: 0.2), value: viewModel.isComplete)
    }

    private func waveformHeight(for index: Int) -> CGFloat {
        let phase = viewModel.waveformPhase
        let base = sin(CGFloat(index) * 0.45 + phase) * 7 + 9
        let variation = cos(CGFloat(index) * 0.3 + phase * 1.2) * 3
        return max(2, base + variation)
    }
}

private struct PlayerSlider: View {
    let label: String
    let icon: String
    @Binding var value: Double

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(Theme.goldAccent.opacity(0.7))
                Text(label)
                    .font(.system(size: 11, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Theme.sandDark.opacity(0.1))
                        .frame(height: 6)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * value, height: 6)

                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 16, height: 16)
                        .shadow(color: Theme.goldAccent.opacity(0.3), radius: 4)
                        .offset(x: max(0, min(geo.size.width * value - 8, geo.size.width - 16)))
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    let newVal = drag.location.x / geo.size.width
                                    value = min(max(newVal, 0), 1)
                                }
                        )
                }
                .frame(height: 16)
            }
            .frame(height: 16)
        }
    }
}

struct LivingWordParticleField: View {
    let density: Int

    private let particles: [LivingWordDust]

    init(density: Int) {
        self.density = density
        var rng = SeededRNG(seed: 77)
        var items: [LivingWordDust] = []
        for i in 0..<density {
            items.append(LivingWordDust(
                id: i,
                x: CGFloat.random(in: 0...1, using: &rng),
                y: CGFloat.random(in: 0...1, using: &rng),
                size: CGFloat.random(in: 1.5...4.5, using: &rng),
                baseOpacity: Double.random(in: 0.12...0.35, using: &rng)
            ))
        }
        self.particles = items
    }

    var body: some View {
        GeometryReader { geo in
            ForEach(particles, id: \.id) { p in
                LivingWordDustView(dust: p, geoSize: geo.size)
            }
        }
    }
}

nonisolated struct LivingWordDust: Sendable {
    let id: Int
    let x: CGFloat
    let y: CGFloat
    let size: CGFloat
    let baseOpacity: Double
}

struct LivingWordDustView: View {
    let dust: LivingWordDust
    let geoSize: CGSize

    @State private var shimmer: Bool = false
    @State private var drift: Bool = false

    var body: some View {
        Circle()
            .fill(Theme.goldAccent)
            .frame(width: dust.size, height: dust.size)
            .opacity(shimmer ? dust.baseOpacity * 1.6 : dust.baseOpacity * 0.4)
            .position(
                x: dust.x * geoSize.width + (drift ? 4 : -4),
                y: dust.y * geoSize.height + (drift ? -3 : 3)
            )
            .onAppear {
                withAnimation(
                    .easeInOut(duration: Double.random(in: 2.5...4.5))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...2))
                ) {
                    shimmer = true
                }
                withAnimation(
                    .easeInOut(duration: Double.random(in: 6...10))
                    .repeatForever(autoreverses: true)
                    .delay(Double.random(in: 0...3))
                ) {
                    drift = true
                }
            }
    }
}
