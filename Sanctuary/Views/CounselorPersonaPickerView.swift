import SwiftUI

struct CounselorPersonaPickerView: View {
    @Binding var selectedPersona: CounselorPersona
    @Environment(\.dismiss) private var dismiss
    @State private var appeared: Bool = false

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 33)
                .ignoresSafeArea()
                .opacity(0.3)

            VStack(spacing: 0) {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Theme.textMedium)
                            .frame(width: 34, height: 34)
                            .background(Theme.sandLight)
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("Choose Your Guide")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textMedium)

                    Spacer()

                    Color.clear.frame(width: 34, height: 34)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(Array(CounselorPersona.personas.enumerated()), id: \.element.id) { index, persona in
                            personaCard(persona, delay: Double(index) * 0.06)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
                .scrollIndicators(.hidden)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(28)
        .presentationContentInteraction(.scrolls)
    }

    private func personaCard(_ persona: CounselorPersona, delay: Double) -> some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                selectedPersona = persona
            }
            dismiss()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: selectedPersona.id == persona.id
                                    ? [Theme.goldLight, Theme.goldAccent]
                                    : [Theme.sandLight, Theme.warmBeige],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)

                    Image(systemName: persona.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(selectedPersona.id == persona.id ? .white : Theme.textMedium)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(persona.name)
                        .font(.system(.body, design: .serif, weight: .semibold))
                        .foregroundStyle(Theme.textDark)

                    Text(persona.title)
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Theme.goldDark)

                    Text(persona.description)
                        .font(.system(.caption2, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                if selectedPersona.id == persona.id {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Theme.goldDark)
                } else {
                    Circle()
                        .strokeBorder(Theme.sandDark.opacity(0.3), lineWidth: 1.5)
                        .frame(width: 22, height: 22)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(selectedPersona.id == persona.id ? Theme.goldAccent.opacity(0.08) : .white.opacity(0.7))
                    .shadow(color: Theme.sandDark.opacity(0.06), radius: 10, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(
                        selectedPersona.id == persona.id ? Theme.goldAccent.opacity(0.3) : .clear,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
