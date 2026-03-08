import SwiftUI

struct AppearanceSettingView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    private let themes: [(name: String, bg: Color, accent: Color)] = [
        ("Warm Cream", Theme.cream, Theme.divineGold),
        ("Soft Parchment", Theme.sandLight, Theme.goldDark),
        ("Deep Sanctuary", Theme.deepCharcoal, Theme.divineGoldLight),
    ]

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar

                    themeSection
                        .padding(.top, 24)

                    feedbackSection
                        .padding(.top, 24)

                    Spacer().frame(height: 40)
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private var headerBar: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.textMedium)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("Appearance")
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.textDark)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("THEME")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)
                .padding(.horizontal, 20)

            VStack(spacing: 2) {
                ForEach(themes, id: \.name) { theme in
                    Button {
                        viewModel.selectedAppearance = theme.name
                    } label: {
                        HStack(spacing: 14) {
                            ZStack {
                                Circle()
                                    .fill(theme.bg)
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(theme.accent, lineWidth: 2)
                                    )

                                if theme.name == viewModel.selectedAppearance {
                                    Circle()
                                        .fill(theme.accent)
                                        .frame(width: 12, height: 12)
                                }
                            }

                            Text(theme.name)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Theme.textDark)

                            Spacer()

                            if theme.name == viewModel.selectedAppearance {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.divineGold)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain)

                    if theme.name != themes.last?.name {
                        Divider().padding(.leading, 70)
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

    private var feedbackSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("EXPERIENCE")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)
                .padding(.horizontal, 20)

            VStack(spacing: 2) {
                toggleRow(icon: "hand.tap.fill", iconColor: Theme.goldAccent, title: "Haptic Feedback", isOn: $viewModel.hapticFeedbackEnabled)
                Divider().padding(.leading, 70)
                toggleRow(icon: "sparkle", iconColor: Theme.particleGold, title: "Golden Dust Particles", isOn: $viewModel.particlesEnabled)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.sandLight.opacity(0.5))
            )
            .padding(.horizontal, 20)
        }
    }

    private func toggleRow(icon: String, iconColor: Color, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 36, height: 36)

                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(iconColor)
            }

            Text(title)
                .font(.system(.body, design: .serif))
                .foregroundStyle(Theme.textDark)

            Spacer()

            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(Theme.divineGold)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
