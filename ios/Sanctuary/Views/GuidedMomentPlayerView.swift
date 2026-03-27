import SwiftUI

struct GuidedMomentPlayerView: View {
    let onDismiss: () -> Void

    @State private var hasEntered: Bool = false
    @State private var haloPulse: Bool = false
    @State private var currentVerseIndex: Int = 0
    @State private var isPlaying: Bool = true
    @State private var progressArc: Double = 0
    @State private var waveformPhase: CGFloat = 0
    @State private var showControls: Bool = true
    @State private var isMuted: Bool = false
    @State private var isComplete: Bool = false
    @State private var heartbeatTrigger: Int = 0
    @State private var backgroundWarmth: Double = 0

    private let verses: [(text: String, reference: String)] = [
        ("Be still, and know that I am God.", "Psalm 46:10"),
        ("Cast all your anxiety on him because he cares for you.", "1 Peter 5:7"),
        ("The Lord is close to the brokenhearted and saves those who are crushed in spirit.", "Psalm 34:18"),
        ("Come to me, all you who are weary and burdened, and I will give you rest.", "Matthew 11:28"),
        ("Peace I leave with you; my peace I give you.", "John 14:27"),
        ("He restores my soul. He leads me in paths of righteousness for his name's sake.", "Psalm 23:3"),
    ]

