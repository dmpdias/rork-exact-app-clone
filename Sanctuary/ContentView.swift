import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 0) {
                SanctuaryHomeView()
            } label: {
                Label("Home", systemImage: "house.fill")
            }

            Tab(value: 1) {
                CounselorChatView()
            } label: {
                Label("Counselor", systemImage: "heart")
            }

            Tab(value: 2) {
                CommunityPrayerWallView()
            } label: {
                Label("Community", systemImage: "person.2")
            }

            Tab(value: 3) {
                JourneyView()
            } label: {
                Label("Journey", systemImage: "book")
            }

            Tab(value: 4) {
                ProfileView()
            } label: {
                Label("Profile", systemImage: "person")
            }
        }
        .tint(Theme.goldDark)
    }
}
