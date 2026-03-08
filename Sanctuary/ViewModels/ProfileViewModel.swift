import SwiftUI

nonisolated struct ProfileStat: Identifiable, Sendable {
    let id = UUID()
    let value: String
    let label: String
    let icon: String
}

nonisolated struct ProfileMilestone: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let isUnlocked: Bool
    let progress: Double
}

nonisolated struct ProfilePreference: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let icon: String
    let iconColor: Color
}

@Observable
class ProfileViewModel {
    var userName: String = "David"
    var memberSince: String = "January 2024"
    var currentStreak: Int = 12
    var longestStreak: Int = 34
    var devotionScore: Int = 73
    var totalPrayers: Int = 248
    var totalScriptures: Int = 156
    var totalBlessings: Int = 89
    var profileInitial: String = "D"

    var stats: [ProfileStat] {
        [
            ProfileStat(value: "\(totalPrayers)", label: "Prayers", icon: "hands.sparkles"),
            ProfileStat(value: "\(totalScriptures)", label: "Scriptures", icon: "book"),
            ProfileStat(value: "\(currentStreak)", label: "Day Streak", icon: "flame.fill"),
            ProfileStat(value: "\(totalBlessings)", label: "Blessings", icon: "sparkles"),
        ]
    }

    var milestones: [ProfileMilestone] {
        [
            ProfileMilestone(title: "First Light", subtitle: "Complete your first devotion", icon: "sunrise.fill", isUnlocked: true, progress: 1.0),
            ProfileMilestone(title: "Faithful Week", subtitle: "7-day streak achieved", icon: "flame.fill", isUnlocked: true, progress: 1.0),
            ProfileMilestone(title: "Prayer Warrior", subtitle: "Lift 100 prayers", icon: "hands.sparkles", isUnlocked: true, progress: 1.0),
            ProfileMilestone(title: "Scripture Scholar", subtitle: "Read 200 scriptures", icon: "book.fill", isUnlocked: false, progress: 0.78),
            ProfileMilestone(title: "Radiant Soul", subtitle: "Reach 90 devotion score", icon: "sun.max.fill", isUnlocked: false, progress: 0.81),
            ProfileMilestone(title: "Eternal Flame", subtitle: "Maintain a 60-day streak", icon: "flame.circle.fill", isUnlocked: false, progress: 0.57),
        ]
    }

    var preferences: [ProfilePreference] {
        [
            ProfilePreference(title: "Daily Reminders", icon: "bell.fill", iconColor: Theme.goldAccent),
            ProfilePreference(title: "Prayer Notifications", icon: "hands.sparkles", iconColor: Theme.prayerIcon),
            ProfilePreference(title: "Reading Plan", icon: "book.fill", iconColor: Theme.readingIcon),
            ProfilePreference(title: "Appearance", icon: "paintbrush.fill", iconColor: Theme.reflectionIcon),
            ProfilePreference(title: "Privacy", icon: "lock.fill", iconColor: Theme.textMedium),
            ProfilePreference(title: "About Sanctuary", icon: "info.circle.fill", iconColor: Theme.cardBrown),
        ]
    }
}
