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
                BibleProgressView(progress: 0.78)
            }
            .buttonStyle(.plain)
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
