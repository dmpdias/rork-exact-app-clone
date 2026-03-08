import SwiftUI

struct ReadingPlanSettingView: View {
    @Bindable var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss

    private let plans: [String] = ["Through the Gospels", "Psalms & Proverbs", "Whole Bible in a Year", "New Testament", "Letters of Paul"]

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar

                    currentPlanCard
                        .padding(.top, 24)

                    paceSection
                        .padding(.top, 24)

                    planPicker
                        .padding(.top, 24)
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

            Text("Reading Plan")
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.textDark)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var currentPlanCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("CURRENT PLAN")
                        .font(.system(size: 10, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)

                    Text(viewModel.readingPlanName)
                        .font(.system(.title3, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                }
                Spacer()
                Image(systemName: "book.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Theme.readingIcon)
            }

            VStack(spacing: 8) {
                HStack {
                    Text("Progress")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Theme.textLight)
                    Spacer()
                    Text("\(Int(viewModel.readingPlanProgress * 100))%")
                        .font(.system(.caption, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Theme.sandDark.opacity(0.12))
                            .frame(height: 6)

                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(colors: [Theme.readingIcon, Theme.readingTeal], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * viewModel.readingPlanProgress, height: 6)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.sandLight.opacity(0.6))
                .strokeBorder(Theme.sandDark.opacity(0.12), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    private var paceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("DAILY PACE")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)
                .padding(.horizontal, 20)

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.readingIcon.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: "text.page.fill")
                        .font(.system(size: 15))
                        .foregroundStyle(Theme.readingIcon)
                }

                Text("Chapters per day")
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Spacer()

                Stepper("", value: $viewModel.chaptersPerDay, in: 1...10)
                    .labelsHidden()

                Text("\(viewModel.chaptersPerDay)")
                    .font(.system(.body, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.goldDark)
                    .frame(width: 24)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.sandLight.opacity(0.5))
            )
            .padding(.horizontal, 20)
        }
    }

    private var planPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AVAILABLE PLANS")
                .font(.system(size: 10, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(Theme.textLight)
                .padding(.horizontal, 20)

            VStack(spacing: 2) {
                ForEach(plans, id: \.self) { plan in
                    Button {
                        viewModel.readingPlanName = plan
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: plan == viewModel.readingPlanName ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundStyle(plan == viewModel.readingPlanName ? Theme.divineGold : Theme.sandDark.opacity(0.4))

                            Text(plan)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Theme.textDark)

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain)

                    if plan != plans.last {
                        Divider().padding(.leading, 54)
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
}
