import SwiftUI

nonisolated enum JourneyCategory: String, CaseIterable, Identifiable, Sendable, Hashable {
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

    var accentColor: Color {
        switch self {
        case .peace: return Color(red: 0.45, green: 0.65, blue: 0.60)
        case .strength: return Color(red: 0.65, green: 0.55, blue: 0.40)
        case .hope: return Color(red: 0.82, green: 0.68, blue: 0.40)
        case .healing: return Color(red: 0.72, green: 0.50, blue: 0.50)
        }
    }

    var prayerSubtitle: String {
        switch self {
        case .peace: return "Be still and know"
        case .strength: return "Rise in His power"
        case .hope: return "Light in the darkness"
        case .healing: return "Restoration of the soul"
        }
    }
}
