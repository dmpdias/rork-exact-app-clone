import SwiftUI
import UIKit

struct JourneyView: View {
    @State private var hasAppeared: Bool = false
    @State private var selectedCategory: JourneyCategory? = nil
    @State private var showDetail: Bool = false
    @State private var bloomCategory: JourneyCategory? = nil
    @State private var scrollOffset: CGFloat = 0
    @State private var showInsights: Bool = false
    @State private var isVerseBookmarked: Bool = false
    @State private var showShareSheet: Bool = false
    @State private var selectedBead: EmotionalBead? = nil
    @State private var showBeadPrayer: Bool = false
    @State private var selectedContinueItem: ContinuePathItem? = nil
    @State private var showContinueCourse: Bool = false
    @State private var dailyVerse: DailyVerse = DailyVerse.forToday()

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 77)
                .ignoresSafeArea()
                .opacity(0.35)
                .offset(y: scrollOffset * 0.05)

            if showBeadPrayer, let bead = selectedBead {
                EmotionalPrayerPlayerView(bead: bead) {
                    withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                        showBeadPrayer = false
                        selectedBead = nil
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 1.02)),
                    removal: .opacity.combined(with: .scale(scale: 0.98))
                ))
            } else if showContinueCourse, let pathItem = selectedContinueItem {
                CourseDetailView(item: pathItem.toJourneyContentItem(), category: pathItem.category) {
                    withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                        showContinueCourse = false
                        selectedContinueItem = nil
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .trailing)),
                    removal: .opacity.combined(with: .move(edge: .trailing))
                ))
            } else if showInsights {
                SavedInsightsView {
                    withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                        showInsights = false
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 1.02)),
                    removal: .opacity.combined(with: .scale(scale: 0.98))
                ))
            } else if showDetail, let category = selectedCategory {
                JourneyCategoryDetailView(category: category) {
                    withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                        showDetail = false
                        selectedCategory = nil
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 1.02)),
                    removal: .opacity.combined(with: .scale(scale: 0.98))
                ))
            } else {
                mainContent
                    .transition(.opacity)
            }

            if bloomCategory != nil {
                bloomOverlay
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                hasAppeared = true
            }
        }
    }

    private var mainContent: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                headerSection
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                verseOfTheDay
                    .padding(.horizontal, 20)
                    .padding(.bottom, 28)

                navigationGrid
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)

                emotionalPathways
                    .padding(.bottom, 32)

                recentlyExplored
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
            }
        }
        .scrollIndicators(.hidden)
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("Journey")
                .font(.system(size: 32, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("The path to inner radiance")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
    }

    private var verseOfTheDay: some View {
        VStack(alignment: .leading, spacing: 0) {
            Rectangle()
                .fill(Theme.goldAccent)
                .frame(height: 1)

            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 8) {
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                    Text("VERSE OF THE DAY")
                        .font(.system(size: 11, weight: .semibold, design: .serif))
                        .tracking(1.5)
                        .foregroundStyle(Theme.goldAccent)
                }
                .padding(.top, 16)

                Text("\"\(dailyVerse.text)\"")
                    .font(.system(size: 17, weight: .regular, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textDark.opacity(0.85))
                    .lineSpacing(5)

                HStack {
                    Text(dailyVerse.reference.uppercased())
                        .font(.system(size: 11, weight: .bold, design: .serif))
                        .tracking(1)
                        .foregroundStyle(Theme.goldAccent)

                    Spacer()

                    HStack(spacing: 14) {
                        Button {
                            withAnimation(.spring(duration: 0.3, bounce: 0.4)) {
                                isVerseBookmarked.toggle()
                            }
                        } label: {
                            Image(systemName: isVerseBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 16))
                                .foregroundStyle(isVerseBookmarked ? Theme.goldAccent : Theme.textLight)
                                .scaleEffect(isVerseBookmarked ? 1.15 : 1.0)
                        }
                        .sensoryFeedback(.impact(weight: .light), trigger: isVerseBookmarked)

                        Button {
                            shareVerse()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16))
                                .foregroundStyle(Theme.textLight)
                        }
                    }
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.cream)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Theme.sandDark.opacity(0.15), lineWidth: 1)
                    )
            )
            .padding(.top, -1)
        }
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 16)
    }

    private var navigationGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)], spacing: 16) {
            ForEach(JourneyCategory.allCases) { category in
                JourneyCategoryCard(category: category) {
                    if category == .savedInsights {
                        bloomCategory = category
                        withAnimation(.easeOut(duration: 0.35)) {}
                        Task {
                            try? await Task.sleep(for: .milliseconds(400))
                            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                                showInsights = true
                                bloomCategory = nil
                            }
                        }
                    } else {
                        bloomCategory = category
                        withAnimation(.easeOut(duration: 0.35)) {}
                        Task {
                            try? await Task.sleep(for: .milliseconds(400))
                            selectedCategory = category
                            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                                showDetail = true
                                bloomCategory = nil
                            }
                        }
                    }
                }
            }
        }
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 20)
    }

    private var emotionalPathways: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Pray for your heart")
                .font(.system(size: 20, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .padding(.horizontal, 20)

            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(Array(EmotionalBead.allCases.enumerated()), id: \.element.id) { index, bead in
                        EmotionalBeadView(bead: bead, isLast: index == EmotionalBead.allCases.count - 1) {
                            selectedBead = bead
                            withAnimation(.spring(duration: 0.5, bounce: 0.15)) {
                                showBeadPrayer = true
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
            .contentMargins(.horizontal, 20)
            .scrollIndicators(.hidden)
        }
        .opacity(hasAppeared ? 1 : 0)
    }

    private var recentlyExplored: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textLight)
                Text("CONTINUE YOUR PATH")
                    .font(.system(size: 11, weight: .semibold, design: .serif))
                    .tracking(1.2)
                    .foregroundStyle(Theme.textLight)
            }

            VStack(spacing: 10) {
                ForEach(ContinuePathItem.samples) { item in
                    JourneyListRow(item: item) {
                        selectedContinueItem = item
                        withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
                            showContinueCourse = true
                        }
                    }
                }
            }
        }
        .opacity(hasAppeared ? 1 : 0)
    }

    private var bloomOverlay: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.cream.opacity(0.95),
                        Theme.warmBeige.opacity(0.8),
                        Theme.cream.opacity(0.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 500
                )
            )
            .scaleEffect(bloomCategory != nil ? 3.0 : 0.1)
            .opacity(bloomCategory != nil ? 1 : 0)
            .animation(.easeOut(duration: 0.4), value: bloomCategory != nil)
            .allowsHitTesting(false)
            .ignoresSafeArea()
    }

    private func shareVerse() {
        let shareText = "\"\(dailyVerse.text)\"\n— \(dailyVerse.reference)\n\nShared from Amave"
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let root = scene.windows.first?.rootViewController {
            var presenter = root
            while let presented = presenter.presentedViewController {
                presenter = presented
            }
            activityVC.popoverPresentationController?.sourceView = presenter.view
            presenter.present(activityVC, animated: true)
        }
    }
}

