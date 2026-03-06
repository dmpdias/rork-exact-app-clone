import SwiftUI

struct SavedInsightsView: View {
    let onBack: () -> Void

    @State private var selectedTab: InsightTab = .verses
    @State private var hasAppeared: Bool = false
    @State private var savedVerses: [SavedVerse] = SavedVerse.samples
    @State private var journalEntries: [JournalEntry] = JournalEntry.samples
    @State private var prayerAnswers: [PrayerAnswer] = PrayerAnswer.samples
    @State private var showNewJournal: Bool = false
    @State private var newJournalTitle: String = ""
    @State private var newJournalBody: String = ""

    var body: some View {
        VStack(spacing: 0) {
            insightsHeader
            tabSelector
            tabContent
        }
        .background(Theme.cream.ignoresSafeArea())
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                hasAppeared = true
            }
        }
        .sheet(isPresented: $showNewJournal) {
            newJournalSheet
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var insightsHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Journey")
                            .font(.system(size: 14, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(Theme.goldAccent)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            ZStack {
                Circle()
                    .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                    .frame(width: 60, height: 60)
                Circle()
                    .fill(Theme.textDark)
                    .frame(width: 52, height: 52)
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.cream)
            }

            Text("Saved Insights")
                .font(.system(size: 26, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text("Your collected wisdom")
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Theme.goldAccent.opacity(0.0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.top, 8)
        }
        .padding(.bottom, 8)
    }

    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(InsightTab.allCases) { tab in
                Button {
                    withAnimation(.spring(duration: 0.35, bounce: 0.15)) {
                        selectedTab = tab
                    }
                } label: {
                    VStack(spacing: 8) {
                        HStack(spacing: 5) {
                            Image(systemName: tab.icon)
                                .font(.system(size: 11, weight: .medium))
                            Text(tab.rawValue)
                                .font(.system(size: 12, weight: .medium, design: .serif))
                        }
                        .foregroundStyle(selectedTab == tab ? Theme.goldAccent : Theme.textLight)

                        Rectangle()
                            .fill(selectedTab == tab ? Theme.goldAccent : Color.clear)
                            .frame(height: 1.5)
                    }
                }
                .frame(maxWidth: .infinity)
                .sensoryFeedback(.selection, trigger: selectedTab)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    private var tabContent: some View {
        ScrollView(.vertical) {
            switch selectedTab {
            case .verses:
                versesContent
            case .journal:
                journalContent
            case .prayerAnswers:
                prayerAnswersContent
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Saved Verses

    private var versesContent: some View {
        LazyVStack(spacing: 12) {
            ForEach(Array(savedVerses.enumerated()), id: \.element.id) { index, verse in
                SavedVerseCard(verse: verse)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.06), value: hasAppeared)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    // MARK: - Journal Entries

    private var journalContent: some View {
        LazyVStack(spacing: 12) {
            Button {
                showNewJournal = true
            } label: {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Theme.goldAccent.opacity(0.12))
                            .frame(width: 40, height: 40)
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.goldAccent)
                    }
                    Text("New Journal Entry")
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.goldAccent)
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Theme.goldAccent.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))
                )
                .clipShape(.rect(cornerRadius: 14))
            }

            ForEach(Array(journalEntries.enumerated()), id: \.element.id) { index, entry in
                JournalEntryCard(entry: entry)
                    .opacity(hasAppeared ? 1 : 0)
                    .offset(y: hasAppeared ? 0 : 12)
                    .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.06), value: hasAppeared)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    // MARK: - Prayer Answers

    private var prayerAnswersContent: some View {
        LazyVStack(spacing: 16) {
            ForEach(groupedPrayerAnswers, id: \.prayer) { group in
                PrayerAnswerGroup(prayer: group.prayer, answers: group.answers)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 40)
    }

    private var groupedPrayerAnswers: [(prayer: String, answers: [PrayerAnswer])] {
        let grouped = Dictionary(grouping: prayerAnswers, by: { $0.prayerText })
        return grouped.map { (prayer: $0.key, answers: $0.value) }
            .sorted { $0.answers.first?.date ?? .distantPast > $1.answers.first?.date ?? .distantPast }
    }

    // MARK: - New Journal Sheet

    private var newJournalSheet: some View {
        NavigationStack {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .tracking(0.5)
                    TextField("What's on your heart?", text: $newJournalTitle)
                        .font(.system(size: 17, design: .serif))
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.sandLight.opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.sandDark.opacity(0.12), lineWidth: 1)
                        )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Reflection")
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .tracking(0.5)
                    TextEditor(text: $newJournalBody)
                        .font(.system(size: 16, design: .serif))
                        .frame(minHeight: 160)
                        .scrollContentBackground(.hidden)
                        .padding(12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.sandLight.opacity(0.5))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Theme.sandDark.opacity(0.12), lineWidth: 1)
                        )
                }

                Spacer()
            }
            .padding(20)
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showNewJournal = false
                        newJournalTitle = ""
                        newJournalBody = ""
                    }
                    .foregroundStyle(Theme.textLight)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard !newJournalTitle.isEmpty else { return }
                        let entry = JournalEntry(
                            id: UUID(),
                            title: newJournalTitle,
                            body: newJournalBody,
                            mood: "sparkles",
                            date: Date()
                        )
                        withAnimation {
                            journalEntries.insert(entry, at: 0)
                        }
                        showNewJournal = false
                        newJournalTitle = ""
                        newJournalBody = ""
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(newJournalTitle.isEmpty ? Theme.textLight : Theme.goldAccent)
                    .disabled(newJournalTitle.isEmpty)
                }
            }
        }
    }
}

