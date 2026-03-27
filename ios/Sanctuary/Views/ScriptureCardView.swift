import SwiftUI

struct ScriptureCardView: View {
    @State private var isBookmarked: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var showBookmarkConfirm: Bool = false

    private let verseText = "Peace I leave with you; my peace I give you. I do not give to you as the world gives. Do not let your hearts be troubled."
    private let verseRef = "JOHN 14:27"
    private let verseVersion = "New International Version"

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
                        Text(verseText)
                            .font(.system(size: 20, weight: .regular, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textDark.opacity(0.85))
                            .lineSpacing(5)

                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(verseRef)
                                    .font(.system(.caption, design: .serif))
                                    .fontWeight(.bold)
                                    .tracking(1)
                                    .foregroundStyle(Theme.goldAccent)

                                Text(verseVersion)
                                    .font(.system(.caption2, design: .serif))
                                    .foregroundStyle(Theme.textLight)
                            }

                            Spacer()

                            HStack(spacing: 16) {
                                Button {
                                    withAnimation(.spring(duration: 0.3, bounce: 0.3)) {
                                        isBookmarked.toggle()
                                    }
                                    showBookmarkConfirm = true
                                    Task {
                                        try? await Task.sleep(for: .seconds(2))
                                        withAnimation { showBookmarkConfirm = false }
                                    }
                                } label: {
                                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                        .font(.system(size: 18))
                                        .foregroundStyle(isBookmarked ? Theme.goldAccent : Theme.textLight)
                                        .symbolEffect(.bounce, value: isBookmarked)
                                }
                                .buttonStyle(.plain)
                                .sensoryFeedback(.impact(weight: .light), trigger: isBookmarked)

                                Button {
                                    showShareSheet = true
                                } label: {
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
            .overlay(alignment: .bottom) {
                if showBookmarkConfirm {
                    HStack(spacing: 6) {
                        Image(systemName: isBookmarked ? "checkmark.circle.fill" : "bookmark.slash")
                            .font(.system(size: 12))
                        Text(isBookmarked ? "Verse saved to your collection" : "Verse removed from collection")
                            .font(.system(size: 12, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(Theme.cream)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(Theme.textDark)
                    )
                    .offset(y: 20)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: ["\(verseText)\n\n— \(verseRef) (\(verseVersion))"])
                .presentationDetents([.medium])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
