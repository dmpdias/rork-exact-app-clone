import SwiftUI

nonisolated enum JourneyCategory: String, CaseIterable, Identifiable, Sendable {
    case scripture = "Scripture"
    case prayerLibrary = "Prayer Library"
    case guidedJourneys = "Guided Journeys"
    case savedInsights = "Saved Insights"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .scripture: return "book.fill"
        case .prayerLibrary: return "hands.sparkles.fill"
        case .guidedJourneys: return "point.topleft.down.to.point.bottomright.curvepath.fill"
        case .savedInsights: return "lightbulb.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .scripture: return "The living word"
        case .prayerLibrary: return "Prayers for every season"
        case .guidedJourneys: return "Walk a sacred path"
        case .savedInsights: return "Your collected wisdom"
        }
    }
}

nonisolated enum EmotionalBead: String, CaseIterable, Identifiable, Sendable {
    case peace = "Peace"
    case strength = "Strength"
    case hope = "Hope"
    case healing = "Healing"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .peace: return "leaf.fill"
        case .strength: return "mountain.2.fill"
        case .hope: return "sun.max.fill"
        case .healing: return "heart.fill"
        }
    }
}
