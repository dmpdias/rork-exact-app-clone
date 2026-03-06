import Foundation

nonisolated enum PrayerCategory: String, CaseIterable, Sendable {
    case all = "All"
    case healing = "Healing"
    case guidance = "Guidance"
    case gratitude = "Gratitude"
    case family = "Family"
    case faith = "Faith"
    case strength = "Strength"

    var icon: String {
        switch self {
        case .all: return "sparkles"
        case .healing: return "heart.fill"
        case .guidance: return "compass.drawing"
        case .gratitude: return "sun.max.fill"
        case .family: return "figure.2.and.child.holdinghands"
        case .faith: return "hands.sparkles.fill"
        case .strength: return "bolt.heart.fill"
        }
    }
}

nonisolated struct PrayerCard: Identifiable, Sendable {
    let id: UUID
    let initials: String
    let displayName: String
    let text: String
    let timestamp: Date
    let category: PrayerCategory
    var prayingCount: Int
    var isPrayingByMe: Bool

    static let samples: [PrayerCard] = [
        PrayerCard(
            id: UUID(),
            initials: "M.S.",
            displayName: "Maria S.",
            text: "Pray for my mother's healing. She has been in the hospital for two weeks and we trust in God's plan for her recovery.",
            timestamp: Date().addingTimeInterval(-1200),
            category: .healing,
            prayingCount: 34,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "J.D.",
            displayName: "James D.",
            text: "Seeking peace during a difficult season of change. Lord, guide my steps as I navigate this new chapter.",
            timestamp: Date().addingTimeInterval(-3600),
            category: .guidance,
            prayingCount: 21,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "R.L.",
            displayName: "Rachel L.",
            text: "Grateful for answered prayers. My son got accepted into school today. God is faithful.",
            timestamp: Date().addingTimeInterval(-7200),
            category: .gratitude,
            prayingCount: 58,
            isPrayingByMe: true
        ),
        PrayerCard(
            id: UUID(),
            initials: "T.K.",
            displayName: "Thomas K.",
            text: "Please pray for unity in our church community. We are going through a time of transition and need wisdom from above.",
            timestamp: Date().addingTimeInterval(-10800),
            category: .faith,
            prayingCount: 16,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "A.W.",
            displayName: "Anna W.",
            text: "Praying for strength to forgive. The Spirit is working in my heart but I need the community's support.",
            timestamp: Date().addingTimeInterval(-14400),
            category: .strength,
            prayingCount: 42,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "D.M.",
            displayName: "Daniel M.",
            text: "My family is facing financial hardship. Trusting that the Lord will provide, but asking for your prayers during this valley.",
            timestamp: Date().addingTimeInterval(-18000),
            category: .family,
            prayingCount: 73,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "S.P.",
            displayName: "Sarah P.",
            text: "Pray for my daughter as she starts her mission trip next week. May God protect her and use her for His glory.",
            timestamp: Date().addingTimeInterval(-25200),
            category: .family,
            prayingCount: 29,
            isPrayingByMe: false
        ),
        PrayerCard(
            id: UUID(),
            initials: "E.C.",
            displayName: "Elijah C.",
            text: "Struggling with anxiety and doubt. Remind me, Lord, that You hold tomorrow in Your hands.",
            timestamp: Date().addingTimeInterval(-36000),
            category: .strength,
            prayingCount: 51,
            isPrayingByMe: false
        ),
    ]
}
