import SwiftUI

struct GreetingHeaderView: View {
    var onBibleProgressTap: () -> Void

    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning,"
        case 12..<17: return "Good afternoon,"
        case 17..<21: return "Good evening,"
        default: return "Good night,"
        }
    }

    private var encouragement: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "A new day of grace awaits you."
        case 12..<17: return "Keep walking in the light today."
        case 17..<21: return "You were faithful today."
        default: return "Rest in His peace tonight."
        }
    }

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(greetingText)
                    .font(.system(.title2, design: .serif))
                    .foregroundStyle(Theme.textMedium)

                Text("David.")
                    .font(.system(size: 52, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text(encouragement)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .padding(.top, 4)
            }

            Spacer()

            Button(action: onBibleProgressTap) {
                AvatarView()
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct AvatarView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [Theme.goldLight, Theme.goldAccent, Theme.goldDark],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)

            Circle()
                .fill(Theme.cream)
                .frame(width: 44, height: 44)

            Text("D")
                .font(.system(size: 22, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.goldDark)
        }
    }
}
