import SwiftUI

@Observable
class CommunityViewModel {
    var prayers: [PrayerCard] = PrayerCard.samples
    var prayingAnimationId: UUID?

    func togglePraying(for id: UUID) {
        guard let index = prayers.firstIndex(where: { $0.id == id }) else { return }
        let wasPraying = prayers[index].isPrayingByMe
        prayers[index].isPrayingByMe = !wasPraying
        prayers[index].prayingCount += wasPraying ? -1 : 1

        if !wasPraying {
            prayingAnimationId = id
            Task {
                try? await Task.sleep(for: .milliseconds(600))
                if prayingAnimationId == id {
                    prayingAnimationId = nil
                }
            }
        }
    }

    func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        let minutes = Int(interval / 60)
        if minutes < 1 { return "Just now" }
        if minutes < 60 { return "\(minutes)m ago" }
        let hours = minutes / 60
        if hours < 24 { return "\(hours)h ago" }
        return "\(hours / 24)d ago"
    }
}
