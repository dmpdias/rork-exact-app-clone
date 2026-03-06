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

    var whisperTemplate: String {
        switch self {
        case .faithfulness: return "-day streak"
        case .intercession: return " prayers lifted today"
        case .wisdom: return "-day Wisdom streak"
        case .generosity: return " blessings shared"
        }
    }
}

nonisolated struct FellowshipMember: Identifiable, Sendable {
    let id: UUID
    let displayName: String
    let rank: Int
    let isActive: Bool
    let streakDays: Int
    let virtueValue: Int
    var blessCount: Int

    var isTopTen: Bool { rank <= 10 }
    var isTopOne: Bool { rank == 1 }
    var hasLongStreak: Bool { streakDays >= 7 }

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
