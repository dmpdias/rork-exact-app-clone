import SwiftUI

@Observable
class FellowshipViewModel {
    var selectedVirtue: Virtue = .faithfulness
    var selectedCountry: FellowshipCountry = .all
    var selectedTimePeriod: FellowshipTimePeriod = .thisMonth
    var members: [FellowshipMember] = FellowshipViewModel.generateMembers()
    var blessedIds: Set<UUID> = []
    var bloomingId: UUID?
    var showCountryPicker: Bool = false

    var filteredAndRankedMembers: [FellowshipMember] {
        var filtered = members
        if selectedCountry != .all {
            filtered = filtered.filter { $0.country == selectedCountry }
        }
        let sorted = filtered.sorted { $0.score(for: selectedTimePeriod) > $1.score(for: selectedTimePeriod) }
        return sorted.enumerated().map { index, member in
            var m = member
            m.rank = index + 1
            return m
        }
    }

    var topThree: [FellowshipMember] {
        Array(filteredAndRankedMembers.prefix(3))
    }

    var restOfLeaderboard: [FellowshipMember] {
        Array(filteredAndRankedMembers.dropFirst(3))
    }

    var currentUser: FellowshipMember? {
        filteredAndRankedMembers.first { $0.isCurrentUser }
    }

    var currentUserIsVisible: Bool {
        guard let user = currentUser else { return false }
        return user.rank <= 3 + restOfLeaderboard.count
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
        let data: [(String, FellowshipCountry)] = [
            ("Grace M.", .unitedStates),
            ("Elijah T.", .nigeria),
            ("Hannah R.", .unitedKingdom),
            ("Samuel K.", .southKorea),
            ("Miriam J.", .brazil),
            ("Caleb D.", .unitedStates),
            ("Abigail N.", .philippines),
            ("Isaiah W.", .kenya),
            ("Naomi L.", .canada),
            ("Daniel P.", .unitedStates),
            ("Ruth S.", .nigeria),
            ("Joseph A.", .unitedKingdom),
            ("Esther C.", .brazil),
            ("David H.", .unitedStates),
            ("Lydia F.", .philippines),
            ("Aaron B.", .kenya),
            ("Sarah V.", .canada),
            ("Noah G.", .southKorea),
            ("Rebecca E.", .unitedStates),
            ("Moses Q.", .nigeria)
        ]

        var result = data.enumerated().map { index, item in
            let baseScore = max(10, 500 - index * 25 + Int.random(in: -15...15))
            return FellowshipMember(
                id: UUID(),
                displayName: item.0,
                rank: index + 1,
                isActive: index < 5 || index % 3 == 0,
                streakDays: max(1, 30 - index * 2 + Int.random(in: -2...2)),
                virtueValue: max(1, 50 - index * 3 + Int.random(in: -5...5)),
                blessCount: Int.random(in: 2...40),
                country: item.1,
                weeklyScore: max(5, baseScore / 4 + Int.random(in: -10...10)),
                monthlyScore: baseScore,
                allTimeScore: baseScore * 6 + Int.random(in: 0...200),
                isCurrentUser: index == 7
            )
        }

        result[7] = FellowshipMember(
            id: result[7].id,
            displayName: "You",
            rank: 8,
            isActive: true,
            streakDays: 14,
            virtueValue: 28,
            blessCount: 12,
            country: .unitedStates,
            weeklyScore: 95,
            monthlyScore: 340,
            allTimeScore: 1850,
            isCurrentUser: true
        )

        return result
    }
}
