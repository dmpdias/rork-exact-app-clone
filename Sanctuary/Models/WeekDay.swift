import Foundation

nonisolated struct WeekDay: Identifiable, Sendable {
    let id = UUID()
    let label: String
    let percentage: Double
    let isCurrent: Bool
    let isFuture: Bool

    var isCompleted: Bool { percentage >= 1.0 }
}
