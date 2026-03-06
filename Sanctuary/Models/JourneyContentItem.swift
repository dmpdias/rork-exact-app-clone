import Foundation

nonisolated struct JourneyContentItem: Identifiable, Sendable {
    let id: UUID
    let title: String
    let subtitle: String
    let icon: String
    let detail: String

    static let scriptureItems: [JourneyContentItem] = [
        JourneyContentItem(id: UUID(), title: "Genesis to Revelation", subtitle: "Read through the Bible in 365 days", icon: "book.closed.fill", detail: "A daily reading plan that takes you through the entire Bible over the course of a year."),
        JourneyContentItem(id: UUID(), title: "Psalms of Comfort", subtitle: "30 psalms for difficult seasons", icon: "text.book.closed.fill", detail: "A curated collection of psalms that bring peace and reassurance."),
        JourneyContentItem(id: UUID(), title: "Proverbs of Wisdom", subtitle: "Daily wisdom for modern life", icon: "scroll.fill", detail: "One proverb a day to guide your decisions and character."),
        JourneyContentItem(id: UUID(), title: "The Gospels", subtitle: "Walk with Jesus through all four accounts", icon: "star.fill", detail: "Experience the life, teachings, death, and resurrection of Christ."),
        JourneyContentItem(id: UUID(), title: "Letters of Paul", subtitle: "Faith, hope, and love in the epistles", icon: "envelope.open.fill", detail: "Journey through Paul's letters to the early churches."),
    ]

    static let prayerItems: [JourneyContentItem] = [
        JourneyContentItem(id: UUID(), title: "Morning Offerings", subtitle: "Start each day surrendered", icon: "sun.horizon.fill", detail: "A collection of morning prayers to begin each day in devotion."),
        JourneyContentItem(id: UUID(), title: "Evening Vespers", subtitle: "Close the day in gratitude", icon: "moon.stars.fill", detail: "Reflective evening prayers to end your day peacefully."),
        JourneyContentItem(id: UUID(), title: "Prayers for Others", subtitle: "Intercessory prayer guides", icon: "person.2.fill", detail: "Structured prayers for lifting up family, friends, and the world."),
        JourneyContentItem(id: UUID(), title: "Prayers of Lament", subtitle: "Honest words in hard times", icon: "cloud.rain.fill", detail: "Prayers for seasons of grief, doubt, and struggle."),
        JourneyContentItem(id: UUID(), title: "Thanksgiving Prayers", subtitle: "Cultivate a grateful heart", icon: "leaf.fill", detail: "Prayers of praise and thanks for every blessing."),
    ]

    static let journeyItems: [JourneyContentItem] = [
        JourneyContentItem(id: UUID(), title: "40 Days of Faith", subtitle: "A transformative spiritual journey", icon: "flame.fill", detail: "A 40-day guided experience to deepen your faith walk."),
        JourneyContentItem(id: UUID(), title: "The Fruits of the Spirit", subtitle: "9 weeks of character formation", icon: "tree.fill", detail: "Explore love, joy, peace, patience, kindness, goodness, faithfulness, gentleness, and self-control."),
        JourneyContentItem(id: UUID(), title: "Finding Your Purpose", subtitle: "Discover God's plan for you", icon: "compass.drawing", detail: "A 21-day journey to uncover your unique calling."),
        JourneyContentItem(id: UUID(), title: "The Beatitudes", subtitle: "Living the Sermon on the Mount", icon: "mountain.2.fill", detail: "8 weeks studying and applying the Beatitudes."),
    ]

    static let insightItems: [JourneyContentItem] = [
        JourneyContentItem(id: UUID(), title: "Bookmarked Verses", subtitle: "12 saved verses", icon: "bookmark.fill", detail: "Your personally saved scripture passages."),
        JourneyContentItem(id: UUID(), title: "Journal Entries", subtitle: "8 reflections this month", icon: "note.text", detail: "Your spiritual journal and personal reflections."),
        JourneyContentItem(id: UUID(), title: "Prayer Answers", subtitle: "Testimonies of faithfulness", icon: "checkmark.seal.fill", detail: "Prayers that have been answered — reminders of God's faithfulness."),
    ]

    static func items(for category: JourneyCategory) -> [JourneyContentItem] {
        switch category {
        case .scripture: return scriptureItems
        case .prayerLibrary: return prayerItems
        case .guidedJourneys: return journeyItems
        case .savedInsights: return insightItems
        }
    }
}
