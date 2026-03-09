import SwiftUI

nonisolated enum AgeRange: String, CaseIterable, Identifiable, Codable, Sendable {
    case teen = "13–17"
    case youngAdult = "18–24"
    case adult = "25–34"
    case midLife = "35–49"
    case mature = "50–64"
    case elder = "65+"

    var id: String { rawValue }
}

nonisolated enum PrayerFrequency: String, CaseIterable, Identifiable, Codable, Sendable {
    case rarely = "Rarely"
    case weekly = "A few times a week"
    case daily = "Once a day"
    case multiple = "Multiple times a day"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .rarely: return "moon.stars"
        case .weekly: return "leaf"
        case .daily: return "sun.max"
        case .multiple: return "flame.fill"
        }
    }

    func insight(for age: AgeRange?) -> String {
        switch self {
        case .rarely:
            return "You're taking the first step — and that's what matters most. Many who start here discover a rhythm that transforms their days."
        case .weekly:
            return "You're building a beautiful foundation. 62% of people in your age group share this rhythm — and those who grow it report deeper peace."
        case .daily:
            return "Daily prayer is a powerful discipline. Studies show daily prayer reduces anxiety by 35% and strengthens emotional resilience."
        case .multiple:
            return "You have the heart of a devoted prayer warrior. Only 12% of believers pray this frequently — you're in rare, beautiful company."
        }
    }
}

nonisolated enum ScriptureFrequency: String, CaseIterable, Identifiable, Codable, Sendable {
    case never = "Not yet"
    case occasionally = "Occasionally"
    case weekly = "A few times a week"
    case daily = "Every day"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .never: return "book.closed"
        case .occasionally: return "book"
        case .weekly: return "text.book.closed"
        case .daily: return "book.fill"
        }
    }

    func insight(for prayer: PrayerFrequency?) -> String {
        switch self {
        case .never:
            return "No worries — Sanctuary will guide you gently into scripture with short, meaningful passages chosen just for you."
        case .occasionally:
            return "Even occasional reading plants seeds. People who pair scripture with prayer — like you're doing — see 3x more spiritual growth."
        case .weekly:
            if prayer == .daily || prayer == .multiple {
                return "Combined with your prayer life, this creates a powerful rhythm. You're already living what many aspire to."
            }
            return "Consistent readers report 40% more clarity in life decisions. Your discipline is already bearing fruit."
        case .daily:
            return "Daily scripture readers report the highest levels of inner peace and purpose. You're nourishing your soul beautifully."
        }
    }
}

nonisolated enum SpiritualGoal: String, CaseIterable, Identifiable, Codable, Sendable {
    case peace = "Inner Peace"
    case community = "Community"
    case guidance = "Divine Guidance"
    case healing = "Healing"
    case discipline = "Spiritual Discipline"
    case knowledge = "Biblical Knowledge"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .peace: return "leaf.fill"
        case .community: return "person.2.fill"
        case .guidance: return "star.fill"
        case .healing: return "heart.fill"
        case .discipline: return "flame.fill"
        case .knowledge: return "book.fill"
        }
    }

    var color: Color {
        switch self {
        case .peace: return Color(red: 0.55, green: 0.75, blue: 0.65)
        case .community: return Color(red: 0.65, green: 0.60, blue: 0.80)
        case .guidance: return Color(red: 0.85, green: 0.72, blue: 0.35)
        case .healing: return Color(red: 0.82, green: 0.52, blue: 0.52)
        case .discipline: return Color(red: 0.85, green: 0.62, blue: 0.35)
        case .knowledge: return Color(red: 0.45, green: 0.62, blue: 0.78)
        }
    }
}

nonisolated enum SpiritualChallenge: String, CaseIterable, Identifiable, Codable, Sendable {
    case consistency = "Staying Consistent"
    case doubt = "Doubts & Questions"
    case distraction = "Distractions"
    case loneliness = "Feeling Alone"
    case understanding = "Understanding Scripture"
    case time = "Finding Time"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .consistency: return "arrow.triangle.2.circlepath"
        case .doubt: return "questionmark.circle"
        case .distraction: return "eye.slash"
        case .loneliness: return "person.fill.questionmark"
        case .understanding: return "text.magnifyingglass"
        case .time: return "clock"
        }
    }

    func insight(for goals: [SpiritualGoal]) -> String {
        switch self {
        case .consistency:
            return "73% of believers share this challenge. Sanctuary's gentle daily reminders and streak tracking are designed exactly for this — small, faithful steps."
        case .doubt:
            return "Doubt is not the opposite of faith — it's part of the journey. Our Counselor feature offers a safe space to explore your deepest questions."
        case .distraction:
            return "In our noisy world, 68% struggle with this. Sanctuary's guided moments create a sacred bubble — even 5 minutes can center your spirit."
        case .loneliness:
            if goals.contains(.community) {
                return "You're already seeking community — that's beautiful. Our Fellowship and Prayer Wall connect you with believers who understand your journey."
            }
            return "You're not alone in feeling alone. Our Community features connect thousands of believers who lift each other up daily."
        case .understanding:
            if goals.contains(.knowledge) {
                return "Your desire to learn is a gift. Our Journey courses break down scripture into beautiful, digestible lessons with rich context."
            }
            return "Scripture becomes clearer with guidance. Sanctuary's Living Word feature brings passages alive with context and reflection."
        case .time:
            return "Even 5 minutes with God can transform a day. Sanctuary is built for busy lives — quick devotions, bite-sized scripture, prayers on the go."
        }
    }
}

nonisolated struct PersonalizedPlan: Sendable {
    let userName: String
    let commitments: [PlanCommitment]
    let verse: String
    let verseReference: String
}

nonisolated struct PlanCommitment: Identifiable, Sendable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}
