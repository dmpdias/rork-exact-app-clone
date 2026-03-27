import SwiftUI

struct SectionHeaderView: View {
    let label: String
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.sectionHeader)

            Text(title)
                .font(.system(.title2, design: .serif))
                .foregroundStyle(Theme.textDark)
        }
    }
}
