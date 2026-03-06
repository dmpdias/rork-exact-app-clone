import SwiftUI

struct GreetingHeaderView: View {
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good night,")
                    .font(.system(.title2, design: .serif))
                    .foregroundStyle(Theme.textMedium)

                Text("David.")
                    .font(.system(size: 52, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("You were faithful today.")
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .padding(.top, 4)
            }

            Spacer()

            BibleProgressView(progress: 0.78)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

struct BibleProgressView: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 6) {
            Image("BandIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 66)

            HStack(spacing: 3) {
                Circle()
                    .fill(.green)
                    .frame(width: 6, height: 6)
                Text("\(Int(progress * 100))%")
                    .font(.system(.caption2, design: .serif))
                    .foregroundStyle(Theme.textMedium)
            }
        }
    }
}
