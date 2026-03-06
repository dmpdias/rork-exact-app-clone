import SwiftUI

struct PrayerWallView: View {
    @State private var viewModel = PrayerWallViewModel()
    @State private var showPrayers: Bool = false
    @State private var hasAppeared: Bool = false
    @State private var scrollDownPulse: Bool = false
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 99)
                .ignoresSafeArea()
                .opacity(0.3)

            if showPrayers {
                prayerContent
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                openingState
                    .transition(.opacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                scrollDownPulse = true
            }
        }
    }

    private var openingState: some View {
        VStack(spacing: 0) {
            headerBar

            Spacer()

            VStack(spacing: 12) {
                Text("Lift Someone Up")
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("Scroll to Explore Prayers")
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 12)

            Spacer()

            VStack(spacing: 16) {
                softGlow

                Button {
                    withAnimation(.spring(duration: 0.45)) {
                        showPrayers = true
                    }
                } label: {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Theme.sandLight)
                                .shadow(color: Theme.sandDark.opacity(0.15), radius: 8, y: 2)
                        )
                }
                .scaleEffect(scrollDownPulse ? 1.05 : 1.0)
                .opacity(scrollDownPulse ? 1 : 0.7)
            }
            .padding(.bottom, 24)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height < -60 {
                        withAnimation(.spring(duration: 0.45)) {
                            showPrayers = true
                        }
                    }
                    dragOffset = 0
                }
        )
    }

    private var headerBar: some View {
        HStack {
            Button {} label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.textDark)
            }

            Spacer()

            Text("Prayer Wall")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)

            Spacer()

            Image("BandIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 37)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var softGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.warmBeige.opacity(0.6),
                        Theme.cream.opacity(0.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 100
                )
            )
            .frame(width: 200, height: 200)
            .blur(radius: 30)
    }

    private var prayerContent: some View {
        VStack(spacing: 0) {
            prayerHeader

            categoryFilter
                .padding(.top, 8)
                .padding(.bottom, 4)

            prayerCarousel
        }
    }

    private var prayerHeader: some View {
        HStack {
            Button {
                withAnimation(.spring(duration: 0.4)) {
                    showPrayers = false
                }
            } label: {
                Image(systemName: "chevron.up")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textMedium)
                    .frame(width: 36, height: 36)
                    .background(Theme.sandLight)
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Prayer Wall")
                    .font(.system(size: 15, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textDark)

                HStack(spacing: 5) {
                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 6, height: 6)

                    Text("\(viewModel.prayers.reduce(0) { $0 + $1.prayerCount }) prayers")
                        .font(.system(size: 12, design: .serif))
                        .foregroundStyle(Theme.textLight)
                }
            }

            Spacer()

            Button {} label: {
                Image(systemName: "plus")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textMedium)
                    .frame(width: 36, height: 36)
                    .background(Theme.sandLight)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
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
                        height * 0.75
                    }
                    .scrollTransition(.interactive) { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1 : 0.3)
                            .scaleEffect(phase.isIdentity ? 1 : 0.93)
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
