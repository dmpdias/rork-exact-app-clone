import SwiftUI

struct SpiritualMomentCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(label: "SPIRITUAL TODAY", title: "Today's guided moment.")
                .padding(.bottom, 12)

            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.cardBrown.opacity(0.85),
                                Theme.cardOlive.opacity(0.9),
                                Theme.cardBrown.opacity(0.95)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial.opacity(0.15))

                VStack(alignment: .leading, spacing: 24) {
                    Text("Lay down every burden. You have been held today — and you will be held through the night.")
                        .font(.system(size: 26, weight: .regular, design: .serif))
                        .foregroundStyle(.white.opacity(0.85))
                        .lineSpacing(4)

                    BeginMomentButton()

                    Divider()
                        .background(.white.opacity(0.15))

                    HStack(spacing: 6) {
                        Circle()
                            .fill(Theme.goldAccent)
                            .frame(width: 7, height: 7)
                        Text("12,403 souls praying with you")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }
                .padding(24)
            }
        }
        .padding(.horizontal, 20)
    }
}

struct BeginMomentButton: View {
    @State private var shimmerPhase: CGFloat = -200
    @State private var pressed: Bool = false

    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                pressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    pressed = false
                }
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.goldLight, Theme.goldAccent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }

                Text("Begin your moment ›")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(6)
            .padding(.trailing, 20)
            .background(
                Capsule()
                    .fill(.white.opacity(0.08))
            )
            .overlay(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.12), .clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .offset(x: shimmerPhase)
                    .allowsHitTesting(false)
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .scaleEffect(pressed ? 1.03 : 1.0)
        .onAppear {
            startShimmerLoop()
        }
    }

    private func startShimmerLoop() {
        shimmerPhase = -200
        withAnimation(.easeInOut(duration: 2.0)) {
            shimmerPhase = 400
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.6) {
            startShimmerLoop()
        }
    }
}
