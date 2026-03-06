import SwiftUI

struct JourneyCategoryDetailView: View {
    let category: JourneyCategory
    let onBack: () -> Void

    @State private var hasAppeared: Bool = false

    private var items: [JourneyContentItem] {
        JourneyContentItem.items(for: category)
    }

    var body: some View {
        VStack(spacing: 0) {
            detailHeader

            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                        JourneyDetailRow(item: item)
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : 12)
                            .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.06), value: hasAppeared)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                hasAppeared = true
            }
        }
    }

    private var detailHeader: some View {
        VStack(spacing: 12) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .medium))
                        Text("Journey")
                            .font(.system(size: 14, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(Theme.goldAccent)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)

            ZStack {
                Circle()
                    .stroke(Theme.goldAccent.opacity(0.3), lineWidth: 1)
                    .frame(width: 60, height: 60)

                Circle()
                    .fill(Theme.textDark)
                    .frame(width: 52, height: 52)

                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Theme.cream)
            }

            Text(category.rawValue)
                .font(.system(size: 26, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text(category.subtitle)
                .font(.system(size: 14, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Theme.goldAccent.opacity(0.0), Theme.goldAccent.opacity(0.4), Theme.goldAccent.opacity(0.0)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
                .padding(.horizontal, 40)
                .padding(.top, 8)
        }
        .padding(.bottom, 8)
    }
}

struct JourneyDetailRow: View {
    let item: JourneyContentItem
    @State private var isExpanded: Bool = false

    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.35, bounce: 0.15)) {
                isExpanded.toggle()
            }
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Theme.warmBeige.opacity(0.5))
                            .frame(width: 40, height: 40)
                        Image(systemName: item.icon)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundStyle(Theme.goldAccent)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(.system(size: 15, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.textDark)
                        Text(item.subtitle)
                            .font(.system(size: 12, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textLight)
                    }

                    Spacer(minLength: 4)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.right")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Theme.textLight)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)

                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        Rectangle()
                            .fill(Theme.sandDark.opacity(0.1))
                            .frame(height: 1)

                        Text(item.detail)
                            .font(.system(size: 14, design: .serif))
                            .foregroundStyle(Theme.textMedium)
                            .lineSpacing(4)

                        Button {} label: {
                            Text("Begin")
                                .font(.system(size: 13, weight: .medium, design: .serif))
                                .foregroundStyle(Theme.goldAccent)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule()
                                        .stroke(Theme.goldAccent.opacity(0.5), lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 14)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: [Theme.sandLight.opacity(0.5), Theme.cream.opacity(0.3)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Theme.sandDark.opacity(0.08), lineWidth: 1)
            )
            .clipShape(.rect(cornerRadius: 14))
        }
        .sensoryFeedback(.selection, trigger: isExpanded)
    }
}
