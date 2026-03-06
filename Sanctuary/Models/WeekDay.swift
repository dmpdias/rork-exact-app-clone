import Foundation

nonisolated struct WeekDay: Identifiable, Sendable {
    let id = UUID()
    let label: String
    let isCompleted: Bool
    let isCurrent: Bool
}
