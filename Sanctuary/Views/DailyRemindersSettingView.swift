import SwiftUI

struct DailyRemindersSettingView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar(title: "Daily Reminders")

                    VStack(spacing: 2) {
                        toggleRow(
                            icon: "bell.fill",
                            iconColor: Theme.goldAccent,
                            title: "Enable Reminders",
                            isOn: $viewModel.dailyReminderEnabled
                        )

                        Divider().padding(.leading, 70)

                        if viewModel.dailyReminderEnabled {
                            HStack(spacing: 14) {
                                iconBox(icon: "clock.fill", color: Theme.goldDark)

                                DatePicker(
                                    "Reminder Time",
                                    selection: $viewModel.dailyReminderTime,
                                    displayedComponents: .hourAndMinute
                                )
                                .font(.system(.body, design: .serif))
                                .tint(Theme.goldDark)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Theme.sandLight.opacity(0.5))
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    infoCard(
                        text: "You'll receive a gentle reminder each day at your chosen time to begin your devotion."
                    )
                    .padding(.top, 20)
                }
            }
            .scrollIndicators(.hidden)
        }
    }

    private func headerBar(title: String) -> some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Theme.textMedium)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(title)
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
            iconBox(icon: icon, color: iconColor)

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

    private func iconBox(icon: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.opacity(0.12))
                .frame(width: 36, height: 36)

            Image(systemName: icon)
                .font(.system(size: 15))
                .foregroundStyle(color)
        }
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
