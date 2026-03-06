import SwiftUI

@Observable
class FellowshipViewModel {
    var selectedVirtue: Virtue = .faithfulness
    var members: [FellowshipMember] = FellowshipViewModel.generateMembers()
    var blessedIds: Set<UUID> = []
    var bloomingId: UUID?

    var sortedMembers: [FellowshipMember] {
        members.sorted { $0.rank < $1.rank }
    }

    func bless(_ member: FellowshipMember) {
        guard !blessedIds.contains(member.id) else { return }
        blessedIds.insert(member.id)
        bloomingId = member.id

        if let index = members.firstIndex(where: { $0.id == member.id }) {
            members[index].blessCount += 1
        }

        Task {
            try? await Task.sleep(for: .milliseconds(800))
            bloomingId = nil
        }
    }

    private static func generateMembers() -> [FellowshipMember] {
        let names = [
            "Grace M.", "Elijah T.", "Hannah R.", "Samuel K.",
            "Miriam J.", "Caleb D.", "Abigail N.", "Isaiah W.",
            "Naomi L.", "Daniel P.", "Ruth S.", "Joseph A.",
            "Esther C.", "David H.", "Lydia F.", "Aaron B.",
            "Sarah V.", "Noah G.", "Rebecca E.", "Moses Q."
        ]

        return names.enumerated().map { index, name in
            FellowshipMember(
                id: UUID(),
                displayName: name,
                rank: index + 1,
                isActive: index < 5 || index % 3 == 0,
                streakDays: max(1, 30 - index * 2 + Int.random(in: -2...2)),
                virtueValue: max(1, 50 - index * 3 + Int.random(in: -5...5)),
                blessCount: Int.random(in: 2...40)
            )
        }
    }
}
