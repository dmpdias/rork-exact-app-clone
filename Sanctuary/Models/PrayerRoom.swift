import Foundation

nonisolated struct PrayerRoom: Identifiable, Sendable {
    let id: UUID
    let name: String
    let description: String
    let icon: String
    let memberCount: Int
    let activeNow: Int
    let country: String
    let countryFlag: String
    let isLive: Bool

    static let samples: [PrayerRoom] = [
        PrayerRoom(
            id: UUID(),
            name: "Healing Circle",
            description: "A safe space for those seeking God's healing touch",
            icon: "heart.circle.fill",
            memberCount: 342,
            activeNow: 28,
            country: "United States",
            countryFlag: "🇺🇸",
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Morning Devotion",
            description: "Start every day with collective worship and praise",
            icon: "sun.horizon.fill",
            memberCount: 891,
            activeNow: 64,
            country: "United Kingdom",
            countryFlag: "🇬🇧",
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Intercession Room",
            description: "Lifting up nations and communities in prayer",
            icon: "globe.americas.fill",
            memberCount: 567,
            activeNow: 41,
            country: "Brazil",
            countryFlag: "🇧🇷",
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Youth on Fire",
            description: "Young believers gathering in faith and fellowship",
            icon: "flame.fill",
            memberCount: 234,
            activeNow: 19,
            country: "Nigeria",
            countryFlag: "🇳🇬",
            isLive: false
        ),
        PrayerRoom(
            id: UUID(),
            name: "Family Blessings",
            description: "Praying over our families and homes together",
            icon: "house.and.flag.fill",
            memberCount: 478,
            activeNow: 33,
            country: "Mexico",
            countryFlag: "🇲🇽",
            isLive: false
        ),
        PrayerRoom(
            id: UUID(),
            name: "Silent Contemplation",
            description: "A quiet room for meditation and reflection",
            icon: "leaf.fill",
            memberCount: 156,
            activeNow: 12,
            country: "South Korea",
            countryFlag: "🇰🇷",
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Worship & Praise",
            description: "Singing and praising the Lord together",
            icon: "music.note",
            memberCount: 623,
            activeNow: 47,
            country: "Philippines",
            countryFlag: "🇵🇭",
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Scripture Study",
            description: "Deep diving into the Word with fellow believers",
            icon: "book.fill",
            memberCount: 312,
            activeNow: 22,
            country: "Canada",
            countryFlag: "🇨🇦",
            isLive: false
        ),
    ]
}

nonisolated enum RoomCountry: String, CaseIterable, Sendable {
    case all = "All"
    case us = "🇺🇸"
    case uk = "🇬🇧"
    case br = "🇧🇷"
    case ng = "🇳🇬"
    case mx = "🇲🇽"
    case kr = "🇰🇷"
    case ph = "🇵🇭"
    case ca = "🇨🇦"

    var flag: String {
        switch self {
        case .all: return "🌍"
        case .us: return "🇺🇸"
        case .uk: return "🇬🇧"
        case .br: return "🇧🇷"
        case .ng: return "🇳🇬"
        case .mx: return "🇲🇽"
        case .kr: return "🇰🇷"
        case .ph: return "🇵🇭"
        case .ca: return "🇨🇦"
        }
    }

    var label: String {
        switch self {
        case .all: return "All"
        case .us: return "US"
        case .uk: return "UK"
        case .br: return "BR"
        case .ng: return "NG"
        case .mx: return "MX"
        case .kr: return "KR"
        case .ph: return "PH"
        case .ca: return "CA"
        }
    }

    var countryFlag: String {
        switch self {
        case .all: return ""
        case .us: return "🇺🇸"
        case .uk: return "🇬🇧"
        case .br: return "🇧🇷"
        case .ng: return "🇳🇬"
        case .mx: return "🇲🇽"
        case .kr: return "🇰🇷"
        case .ph: return "🇵🇭"
        case .ca: return "🇨🇦"
        }
    }
}
