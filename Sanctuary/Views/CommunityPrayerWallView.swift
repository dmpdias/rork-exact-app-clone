import SwiftUI

enum CommunitySection: String, CaseIterable {
    case wall = "Wall"
    case rooms = "Rooms"

    var icon: String {
        switch self {
        case .wall: return "rectangle.stack.fill"
        case .rooms: return "door.left.hand.open"
        }
    }
}

struct CommunityPrayerWallView: View {
    @State private var viewModel = CommunityViewModel()
    @State private var hasAppeared: Bool = false
    @State private var scrolledID: UUID?
    @State private var activeSection: CommunitySection = .wall

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 42)
                .ignoresSafeArea()
                .opacity(0.4)

            VStack(spacing: 0) {
                headerBar

                sectionToggle
                    .padding(.top, 2)
                    .padding(.bottom, 10)

                if activeSection == .wall {
                    wallContent
                } else {
                    PrayerRoomsView()
                }
            }
        }
        .onChange(of: viewModel.selectedCategory) { _, _ in
            scrolledID = viewModel.filteredPrayers.first?.id
        }
    }

    private var headerBar: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.textDark)
            }

            Spacer()

            Text("Community")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)

            Spacer()

            Color.clear
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var sectionToggle: some View {
        HStack(spacing: 0) {
            ForEach(CommunitySection.allCases, id: \.self) { section in
                Button {
                    withAnimation(.spring(duration: 0.35)) {
                        activeSection = section
                    }
                } label: {
                    VStack(spacing: 8) {
                        HStack(spacing: 6) {
                            Image(systemName: section.icon)
                                .font(.system(size: 14, weight: .medium))
                            Text(section.rawValue)
                                .font(.system(size: 14, weight: .medium, design: .serif))
                        }
                        .foregroundStyle(activeSection == section ? Theme.textDark : Theme.textLight)

                        Rectangle()
                            .fill(activeSection == section ? Theme.divineGold : Color.clear)
                            .frame(height: 2)
                            .frame(maxWidth: 60)
                    }
                }
                .frame(maxWidth: .infinity)
                .sensoryFeedback(.selection, trigger: activeSection == section)
            }
        }
        .padding(.horizontal, 32)
    }

    private var wallContent: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.top, 4)
                .padding(.bottom, 8)

            categoryFilterRow
                .padding(.bottom, 12)

            cardCarousel

            cardIndicator
                .padding(.top, 12)
                .padding(.bottom, 8)

            navigationHint
                .padding(.bottom, 16)
        }
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("Prayer Wall")
                .font(.system(size: 32, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("Lift each other up in faith")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
        }
    }

    private var categoryFilterRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(PrayerCategory.allCases, id: \.self) { category in
                    CategoryFilterItem(
                        category: category,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        withAnimation(.spring(duration: 0.3)) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 24)
        .scrollIndicators(.hidden)
    }

    private var cardCarousel: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 24) {
                ForEach(viewModel.filteredPrayers) { prayer in
                    PrayerCardView(
                        prayer: prayer,
                        timeAgo: viewModel.timeAgo(from: prayer.timestamp),
                        isPulsing: viewModel.prayingAnimationId == prayer.id,
                        isActive: scrolledID == prayer.id
                    ) {
                        withAnimation(.spring(duration: 0.35)) {
                            viewModel.togglePraying(for: prayer.id)
                        }
                    }
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.78
                    }
                    .scrollTransition(.interactive) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.35)
                            .scaleEffect(phase.isIdentity ? 1 : 0.90)
                            .blur(radius: phase.isIdentity ? 0 : 2)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrolledID)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 20)
        .sensoryFeedback(.selection, trigger: scrolledID)
        .onAppear {
            scrolledID = viewModel.filteredPrayers.first?.id
        }
    }

    private var currentIndex: Int {
        guard let scrolledID else { return 0 }
        return viewModel.filteredPrayers.firstIndex(where: { $0.id == scrolledID }) ?? 0
    }

    private var cardIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<viewModel.filteredPrayers.count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Theme.goldAccent : Theme.sandDark.opacity(0.3))
                    .frame(width: index == currentIndex ? 20 : 6, height: 6)
                    .animation(.spring(duration: 0.3), value: currentIndex)
            }
        }
    }

    private var navigationHint: some View {
        HStack(spacing: 4) {
            Image(systemName: "hand.draw")
                .font(.system(size: 11))
            Text("Swipe to read more prayers")
                .font(.system(size: 11, weight: .medium, design: .serif))
        }
        .foregroundStyle(Theme.textLight.opacity(0.7))
        .opacity(hasAppeared ? 1 : 0)
    }
}

struct CategoryFilterItem: View {
    let category: PrayerCategory
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Theme.textDark : Theme.warmBeige.opacity(0.6))
                        .frame(width: 48, height: 48)

                    Image(systemName: category.icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(isSelected ? Theme.cream : Theme.textMedium)
                }

                Text(category.rawValue)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .regular, design: .serif))
                    .foregroundStyle(isSelected ? Theme.textDark : Theme.textLight)
            }
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
