import Foundation

nonisolated struct PrayerSessionVerse: Identifiable, Sendable {
    let id: UUID
    let text: String
    let reference: String

    init(id: UUID = UUID(), text: String, reference: String) {
        self.id = id
        self.text = text
        self.reference = reference
    }
}

nonisolated struct PrayerSession: Identifiable, Sendable {
    let id: UUID
    let prayerForName: String
    let prayerText: String
    let category: PrayerCategory
    let verses: [PrayerSessionVerse]
    let prayingWith: Int

    init(id: UUID = UUID(), prayerForName: String, prayerText: String, category: PrayerCategory, verses: [PrayerSessionVerse], prayingWith: Int) {
        self.id = id
        self.prayerForName = prayerForName
        self.prayerText = prayerText
        self.category = category
        self.verses = verses
        self.prayingWith = prayingWith
    }

    var sessionTitle: String {
        switch category {
        case .all: return "Intercession"
        case .healing: return "Prayer for Healing"
        case .guidance: return "Prayer for Guidance"
        case .gratitude: return "Prayer of Gratitude"
        case .family: return "Prayer for Family"
        case .faith: return "Prayer for Faith"
        case .strength: return "Prayer for Strength"
        }
    }

    var sessionSubtitle: String {
        "Lifting up \(prayerForName)"
    }

    static func session(for card: PrayerCard) -> PrayerSession {
        PrayerSession(
            prayerForName: card.displayName,
            prayerText: card.text,
            category: card.category,
            verses: verses(for: card.category),
            prayingWith: card.prayingCount
        )
    }

    private static func verses(for category: PrayerCategory) -> [PrayerSessionVerse] {
        switch category {
        case .healing:
            return [
                PrayerSessionVerse(text: "Heal me, Lord, and I will be healed; save me and I will be saved, for you are the one I praise.", reference: "Jeremiah 17:14"),
                PrayerSessionVerse(text: "He heals the brokenhearted and binds up their wounds.", reference: "Psalm 147:3"),
                PrayerSessionVerse(text: "But I will restore you to health and heal your wounds, declares the Lord.", reference: "Jeremiah 30:17"),
                PrayerSessionVerse(text: "The prayer offered in faith will make the sick person well; the Lord will raise them up.", reference: "James 5:15"),
                PrayerSessionVerse(text: "By his wounds we are healed.", reference: "Isaiah 53:5"),
            ]
        case .guidance:
            return [
                PrayerSessionVerse(text: "Trust in the Lord with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5"),
                PrayerSessionVerse(text: "In all your ways submit to him, and he will make your paths straight.", reference: "Proverbs 3:6"),
                PrayerSessionVerse(text: "Your word is a lamp for my feet, a light on my path.", reference: "Psalm 119:105"),
                PrayerSessionVerse(text: "I will instruct you and teach you in the way you should go; I will counsel you with my loving eye on you.", reference: "Psalm 32:8"),
                PrayerSessionVerse(text: "Whether you turn to the right or to the left, your ears will hear a voice behind you, saying, \"This is the way; walk in it.\"", reference: "Isaiah 30:21"),
            ]
        case .gratitude:
            return [
                PrayerSessionVerse(text: "Give thanks to the Lord, for he is good; his love endures forever.", reference: "Psalm 107:1"),
                PrayerSessionVerse(text: "Every good and perfect gift is from above, coming down from the Father of the heavenly lights.", reference: "James 1:17"),
                PrayerSessionVerse(text: "Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. And be thankful.", reference: "Colossians 3:15"),
                PrayerSessionVerse(text: "Rejoice always, pray continually, give thanks in all circumstances.", reference: "1 Thessalonians 5:16-18"),
                PrayerSessionVerse(text: "Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name.", reference: "Psalm 100:4"),
            ]
        case .family:
            return [
                PrayerSessionVerse(text: "As for me and my household, we will serve the Lord.", reference: "Joshua 24:15"),
                PrayerSessionVerse(text: "Children are a heritage from the Lord, offspring a reward from him.", reference: "Psalm 127:3"),
                PrayerSessionVerse(text: "The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you.", reference: "Numbers 6:24-25"),
                PrayerSessionVerse(text: "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.", reference: "1 Corinthians 13:4"),
                PrayerSessionVerse(text: "And over all these virtues put on love, which binds them all together in perfect unity.", reference: "Colossians 3:14"),
            ]
        case .faith:
            return [
                PrayerSessionVerse(text: "Now faith is confidence in what we hope for and assurance about what we do not see.", reference: "Hebrews 11:1"),
                PrayerSessionVerse(text: "For we walk by faith, not by sight.", reference: "2 Corinthians 5:7"),
                PrayerSessionVerse(text: "If you have faith as small as a mustard seed, you can say to this mountain, 'Move from here to there,' and it will move.", reference: "Matthew 17:20"),
                PrayerSessionVerse(text: "Let us hold unswervingly to the hope we profess, for he who promised is faithful.", reference: "Hebrews 10:23"),
                PrayerSessionVerse(text: "Be on your guard; stand firm in the faith; be courageous; be strong.", reference: "1 Corinthians 16:13"),
            ]
        case .strength:
            return [
                PrayerSessionVerse(text: "I can do all this through him who gives me strength.", reference: "Philippians 4:13"),
                PrayerSessionVerse(text: "The Lord is my strength and my shield; my heart trusts in him, and he helps me.", reference: "Psalm 28:7"),
                PrayerSessionVerse(text: "But those who hope in the Lord will renew their strength. They will soar on wings like eagles.", reference: "Isaiah 40:31"),
                PrayerSessionVerse(text: "God is our refuge and strength, an ever-present help in trouble.", reference: "Psalm 46:1"),
                PrayerSessionVerse(text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", reference: "Joshua 1:9"),
            ]
        case .all:
            return [
                PrayerSessionVerse(text: "The Lord is near to all who call on him, to all who call on him in truth.", reference: "Psalm 145:18"),
                PrayerSessionVerse(text: "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.", reference: "Philippians 4:6"),
                PrayerSessionVerse(text: "And the peace of God, which transcends all understanding, will guard your hearts and your minds in Christ Jesus.", reference: "Philippians 4:7"),
                PrayerSessionVerse(text: "Cast all your anxiety on him because he cares for you.", reference: "1 Peter 5:7"),
                PrayerSessionVerse(text: "The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you.", reference: "Numbers 6:24-25"),
            ]
        }
    }
}
