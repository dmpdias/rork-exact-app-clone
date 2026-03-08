import SwiftUI

struct SanctuaryHomeView: View {
    @State private var showGuidedMoment: Bool = false
    @State private var showBibleProgress: Bool = false
    @State private var showDevotionBreakdown: Bool = false
    @State private var selectedActivity: ActivityItem? = nil
    @State private var selectedDayInfo: (day: WeekDay, index: Int)? = nil
    @State private var showDayDetail: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 42)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    GreetingHeaderView(onBibleProgressTap: {
                        showBibleProgress = true
                    })
                    .scrollReveal(delay: 0)

                    SpiritualMomentCardView(onBeginMoment: {
                        showGuidedMoment = true
                    })
                    .scrollReveal(delay: 0.08)

                    WeeklyStreakView(onDayTap: { day, index in
                        selectedDayInfo = (day, index)
                        showDayDetail = true
                    })
                    .scrollReveal(delay: 0.16)

                    DevotionScoreView(onSeeBreakdown: {
                        showDevotionBreakdown = true
                    })
                    .scrollReveal(delay: 0.24)

                    ScriptureCardView()
                        .scrollReveal(delay: 0.32)

                    ActivityLogView(onActivityTap: { activity in
                        selectedActivity = activity
                    })
                    .scrollReveal(delay: 0.40)
                }
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .fullScreenCover(isPresented: $showGuidedMoment) {
            GuidedMomentPlayerView {
                showGuidedMoment = false
            }
        }
        .sheet(isPresented: $showBibleProgress) {
            BibleProgressDetailView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showDevotionBreakdown) {
            DevotionBreakdownView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
        .sheet(item: $selectedActivity) { activity in
            ActivityDetailView(activity: activity)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showDayDetail) {
            if let info = selectedDayInfo {
                DayDetailView(day: info.day, dayIndex: info.index)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }
}
