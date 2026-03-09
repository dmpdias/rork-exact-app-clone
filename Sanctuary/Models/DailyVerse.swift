import Foundation

nonisolated struct DailyVerse: Sendable {
    let text: String
    let reference: String

    static let verses: [DailyVerse] = [
        DailyVerse(text: "For I know the plans I have for you, declares the Lord, plans to prosper you and not to harm you, plans to give you hope and a future.", reference: "Jeremiah 29:11"),
        DailyVerse(text: "The Lord is my shepherd; I shall not want. He makes me lie down in green pastures. He leads me beside still waters.", reference: "Psalm 23:1-2"),
        DailyVerse(text: "Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", reference: "Joshua 1:9"),
        DailyVerse(text: "Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.", reference: "Proverbs 3:5-6"),
        DailyVerse(text: "Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled and do not be afraid.", reference: "John 14:27"),
        DailyVerse(text: "Come to me, all you who are weary and burdened, and I will give you rest.", reference: "Matthew 11:28"),
        DailyVerse(text: "I can do all things through Christ who strengthens me.", reference: "Philippians 4:13"),
        DailyVerse(text: "The Lord is close to the brokenhearted and saves those who are crushed in spirit.", reference: "Psalm 34:18"),
        DailyVerse(text: "And we know that in all things God works for the good of those who love him, who have been called according to his purpose.", reference: "Romans 8:28"),
        DailyVerse(text: "He has made everything beautiful in its time. He has also set eternity in the human heart.", reference: "Ecclesiastes 3:11"),
        DailyVerse(text: "The Lord bless you and keep you; the Lord make his face shine on you and be gracious to you.", reference: "Numbers 6:24-25"),
        DailyVerse(text: "But those who hope in the Lord will renew their strength. They will soar on wings like eagles.", reference: "Isaiah 40:31"),
        DailyVerse(text: "Delight yourself in the Lord, and he will give you the desires of your heart.", reference: "Psalm 37:4"),
        DailyVerse(text: "Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.", reference: "Philippians 4:6"),
        DailyVerse(text: "The steadfast love of the Lord never ceases; his mercies never come to an end; they are new every morning.", reference: "Lamentations 3:22-23"),
        DailyVerse(text: "For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.", reference: "John 3:16"),
        DailyVerse(text: "He will cover you with his feathers, and under his wings you will find refuge; his faithfulness will be your shield.", reference: "Psalm 91:4"),
        DailyVerse(text: "Cast all your anxiety on him because he cares for you.", reference: "1 Peter 5:7"),
        DailyVerse(text: "The Lord your God is in your midst, a mighty one who will save; he will rejoice over you with gladness.", reference: "Zephaniah 3:17"),
        DailyVerse(text: "Create in me a pure heart, O God, and renew a steadfast spirit within me.", reference: "Psalm 51:10"),
        DailyVerse(text: "Have I not commanded you? Be strong and courageous. Do not be terrified; do not be discouraged.", reference: "Joshua 1:9"),
        DailyVerse(text: "But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness and self-control.", reference: "Galatians 5:22-23"),
        DailyVerse(text: "The name of the Lord is a fortified tower; the righteous run to it and are safe.", reference: "Proverbs 18:10"),
        DailyVerse(text: "Wait for the Lord; be strong and take heart and wait for the Lord.", reference: "Psalm 27:14"),
        DailyVerse(text: "God is our refuge and strength, an ever-present help in trouble.", reference: "Psalm 46:1"),
        DailyVerse(text: "In all your ways acknowledge him, and he shall direct your paths.", reference: "Proverbs 3:6"),
        DailyVerse(text: "Blessed is the one who trusts in the Lord, whose confidence is in him.", reference: "Jeremiah 17:7"),
        DailyVerse(text: "The Lord is my light and my salvation — whom shall I fear?", reference: "Psalm 27:1"),
        DailyVerse(text: "Be still, and know that I am God.", reference: "Psalm 46:10"),
        DailyVerse(text: "For where two or three gather in my name, there am I with them.", reference: "Matthew 18:20"),
        DailyVerse(text: "Rejoice always, pray continually, give thanks in all circumstances.", reference: "1 Thessalonians 5:16-18"),
    ]

    static func forToday() -> DailyVerse {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % verses.count
        return verses[index]
    }
}
