import SwiftUI

@Observable
class CounselorViewModel {
    var messages: [ChatMessage] = []
    var inputText: String = ""
    var isTyping: Bool = false
    var showStarters: Bool = false

    private let counselorResponses: [String] = [
        "The Lord is close to the brokenhearted and saves those who are crushed in spirit. — Psalm 34:18\n\nRemember, your feelings are valid, and God walks with you through every valley. Take a moment to breathe and release your burdens to Him.",
        "Cast all your anxiety on Him because He cares for you. — 1 Peter 5:7\n\nWhen life feels heavy, it's an invitation to lean deeper into His grace. You don't have to carry this alone.",
        "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future. — Jeremiah 29:11\n\nTrust in His timing. Even when the path is unclear, He is writing a beautiful story with your life.",
        "Be still, and know that I am God. — Psalm 46:10\n\nIn the noise of daily life, find your quiet place with Him. Silence is where His voice becomes clearest.",
        "The peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus. — Philippians 4:7\n\nPeace isn't the absence of trouble — it's the presence of God in the midst of it. Let His peace wash over you right now.",
        "Come to me, all you who are weary and burdened, and I will give you rest. — Matthew 11:28\n\nYou were never meant to do this alone. Lay down your striving and rest in His finished work.",
        "Trust in the Lord with all your heart and lean not on your own understanding. — Proverbs 3:5\n\nFaith means stepping forward even when you can't see the full path. He sees what you cannot.",
        "The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you; in His love He will no longer rebuke you, but will rejoice over you with singing. — Zephaniah 3:17\n\nYou are deeply, fiercely loved. Let that truth settle into your bones today.",
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
            let response = counselorResponses.randomElement() ?? counselorResponses[0]
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
}
