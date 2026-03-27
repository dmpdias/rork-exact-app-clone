import Foundation

nonisolated struct SavedVerse: Identifiable, Sendable {
    let id: UUID
    let text: String
    let reference: String
    let dateSaved: Date
    var isBookmarked: Bool

    static let samples: [SavedVerse] = [
        SavedVerse(id: UUID(), text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11", dateSaved: Date().addingTimeInterval(-86400), isBookmarked: true),
        SavedVerse(id: UUID(), text: "The Lord is my shepherd; I shall not want.", reference: "Psalm 23:1", dateSaved: Date().addingTimeInterval(-172800), isBookmarked: true),
        SavedVerse(id: UUID(), text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", reference: "Joshua 1:9", dateSaved: Date().addingTimeInterval(-259200), isBookmarked: true),
        SavedVerse(id: UUID(), text: "Trust in the Lord with all your heart and lean not on your own understanding.", reference: "Proverbs 3:5", dateSaved: Date().addingTimeInterval(-345600), isBookmarked: true),
        SavedVerse(id: UUID(), text: "Peace I leave with you; my peace I give you. I do not give to you as the world gives.", reference: "John 14:27", dateSaved: Date().addingTimeInterval(-432000), isBookmarked: true),
        SavedVerse(id: UUID(), text: "Come to me, all you who are weary and burdened, and I will give you rest.", reference: "Matthew 11:28", dateSaved: Date().addingTimeInterval(-518400), isBookmarked: true),
    ]
}

nonisolated struct JournalEntry: Identifiable, Sendable {
    let id: UUID
    let title: String
    let body: String
    let mood: String
    let date: Date

    static let samples: [JournalEntry] = [
        JournalEntry(id: UUID(), title: "A morning of clarity", body: "Woke up feeling restless, but after spending time in Psalm 46, a deep calm settled over me. God reminded me that He is in control — I don't need to carry the weight alone.", mood: "leaf.fill", date: Date().addingTimeInterval(-3600)),
        JournalEntry(id: UUID(), title: "Answered prayer for peace", body: "The anxiety I've been carrying about work finally lifted during evening prayer. I felt the Spirit whisper that this season of uncertainty is preparing me for something greater.", mood: "sun.max.fill", date: Date().addingTimeInterval(-90000)),
        JournalEntry(id: UUID(), title: "Reflecting on forgiveness", body: "Read the parable of the unforgiving servant today. It challenged me deeply — I realize I've been holding onto resentment. Lord, help me release it.", mood: "heart.fill", date: Date().addingTimeInterval(-180000)),
        JournalEntry(id: UUID(), title: "Gratitude overflow", body: "My daughter said the sweetest prayer at dinner tonight. Watching her faith grow fills me with indescribable joy. Thank You, Lord, for this gift.", mood: "sparkles", date: Date().addingTimeInterval(-360000)),
        JournalEntry(id: UUID(), title: "Wrestling with doubt", body: "Honest moment: today was hard. I questioned why God feels distant. But I'm choosing to trust even when I can't feel His presence. Faith is a choice.", mood: "cloud.rain.fill", date: Date().addingTimeInterval(-540000)),
    ]
}

nonisolated struct PrayerAnswer: Identifiable, Sendable {
    let id: UUID
    let prayerText: String
    let commenterName: String
    let commenterInitials: String
    let comment: String
    let date: Date

    static let samples: [PrayerAnswer] = [
        PrayerAnswer(id: UUID(), prayerText: "Pray for my mother's healing journey", commenterName: "Sarah P.", commenterInitials: "S.P.", comment: "Praying with you daily. God is the great physician — trust in His timing. Your mother is covered in prayer.", date: Date().addingTimeInterval(-7200)),
        PrayerAnswer(id: UUID(), prayerText: "Pray for my mother's healing journey", commenterName: "Elijah C.", commenterInitials: "E.C.", comment: "Standing in agreement with you. Jeremiah 30:17 — He will restore your health and heal your wounds.", date: Date().addingTimeInterval(-14400)),
        PrayerAnswer(id: UUID(), prayerText: "Seeking guidance for a career change", commenterName: "Anna W.", commenterInitials: "A.W.", comment: "I went through the same thing last year. God opened doors I never expected. Keep praying and stay open!", date: Date().addingTimeInterval(-86400)),
        PrayerAnswer(id: UUID(), prayerText: "Seeking guidance for a career change", commenterName: "James D.", commenterInitials: "J.D.", comment: "Proverbs 3:6 — In all your ways acknowledge Him, and He shall direct your paths. Praying for clarity.", date: Date().addingTimeInterval(-172800)),
        PrayerAnswer(id: UUID(), prayerText: "Strength to overcome anxiety", commenterName: "Maria S.", commenterInitials: "M.S.", comment: "You are not alone in this. Philippians 4:6-7 has been my anchor. Lifting you up tonight.", date: Date().addingTimeInterval(-259200)),
        PrayerAnswer(id: UUID(), prayerText: "Strength to overcome anxiety", commenterName: "Thomas K.", commenterInitials: "T.K.", comment: "Peace that surpasses understanding is yours. Claiming it over you right now. Stay strong, friend.", date: Date().addingTimeInterval(-345600)),
    ]
}
