import SwiftUI

struct FellowshipView: View {
    @State private var viewModel = FellowshipViewModel()
    @State private var hasAppeared: Bool = false
    @Namespace private var virtueNamespace

    var body: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.top, 4)
                .padding(.bottom, 6)

            virtuePillMenu
                .padding(.bottom, 0)

            goldenThread
                .padding(.bottom, 0)

            memberList
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                hasAppeared = true
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("Fellowship")
                .font(.system(size: 32, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("Inspire and be inspired together")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
    }

    private var virtuePillMenu: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Virtue.allCases, id: \.self) { virtue in
                    Button {
                        withAnimation(.spring(duration: 0.4, bounce: 0.15)) {
                            viewModel.selectedVirtue = virtue
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: virtue.icon)
                                .font(.system(size: 13, weight: .medium))
                            Text(virtue.rawValue)
                                .font(.system(size: 13, weight: .medium, design: .serif))
                        }
                        .foregroundStyle(viewModel.selectedVirtue == virtue ? Theme.cream : Theme.textMedium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background {
                            if viewModel.selectedVirtue == virtue {
                                Capsule()
                                    .fill(Theme.textDark)
                                    .matchedGeometryEffect(id: "virtuePill", in: virtueNamespace)
                            } else {
                                Capsule()
                                    .fill(Theme.warmBeige.opacity(0.5))
                            }
                        }
                    }
                    .sensoryFeedback(.selection, trigger: viewModel.selectedVirtue)
                }
            }
        }
        .contentMargins(.horizontal, 24)
        .scrollIndicators(.hidden)
    }

    private var goldenThread: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Theme.goldAccent.opacity(0.6), Theme.goldAccent.opacity(0.15)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 1, height: 28)
            .opacity(hasAppeared ? 1 : 0)
    }

    private var memberList: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 4) {
                ForEach(viewModel.sortedMembers) { member in
                    FellowshipMemberRow(
                        member: member,
                        virtue: viewModel.selectedVirtue,
                        isBlessed: viewModel.blessedIds.contains(member.id),
                        isBlooming: viewModel.bloomingId == member.id
                    ) {
                        viewModel.bless(member)
                    }
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .bottom)),
                        removal: .opacity
                    ))
                }
            }
            .padding(.horizontal, 16)
            .animation(.spring(duration: 0.5, bounce: 0.1), value: viewModel.selectedVirtue)
        }
        .scrollIndicators(.hidden)
    }
}

struct FellowshipMemberRow: View {
    let member: FellowshipMember
    let virtue: Virtue
    let isBlessed: Bool
    let isBlooming: Bool
    let onBless: () -> Void

    @State private var haloBreathing: Bool = false
    @State private var showBloom: Bool = false

    private let avatarColors: [Color] = [
        Color(red: 0.72, green: 0.62, blue: 0.52),
        Color(red: 0.62, green: 0.55, blue: 0.48),
        Color(red: 0.78, green: 0.68, blue: 0.58),
        Color(red: 0.68, green: 0.60, blue: 0.50),
        Color(red: 0.75, green: 0.65, blue: 0.55),
    ]

    var body: some View {
        HStack(spacing: 14) {
            avatarView
            centerContent
            Spacer(minLength: 4)
            blessButton
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    member.isTopTen
                        ? LinearGradient(
                            colors: [Theme.sandLight, Theme.cream],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [Theme.cream.opacity(0.6), Theme.cream.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                )
        )
        .overlay {
            if showBloom {
                bloomEffect
            }
        }
        .clipShape(.rect(cornerRadius: 16))
        .onChange(of: isBlooming) { _, newValue in
            if newValue {
                withAnimation(.easeOut(duration: 0.6)) {
                    showBloom = true
                }
                Task {
                    try? await Task.sleep(for: .milliseconds(700))
                    withAnimation(.easeIn(duration: 0.3)) {
                        showBloom = false
                    }
                }
            }
        }
    }

    private var avatarView: some View {
        ZStack {
            if member.isTopTen {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                Theme.divineGoldLight.opacity(member.isTopOne ? 0.5 : 0.25),
                                Theme.divineGold.opacity(0.0)
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: member.isTopOne ? 36 : 32
                        )
                    )
                    .frame(width: member.isTopOne ? 72 : 64, height: member.isTopOne ? 72 : 64)
                    .scaleEffect(member.isTopOne && haloBreathing ? 1.12 : 1.0)
                    .opacity(member.isTopOne && haloBreathing ? 0.7 : 1.0)
            }

            Circle()
                .fill(avatarColors[member.rank % avatarColors.count])
                .frame(width: 48, height: 48)
                .overlay(
                    Circle()
                        .stroke(
                            member.hasLongStreak
                                ? Theme.chainGold
                                : (member.isActive ? Theme.divineGold : Color.clear),
                            style: member.hasLongStreak
                                ? StrokeStyle(lineWidth: 2.5, dash: [4, 3])
                                : StrokeStyle(lineWidth: 2)
                        )
                        .scaleEffect(member.isActive && haloBreathing ? 1.08 : 1.0)
                )
                .overlay(
                    Text(String(member.displayName.prefix(1)))
                        .font(.system(size: 18, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.cream)
                )
        }
        .frame(width: 56, height: 56)
        .onAppear {
            if member.isTopOne || member.isActive {
                withAnimation(
                    .easeInOut(duration: 2.2)
                    .repeatForever(autoreverses: true)
                ) {
                    haloBreathing = true
                }
            }
        }
    }

    private var centerContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(member.displayName)
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text(member.whisper(for: virtue))
                .font(.system(size: 13, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
        }
    }

    private var blessButton: some View {
        Button {
            onBless()
        } label: {
            Image(systemName: isBlessed ? "sparkle" : "sparkles")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isBlessed ? Theme.divineGold : Theme.goldAccent.opacity(0.6))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isBlessed ? Theme.divineGoldLight.opacity(0.15) : Color.clear)
                )
                .scaleEffect(isBlessed ? 1.1 : 1.0)
                .animation(.spring(duration: 0.3), value: isBlessed)
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.6), trigger: isBlessed)
    }

    private var bloomEffect: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.divineGoldLight.opacity(0.3),
                        Theme.divineGold.opacity(0.1),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 200
                )
            )
            .scaleEffect(showBloom ? 2.5 : 0.3)
            .opacity(showBloom ? 0 : 0.8)
            .allowsHitTesting(false)
    }
}
