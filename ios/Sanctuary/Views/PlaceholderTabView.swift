import SwiftUI

struct PlaceholderTabView: View {
    let title: String
    let icon: String

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: title.hashValue)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.textLight)

                Text(title)
                    .font(.system(.title2, design: .serif))
                    .foregroundStyle(Theme.textMedium)

                Text("Coming soon")
                    .font(.system(.subheadline, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
            }
        }
    }
}