    var body: some View {
        ZStack {
            playerBackground
            LivingWordParticleField(density: 45)
                .ignoresSafeArea()
                .opacity(hasEntered ? 0.45 : 0)
                .animation(.easeIn(duration: 1.5), value: hasEntered)

            centralHalo
            controlsOverlay

            if isComplete {
                completionOverlay
            }
        }
        .ignoresSafeArea()
        .statusBar(hidden: true)
        .onAppear { startSession() }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                showControls = true
            }
            Task {
                try? await Task.sleep(for: .seconds(4))
                withAnimation { showControls = false }
            }
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.4), trigger: heartbeatTrigger)
    }

    private var playerBackground: some View {
        ZStack {
            Color(red: 0.96 + backgroundWarmth,
                  green: 0.93 - backgroundWarmth * 0.3,
                  blue: 0.87 - backgroundWarmth * 0.6)
                .ignoresSafeArea()

            RadialGradient(
                colors: [Theme.goldAccent.opacity(0.05 + backgroundWarmth * 0.1), Color.clear],
                center: .center,
                startRadius: 60,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }

    private var centralHalo: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.35)
            let haloSize: CGFloat = min(geo.size.width * 0.6, 260)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.goldAccent.opacity(0.07), Theme.goldAccent.opacity(0.02), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: haloSize * 0.9
                        )
                    )
                    .frame(width: haloSize * 1.6, height: haloSize * 1.6)
                    .scaleEffect(haloPulse ? 1.06 : 0.96)

                ZStack {
                    Circle()
                        .stroke(Theme.sandDark.opacity(0.08), lineWidth: 2)
                        .frame(width: haloSize, height: haloSize)
                    Circle()
                        .trim(from: 0, to: progressArc)
                        .stroke(
                            AngularGradient(
                                colors: [Theme.goldAccent.opacity(0.2), Theme.goldAccent.opacity(0.8), Theme.goldLight],
                                center: .center,
                                startAngle: .degrees(-90),
                                endAngle: .degrees(270)
                            ),
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: haloSize, height: haloSize)
                        .rotationEffect(.degrees(-90))
                }

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.goldAccent.opacity(0.18), Theme.goldAccent.opacity(0.06), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: haloSize * 0.25
                        )
                    )
                    .frame(width: haloSize * 0.5, height: haloSize * 0.5)

                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: haloSize * 0.1, weight: .light))
                    .foregroundStyle(Theme.goldAccent.opacity(0.7))
            }
            .position(center)
            .opacity(hasEntered ? 1 : 0)
            .scaleEffect(hasEntered ? 1 : 0.6)
            .animation(.spring(duration: 1.0, bounce: 0.2), value: hasEntered)
        }
        .allowsHitTesting(false)
    }

    private var controlsOverlay: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Theme.textMedium.opacity(0.7))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.5)))
                }
                Spacer()
                VStack(spacing: 3) {
                    Text("Guided Moment")
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textDark.opacity(0.8))
                    Text("Be still and know")
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
                Spacer()
                Button {
                    isMuted.toggle()
                } label: {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.textMedium.opacity(0.7))
                        .frame(width: 36, height: 36)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.5)))
                }
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            .opacity(showControls ? 1 : 0.1)

            Spacer()

            HStack(spacing: 6) {
                Circle()
                    .fill(Theme.goldAccent.opacity(0.6))
                    .frame(width: 5, height: 5)
                Text("12,403 souls are in this moment with you")
                    .font(.system(size: 12, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
            }
            .opacity(hasEntered ? 0.8 : 0)
            .padding(.bottom, 8)

            VStack(spacing: 14) {
                Text(verses[currentVerseIndex].text)
                    .font(.system(size: 20, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textDark.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(8)
                    .id(currentVerseIndex)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .offset(y: 12)),
                        removal: .opacity.combined(with: .offset(y: -12))
                    ))
                    .animation(.easeInOut(duration: 0.9), value: currentVerseIndex)

                Text(verses[currentVerseIndex].reference)
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .tracking(1.2)
                    .foregroundStyle(Theme.goldAccent.opacity(0.7))
            }
            .frame(minHeight: 120)
            .padding(.horizontal, 32)
            .padding(.bottom, 20)

            HStack(spacing: 40) {
                Button {
                    guard currentVerseIndex > 0 else { return }
                    withAnimation { currentVerseIndex -= 1 }
                    updateProgress()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(currentVerseIndex > 0 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.4)))
                }
                .disabled(currentVerseIndex == 0)

                Button {
                    isPlaying.toggle()
                    if isPlaying { scheduleAutoAdvance() }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Theme.goldAccent.opacity(0.1))
                                .overlay(Circle().stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1))
                        )
                }

                Button {
                    advanceVerse()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(currentVerseIndex < verses.count - 1 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.4)))
                }
                .disabled(currentVerseIndex >= verses.count - 1)
            }
            .padding(.bottom, 16)

            HStack(spacing: 2.5) {
                ForEach(0..<36, id: \.self) { index in
                    let height = sin(CGFloat(index) * 0.45 + waveformPhase) * 7 + 9
                    RoundedRectangle(cornerRadius: 1)
                        .fill(LinearGradient(colors: [Theme.goldAccent.opacity(0.25), Theme.goldAccent.opacity(0.5)], startPoint: .bottom, endPoint: .top))
                        .frame(width: 3, height: max(2, height))
                }
            }
            .frame(height: 24)
            .opacity(isMuted ? 0.15 : 0.5)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
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

                Text("Moment Complete")
                    .font(.system(size: 24, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("You meditated on \(verses.count) verses")
                    .font(.system(size: 15, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)

                Button(action: onDismiss) {
                    HStack(spacing: 10) {
                        Text("Return to Home")
                            .font(.system(size: 16, weight: .medium, design: .serif))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundStyle(Theme.cream)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(Capsule().fill(Theme.textDark))
                    .overlay(Capsule().stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1))
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
        .sensoryFeedback(.success, trigger: isComplete)
    }

    private func startSession() {
        withAnimation(.easeOut(duration: 1.0)) { hasEntered = true }
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) { haloPulse = true }
        startWaveform()
        scheduleAutoAdvance()
    }

    private func advanceVerse() {
        guard currentVerseIndex < verses.count - 1 else {
            withAnimation(.spring(duration: 0.6, bounce: 0.2)) { isComplete = true }
            return
        }
        withAnimation { currentVerseIndex += 1 }
        heartbeatTrigger += 1
        updateProgress()
        withAnimation(.easeOut(duration: 0.4)) {
            backgroundWarmth = Double(currentVerseIndex) / Double(verses.count) * 0.04
        }
    }

    private func updateProgress() {
        withAnimation(.easeInOut(duration: 0.8)) {
            progressArc = Double(currentVerseIndex + 1) / Double(verses.count)
        }
    }

    private func scheduleAutoAdvance() {
        Task {
            try? await Task.sleep(for: .seconds(8))
            guard isPlaying && !isComplete else { return }
            advanceVerse()
            if isPlaying && !isComplete { scheduleAutoAdvance() }
        }
    }

    private func startWaveform() {
        Task {
            while !isComplete {
                try? await Task.sleep(for: .milliseconds(80))
                waveformPhase += 0.12
            }
        }
    }
}
