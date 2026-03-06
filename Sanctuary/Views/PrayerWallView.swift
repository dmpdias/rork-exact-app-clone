import SwiftUI

struct PrayerWallView: View {
    @State private var viewModel = PrayerWallViewModel()
    @State private var appeared: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 99)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 8)

                categoryFilter
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                prayerCarousel
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("PRAYER WALL")
                        .font(.system(size: 11, weight: .semibold, design: .serif))
                        .tracking(2)
                        .foregroundStyle(Theme.textLight)

                    Text("Lift someone up today.")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                }

                Spacer()

                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(Theme.goldAccent)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(Theme.goldAccent)
                    .frame(width: 7, height: 7)
                    .overlay(
                        Circle()
                            .fill(Theme.goldAccent.opacity(0.3))
                            .frame(width: 14, height: 14)
                            .scaleEffect(appeared ? 1.4 : 1.0)
                            .opacity(appeared ? 0 : 0.6)
                            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: false), value: appeared)
                    )

                Text("\(viewModel.prayers.reduce(0) { $0 + $1.prayerCount }) prayers shared today")
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.top, 4)
        }
        .padding(.horizontal, 20)
        .onAppear { appeared = true }
    }

    private var categoryFilter: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                FilterChip(
                    label: "All",
                    icon: "sparkles",
                    isSelected: viewModel.selectedCategory == nil
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        viewModel.selectedCategory = nil
                    }
                }

                ForEach(PrayerCategory.allCases, id: \.rawValue) { category in
                    FilterChip(
                        label: category.rawValue,
                        icon: category.icon,
                        isSelected: viewModel.selectedCategory == category
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            viewModel.selectedCategory = category
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 20)
        .scrollIndicators(.hidden)
    }

    private var prayerCarousel: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredPrayers) { prayer in
                    PrayerCardView(prayer: prayer) {
                        viewModel.togglePrayer(for: prayer)
                    }
                    .containerRelativeFrame(.vertical) { height, _ in
                        height * 0.78
                    }
                    .scrollTransition(.interactive) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.4)
                            .scaleEffect(phase.isIdentity ? 1 : 0.92)
                            .blur(radius: phase.isIdentity ? 0 : 2)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
    }
}

struct FilterChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11))

                Text(label)
                    .font(.system(size: 13, weight: .medium, design: .serif))
            }
            .foregroundStyle(isSelected ? .white : Theme.textMedium)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected
                          ? AnyShapeStyle(LinearGradient(colors: [Theme.cardBrown, Theme.cardOlive], startPoint: .leading, endPoint: .trailing))
                          : AnyShapeStyle(Theme.sandLight))
            )
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: isSelected)
    }
}
