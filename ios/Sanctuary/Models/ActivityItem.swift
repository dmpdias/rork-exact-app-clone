import SwiftUI

nonisolated struct ActivityItem: Identifiable, Sendable {
    let id = UUID()
    let title: String
    let category: String
    let points: Int
    let iconName: String
    let iconColor: Color
    let bgColor: Color
    let categoryColor: Color
}
