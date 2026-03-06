import SwiftUI

struct PrayerSessionPlayerView: View {
    let prayer: PrayerCard
    let onDismiss: () -> Void
    let onComplete: () -> Void

    @State private var viewModel: PrayerSessionViewModel

    init(prayer: PrayerCard, onDismiss: @escaping () -> Void, onComplete: @escaping () -> Void) {
        self.prayer = prayer
        self.onDismiss = onDismiss
        self.onComplete = onComplete
        let session = PrayerSession.session(for: prayer)
        _viewModel = State(initialValue: PrayerSessionViewModel(session: session))
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
                    categoryAccentColor.opacity(0.06 + viewModel.backgroundWarmth * 0.12),
                    Color.clear
                ],
                center: .center,
                startRadius: 60,
                endRadius: 400
            )
            .ignoresSafeArea()
        }
    }

    private var categoryAccentColor: Color {
        switch prayer.category {
        case .healing: return Color(red: 0.90, green: 0.55, blue: 0.55)
        case .guidance: return Color(red: 0.55, green: 0.65, blue: 0.90)
        case .gratitude: return Theme.goldAccent
        case .family: return Color(red: 0.55, green: 0.78, blue: 0.55)
        case .faith: return Color(red: 0.75, green: 0.60, blue: 0.85)
        case .strength: return Color(red: 0.88, green: 0.65, blue: 0.45)
        case .all: return Theme.goldAccent
        }
    }

    private var goldenDustLayer: some View {
        LivingWordParticleField(density: 40)
            .ignoresSafeArea()
            .opacity(viewModel.hasEntered ? 0.45 : 0)
            .animation(.easeIn(duration: 1.5), value: viewModel.hasEntered)
    }

    private var centralHaloComposition: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height * 0.32)
            let haloSize: CGFloat = min(geo.size.width * 0.6, 260)

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                categoryAccentColor.opacity(0.08),
                                categoryAccentColor.opacity(0.03),
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
                                categoryAccentColor.opacity(0.2),
                                categoryAccentColor.opacity(0.06),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 0,
                            endRadius: haloSize * 0.25
                        )
                    )
                    .frame(width: haloSize * 0.5, height: haloSize * 0.5)

                Image(systemName: prayer.category.icon)
                    .font(.system(size: haloSize * 0.12, weight: .light))
                    .foregroundStyle(categoryAccentColor.opacity(0.7))
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
                            categoryAccentColor.opacity(0.2),
                            categoryAccentColor.opacity(0.8),
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
                    .fill(categoryAccentColor)
                    .frame(width: 6, height: 6)
                    .shadow(color: categoryAccentColor.opacity(0.5), radius: 4)
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
                .padding(.bottom, 6)

            prayerRequestCard
                .padding(.horizontal, 28)
                .padding(.bottom, 16)
                .opacity(viewModel.showPrayerText ? 1 : 0)
                .offset(y: viewModel.showPrayerText ? 0 : 10)

            verseDisplay
                .padding(.horizontal, 32)
                .padding(.bottom, 20)

            verseNavigation
                .padding(.bottom, 16)

            waveformVisualizer
                .padding(.horizontal, 40)
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
                Text(viewModel.session.sessionTitle)
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textDark.opacity(0.8))
                Text(viewModel.session.sessionSubtitle)
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
                .fill(categoryAccentColor.opacity(0.6))
                .frame(width: 5, height: 5)
            Text("\(viewModel.session.prayingWith) others are praying for \(prayer.displayName) right now")
                .font(.system(size: 12, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
        }
        .opacity(viewModel.hasEntered ? 0.8 : 0)
        .animation(.easeIn(duration: 1.0).delay(1.2), value: viewModel.hasEntered)
    }

    private var prayerRequestCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Text(prayer.initials)
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.cardBrown)
                    .frame(width: 28, height: 28)
                    .background(Theme.warmBeige.opacity(0.6))
                    .clipShape(Circle())

                Text("\(prayer.displayName)'s Prayer")
                    .font(.system(size: 13, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textMedium)

                Spacer()
            }

            Text("\"\(prayer.text)\"")
                .font(.system(size: 14, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(Theme.textDark.opacity(0.7))
                .lineSpacing(4)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Theme.goldAccent.opacity(0.15), lineWidth: 0.5)
                )
        )
    }

    private var verseDisplay: some View {
        VStack(spacing: 14) {
            Text(viewModel.currentVerse.text)
                .font(.system(size: 19, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(Theme.textDark.opacity(0.9))
                .multilineTextAlignment(.center)
                .lineSpacing(7)
                .id(viewModel.currentVerseIndex)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .offset(y: 12)).combined(with: .scale(scale: 0.98)),
                    removal: .opacity.combined(with: .offset(y: -12)).combined(with: .scale(scale: 0.98))
                ))
                .animation(.easeInOut(duration: 0.9), value: viewModel.currentVerseIndex)

            Text(viewModel.currentVerse.reference)
                .font(.system(size: 11, weight: .semibold, design: .serif))
                .tracking(1.2)
                .foregroundStyle(categoryAccentColor.opacity(0.7))
                .id("ref-\(viewModel.currentVerseIndex)")
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.6).delay(0.2), value: viewModel.currentVerseIndex)
        }
        .frame(minHeight: 100)
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
                    .foregroundStyle(categoryAccentColor)
                    .frame(width: 56, height: 56)
                    .background(
                        Circle()
                            .fill(categoryAccentColor.opacity(0.1))
                            .overlay(
                                Circle()
                                    .stroke(categoryAccentColor.opacity(0.3), lineWidth: 1)
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
                                categoryAccentColor.opacity(0.25),
                                categoryAccentColor.opacity(0.5)
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

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.0001)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(categoryAccentColor.opacity(0.12))
                        .frame(width: 90, height: 90)
                        .scaleEffect(viewModel.isComplete ? 1 : 0.5)

                    Circle()
                        .fill(categoryAccentColor.opacity(0.06))
                        .frame(width: 120, height: 120)
                        .scaleEffect(viewModel.isComplete ? 1 : 0.3)

                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 38))
                        .foregroundStyle(categoryAccentColor)
                        .symbolEffect(.bounce, value: viewModel.isComplete)
                }

                Text("Prayer Lifted")
                    .font(.system(size: 26, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                VStack(spacing: 6) {
                    Text("Your prayer for \(prayer.displayName) has been lifted")
                        .font(.system(size: 15, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)

                    Text("You prayed through \(viewModel.totalVerses) verses of \(prayer.category == .all ? "intercession" : prayer.category.rawValue.lowercased())")
                        .font(.system(size: 13, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 8)

                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 11))
                    Text("\(viewModel.session.prayingWith + 1) have prayed for this request")
                        .font(.system(size: 12, weight: .medium, design: .serif))
                }
                .foregroundStyle(categoryAccentColor)
                .padding(.top, 4)

                Button {
                    onComplete()
                } label: {
                    HStack(spacing: 10) {
                        Text("Return to Prayer Wall")
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
                            .stroke(categoryAccentColor.opacity(0.3), lineWidth: 1)
                    )
                }
                .padding(.top, 8)
            }
            .padding(36)
            .background(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Theme.cream)
                    .shadow(color: Theme.sandDark.opacity(0.15), radius: 30, y: 10)
            )
            .padding(.horizontal, 24)
            .transition(.scale(scale: 0.9).combined(with: .opacity))
        }
        .sensoryFeedback(.success, trigger: viewModel.isComplete)
    }

    private func waveformHeight(for index: Int) -> CGFloat {
        let phase = viewModel.waveformPhase
        let base = sin(CGFloat(index) * 0.45 + phase) * 7 + 9
        let variation = cos(CGFloat(index) * 0.3 + phase * 1.2) * 3
        return max(2, base + variation)
    }
}
