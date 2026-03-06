import SwiftUI

struct StarterCardView: View {
    let starter: ConversationStarter
    let delay: Double
    let onTap: () -> Void
    @State private var appeared: Bool = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                Image(systemName: starter.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.goldDark)
                    .frame(width: 36, height: 36)
                    .background(Theme.goldAccent.opacity(0.12))
                    .clipShape(Circle())

                Text(starter.prompt)
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .multilineTextAlignment(.leading)

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white.opacity(0.7))
                    .shadow(color: Theme.sandDark.opacity(0.06), radius: 8, y: 2)
            )
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35).delay(delay)) {
                appeared = true
            }
        }
    }
}
