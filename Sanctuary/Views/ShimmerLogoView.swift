import SwiftUI

struct ShimmerLogoView: View {
    @State private var shimmerOffset: CGFloat = -1.5
    @State private var breathing: Bool = false
    @State private var glowPulse: Bool = false
    let logoOpacity: Double

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.goldLight.opacity(glowPulse ? 0.35 : 0.2),
                            Theme.goldAccent.opacity(glowPulse ? 0.12 : 0.04),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 30,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: glowPulse)

            Image("BandIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .overlay {
                    Image("BandIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(
                            LinearGradient(
                                stops: [
                                    .init(color: .clear, location: shimmerOffset - 0.3),
                                    .init(color: .white.opacity(0.6), location: shimmerOffset),
                                    .init(color: .clear, location: shimmerOffset + 0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .blendMode(.overlay)
                }
                .scaleEffect(breathing ? 1.03 : 1.0)
                .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: breathing)
        }
        .opacity(logoOpacity)
        .onAppear {
            breathing = true
            glowPulse = true
            startShimmerLoop()
        }
    }

    private func startShimmerLoop() {
        withAnimation(.easeInOut(duration: 1.2)) {
            shimmerOffset = 1.5
        }
        Task {
            try? await Task.sleep(for: .seconds(3))
            shimmerOffset = -1.5
            startShimmerLoop()
        }
    }
}
