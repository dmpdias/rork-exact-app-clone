import Foundation

nonisolated struct EmotionalPrayer: Identifiable, Sendable {
    let id: UUID
    let text: String
    let reference: String

    init(id: UUID = UUID(), text: String, reference: String = "") {
        self.id = id
        self.text = text
        self.reference = reference
    }

    static func prayers(for bead: EmotionalBead) -> [EmotionalPrayer] {
        switch bead {
        case .peace:
            return peacePrayers
        case .strength:
            return strengthPrayers
        case .hope:
            return hopePrayers
        case .healing:
            return healingPrayers
        }
    }

    static let peacePrayers: [EmotionalPrayer] = [
        EmotionalPrayer(text: "Lord, quiet the noise within me. Let Your peace settle over my anxious thoughts like still waters.", reference: "Psalm 46:10"),
        EmotionalPrayer(text: "Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled.", reference: "John 14:27"),
        EmotionalPrayer(text: "Father, I release every worry into Your hands. You hold all things together — including me.", reference: "Colossians 1:17"),
        EmotionalPrayer(text: "Guard my heart and mind, Lord. Let Your peace, which surpasses all understanding, be my anchor today.", reference: "Philippians 4:7"),
        EmotionalPrayer(text: "In the chaos of this world, You are my refuge. I choose to rest in Your unchanging faithfulness.", reference: "Psalm 62:1-2"),
        EmotionalPrayer(text: "Breathe Your shalom into every corner of my being. From my racing mind to my weary body — peace, Lord. Peace."),
    ]

    static let strengthPrayers: [EmotionalPrayer] = [
        EmotionalPrayer(text: "Lord, when I am weak, You are strong. Pour Your strength into my weariness today.", reference: "2 Corinthians 12:9"),
        EmotionalPrayer(text: "I can do all things through Christ who strengthens me. Remind me of this truth when I falter.", reference: "Philippians 4:13"),
        EmotionalPrayer(text: "Father, be my fortress and my shield. I face battles I cannot fight alone — but with You, I am more than a conqueror.", reference: "Romans 8:37"),
        EmotionalPrayer(text: "Renew my strength, Lord. Let me rise on wings like eagles — running and not growing weary.", reference: "Isaiah 40:31"),
        EmotionalPrayer(text: "The Lord is my strength and my song; he has become my salvation. With You, I will not be shaken.", reference: "Exodus 15:2"),
        EmotionalPrayer(text: "Give me courage for the next step. Not the whole journey — just this one step. Your grace is enough for right now."),
    ]

    static let hopePrayers: [EmotionalPrayer] = [
        EmotionalPrayer(text: "Lord, rekindle hope in my heart. Even in the darkest valley, Your light breaks through.", reference: "Psalm 130:5"),
        EmotionalPrayer(text: "For I know the plans I have for you — plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11"),
        EmotionalPrayer(text: "Father, when the road ahead feels uncertain, anchor my soul in the hope that does not disappoint.", reference: "Romans 5:5"),
        EmotionalPrayer(text: "May the God of hope fill you with all joy and peace as you trust in him, so that you may overflow with hope.", reference: "Romans 15:13"),
        EmotionalPrayer(text: "The morning is coming, Lord. Help me hold on through this night, trusting that joy comes with the dawn.", reference: "Psalm 30:5"),
        EmotionalPrayer(text: "Plant seeds of hope deep in my spirit. Let them grow even now — especially now — when I cannot yet see the harvest."),
    ]

    static let healingPrayers: [EmotionalPrayer] = [
        EmotionalPrayer(text: "Lord, You are the healer of broken hearts and wounded spirits. Touch the places in me that only You can reach.", reference: "Psalm 147:3"),
        EmotionalPrayer(text: "By His wounds we are healed. I claim this promise over my body, my mind, and my soul.", reference: "Isaiah 53:5"),
        EmotionalPrayer(text: "Father, bring restoration to what has been damaged. Mend what is torn. Rebuild what has crumbled.", reference: "Joel 2:25"),
        EmotionalPrayer(text: "He restores my soul. He leads me in paths of righteousness for his name's sake.", reference: "Psalm 23:3"),
        EmotionalPrayer(text: "Lord, I surrender my pain to You. Take what is broken and make it beautiful in Your time.", reference: "Ecclesiastes 3:11"),
        EmotionalPrayer(text: "Heal me from the inside out, Lord. Not just the symptoms, but the deep roots of hurt I've been carrying."),
    ]
}
