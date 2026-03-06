import SwiftUI

nonisolated struct PrayerRequest: Identifiable, Sendable {
    let id = UUID()
    let authorName: String
    let authorInitials: String
    let timeAgo: String
    let category: PrayerCategory
    let title: String
    let body: String
    let prayerCount: Int
    let isPrayedFor: Bool
}

nonisolated enum PrayerCategory: String, Sendable, CaseIterable {
    case healing = "Healing"
    case strength = "Strength"
    case gratitude = "Gratitude"
    case guidance = "Guidance"
    case peace = "Peace"
    case family = "Family"

    var icon: String {
        switch self {
        case .healing: return "heart.circle.fill"
        case .strength: return "flame.fill"
        case .gratitude: return "sun.max.fill"
        case .guidance: return "compass.drawing"
        case .peace: return "leaf.fill"
        case .family: return "figure.2.and.child"
        }
    }

    var color: Color {
        switch self {
        case .healing: return Color(red: 0.88, green: 0.60, blue: 0.58)
        case .strength: return Color(red: 0.82, green: 0.68, blue: 0.40)
        case .gratitude: return Color(red: 0.90, green: 0.78, blue: 0.50)
        case .guidance: return Color(red: 0.65, green: 0.72, blue: 0.60)
        case .peace: return Color(red: 0.70, green: 0.84, blue: 0.82)
        case .family: return Color(red: 0.78, green: 0.65, blue: 0.55)
        }
    }

    var bgColor: Color {
        switch self {
        case .healing: return Color(red: 0.95, green: 0.88, blue: 0.87)
        case .strength: return Color(red: 0.95, green: 0.90, blue: 0.80)
        case .gratitude: return Color(red: 0.97, green: 0.94, blue: 0.84)
        case .guidance: return Color(red: 0.90, green: 0.94, blue: 0.88)
        case .peace: return Color(red: 0.88, green: 0.94, blue: 0.94)
        case .family: return Color(red: 0.94, green: 0.90, blue: 0.86)
        }
    }
}
