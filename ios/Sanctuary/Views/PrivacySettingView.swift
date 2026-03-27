import SwiftUI

struct PrivacySettingView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar

                    VStack(spacing: 2) {
                        toggleRow(icon: "eye.fill", iconColor: Theme.textMedium, title: "Public Profile", isOn: $viewModel.profilePublic)
                        Divider().padding(.leading, 70)
                        toggleRow(icon: "flame.fill", iconColor: Theme.goldAccent, title: "Show Streak Publicly", isOn: $viewModel.showStreakPublicly)
                        Divider().padding(.leading, 70)
                        toggleRow(icon: "hands.sparkles", iconColor: Theme.prayerIcon, title: "Show Prayer Activity", isOn: $viewModel.showPrayerActivity)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.sandLight.opacity(0.5))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    infoCard(text: "When your profile is private, other community members can only see your first name initial in prayer rooms.")
                        .padding(.top, 20)

                    dangerZone
                        .padding(.top, 32)
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

            Text("Privacy")
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.textDark)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
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

    private func infoCard(text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 14))
                .foregroundStyle(Theme.goldAccent)

            Text(text)
                .font(.system(.caption, design: .serif))
                .italic()
                .foregroundStyle(Theme.textMedium)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Theme.sandLight.opacity(0.6))
                .strokeBorder(Theme.goldAccent.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    private var dangerZone: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("DATA")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)
                .padding(.horizontal, 20)

            VStack(spacing: 2) {
                actionRow(icon: "arrow.down.doc.fill", iconColor: Theme.readingIcon, title: "Export My Data")
                Divider().padding(.leading, 70)
                actionRow(icon: "trash.fill", iconColor: Color.red.opacity(0.7), title: "Delete Account", isDestructive: true)
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.sandLight.opacity(0.5))
            )
            .padding(.horizontal, 20)
        }
    }

    private func actionRow(icon: String, iconColor: Color, title: String, isDestructive: Bool = false) -> some View {
        Button {} label: {
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
                    .foregroundStyle(isDestructive ? Color.red.opacity(0.8) : Theme.textDark)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}