// MARK: - Insight Tab

nonisolated enum InsightTab: String, CaseIterable, Identifiable, Sendable {
    case verses = "Verses"
    case journal = "Journal"
    case prayerAnswers = "Responses"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .verses: return "bookmark.fill"
        case .journal: return "note.text"
        case .prayerAnswers: return "bubble.left.and.text.bubble.right.fill"
        }
    }
}

// MARK: - Saved Verse Card

struct SavedVerseCard: View {
    let verse: SavedVerse

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(verse.text)
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
                .foregroundStyle(Theme.textDark.opacity(0.85))
                .lineSpacing(5)

            HStack {
                Text(verse.reference.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .serif))
                    .tracking(1)
                    .foregroundStyle(Theme.goldAccent)

                Spacer()

                Text(verse.dateSaved, style: .date)
                    .font(.system(size: 11, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Theme.sandLight.opacity(0.6), Theme.cream.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.sandDark.opacity(0.1), lineWidth: 1)
        )
        .overlay(alignment: .topLeading) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 10))
                .foregroundStyle(Theme.goldAccent.opacity(0.5))
                .padding(12)
        }
        .clipShape(.rect(cornerRadius: 16))
    }
}

// MARK: - Journal Entry Card

struct JournalEntryCard: View {
    let entry: JournalEntry

    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Theme.warmBeige.opacity(0.6))
                        .frame(width: 36, height: 36)
                    Image(systemName: entry.mood)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.title)
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textDark)
                    Text(entry.date, style: .relative)
                        .font(.system(size: 11, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }

                Spacer()

                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textLight)
                }
            }

            if isExpanded {
                Text(entry.body)
                    .font(.system(size: 14, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(5)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Theme.sandLight.opacity(0.5), Theme.cream.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 14))
    }
}

// MARK: - Prayer Answer Group

struct PrayerAnswerGroup: View {
    let prayer: String
    let answers: [PrayerAnswer]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Theme.warmBeige.opacity(0.6))
                        .frame(width: 32, height: 32)
                    Image(systemName: "hands.sparkles.fill")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                }

                Text(prayer)
                    .font(.system(size: 14, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .lineLimit(2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            Rectangle()
                .fill(Theme.goldAccent.opacity(0.15))
                .frame(height: 1)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                ForEach(Array(answers.enumerated()), id: \.element.id) { index, answer in
                    PrayerAnswerRow(answer: answer)

                    if index < answers.count - 1 {
                        Rectangle()
                            .fill(Theme.sandDark.opacity(0.06))
                            .frame(height: 1)
                            .padding(.leading, 54)
                            .padding(.trailing, 16)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Theme.sandLight.opacity(0.5), Theme.cream.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 16))
    }
}

struct PrayerAnswerRow: View {
    let answer: PrayerAnswer

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Theme.textDark)
                    .frame(width: 34, height: 34)
                Text(answer.commenterInitials)
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.cream)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(answer.commenterName)
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                    Spacer()
                    Text(answer.date, style: .relative)
                        .font(.system(size: 10, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }

                Text(answer.comment)
                    .font(.system(size: 13, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(3)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