struct JourneyCategoryCard: View {
    let category: JourneyCategory
    let onTap: () -> Void

    @State private var haloGlow: Bool = false

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(Theme.goldAccent.opacity(haloGlow ? 0.5 : 0.25), lineWidth: 1)
                        .frame(width: 60, height: 60)
                        .scaleEffect(haloGlow ? 1.08 : 1.0)

                    Circle()
                        .fill(Theme.textDark)
                        .frame(width: 52, height: 52)

                    Image(systemName: category.icon)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(Theme.cream)
                }

                VStack(spacing: 4) {
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text(category.subtitle)
                        .font(.system(size: 11, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 22)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Theme.sandLight, Theme.cream],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Theme.sandDark.opacity(0.12), lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 20))
        }
        .sensoryFeedback(.impact(weight: .light), trigger: false)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.8)
                .repeatForever(autoreverses: true)
            ) {
                haloGlow = true
            }
        }
    }
}

struct EmotionalBeadView: View {
    let bead: EmotionalBead
    let isLast: Bool
    let onTap: () -> Void

    @State private var isPulsing: Bool = false

    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 8) {
                Button(action: onTap) {
                    ZStack {
                        Circle()
                            .fill(Theme.goldAccent.opacity(0.12))
                            .frame(width: 56, height: 56)
                            .scaleEffect(isPulsing ? 1.08 : 1.0)

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.warmBeige, Theme.sandLight],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 20
                                )
                            )
                            .frame(width: 44, height: 44)

                        Image(systemName: bead.icon)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(Theme.goldAccent)
                    }
                }
                .sensoryFeedback(.impact(weight: .medium), trigger: isPulsing)

                Text(bead.rawValue)
                    .font(.system(size: 12, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textMedium)
            }

            if !isLast {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent.opacity(0.15), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0.15)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 32, height: 1)
                    .offset(y: -12)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true).delay(Double.random(in: 0...1))) {
                isPulsing = true
            }
        }
    }
}

struct JourneyListRow: View {
    let item: ContinuePathItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Theme.warmBeige.opacity(0.6))
                        .frame(width: 42, height: 42)
                    Image(systemName: item.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 15, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.textDark)
                    Text(item.subtitle)
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }

                Spacer(minLength: 4)

                ZStack {
                    Circle()
                        .stroke(Theme.sandDark.opacity(0.15), lineWidth: 3)
                        .frame(width: 32, height: 32)
                    Circle()
                        .trim(from: 0, to: item.progress)
                        .stroke(Theme.goldAccent, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(item.progress * 100))%")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(Theme.textMedium)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Theme.sandLight.opacity(0.6), Theme.cream.opacity(0.4)],
                            startPoint: .leading,
                            endPoint: .trailing
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
}
