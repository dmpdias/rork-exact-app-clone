import SwiftUI

struct NewPrayerRequestSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var prayerText: String = ""
    @State private var selectedCategory: PrayerCategory = .faith
    @State private var isAnonymous: Bool = false
    @State private var submitted: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.cream
                    .ignoresSafeArea()

                if submitted {
                    submittedView
                } else {
                    formContent
                }
            }
            .navigationTitle("Submit a Prayer")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.system(size: 15, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                }
                if !submitted {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Submit") { submitPrayer() }
                            .font(.system(size: 15, weight: .semibold, design: .serif))
                            .foregroundStyle(prayerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Theme.textLight : Theme.goldDark)
                            .disabled(prayerText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
    }

    private var formContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your Prayer")
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .textCase(.uppercase)
                        .tracking(1)

                    TextEditor(text: $prayerText)
                        .font(.system(size: 16, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 120)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Theme.sandLight)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14)
                                        .stroke(Theme.goldAccent.opacity(0.2), lineWidth: 0.5)
                                )
                        )

                    Text("\(prayerText.count)/300")
                        .font(.system(size: 11, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Category")
                        .font(.system(size: 13, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .textCase(.uppercase)
                        .tracking(1)

                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(PrayerCategory.allCases.filter { $0 != .all }, id: \.self) { category in
                                Button {
                                    selectedCategory = category
                                } label: {
                                    HStack(spacing: 6) {
                                        Image(systemName: category.icon)
                                            .font(.system(size: 12))
                                        Text(category.rawValue)
                                            .font(.system(size: 13, weight: .medium, design: .serif))
                                    }
                                    .foregroundStyle(selectedCategory == category ? .white : Theme.textDark)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 9)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategory == category ? Theme.goldDark : Theme.sandLight)
                                    )
                                }
                            }
                        }
                    }
                    .contentMargins(.horizontal, 0)
                    .scrollIndicators(.hidden)
                }

                Toggle(isOn: $isAnonymous) {
                    HStack(spacing: 10) {
                        Image(systemName: "eye.slash")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.textMedium)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Post Anonymously")
                                .font(.system(size: 15, weight: .medium, design: .serif))
                                .foregroundStyle(Theme.textDark)
                            Text("Your name will be hidden from the prayer wall")
                                .font(.system(size: 12, design: .serif))
                                .foregroundStyle(Theme.textLight)
                        }
                    }
                }
                .tint(Theme.goldAccent)

                Spacer()
            }
            .padding(20)
        }
    }

    private var submittedView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Theme.divineGoldLight.opacity(0.2))
                    .frame(width: 100, height: 100)

                Image(systemName: "hands.sparkles.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.goldAccent)
            }

            Text("Prayer Submitted")
                .font(.system(size: 24, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text("Your prayer has been added to the wall.\nThe community will lift you up in faith.")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Button {
                dismiss()
            } label: {
                Text("Amen")
                    .font(.system(size: 16, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.goldAccent, Theme.goldDark],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            .padding(.top, 8)

            Spacer()
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }

    private func submitPrayer() {
        withAnimation(.spring(duration: 0.5)) {
            submitted = true
        }
    }
}
