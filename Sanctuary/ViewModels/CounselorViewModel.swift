import SwiftUI

@Observable
class CounselorViewModel {
    var messages: [ChatMessage] = []
    var inputText: String = ""
    var isTyping: Bool = false
    var showStarters: Bool = false
    var selectedPersona: CounselorPersona = CounselorPersona.defaultPersona
    var showPersonaPicker: Bool = false

    static let featuredStarters: [ConversationStarter] = [
        ConversationStarter(prompt: "I'm feeling distant from God today", icon: "heart"),
        ConversationStarter(prompt: "Help me understand forgiveness", icon: "hands.sparkles"),
        ConversationStarter(prompt: "I need strength to get through this week", icon: "figure.mind.and.body"),
    ]

    private let counselorResponses: [String: [String]] = [
        "shepherd": [
            "The Lord is my shepherd; I shall not want. — Psalm 23:1\n\nCome, walk with me through this. He leads you beside still waters, even when the path feels uncertain. You are never walking alone.",
            "Cast all your anxiety on Him because He cares for you. — 1 Peter 5:7\n\nWhen life feels heavy, it's an invitation to lean deeper into His grace. You don't have to carry this alone, dear one.",
            "He heals the brokenhearted and binds up their wounds. — Psalm 147:3\n\nYour pain is not invisible to Him. Let His gentle hands tend to what hurts. Healing is already underway.",
            "The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you. — Zephaniah 3:17\n\nYou are deeply, fiercely loved. Let that truth settle into your bones today.",
        ],
        "elder": [
            "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you. — Jeremiah 29:11\n\nScripture has weathered every storm humanity has faced. Trust in His ancient wisdom — it speaks directly into your modern moment.",
            "Trust in the Lord with all your heart and lean not on your own understanding. — Proverbs 3:5\n\nFaith has never been about seeing the full picture. The patriarchs walked forward in darkness, and God met them every time.",
            "The fear of the Lord is the beginning of wisdom, and knowledge of the Holy One is understanding. — Proverbs 9:10\n\nSeek wisdom not in the noise of the world, but in the quiet truth of His word. There you will find clarity.",
            "All Scripture is God-breathed and useful for teaching, rebuking, correcting and training in righteousness. — 2 Timothy 3:16\n\nReturn to the Word. It has answered every question the human heart has ever asked.",
        ],
        "companion": [
            "A friend loves at all times, and a brother is born for a time of adversity. — Proverbs 17:17\n\nHey, I'm right here with you. Whatever you're going through, you don't have to face it alone. Let's talk it through.",
            "Two are better than one, because they have a good return for their labor. — Ecclesiastes 4:9\n\nSometimes we just need someone to sit with us. I'm here — no judgment, no rush. Just tell me what's on your heart.",
            "Bear one another's burdens, and so fulfill the law of Christ. — Galatians 6:2\n\nI hear you. That sounds really hard. It's okay to feel this way. God sees you right where you are, and so do I.",
            "The peace of God, which transcends all understanding, will guard your hearts and minds. — Philippians 4:7\n\nTake a deep breath. You're doing better than you think. Let's find that peace together, one moment at a time.",
        ],
        "prophet": [
            "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go. — Joshua 1:9\n\nNow is not the time to shrink back. God did not give you a spirit of timidity. Rise up and walk in your calling.",
            "I can do all things through Christ who strengthens me. — Philippians 4:13\n\nStop telling yourself you're not enough. The Creator of the universe lives in you. Act like it.",
            "If God is for us, who can be against us? — Romans 8:31\n\nThe enemy wants you stuck in fear and doubt. But you serve a God who has already won the battle. Step forward boldly.",
            "Be still, and know that I am God. — Psalm 46:10\n\nSilence the noise. The world will always be loud, but His voice cuts through it all. Listen — He is speaking to you right now.",
        ],
    ]

    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let userMessage = ChatMessage(role: .user, content: text)
        messages.append(userMessage)
        inputText = ""
        isTyping = true

        Task {
            try? await Task.sleep(for: .seconds(Double.random(in: 1.5...2.5)))
            let personaResponses = counselorResponses[selectedPersona.id] ?? counselorResponses["shepherd"]!
            let response = personaResponses.randomElement() ?? personaResponses[0]
            let counselorMessage = ChatMessage(role: .counselor, content: response)
            withAnimation(.easeOut(duration: 0.3)) {
                messages.append(counselorMessage)
                isTyping = false
            }
        }
    }

    func sendStarter(_ starter: ConversationStarter) {
        inputText = starter.prompt
        withAnimation(.easeOut(duration: 0.25)) {
            showStarters = false
        }
        sendMessage()
    }

    func clearConversation() {
        withAnimation(.easeOut(duration: 0.3)) {
            messages.removeAll()
            isTyping = false
        }
    }
}
