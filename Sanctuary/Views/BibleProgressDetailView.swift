import SwiftUI

struct BibleProgressDetailView: View {
    @Environment(\.dismiss) private var dismiss

    private let books: [(name: String, progress: Double)] = [
        ("Genesis", 1.0), ("Exodus", 1.0), ("Leviticus", 1.0), ("Numbers", 1.0),
        ("Deuteronomy", 1.0), ("Joshua", 1.0), ("Judges", 1.0), ("Ruth", 1.0),
        ("1 Samuel", 1.0), ("2 Samuel", 1.0), ("1 Kings", 1.0), ("2 Kings", 1.0),
        ("1 Chronicles", 0.85), ("2 Chronicles", 0.6), ("Ezra", 0.4),
        ("Nehemiah", 0.2), ("Esther", 0.0), ("Job", 0.0),
        ("Psalms", 0.78), ("Proverbs", 0.65), ("Ecclesiastes", 0.3),
        ("Song of Solomon", 0.0), ("Isaiah", 0.45), ("Jeremiah", 0.1),
    ]

    var body: some View {
        VStack(spacing: 0) {
            header
            ScrollView {
                VStack(spacing: 24) {
                    overallProgress
                    booksGrid
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background(Theme.cream.ignoresSafeArea())
    }

    private var header: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 32, height: 32)
                        .background(Theme.sandLight.opacity(0.8))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.15), lineWidth: 6)
                    .frame(width: 80, height: 80)

                Circle()
                    .trim(from: 0, to: 0.78)
                    .stroke(Theme.goldAccent, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))

                Text("78%")
                    .font(.system(size: 22, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }

            Text("Bible Reading Progress")
                .font(.system(size: 22, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text("You've read through 78% of your plan")
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(LinearGradient(colors: [Theme.goldAccent.opacity(0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0)], startPoint: .leading, endPoint: .trailing))
                .frame(height: 1)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 12)
    }

    private var overallProgress: some View {
        HStack(spacing: 16) {
            statPill(value: "285", label: "Chapters Read")
            statPill(value: "46", label: "Books Started")
            statPill(value: "15", label: "Completed")
        }
    }

    private func statPill(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
            Text(label)
                .font(.system(size: 10, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)
                .tracking(0.3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.sandLight.opacity(0.5))
        )
    }

    private var booksGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("BOOKS")
                .font(.system(size: 11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.sectionHeader)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(Array(books.enumerated()), id: \.offset) { _, book in
                    bookRow(name: book.name, progress: book.progress)
                }
            }
        }
    }

    private func bookRow(name: String, progress: Double) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.12), lineWidth: 2.5)
                    .frame(width: 28, height: 28)

                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(progress >= 1.0 ? Theme.goldAccent : Theme.cardBrown.opacity(0.6), style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                    .frame(width: 28, height: 28)
                    .rotationEffect(.degrees(-90))

                if progress >= 1.0 {
                    Image(systemName: "checkmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Theme.goldAccent)
                }
            }

            Text(name)
                .font(.system(size: 13, weight: .medium, design: .serif))
                .foregroundStyle(progress >= 1.0 ? Theme.textDark : Theme.textMedium)
                .lineLimit(1)

            Spacer()
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(progress >= 1.0 ? Theme.goldAccent.opacity(0.06) : Color.clear)
        )
    }
}
