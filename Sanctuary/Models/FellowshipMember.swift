import Foundation

nonisolated enum Virtue: String, CaseIterable, Sendable {
    case faithfulness = "Faithfulness"
    case intercession = "Intercession"
    case wisdom = "Wisdom"
    case generosity = "Generosity"

    var icon: String {
        switch self {
        case .faithfulness: return "flame.fill"
        case .intercession: return "hands.sparkles.fill"
        case .wisdom: return "book.fill"
        case .generosity: return "heart.circle.fill"
        }
    }
}

nonisolated enum FellowshipCountry: String, CaseIterable, Sendable {
    case all = "All"
    case unitedStates = "United States"
    case unitedKingdom = "United Kingdom"
    case brazil = "Brazil"
    case nigeria = "Nigeria"
    case philippines = "Philippines"
    case southKorea = "South Korea"
    case kenya = "Kenya"
    case canada = "Canada"

    var flag: String {
        switch self {
        case .all: return "globe"
        case .unitedStates: return "🇺🇸"
        case .unitedKingdom: return "🇬🇧"
        case .brazil: return "🇧🇷"
        case .nigeria: return "🇳🇬"
        case .philippines: return "🇵🇭"
        case .southKorea: return "🇰🇷"
        case .kenya: return "🇰🇪"
        case .canada: return "🇨🇦"
        }
    }
}

nonisolated enum FellowshipTimePeriod: String, CaseIterable, Sendable {
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case allTime = "All Time"

    var icon: String {
        switch self {
        case .thisWeek: return "calendar"
        case .thisMonth: return "calendar.badge.clock"
        case .allTime: return "infinity"
        }
    }
}

nonisolated struct FellowshipMember: Identifiable, Sendable {
    let id: UUID
    let displayName: String
    var rank: Int
    let isActive: Bool
    let streakDays: Int
    let virtueValue: Int
    var blessCount: Int
    let country: FellowshipCountry
    let weeklyScore: Int
    let monthlyScore: Int
    let allTimeScore: Int
    let isCurrentUser: Bool

    var isTopThree: Bool { rank <= 3 }
    var isTopTen: Bool { rank <= 10 }
    var isTopOne: Bool { rank == 1 }
    var hasLongStreak: Bool { streakDays >= 7 }

    func score(for period: FellowshipTimePeriod) -> Int {
        switch period {
        case .thisWeek: return weeklyScore
        case .thisMonth: return monthlyScore
        case .allTime: return allTimeScore
        }
    }

    func whisper(for virtue: Virtue) -> String {
        switch virtue {
        case .faithfulness:
            return "\(streakDays)-day streak"
        case .intercession:
            return "Lifting \(virtueValue) prayers today"
        case .wisdom:
            return "\(streakDays)-day Wisdom streak"
        case .generosity:
            return "\(virtueValue) blessings shared"
        }
    }
}
