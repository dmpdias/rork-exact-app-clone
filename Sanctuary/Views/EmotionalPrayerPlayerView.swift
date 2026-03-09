import SwiftUI

struct EmotionalPrayerPlayerView: View {
    let bead: EmotionalBead
    let onDismiss: () -> Void

    @State private var hasEntered: Bool = false
    @State private var haloPulse: Bool = false
    @State private var currentPrayerIndex: Int = 0
    @State private var isPlaying: Bool = true
    @State private var progressArc: Double = 0
    @State private var waveformPhase: CGFloat = 0
    @State private var showControls: Bool = true
    @State private var isComplete: Bool = false
    @State private var heartbeatTrigger: Int = 0
    @State private var backgroundWarmth: Double = 0
    @State private var breathScale: CGFloat = 1.0
    @State private var breathOpacity: Double = 0.06

    private var prayers: [EmotionalPrayer] {
        EmotionalPrayer.prayers(for: bead)
    }

    var body: some View {
        ZStack {
            playerBackground
            LivingWordParticleField(density: 40)
                .ignoresSafeArea()
                .opacity(hasEntered ? 0.4 : 0)
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
            withAnimation(.easeInOut(duration: 0.3)) { showControls = true }
            Task {
                try? await Task.sleep(for: .seconds(5))
                withAnimation { showControls = false }
            }
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.3), trigger: heartbeatTrigger)
    }

    private var playerBackground: some View {
        ZStack {
            Color(red: 0.96 + backgroundWarmth,
                  green: 0.93 - backgroundWarmth * 0.25,
                  blue: 0.87 - backgroundWarmth * 0.5)
                .ignoresSafeArea()

            RadialGradient(
                colors: [bead.accentColor.opacity(0.06 + backgroundWarmth * 0.08), Color.clear],
                center: .center,
                startRadius: 60,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }

    private var centralHalo: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.34)
            let haloSize: CGFloat = min(geo.size.width * 0.6, 260)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [bead.accentColor.opacity(breathOpacity), bead.accentColor.opacity(0.02), Color.clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: haloSize * 0.9
                        )
                    )
                    .frame(width: haloSize * 1.6, height: haloSize * 1.6)
                    .scaleEffect(breathScale)

                ZStack {
                    Circle()
                        .stroke(Theme.sandDark.opacity(0.08), lineWidth: 2)
                        .frame(width: haloSize, height: haloSize)
                    Circle()
                        .trim(from: 0, to: progressArc)
                        .stroke(
                            AngularGradient(
                                colors: [bead.accentColor.opacity(0.2), bead.accentColor.opacity(0.7), Theme.goldLight],
                                center: .center,
                                startAngle: .degrees(-90),
                                endAngle: .degrees(270)
                            ),
                            style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
                        )
                        .frame(width: haloSize, height: haloSize)
                        .rotationEffect(.degrees(-90))

                    if progressArc > 0 {
                        Circle()
                            .fill(bead.accentColor)
                            .frame(width: 6, height: 6)
                            .shadow(color: bead.accentColor.opacity(0.5), radius: 4)
                            .offset(y: -haloSize / 2)
                            .rotationEffect(.degrees(360 * progressArc - 90))
                    }
                }

                Circle()
                    .stroke(bead.accentColor.opacity(0.1), lineWidth: 0.5)
                    .frame(width: haloSize * 0.7, height: haloSize * 0.7)
                    .scaleEffect(haloPulse ? 1.04 : 0.97)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [bead.accentColor.opacity(0.18), bead.accentColor.opacity(0.06), Color.clear],
                            center: .center,
                            startRadius: 0,
                            endRadius: haloSize * 0.25
                        )
                    )
                    .frame(width: haloSize * 0.5, height: haloSize * 0.5)

                Image(systemName: bead.icon)
                    .font(.system(size: haloSize * 0.11, weight: .light))
                    .foregroundStyle(bead.accentColor.opacity(0.7))
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
                    Text("Prayer for \(bead.rawValue)")
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textDark.opacity(0.8))
                    Text(bead.prayerSubtitle)
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
                Spacer()
                Text("\(currentPrayerIndex + 1)/\(prayers.count)")
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .frame(width: 36, height: 36)
            }
            .padding(.top, 60)
            .padding(.horizontal, 24)
            .opacity(showControls ? 1 : 0.1)
            .animation(.easeInOut(duration: 0.4), value: showControls)

            Spacer()

            breathingGuide
                .padding(.bottom, 12)

            HStack(spacing: 6) {
                Circle()
                    .fill(bead.accentColor.opacity(0.6))
                    .frame(width: 5, height: 5)
                Text("\(Int.random(in: 340...2800)) souls praying for \(bead.rawValue.lowercased()) right now")
                    .font(.system(size: 12, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
            }
            .opacity(hasEntered ? 0.8 : 0)
            .animation(.easeIn(duration: 1.0).delay(1.0), value: hasEntered)
            .padding(.bottom, 8)

            VStack(spacing: 16) {
                Text(prayers[currentPrayerIndex].text)
                    .font(.system(size: 19, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textDark.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .lineSpacing(7)
                    .id(currentPrayerIndex)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .offset(y: 14)),
                        removal: .opacity.combined(with: .offset(y: -14))
                    ))
                    .animation(.easeInOut(duration: 0.9), value: currentPrayerIndex)

                if !prayers[currentPrayerIndex].reference.isEmpty {
                    Text(prayers[currentPrayerIndex].reference)
                        .font(.system(size: 11, weight: .semibold, design: .serif))
                        .tracking(1.2)
                        .foregroundStyle(bead.accentColor.opacity(0.7))
                        .id("ref-\(currentPrayerIndex)")
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.6).delay(0.2), value: currentPrayerIndex)
                }
            }
            .frame(minHeight: 130)
            .padding(.horizontal, 32)
            .padding(.bottom, 20)

            HStack(spacing: 40) {
                Button {
                    guard currentPrayerIndex > 0 else { return }
                    withAnimation { currentPrayerIndex -= 1 }
                    heartbeatTrigger += 1
                    updateProgress()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(currentPrayerIndex > 0 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.4)))
                }
                .disabled(currentPrayerIndex == 0)

                Button {
                    isPlaying.toggle()
                    if isPlaying { scheduleAutoAdvance() }
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(bead.accentColor)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(bead.accentColor.opacity(0.1))
                                .overlay(Circle().stroke(bead.accentColor.opacity(0.3), lineWidth: 1))
                        )
                }

                Button {
                    advancePrayer()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(currentPrayerIndex < prayers.count - 1 ? Theme.textMedium : Theme.textLight.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .background(Circle().fill(Theme.warmBeige.opacity(0.4)))
                }
                .disabled(currentPrayerIndex >= prayers.count - 1)
            }
            .padding(.bottom, 16)

            HStack(spacing: 2.5) {
                ForEach(0..<36, id: \.self) { index in
                    let height = sin(CGFloat(index) * 0.45 + waveformPhase) * 7 + 9
                    RoundedRectangle(cornerRadius: 1)
                        .fill(
                            LinearGradient(
                                colors: [bead.accentColor.opacity(0.2), bead.accentColor.opacity(0.45)],
                                startPoint: .bottom,
                                endPoint: .top
                            )
                        )
                        .frame(width: 3, height: max(2, height))
                }
            }
            .frame(height: 24)
            .opacity(0.5)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }

    private var breathingGuide: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(bead.accentColor.opacity(0.3))
                .frame(width: 8, height: 8)
                .scaleEffect(breathScale)

            Text("Breathe slowly as you pray")
                .font(.system(size: 12, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight.opacity(0.7))

            Circle()
                .fill(bead.accentColor.opacity(0.3))
                .frame(width: 8, height: 8)
                .scaleEffect(breathScale)
        }
        .opacity(hasEntered ? 0.8 : 0)
        .animation(.easeIn(duration: 1.0).delay(0.6), value: hasEntered)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.0001)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(bead.accentColor.opacity(0.1))
                        .frame(width: 80, height: 80)
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(bead.accentColor)
                }

                Text("Prayer Complete")
                    .font(.system(size: 24, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("You prayed through \(prayers.count) moments of \(bead.rawValue.lowercased())")
                    .font(.system(size: 15, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .multilineTextAlignment(.center)

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
                    .background(Capsule().fill(Theme.textDark))
                    .overlay(Capsule().stroke(bead.accentColor.opacity(0.3), lineWidth: 1))
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
        withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
            breathScale = 1.12
            breathOpacity = 0.12
        }
        startWaveform()
        scheduleAutoAdvance()
    }

    private func advancePrayer() {
        guard currentPrayerIndex < prayers.count - 1 else {
            withAnimation(.spring(duration: 0.6, bounce: 0.2)) { isComplete = true }
            isPlaying = false
            return
        }
        withAnimation { currentPrayerIndex += 1 }
        heartbeatTrigger += 1
        updateProgress()
        withAnimation(.easeOut(duration: 0.4)) {
            backgroundWarmth = Double(currentPrayerIndex) / Double(prayers.count) * 0.04
        }
    }

    private func updateProgress() {
        withAnimation(.easeInOut(duration: 0.8)) {
            progressArc = Double(currentPrayerIndex + 1) / Double(prayers.count)
        }
    }

    private func scheduleAutoAdvance() {
        Task {
            try? await Task.sleep(for: .seconds(9))
            guard isPlaying && !isComplete else { return }
            advancePrayer()
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
