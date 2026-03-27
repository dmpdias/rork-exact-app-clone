import SwiftUI

@Observable
final class LivingWordPlayerViewModel {
    var session: ScriptureSession
    var currentVerseIndex: Int = 0
    var isPlaying: Bool = true
    var isMuted: Bool = false
    var ambientLevel: Double = 0.6
    var focusLevel: Double = 0.8
    var showControls: Bool = true
    var waveformPhase: CGFloat = 0
    var haloPulse: Bool = false
    var progressArc: Double = 0
    var backgroundWarmth: Double = 0
    var heartbeatTrigger: Bool = false
    var hasEntered: Bool = false
    var isComplete: Bool = false

    private var verseTimer: Timer?
    private var waveformTimer: Timer?
    private var controlsTimer: Timer?

    var totalVerses: Int { session.verses.count }

    var currentVerse: ScriptureVerse {
        session.verses[currentVerseIndex]
    }

    var progress: Double {
        guard totalVerses > 1 else { return 1.0 }
        return Double(currentVerseIndex) / Double(totalVerses - 1)
    }

    init(session: ScriptureSession) {
        self.session = session
    }

    func beginSession() {
        withAnimation(.easeOut(duration: 1.2)) {
            hasEntered = true
        }
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            haloPulse = true
        }
        startVerseProgression()
        startWaveform()
        scheduleControlsHide()
    }

    func togglePlayPause() {
        isPlaying.toggle()
        if isPlaying {
            startVerseProgression()
        } else {
            verseTimer?.invalidate()
            verseTimer = nil
        }
    }

    func revealControls() {
        withAnimation(.easeOut(duration: 0.3)) {
            showControls = true
        }
        scheduleControlsHide()
    }

    func advanceVerse() {
        guard currentVerseIndex < totalVerses - 1 else {
            isPlaying = false
            verseTimer?.invalidate()
            isComplete = true
            return
        }
        withAnimation(.easeInOut(duration: 0.8)) {
            currentVerseIndex += 1
        }
        heartbeatTrigger.toggle()
        withAnimation(.easeInOut(duration: 0.6)) {
            progressArc = progress
            backgroundWarmth = progress * 0.15
        }
    }

    func retreat() {
        guard currentVerseIndex > 0 else { return }
        withAnimation(.easeInOut(duration: 0.8)) {
            currentVerseIndex -= 1
        }
        withAnimation(.easeInOut(duration: 0.6)) {
            progressArc = progress
            backgroundWarmth = progress * 0.15
        }
    }

    func cleanup() {
        verseTimer?.invalidate()
        waveformTimer?.invalidate()
        controlsTimer?.invalidate()
    }

    private func startVerseProgression() {
        verseTimer?.invalidate()
        verseTimer = Timer.scheduledTimer(withTimeInterval: 6.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.advanceVerse()
            }
        }
    }

    private func startWaveform() {
        waveformTimer = Timer.scheduledTimer(withTimeInterval: 0.07, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.waveformPhase += 0.12
            }
        }
    }

    private func scheduleControlsHide() {
        controlsTimer?.invalidate()
        controlsTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            Task { @MainActor in
                withAnimation(.easeInOut(duration: 0.6)) {
                    self?.showControls = false
                }
            }
        }
    }
}
