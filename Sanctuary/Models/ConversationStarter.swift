import Foundation

nonisolated struct ConversationStarter: Identifiable, Sendable {
    let id: UUID
    let prompt: String
    let icon: String

    init(id: UUID = UUID(), prompt: String, icon: String) {
        self.id = id
        self.prompt = prompt
        self.icon = icon
    }

    static let starters: [ConversationStarter] = [
        ConversationStarter(prompt: "I'm feeling distant from God today", icon: "heart"),
        ConversationStarter(prompt: "Help me understand forgiveness", icon: "hands.sparkles"),
        ConversationStarter(prompt: "I need strength to get through this week", icon: "figure.mind.and.body"),
        ConversationStarter(prompt: "What does the Bible say about anxiety?", icon: "book"),
        ConversationStarter(prompt: "I want to deepen my prayer life", icon: "flame"),
        ConversationStarter(prompt: "How do I trust God's plan for me?", icon: "arrow.triangle.turn.up.right.diamond"),
        ConversationStarter(prompt: "I'm struggling with doubt", icon: "cloud.sun"),
        ConversationStarter(prompt: "Guide me through gratitude today", icon: "leaf"),
    ]
}
