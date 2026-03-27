import Foundation

struct ContinuePathItem: Identifiable {
    let id: UUID
    let icon: String
    let title: String
    let subtitle: String
    let progress: Double
    let category: JourneyCategory
    let synopsis: String
    let duration: String
    let chapters: Int
    let difficulty: String

    func toJourneyContentItem() -> JourneyContentItem {
        JourneyContentItem(
            id: id,
            title: title,
            subtitle: subtitle,
            icon: icon,
            detail: synopsis,
            synopsis: synopsis,
            duration: duration,
            chapters: chapters,
            prayers: Int(Double(chapters) * 42.5),
            reads: Int(Double(chapters) * 85),
            reflections: Int(Double(chapters) * 22),
            difficulty: difficulty
        )
    }

    static let samples: [ContinuePathItem] = [
        ContinuePathItem(
            id: UUID(),
            icon: "flame.fill",
            title: "40 Days of Faith",
            subtitle: "Day 12 of 40",
            progress: 0.3,
            category: .guidedJourneys,
            synopsis: "Inspired by the biblical significance of 40 days — from Noah's flood to Jesus in the wilderness — this journey invites you into a season of deep spiritual transformation. Each day combines scripture study, guided prayer, and a faith challenge that stretches you beyond comfort into genuine trust.",
            duration: "40 days",
            chapters: 40,
            difficulty: "Committed"
        ),
        ContinuePathItem(
            id: UUID(),
            icon: "book.closed.fill",
            title: "Genesis to Revelation",
            subtitle: "Week 8 — Exodus 14",
            progress: 0.15,
            category: .scripture,
            synopsis: "Embark on a transformative 365-day journey through the entire Bible. From the creation story in Genesis to the prophetic visions of Revelation, each day brings a carefully curated reading that builds upon the last.",
            duration: "365 days",
            chapters: 52,
            difficulty: "Committed"
        ),
        ContinuePathItem(
            id: UUID(),
            icon: "leaf.fill",
            title: "Psalms of Comfort",
            subtitle: "Psalm 23 completed",
            progress: 0.6,
            category: .scripture,
            synopsis: "When life feels heavy and uncertain, the Psalms offer a sanctuary of words that speak directly to the weary heart. This 30-day journey walks you through carefully selected psalms — each chosen for its power to comfort, restore hope, and remind you that you are never alone.",
            duration: "30 days",
            chapters: 30,
            difficulty: "Gentle"
        ),
    ]
}
