import SwiftUI

struct CommunityPrayerWallView: View {
    @State private var viewModel = CommunityViewModel()
    @State private var hasAppeared: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 42)
                .ignoresSafeArea()
                .opacity(0.4)

            VStack(spacing: 0) {
                headerBar

                ScrollView {
                    VStack(spacing: 0) {
                        titleSection
                            .padding(.bottom, 28)

                        prayerFeed
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.textDark)
            }

            Spacer()

            Text("Community")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)

            Spacer()

            Image("BandIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 37)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var titleSection: some View {
        VStack(spacing: 10) {
            Text("Prayer Wall")
                .font(.system(size: 32, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("Lift each other up in faith")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)

            HStack(spacing: 6) {
                Circle()
                    .fill(Theme.goldAccent)
                    .frame(width: 6, height: 6)

                Text("\(viewModel.prayers.filter { $0.isPrayingByMe }.count) prayers you're lifting")
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textMedium)
            }
            .padding(.top, 4)
            .opacity(hasAppeared ? 1 : 0)
        }
        .padding(.top, 12)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
        }
    }

    private var prayerFeed: some View {
        LazyVStack(spacing: 14) {
            ForEach(viewModel.prayers) { prayer in
                PrayerCardView(
                    prayer: prayer,
                    timeAgo: viewModel.timeAgo(from: prayer.timestamp),
                    isPulsing: viewModel.prayingAnimationId == prayer.id
                ) {
                    withAnimation(.spring(duration: 0.35)) {
                        viewModel.togglePraying(for: prayer.id)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
