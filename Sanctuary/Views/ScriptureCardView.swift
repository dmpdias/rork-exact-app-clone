import SwiftUI

struct ScriptureCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeaderView(label: "SCRIPTURE", title: "A word for today.")
                .padding(.bottom, 12)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Theme.scriptureCardBg)

                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.scriptureAccent.opacity(0.5))
                        .frame(width: 3)
                        .padding(.vertical, 20)

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled.")
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textDark.opacity(0.85))
                            .lineSpacing(5)

                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("JOHN 14:27")
                                    .font(.system(.caption, design: .serif))
                                    .fontWeight(.bold)
                                    .tracking(1)
                                    .foregroundStyle(Theme.goldAccent)

                                Text("New International Version")
                                    .font(.system(.caption2, design: .serif))
                                    .foregroundStyle(Theme.textLight)
                            }

                            Spacer()

                            HStack(spacing: 16) {
                                Button(action: {}) {
                                    Image(systemName: "bookmark")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Theme.textLight)
                                }
                                .buttonStyle(.plain)

                                Button(action: {}) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 18))
                                        .foregroundStyle(Theme.textLight)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding(20)
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
