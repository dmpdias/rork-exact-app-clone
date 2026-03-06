import SwiftUI

@Observable
class PrayerWallViewModel {
    var prayers: [PrayerRequest] = PrayerWallViewModel.samplePrayers
    var selectedCategory: PrayerCategory? = nil
    var currentIndex: Int = 0

    var filteredPrayers: [PrayerRequest] {
        guard let category = selectedCategory else { return prayers }
        return prayers.filter { $0.category == category }
    }

    func togglePrayer(for prayer: PrayerRequest) {
        guard let index = prayers.firstIndex(where: { $0.id == prayer.id }) else { return }
        let current = prayers[index]
        prayers[index] = PrayerRequest(
            authorName: current.authorName,
            authorInitials: current.authorInitials,
            timeAgo: current.timeAgo,
            category: current.category,
            title: current.title,
            body: current.body,
            prayerCount: current.isPrayedFor ? current.prayerCount - 1 : current.prayerCount + 1,
            isPrayedFor: !current.isPrayedFor
        )
    }

    static let samplePrayers: [PrayerRequest] = [
        PrayerRequest(
            authorName: "Sarah M.",
            authorInitials: "SM",
            timeAgo: "2h ago",
            category: .healing,
            title: "Healing for my mother",
            body: "My mother was diagnosed last week and the family is struggling to stay strong. I believe in the power of collective prayer. Please keep her in your thoughts tonight.",
            prayerCount: 234,
            isPrayedFor: false
        ),
        PrayerRequest(
            authorName: "James R.",
            authorInitials: "JR",
            timeAgo: "4h ago",
            category: .strength,
            title: "Finding strength in transition",
            body: "I lost my job unexpectedly and I'm trying to trust God's plan. Some days it feels impossible to keep faith. I need strength to keep moving forward and provide for my family.",
            prayerCount: 187,
            isPrayedFor: true
        ),
        PrayerRequest(
            authorName: "Maria L.",
            authorInitials: "ML",
            timeAgo: "6h ago",
            category: .gratitude,
            title: "Grateful for a second chance",
            body: "After years of struggle, I finally feel at peace. I want to share my gratitude with this community and remind everyone that God's timing is perfect. Never lose hope.",
            prayerCount: 412,
            isPrayedFor: false
        ),
        PrayerRequest(
            authorName: "David K.",
            authorInitials: "DK",
            timeAgo: "8h ago",
            category: .guidance,
            title: "Seeking direction for my calling",
            body: "I feel a pull toward ministry but I'm terrified of the unknown. I keep praying for a sign, for clarity. If you've ever felt called to something bigger, please pray with me.",
            prayerCount: 156,
            isPrayedFor: false
        ),
        PrayerRequest(
            authorName: "Elena W.",
            authorInitials: "EW",
            timeAgo: "12h ago",
            category: .peace,
            title: "Peace after loss",
            body: "It's been three months since I lost my best friend. The grief comes in waves. I'm searching for peace — the kind that surpasses understanding. Hold me in your prayers.",
            prayerCount: 308,
            isPrayedFor: false
        ),
        PrayerRequest(
            authorName: "Michael T.",
            authorInitials: "MT",
            timeAgo: "1d ago",
            category: .family,
            title: "Restoring a broken relationship",
            body: "My brother and I haven't spoken in two years. Pride keeps us apart. I want to be the one to reach out but fear rejection. Pray that God softens both our hearts.",
            prayerCount: 275,
            isPrayedFor: false
        ),
        PrayerRequest(
            authorName: "Ruth A.",
            authorInitials: "RA",
            timeAgo: "1d ago",
            category: .healing,
            title: "Recovery from surgery",
            body: "I'm going into surgery tomorrow morning. I trust my doctors but I also trust in something greater. Please pray for steady hands and a smooth recovery.",
            prayerCount: 521,
            isPrayedFor: true
        ),
        PrayerRequest(
            authorName: "Nathan P.",
            authorInitials: "NP",
            timeAgo: "2d ago",
            category: .strength,
            title: "Battling addiction",
            body: "Day 47 clean. Every day is a fight but I'm choosing faith over fear. This community keeps me going. Your prayers are my armor. Please don't stop.",
            prayerCount: 643,
            isPrayedFor: true
        )
    ]
}
