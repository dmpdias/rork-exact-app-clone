import Foundation

nonisolated struct PrayerRoom: Identifiable, Sendable {
    let id: UUID
    let name: String
    let description: String
    let icon: String
    let activeNow: Int
    let isLive: Bool

    static let sanctuaryRooms: [PrayerRoom] = [
        PrayerRoom(
            id: UUID(),
            name: "Morning Devotion",
            description: "Start every day with collective worship and praise",
            icon: "sun.horizon.fill",
            activeNow: 891,
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Healing Circle",
            description: "A safe space for those seeking God's healing touch",
            icon: "heart.circle.fill",
            activeNow: 342,
            isLive: true
        ),
        PrayerRoom(
            id: UUID(),
            name: "Intercession Room",
            description: "Lifting up nations and communities in prayer",
            icon: "globe.americas.fill",
            activeNow: 567,
            isLive: true
        ),
    ]
}
