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
    let description: String
    let reward: String
    let requirement: String
    let dateUnlocked: String?
}

nonisolated struct ProfilePreference: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let icon: String
    let iconColor: Color
    let type: PreferenceType
}

nonisolated enum PreferenceType: Sendable, Equatable {
    case dailyReminders
    case prayerNotifications
    case readingPlan
    case appearance
    case privacy
    case about
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

    var dailyReminderEnabled: Bool = true
    var dailyReminderTime: Date = Calendar.current.date(from: DateComponents(hour: 7, minute: 0)) ?? Date()
    var prayerNotificationsEnabled: Bool = true
    var communityPrayerAlerts: Bool = true
    var prayerAnsweredAlerts: Bool = true
    var readingPlanName: String = "Through the Gospels"
    var readingPlanProgress: Double = 0.42
    var chaptersPerDay: Int = 2
    var selectedAppearance: String = "Warm Cream"
    var hapticFeedbackEnabled: Bool = true
    var particlesEnabled: Bool = true
    var profilePublic: Bool = false
    var showStreakPublicly: Bool = true
    var showPrayerActivity: Bool = true

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
            ProfileMilestone(
                title: "First Light",
                subtitle: "Complete your first devotion",
                icon: "sunrise.fill",
                isUnlocked: true,
                progress: 1.0,
                description: "Every journey begins with a single step of faith. You opened your heart to the first devotion and ignited the flame within.",
                reward: "Golden Sunrise Badge",
                requirement: "Complete 1 devotion session",
                dateUnlocked: "Jan 15, 2024"
            ),
            ProfileMilestone(
                title: "Faithful Week",
                subtitle: "7-day streak achieved",
                icon: "flame.fill",
                isUnlocked: true,
                progress: 1.0,
                description: "Seven days of unwavering devotion. Like the days of creation, you built a foundation of spiritual discipline.",
                reward: "Sacred Flame Badge",
                requirement: "Maintain a 7-day streak",
                dateUnlocked: "Feb 3, 2024"
            ),
            ProfileMilestone(
                title: "Prayer Warrior",
                subtitle: "Lift 100 prayers",
                icon: "hands.sparkles",
                isUnlocked: true,
                progress: 1.0,
                description: "A hundred prayers lifted to the heavens. Your voice has become a constant presence in the sanctuary of the divine.",
                reward: "Radiant Hands Badge",
                requirement: "Lift 100 prayers",
                dateUnlocked: "Apr 20, 2024"
            ),
            ProfileMilestone(
                title: "Scripture Scholar",
                subtitle: "Read 200 scriptures",
                icon: "book.fill",
                isUnlocked: false,
                progress: 0.78,
                description: "Immerse yourself in the living word. Two hundred passages of divine wisdom will transform your understanding.",
                reward: "Sacred Scroll Badge",
                requirement: "Read 200 scriptures (156 / 200)",
                dateUnlocked: nil
            ),
            ProfileMilestone(
                title: "Radiant Soul",
                subtitle: "Reach 90 devotion score",
                icon: "sun.max.fill",
                isUnlocked: false,
                progress: 0.81,
                description: "Let your devotion shine so brightly that it illuminates the path for others. Reach the pinnacle of spiritual radiance.",
                reward: "Divine Light Badge",
                requirement: "Achieve a devotion score of 90 (73 / 90)",
                dateUnlocked: nil
            ),
            ProfileMilestone(
                title: "Eternal Flame",
                subtitle: "Maintain a 60-day streak",
                icon: "flame.circle.fill",
                isUnlocked: false,
                progress: 0.57,
                description: "Two months of unbroken devotion. Your flame has become eternal — a beacon of perseverance and faith.",
                reward: "Eternal Flame Badge",
                requirement: "Maintain a 60-day streak (34 / 60)",
                dateUnlocked: nil
            ),
        ]
    }

    var preferences: [ProfilePreference] {
        [
            ProfilePreference(title: "Daily Reminders", icon: "bell.fill", iconColor: Theme.goldAccent, type: .dailyReminders),
            ProfilePreference(title: "Prayer Notifications", icon: "hands.sparkles", iconColor: Theme.prayerIcon, type: .prayerNotifications),
            ProfilePreference(title: "Reading Plan", icon: "book.fill", iconColor: Theme.readingIcon, type: .readingPlan),
            ProfilePreference(title: "Appearance", icon: "paintbrush.fill", iconColor: Theme.reflectionIcon, type: .appearance),
            ProfilePreference(title: "Privacy", icon: "lock.fill", iconColor: Theme.textMedium, type: .privacy),
            ProfilePreference(title: "About Sanctuary", icon: "info.circle.fill", iconColor: Theme.cardBrown, type: .about),
        ]
    }
}
