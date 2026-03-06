import SwiftUI

struct SanctuaryHomeView: View {
    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 42)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    GreetingHeaderView()
                        .scrollReveal(delay: 0)

                    SpiritualMomentCardView()
                        .scrollReveal(delay: 0.08)

                    WeeklyStreakView()
                        .scrollReveal(delay: 0.16)

                    DevotionScoreView()
                        .scrollReveal(delay: 0.24)

                    ScriptureCardView()
                        .scrollReveal(delay: 0.32)

                    ActivityLogView()
                        .scrollReveal(delay: 0.40)
                }
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
    }
}
