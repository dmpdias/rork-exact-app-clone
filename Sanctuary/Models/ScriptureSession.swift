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
        case "Proverbs of Wisdom":
            return proverbsSession
        case "The Gospels":
            return gospelsSession
        case "Letters of Paul":
            return paulSession
        case "Evening Vespers":
            return vespersSession
        case "Prayers for Others":
            return intercessionSession
        case "Prayers of Lament":
            return lamentSession
        case "Thanksgiving Prayers":
            return thanksgivingSession
        case "The Fruits of the Spirit":
            return fruitsSession
        case "Finding Your Purpose":
            return purposeSession
        case "The Beatitudes":
            return beatitudesSession
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

    static let proverbsSession = ScriptureSession(
        title: "The Way of Wisdom",
        subtitle: "Proverbs 3:1–8",
        verses: [
            ScriptureVerse(text: "My son, do not forget my teaching, but keep my commands in your heart.", reference: "Proverbs 3:1"),
            ScriptureVerse(text: "For they will prolong your life many years and bring you peace and prosperity.", reference: "Proverbs 3:2"),
            ScriptureVerse(text: "Let love and faithfulness never leave you; bind them around your neck, write them on the tablet of your heart.", reference: "Proverbs 3:3"),
            ScriptureVerse(text: "Then you will win favor and a good name in the sight of God and man.", reference: "Proverbs 3:4"),
            ScriptureVerse(text: "Trust in the Lord with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5"),
            ScriptureVerse(text: "In all your ways submit to him, and he will make your paths straight.", reference: "Proverbs 3:6"),
            ScriptureVerse(text: "Do not be wise in your own eyes; fear the Lord and shun evil.", reference: "Proverbs 3:7"),
            ScriptureVerse(text: "This will bring health to your body and nourishment to your bones.", reference: "Proverbs 3:8"),
        ],
        readingWith: 143
    )

    static let gospelsSession = ScriptureSession(
        title: "The Sermon on the Mount",
        subtitle: "Matthew 5:1–12",
        verses: [
            ScriptureVerse(text: "Now when Jesus saw the crowds, he went up on a mountainside and sat down. His disciples came to him.", reference: "Matthew 5:1"),
            ScriptureVerse(text: "Blessed are the poor in spirit, for theirs is the kingdom of heaven.", reference: "Matthew 5:3"),
            ScriptureVerse(text: "Blessed are those who mourn, for they will be comforted.", reference: "Matthew 5:4"),
            ScriptureVerse(text: "Blessed are the meek, for they will inherit the earth.", reference: "Matthew 5:5"),
            ScriptureVerse(text: "Blessed are those who hunger and thirst for righteousness, for they will be filled.", reference: "Matthew 5:6"),
            ScriptureVerse(text: "Blessed are the merciful, for they will be shown mercy.", reference: "Matthew 5:7"),
            ScriptureVerse(text: "Blessed are the pure in heart, for they will see God.", reference: "Matthew 5:8"),
            ScriptureVerse(text: "Blessed are the peacemakers, for they will be called children of God.", reference: "Matthew 5:9"),
        ],
        readingWith: 312
    )

    static let paulSession = ScriptureSession(
        title: "The Armor of God",
        subtitle: "Ephesians 6:10–18",
        verses: [
            ScriptureVerse(text: "Finally, be strong in the Lord and in his mighty power.", reference: "Ephesians 6:10"),
            ScriptureVerse(text: "Put on the full armor of God, so that you can take your stand against the devil's schemes.", reference: "Ephesians 6:11"),
            ScriptureVerse(text: "Stand firm then, with the belt of truth buckled around your waist.", reference: "Ephesians 6:14a"),
            ScriptureVerse(text: "With the breastplate of righteousness in place.", reference: "Ephesians 6:14b"),
            ScriptureVerse(text: "And with your feet fitted with the readiness that comes from the gospel of peace.", reference: "Ephesians 6:15"),
            ScriptureVerse(text: "Take up the shield of faith, with which you can extinguish all the flaming arrows of the evil one.", reference: "Ephesians 6:16"),
            ScriptureVerse(text: "Take the helmet of salvation and the sword of the Spirit, which is the word of God.", reference: "Ephesians 6:17"),
            ScriptureVerse(text: "And pray in the Spirit on all occasions with all kinds of prayers and requests.", reference: "Ephesians 6:18"),
        ],
        readingWith: 198
    )

    static let vespersSession = ScriptureSession(
        title: "Evening Rest",
        subtitle: "Day 1 — Surrender",
        verses: [
            ScriptureVerse(text: "In peace I will lie down and sleep, for you alone, Lord, make me dwell in safety.", reference: "Psalm 4:8"),
            ScriptureVerse(text: "By day the Lord directs his love, at night his song is with me — a prayer to the God of my life.", reference: "Psalm 42:8"),
            ScriptureVerse(text: "He who watches over Israel will neither slumber nor sleep.", reference: "Psalm 121:4"),
            ScriptureVerse(text: "Come to me, all you who are weary and burdened, and I will give you rest.", reference: "Matthew 11:28"),
            ScriptureVerse(text: "Take my yoke upon you and learn from me, for I am gentle and humble in heart, and you will find rest for your souls.", reference: "Matthew 11:29"),
            ScriptureVerse(text: "The Lord your God is with you, the Mighty Warrior who saves. He will take great delight in you; in his love he will quiet you with his singing.", reference: "Zephaniah 3:17"),
        ],
        readingWith: 234
    )

    static let intercessionSession = ScriptureSession(
        title: "Praying for Others",
        subtitle: "Day 1 — Family",
        verses: [
            ScriptureVerse(text: "I urge, then, first of all, that petitions, prayers, intercession and thanksgiving be made for all people.", reference: "1 Timothy 2:1"),
            ScriptureVerse(text: "Therefore confess your sins to each other and pray for each other so that you may be healed.", reference: "James 5:16a"),
            ScriptureVerse(text: "The prayer of a righteous person is powerful and effective.", reference: "James 5:16b"),
            ScriptureVerse(text: "Bear one another's burdens, and so fulfill the law of Christ.", reference: "Galatians 6:2"),
            ScriptureVerse(text: "And pray in the Spirit on all occasions with all kinds of prayers and requests.", reference: "Ephesians 6:18a"),
            ScriptureVerse(text: "With this in mind, be alert and always keep on praying for all the Lord's people.", reference: "Ephesians 6:18b"),
        ],
        readingWith: 156
    )

    static let lamentSession = ScriptureSession(
        title: "Crying Out to God",
        subtitle: "Day 1 — Honest Before God",
        verses: [
            ScriptureVerse(text: "How long, Lord? Will you forget me forever? How long will you hide your face from me?", reference: "Psalm 13:1"),
            ScriptureVerse(text: "How long must I wrestle with my thoughts and day after day have sorrow in my heart?", reference: "Psalm 13:2"),
            ScriptureVerse(text: "But I trust in your unfailing love; my heart rejoices in your salvation.", reference: "Psalm 13:5"),
            ScriptureVerse(text: "I will sing the Lord's praise, for he has been good to me.", reference: "Psalm 13:6"),
            ScriptureVerse(text: "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", reference: "Psalm 34:18"),
            ScriptureVerse(text: "He heals the brokenhearted and binds up their wounds.", reference: "Psalm 147:3"),
        ],
        readingWith: 87
    )

    static let thanksgivingSession = ScriptureSession(
        title: "A Heart of Thanks",
        subtitle: "Day 1 — Gratitude",
        verses: [
            ScriptureVerse(text: "Give thanks to the Lord, for he is good; his love endures forever.", reference: "Psalm 107:1"),
            ScriptureVerse(text: "Enter his gates with thanksgiving and his courts with praise; give thanks to him and praise his name.", reference: "Psalm 100:4"),
            ScriptureVerse(text: "Give thanks in all circumstances; for this is God's will for you in Christ Jesus.", reference: "1 Thessalonians 5:18"),
            ScriptureVerse(text: "Every good and perfect gift is from above, coming down from the Father of the heavenly lights.", reference: "James 1:17"),
            ScriptureVerse(text: "Let the peace of Christ rule in your hearts, since as members of one body you were called to peace. And be thankful.", reference: "Colossians 3:15"),
            ScriptureVerse(text: "Praise the Lord, my soul, and forget not all his benefits.", reference: "Psalm 103:2"),
        ],
        readingWith: 201
    )

    static let fruitsSession = ScriptureSession(
        title: "Love — The First Fruit",
        subtitle: "Week 1 — Agape",
        verses: [
            ScriptureVerse(text: "But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness and self-control.", reference: "Galatians 5:22-23"),
            ScriptureVerse(text: "Love is patient, love is kind. It does not envy, it does not boast, it is not proud.", reference: "1 Corinthians 13:4"),
            ScriptureVerse(text: "It does not dishonor others, it is not self-seeking, it is not easily angered, it keeps no record of wrongs.", reference: "1 Corinthians 13:5"),
            ScriptureVerse(text: "Love does not delight in evil but rejoices with the truth.", reference: "1 Corinthians 13:6"),
            ScriptureVerse(text: "It always protects, always trusts, always hopes, always perseveres.", reference: "1 Corinthians 13:7"),
            ScriptureVerse(text: "Dear friends, let us love one another, for love comes from God. Everyone who loves has been born of God and knows God.", reference: "1 John 4:7"),
            ScriptureVerse(text: "And now these three remain: faith, hope and love. But the greatest of these is love.", reference: "1 Corinthians 13:13"),
        ],
        readingWith: 278
    )

    static let purposeSession = ScriptureSession(
        title: "Created with Purpose",
        subtitle: "Day 1 — Known Before Birth",
        verses: [
            ScriptureVerse(text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11"),
            ScriptureVerse(text: "Before I formed you in the womb I knew you, before you were born I set you apart.", reference: "Jeremiah 1:5"),
            ScriptureVerse(text: "For we are God's handiwork, created in Christ Jesus to do good works, which God prepared in advance for us to do.", reference: "Ephesians 2:10"),
            ScriptureVerse(text: "Your eyes saw my unformed body; all the days ordained for me were written in your book before one of them came to be.", reference: "Psalm 139:16"),
            ScriptureVerse(text: "Many are the plans in a person's heart, but it is the Lord's purpose that prevails.", reference: "Proverbs 19:21"),
            ScriptureVerse(text: "The Lord will fulfill his purpose for me; your steadfast love, O Lord, endures forever.", reference: "Psalm 138:8"),
        ],
        readingWith: 189
    )

    static let beatitudesSession = ScriptureSession(
        title: "The Blessings",
        subtitle: "Week 1 — Poor in Spirit",
        verses: [
            ScriptureVerse(text: "Blessed are the poor in spirit, for theirs is the kingdom of heaven.", reference: "Matthew 5:3"),
            ScriptureVerse(text: "To be poor in spirit is to recognize our complete dependence on God — to come with empty hands and an open heart.", reference: "Reflection"),
            ScriptureVerse(text: "He has shown you, O mortal, what is good. And what does the Lord require of you? To act justly and to love mercy and to walk humbly with your God.", reference: "Micah 6:8"),
            ScriptureVerse(text: "God opposes the proud but shows favor to the humble.", reference: "James 4:6"),
            ScriptureVerse(text: "Humble yourselves before the Lord, and he will lift you up.", reference: "James 4:10"),
            ScriptureVerse(text: "The sacrifices of God are a broken spirit; a broken and contrite heart, O God, you will not despise.", reference: "Psalm 51:17"),
        ],
        readingWith: 145
    )
}
