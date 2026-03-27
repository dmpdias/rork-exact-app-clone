import SwiftUI

struct ChatBubbleView: View {
    let message: ChatMessage
    var personaIcon: String = "sparkles"
    @State private var appeared: Bool = false

    private var isUser: Bool { message.role == .user }

    var body: some View {
        HStack(alignment: .top) {
            if isUser { Spacer(minLength: 60) }

            if !isUser {
                Image(systemName: personaIcon)
                    .font(.system(size: 12))
                    .foregroundStyle(Theme.goldAccent)
                    .frame(width: 24, height: 24)
                    .background(Theme.goldAccent.opacity(0.12))
                    .clipShape(Circle())
                    .padding(.top, 4)
            }

            Text(message.content)
                .font(.system(.body, design: .serif))
                .foregroundStyle(isUser ? .white : Theme.textDark)
                .lineSpacing(4)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    isUser
                        ? AnyShapeStyle(Theme.textDark)
                        : AnyShapeStyle(Theme.sandLight.opacity(0.8))
                )
                .clipShape(.rect(cornerRadius: 20, style: .continuous))

            if !isUser { Spacer(minLength: 40) }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 8)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35)) {
                appeared = true
            }
        }
    }
}
