import Foundation

nonisolated struct ScriptureVerse: Identifiable, Sendable {
    let id: UUID
    let text: String
    let reference: String

    init(id: UUID = UUID(), text: String, reference: String) {
        self.id = id
        self.text = text
        self.reference = reference
    }
}

nonisolated struct ScriptureSession: Identifiable, Sendable {
    let id: UUID
    let title: String
    let subtitle: String
    let verses: [ScriptureVerse]
    let readingWith: Int

    init(id: UUID = UUID(), title: String, subtitle: String, verses: [ScriptureVerse], readingWith: Int) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.verses = verses
        self.readingWith = readingWith
    }

    static func session(for item: String) -> ScriptureSession {
        switch item {
        case "Genesis to Revelation":
            return genesisSession
        case "Psalms of Comfort":
            return psalmsSession
        case "40 Days of Faith":
            return faithSession
        case "Morning Offerings":
            return morningSession
        default:
            return psalmsSession
        }
    }

    static let genesisSession = ScriptureSession(
        title: "In the Beginning",
        subtitle: "Genesis 1:1–5",
        verses: [
            ScriptureVerse(text: "In the beginning God created the heavens and the earth.", reference: "Genesis 1:1"),
            ScriptureVerse(text: "Now the earth was formless and empty, darkness was over the surface of the deep.", reference: "Genesis 1:2a"),
            ScriptureVerse(text: "And the Spirit of God was hovering over the waters.", reference: "Genesis 1:2b"),
            ScriptureVerse(text: "And God said, \"Let there be light,\" and there was light.", reference: "Genesis 1:3"),
            ScriptureVerse(text: "God saw that the light was good, and he separated the light from the darkness.", reference: "Genesis 1:4"),
            ScriptureVerse(text: "God called the light \"day,\" and the darkness he called \"night.\"", reference: "Genesis 1:5a"),
            ScriptureVerse(text: "And there was evening, and there was morning — the first day.", reference: "Genesis 1:5b"),
        ],
        readingWith: 124
    )

    static let psalmsSession = ScriptureSession(
        title: "The Lord is My Shepherd",
        subtitle: "Psalm 23",
        verses: [
            ScriptureVerse(text: "The Lord is my shepherd; I shall not want.", reference: "Psalm 23:1"),
            ScriptureVerse(text: "He makes me lie down in green pastures.", reference: "Psalm 23:2a"),
            ScriptureVerse(text: "He leads me beside still waters.", reference: "Psalm 23:2b"),
            ScriptureVerse(text: "He restores my soul.", reference: "Psalm 23:3a"),
            ScriptureVerse(text: "He leads me in paths of righteousness for his name's sake.", reference: "Psalm 23:3b"),
            ScriptureVerse(text: "Even though I walk through the valley of the shadow of death, I will fear no evil, for you are with me.", reference: "Psalm 23:4a"),
            ScriptureVerse(text: "Your rod and your staff, they comfort me.", reference: "Psalm 23:4b"),
            ScriptureVerse(text: "You prepare a table before me in the presence of my enemies.", reference: "Psalm 23:5a"),
            ScriptureVerse(text: "You anoint my head with oil; my cup overflows.", reference: "Psalm 23:5b"),
            ScriptureVerse(text: "Surely goodness and mercy shall follow me all the days of my life.", reference: "Psalm 23:6a"),
            ScriptureVerse(text: "And I shall dwell in the house of the Lord forever.", reference: "Psalm 23:6b"),
        ],
        readingWith: 89
    )

    static let faithSession = ScriptureSession(
        title: "Walk by Faith",
        subtitle: "Day 1 — Trust",
        verses: [
            ScriptureVerse(text: "For we walk by faith, not by sight.", reference: "2 Corinthians 5:7"),
            ScriptureVerse(text: "Now faith is confidence in what we hope for and assurance about what we do not see.", reference: "Hebrews 11:1"),
            ScriptureVerse(text: "Trust in the Lord with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5"),
            ScriptureVerse(text: "In all your ways submit to him, and he will make your paths straight.", reference: "Proverbs 3:6"),
            ScriptureVerse(text: "The Lord himself goes before you and will be with you; he will never leave you nor forsake you.", reference: "Deuteronomy 31:8a"),
            ScriptureVerse(text: "Do not be afraid; do not be discouraged.", reference: "Deuteronomy 31:8b"),
        ],
        readingWith: 215
    )

    static let morningSession = ScriptureSession(
        title: "Morning Light",
        subtitle: "Day 1 — Awakening",
        verses: [
            ScriptureVerse(text: "This is the day the Lord has made; let us rejoice and be glad in it.", reference: "Psalm 118:24"),
            ScriptureVerse(text: "Because of the Lord's great love we are not consumed, for his compassions never fail.", reference: "Lamentations 3:22"),
            ScriptureVerse(text: "They are new every morning; great is your faithfulness.", reference: "Lamentations 3:23"),
            ScriptureVerse(text: "Let the morning bring me word of your unfailing love, for I have put my trust in you.", reference: "Psalm 143:8a"),
            ScriptureVerse(text: "Show me the way I should go, for to you I entrust my life.", reference: "Psalm 143:8b"),
            ScriptureVerse(text: "Satisfy us in the morning with your unfailing love, that we may sing for joy and be glad all our days.", reference: "Psalm 90:14"),
        ],
        readingWith: 167
    )
}
