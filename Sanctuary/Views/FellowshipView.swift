import SwiftUI

struct FellowshipView: View {
    @State private var viewModel = FellowshipViewModel()
    @State private var hasAppeared: Bool = false
    @Namespace private var filterNamespace

    var body: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.top, 4)
                .padding(.bottom, 10)

            filterBar
                .padding(.bottom, 12)

            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    if viewModel.topThree.count >= 3 {
                        podiumSection
                    }

                    leaderboardSection
                }
                .padding(.bottom, 100)
            }
            .scrollIndicators(.hidden)

            if let user = viewModel.currentUser, user.rank > 3 {
                userPositionBar(user: user)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                hasAppeared = true
            }
        }
        .sheet(isPresented: $viewModel.showCountryPicker) {
            countryPickerSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("Fellowship")
                .font(.system(size: 28, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("Rise together in devotion")
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
    }

    private var filterBar: some View {
        HStack(spacing: 8) {
            timePeriodMenu

            countryButton

            Spacer()

            virtueMenu
        }
        .padding(.horizontal, 20)
    }

    private var timePeriodMenu: some View {
        Menu {
            ForEach(FellowshipTimePeriod.allCases, id: \.self) { period in
                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.selectedTimePeriod = period
                    }
                } label: {
                    Label(period.rawValue, systemImage: period.icon)
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: viewModel.selectedTimePeriod.icon)
                    .font(.system(size: 11, weight: .semibold))
                Text(viewModel.selectedTimePeriod.rawValue)
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(Theme.textDark)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Theme.sandLight)
                    .shadow(color: Theme.sandDark.opacity(0.1), radius: 4, y: 2)
            )
        }
    }

    private var countryButton: some View {
        Button {
            viewModel.showCountryPicker = true
        } label: {
            HStack(spacing: 5) {
                if viewModel.selectedCountry == .all {
                    Image(systemName: "globe")
                        .font(.system(size: 12, weight: .semibold))
                } else {
                    Text(viewModel.selectedCountry.flag)
                        .font(.system(size: 14))
                }
                Text(viewModel.selectedCountry == .all ? "Global" : viewModel.selectedCountry.rawValue)
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(Theme.textDark)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(viewModel.selectedCountry != .all ? Theme.divineGoldLight.opacity(0.3) : Theme.sandLight)
                    .shadow(color: Theme.sandDark.opacity(0.1), radius: 4, y: 2)
            )
        }
    }

    private var virtueMenu: some View {
        Menu {
            ForEach(Virtue.allCases, id: \.self) { virtue in
                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.selectedVirtue = virtue
                    }
                } label: {
                    Label(virtue.rawValue, systemImage: virtue.icon)
                }
            }
        } label: {
            HStack(spacing: 5) {
                Image(systemName: viewModel.selectedVirtue.icon)
                    .font(.system(size: 11, weight: .semibold))
                Image(systemName: "chevron.down")
                    .font(.system(size: 9, weight: .bold))
            }
            .foregroundStyle(Theme.goldDark)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Theme.divineGoldLight.opacity(0.2))
            )
        }
    }

    private var podiumSection: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if viewModel.topThree.count >= 2 {
                podiumColumn(member: viewModel.topThree[1], place: 2, height: 90)
            }
            if viewModel.topThree.count >= 1 {
                podiumColumn(member: viewModel.topThree[0], place: 1, height: 120)
            }
            if viewModel.topThree.count >= 3 {
                podiumColumn(member: viewModel.topThree[2], place: 3, height: 70)
            }
        }
        .padding(.horizontal, 16)
        .opacity(hasAppeared ? 1 : 0)
        .offset(y: hasAppeared ? 0 : 20)
        .animation(.spring(duration: 0.6).delay(0.15), value: hasAppeared)
    }

    private func podiumColumn(member: FellowshipMember, place: Int, height: CGFloat) -> some View {
        VStack(spacing: 0) {
            podiumAvatar(member: member, place: place)
                .padding(.bottom, 6)

            Text(member.displayName)
                .font(.system(size: 13, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .lineLimit(1)

            Text("\(member.score(for: viewModel.selectedTimePeriod)) pts")
                .font(.system(size: 11, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)
                .padding(.bottom, 8)

            podiumBase(place: place, height: height)
        }
        .frame(maxWidth: .infinity)
    }

    private func podiumAvatar(member: FellowshipMember, place: Int) -> some View {
        ZStack {
            if place == 1 {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.divineGoldLight.opacity(0.5), Theme.divineGold.opacity(0)],
                            center: .center, startRadius: 22, endRadius: 42
                        )
                    )
                    .frame(width: 80, height: 80)
            }

            Circle()
                .fill(
                    LinearGradient(
                        colors: place == 1
                            ? [Theme.divineGold, Theme.goldDark]
                            : place == 2
                                ? [Color(red: 0.75, green: 0.75, blue: 0.78), Color(red: 0.60, green: 0.60, blue: 0.63)]
                                : [Color(red: 0.80, green: 0.65, blue: 0.50), Color(red: 0.65, green: 0.50, blue: 0.35)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    )
                )
                .frame(width: place == 1 ? 60 : 50, height: place == 1 ? 60 : 50)
                .overlay(
                    Text(String(member.displayName.prefix(1)))
                        .font(.system(size: place == 1 ? 22 : 18, weight: .bold, design: .serif))
                        .foregroundStyle(.white)
                )
                .overlay(alignment: .bottom) {
                    crownBadge(place: place)
                        .offset(y: 10)
                }
                .shadow(color: place == 1 ? Theme.divineGold.opacity(0.3) : Color.clear, radius: 8, y: 2)
        }
    }

    private func crownBadge(place: Int) -> some View {
        ZStack {
            Circle()
                .fill(
                    place == 1 ? Theme.divineGold
                    : place == 2 ? Color(red: 0.75, green: 0.75, blue: 0.78)
                    : Color(red: 0.80, green: 0.65, blue: 0.50)
                )
                .frame(width: 22, height: 22)

            Text("\(place)")
                .font(.system(size: 11, weight: .heavy, design: .rounded))
                .foregroundStyle(.white)
        }
    }

    private func podiumBase(place: Int, height: CGFloat) -> some View {
        UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10)
            .fill(
                LinearGradient(
                    colors: place == 1
                        ? [Theme.divineGoldLight.opacity(0.4), Theme.divineGoldLight.opacity(0.15)]
                        : place == 2
                            ? [Theme.sandLight, Theme.warmBeige.opacity(0.5)]
                            : [Theme.warmBeige.opacity(0.6), Theme.warmBeige.opacity(0.3)],
                    startPoint: .top, endPoint: .bottom
                )
            )
            .frame(height: height)
            .overlay(
                UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 10)
                    .stroke(
                        place == 1 ? Theme.divineGold.opacity(0.3) : Theme.sandDark.opacity(0.15),
                        lineWidth: 1
                    )
            )
    }

    private var leaderboardSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Leaderboard")
                    .font(.system(size: 13, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .textCase(.uppercase)
                    .tracking(1.2)

                Spacer()

                Text("\(viewModel.filteredAndRankedMembers.count) members")
                    .font(.system(size: 12, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 10)

            LazyVStack(spacing: 3) {
                ForEach(viewModel.restOfLeaderboard) { member in
                    LeaderboardRow(
                        member: member,
                        virtue: viewModel.selectedVirtue,
                        timePeriod: viewModel.selectedTimePeriod,
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
            .animation(.spring(duration: 0.5, bounce: 0.1), value: viewModel.selectedTimePeriod)
            .animation(.spring(duration: 0.5, bounce: 0.1), value: viewModel.selectedCountry)
        }
    }

    private func userPositionBar(user: FellowshipMember) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent, Theme.goldDark],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 36, height: 36)

                Text("Y")
                    .font(.system(size: 15, weight: .bold, design: .serif))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Your Ranking")
                    .font(.system(size: 11, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)

                Text("#\(user.rank) of \(viewModel.filteredAndRankedMembers.count)")
                    .font(.system(size: 16, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(user.score(for: viewModel.selectedTimePeriod))")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(Theme.goldDark)

                Text("points")
                    .font(.system(size: 10, weight: .medium, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }

            Image(systemName: "chevron.up")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(Theme.goldAccent)
                .padding(8)
                .background(
                    Circle()
                        .fill(Theme.divineGoldLight.opacity(0.2))
                )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .overlay(
                    Rectangle()
                        .fill(Theme.cream.opacity(0.7))
                )
                .shadow(color: Theme.sandDark.opacity(0.1), radius: 8, y: -4)
        )
    }

    private var countryPickerSheet: some View {
        VStack(spacing: 0) {
            Text("Select Region")
                .font(.system(size: 20, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .padding(.top, 20)
                .padding(.bottom, 16)

            LazyVStack(spacing: 2) {
                ForEach(FellowshipCountry.allCases, id: \.self) { country in
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            viewModel.selectedCountry = country
                        }
                        viewModel.showCountryPicker = false
                    } label: {
                        HStack(spacing: 12) {
                            if country == .all {
                                Image(systemName: "globe")
                                    .font(.system(size: 20))
                                    .frame(width: 30)
                            } else {
                                Text(country.flag)
                                    .font(.system(size: 22))
                                    .frame(width: 30)
                            }

                            Text(country.rawValue)
                                .font(.system(size: 16, weight: .medium, design: .serif))
                                .foregroundStyle(Theme.textDark)

                            Spacer()

                            if viewModel.selectedCountry == country {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(Theme.goldDark)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            viewModel.selectedCountry == country
                                ? Theme.divineGoldLight.opacity(0.15)
                                : Color.clear
                        )
                    }
                }
            }

            Spacer()
        }
    }
}

struct LeaderboardRow: View {
    let member: FellowshipMember
    let virtue: Virtue
    let timePeriod: FellowshipTimePeriod
    let isBlessed: Bool
    let isBlooming: Bool
    let onBless: () -> Void

    @State private var showBloom: Bool = false

    private let avatarColors: [Color] = [
        Color(red: 0.72, green: 0.62, blue: 0.52),
        Color(red: 0.62, green: 0.55, blue: 0.48),
        Color(red: 0.78, green: 0.68, blue: 0.58),
        Color(red: 0.68, green: 0.60, blue: 0.50),
        Color(red: 0.75, green: 0.65, blue: 0.55),
    ]

    var body: some View {
        HStack(spacing: 10) {
            rankBadge

            avatarView

            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(member.displayName)
                        .font(.system(size: 15, weight: member.isCurrentUser ? .bold : .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    if member.isCurrentUser {
                        Text("YOU")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundStyle(Theme.goldDark)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Theme.divineGoldLight.opacity(0.3))
                            )
                    }
                }

                HStack(spacing: 8) {
                    Text(member.whisper(for: virtue))
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)

                    if member.hasLongStreak {
                        HStack(spacing: 2) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 9))
                            Text("\(member.streakDays)d")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .foregroundStyle(Theme.goldAccent)
                    }
                }
            }

            Spacer(minLength: 4)

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(member.score(for: timePeriod))")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textDark)

                Text("pts")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundStyle(Theme.textLight)
            }

            Button {
                onBless()
            } label: {
                Image(systemName: isBlessed ? "sparkle" : "sparkles")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(isBlessed ? Theme.divineGold : Theme.goldAccent.opacity(0.5))
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(isBlessed ? Theme.divineGoldLight.opacity(0.15) : Color.clear)
                    )
                    .scaleEffect(isBlessed ? 1.1 : 1.0)
                    .animation(.spring(duration: 0.3), value: isBlessed)
            }
            .sensoryFeedback(.impact(weight: .light, intensity: 0.6), trigger: isBlessed)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    member.isCurrentUser
                        ? LinearGradient(
                            colors: [Theme.divineGoldLight.opacity(0.15), Theme.divineGoldLight.opacity(0.05)],
                            startPoint: .leading, endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [Theme.cream.opacity(0.5), Theme.cream.opacity(0.25)],
                            startPoint: .leading, endPoint: .trailing
                        )
                )
        )
        .overlay {
            if member.isCurrentUser {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.divineGold.opacity(0.2), lineWidth: 1)
            }
        }
        .clipShape(.rect(cornerRadius: 14))
        .overlay {
            if showBloom {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.divineGoldLight.opacity(0.3), Theme.divineGold.opacity(0.1), Color.clear],
                            center: .center, startRadius: 0, endRadius: 200
                        )
                    )
                    .scaleEffect(showBloom ? 2.5 : 0.3)
                    .opacity(showBloom ? 0 : 0.8)
                    .allowsHitTesting(false)
            }
        }
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

    private var rankBadge: some View {
        Text("#\(member.rank)")
            .font(.system(size: 13, weight: .bold, design: .rounded))
            .foregroundStyle(member.rank <= 10 ? Theme.goldDark : Theme.textLight)
            .frame(width: 32)
    }

    private var avatarView: some View {
        Circle()
            .fill(avatarColors[member.rank % avatarColors.count])
            .frame(width: 40, height: 40)
            .overlay(
                Circle()
                    .stroke(
                        member.hasLongStreak ? Theme.chainGold
                        : member.isActive ? Theme.divineGold.opacity(0.5)
                        : Color.clear,
                        style: member.hasLongStreak
                            ? StrokeStyle(lineWidth: 2, dash: [3, 2])
                            : StrokeStyle(lineWidth: 1.5)
                    )
            )
            .overlay(
                Text(String(member.displayName.prefix(1)))
                    .font(.system(size: 15, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.cream)
            )
    }
}
