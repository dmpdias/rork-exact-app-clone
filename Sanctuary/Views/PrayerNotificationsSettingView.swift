import SwiftUI

struct PrayerNotificationsSettingView: View {
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
                        toggleRow(icon: "hands.sparkles", iconColor: Theme.prayerIcon, title: "Prayer Notifications", isOn: $viewModel.prayerNotificationsEnabled)
                        Divider().padding(.leading, 70)
                        toggleRow(icon: "person.2.fill", iconColor: Theme.goldAccent, title: "Community Prayer Alerts", isOn: $viewModel.communityPrayerAlerts)
                        Divider().padding(.leading, 70)
                        toggleRow(icon: "checkmark.circle.fill", iconColor: Theme.reflectionIcon, title: "Prayer Answered Alerts", isOn: $viewModel.prayerAnsweredAlerts)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.sandLight.opacity(0.5))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    infoCard(text: "When enabled, you'll be notified when others pray for your requests, and when prayers in the community receive answers.")
                        .padding(.top, 20)
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

            Text("Prayer Notifications")
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
            Image(systemName: "lightbulb.fill")
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
}
