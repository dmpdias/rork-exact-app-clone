import Foundation

nonisolated struct CounselorPersona: Identifiable, Sendable, Hashable {
    let id: String
    let name: String
    let title: String
    let icon: String
    let initial: String
    let description: String

    static let personas: [CounselorPersona] = [
        CounselorPersona(
            id: "shepherd",
            name: "The Shepherd",
            title: "Gentle Guide",
            icon: "leaf.fill",
            initial: "S",
            description: "Warm and nurturing, guides you with patience and compassion through life's valleys."
        ),
        CounselorPersona(
            id: "elder",
            name: "The Elder",
            title: "Wise Counsel",
            icon: "book.closed.fill",
            initial: "E",
            description: "Deep biblical wisdom rooted in scripture, offering timeless truth for modern struggles."
        ),
        CounselorPersona(
            id: "companion",
            name: "The Companion",
            title: "Faithful Friend",
            icon: "heart.fill",
            initial: "C",
            description: "Walks beside you like a trusted friend, listening without judgment and encouraging with love."
        ),
        CounselorPersona(
            id: "prophet",
            name: "The Prophet",
            title: "Bold Truth",
            icon: "flame.fill",
            initial: "P",
            description: "Speaks with conviction and clarity, challenging you to grow deeper in faith and purpose."
        ),
    ]

    static let defaultPersona = personas[0]
}
