import SwiftUI

struct ProfileView: View {
    @State private var viewModel = ProfileViewModel()
    @State private var haloBreathing: Bool = false
    @State private var showSignOutConfirm: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 99)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    profileHeader
                        .scrollReveal(delay: 0)

                    statsGrid
                        .padding(.top, 28)
                        .scrollReveal(delay: 0.08)

                    devotionRing
                        .padding(.top, 32)
                        .scrollReveal(delay: 0.16)

                    milestonesSection
                        .padding(.top, 36)
                        .scrollReveal(delay: 0.24)

                    settingsSection
                        .padding(.top, 36)
                        .scrollReveal(delay: 0.32)

                    signOutButton
                        .padding(.top, 32)
                        .padding(.bottom, 60)
                        .scrollReveal(delay: 0.40)
                }
            }
            .scrollIndicators(.hidden)
        }
        .confirmationDialog("Sign Out", isPresented: $showSignOutConfirm) {
            Button("Sign Out", role: .destructive) {}
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [Theme.divineGoldLight, Theme.divineGold, Theme.chainGold, Theme.divineGoldLight],
                            center: .center
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 108, height: 108)
                    .scaleEffect(haloBreathing ? 1.04 : 1.0)
                    .opacity(haloBreathing ? 1.0 : 0.7)
                    .shadow(color: Theme.divineGold.opacity(haloBreathing ? 0.5 : 0.2), radius: haloBreathing ? 12 : 6)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.cardBrown, Theme.cardOlive],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 96, height: 96)

                Text(viewModel.profileInitial)
                    .font(.system(size: 40, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.cream)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    haloBreathing = true
                }
            }

            VStack(spacing: 6) {
                Text(viewModel.userName)
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("Member since \(viewModel.memberSince)")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }

            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.divineGold)

                Text("\(viewModel.currentStreak)-day streak")
                    .font(.system(.subheadline, design: .serif))
                    .fontWeight(.medium)
                    .foregroundStyle(Theme.goldDark)

                Text("·")
                    .foregroundStyle(Theme.textLight)

                Text("Longest: \(viewModel.longestStreak) days")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Theme.sandLight.opacity(0.8))
                    .strokeBorder(Theme.goldAccent.opacity(0.3), lineWidth: 1)
            )
        }
        .padding(.top, 24)
        .padding(.horizontal, 20)
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(viewModel.stats) { stat in
                statCard(stat)
            }
        }
        .padding(.horizontal, 20)
    }

    private func statCard(_ stat: ProfileStat) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: stat.icon)
                    .font(.system(size: 14))
                    .foregroundStyle(Theme.goldAccent.opacity(0.6))
                    .padding(6)
            }

            Text(stat.value)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text(stat.label.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)

            Spacer().frame(height: 4)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.sandLight.opacity(0.7))
                .strokeBorder(Theme.sandDark.opacity(0.15), lineWidth: 1)
        )
    }

    private var devotionRing: some View {
        VStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.12), lineWidth: 6)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: Double(viewModel.devotionScore) / 100.0)
                    .stroke(
                        AngularGradient(
                            colors: [Theme.goldDark, Theme.goldAccent, Theme.divineGoldLight],
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270)
                        ),
                        style: StrokeStyle(lineWidth: 6, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))

                VStack(spacing: 2) {
                    Text("\(viewModel.devotionScore)")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text("DEVOTION")
                        .font(.system(size: 9, weight: .medium))
                        .tracking(2)
                        .foregroundStyle(Theme.textLight)
                }
            }

            Text("Your spirit burns bright, \(viewModel.userName).")
                .font(.system(.subheadline, design: .serif))
                .italic()
                .foregroundStyle(Theme.textMedium)
        }
        .padding(.horizontal, 20)
    }

    private var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionHeaderView(label: "MILESTONES", title: "Your sacred journey.")
                .padding(.horizontal, 20)

            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(viewModel.milestones) { milestone in
                        milestoneCard(milestone)
                    }
                }
            }
            .contentMargins(.horizontal, 20)
            .scrollIndicators(.hidden)
        }
    }

    private func milestoneCard(_ milestone: ProfileMilestone) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(Theme.sandDark.opacity(0.15), lineWidth: 3)
                    .frame(width: 56, height: 56)

                Circle()
                    .trim(from: 0, to: milestone.progress)
                    .stroke(
                        milestone.isUnlocked ? Theme.divineGold : Theme.goldAccent.opacity(0.5),
                        style: StrokeStyle(lineWidth: 3, lineCap: .round)
                    )
                    .frame(width: 56, height: 56)
                    .rotationEffect(.degrees(-90))

                Image(systemName: milestone.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(milestone.isUnlocked ? Theme.divineGold : Theme.textLight)
            }

            VStack(spacing: 4) {
                Text(milestone.title)
                    .font(.system(.caption, design: .serif))
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textDark)
                    .lineLimit(1)

                Text(milestone.isUnlocked ? "Unlocked" : "\(Int(milestone.progress * 100))%")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(milestone.isUnlocked ? Theme.goldDark : Theme.textLight)
            }
        }
        .frame(width: 100)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(milestone.isUnlocked ? Theme.sandLight : Theme.cream.opacity(0.6))
                .strokeBorder(
                    milestone.isUnlocked ? Theme.divineGold.opacity(0.3) : Theme.sandDark.opacity(0.1),
                    lineWidth: 1
                )
        )
    }

    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeaderView(label: "SETTINGS", title: "Your preferences.")
                .padding(.horizontal, 20)

            VStack(spacing: 2) {
                ForEach(viewModel.preferences) { pref in
                    Button(action: {}) {
                        HStack(spacing: 14) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(pref.iconColor.opacity(0.12))
                                    .frame(width: 36, height: 36)

                                Image(systemName: pref.icon)
                                    .font(.system(size: 15))
                                    .foregroundStyle(pref.iconColor)
                            }

                            Text(pref.title)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Theme.textDark)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(Theme.textLight)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)

                    if pref.id != viewModel.preferences.last?.id {
                        Divider()
                            .padding(.leading, 70)
                            .foregroundStyle(Theme.sandDark.opacity(0.15))
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.sandLight.opacity(0.5))
            )
            .padding(.horizontal, 20)
        }
    }

    private var signOutButton: some View {
        Button {
            showSignOutConfirm = true
        } label: {
            Text("Sign Out")
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(Theme.textMedium)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .strokeBorder(Theme.sandDark.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
