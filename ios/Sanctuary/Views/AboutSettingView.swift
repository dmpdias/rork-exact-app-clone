import SwiftUI

struct AboutSettingView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 55)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    headerBar

                    logoSection
                        .padding(.top, 32)

                    versionSection
                        .padding(.top, 28)

                    linksSection
                        .padding(.top, 24)

                    creditsSection
                        .padding(.top, 24)

                    Spacer().frame(height: 60)
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

            Text("About")
                .font(.system(.headline, design: .serif))
                .foregroundStyle(Theme.textDark)

            Spacer()

            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    private var logoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.divineGold.opacity(0.15), Theme.divineGoldLight.opacity(0.08)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Circle()
                    .strokeBorder(
                        AngularGradient(
                            colors: [Theme.divineGoldLight, Theme.divineGold, Theme.chainGold, Theme.divineGoldLight],
                            center: .center
                        ),
                        lineWidth: 2
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "flame.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Theme.divineGold)
            }

            VStack(spacing: 6) {
                Text("Amave")
                    .font(.system(size: 32, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("A sacred space for your soul.")
                    .font(.system(.subheadline, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textMedium)
            }
        }
    }

    private var versionSection: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Version 1.0.0")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Theme.textLight)

                Text("·")
                    .foregroundStyle(Theme.textLight)

                Text("Build 1")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }
        }
    }

    private var linksSection: some View {
        VStack(spacing: 2) {
            linkRow(icon: "star.fill", iconColor: Theme.goldAccent, title: "Rate Amave")
            Divider().padding(.leading, 70)
            linkRow(icon: "square.and.arrow.up", iconColor: Theme.readingIcon, title: "Share with Friends")
            Divider().padding(.leading, 70)
            linkRow(icon: "envelope.fill", iconColor: Theme.prayerIcon, title: "Send Feedback")
            Divider().padding(.leading, 70)
            linkRow(icon: "doc.text.fill", iconColor: Theme.textMedium, title: "Terms of Service")
            Divider().padding(.leading, 70)
            linkRow(icon: "hand.raised.fill", iconColor: Theme.cardBrown, title: "Privacy Policy")
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Theme.sandLight.opacity(0.5))
        )
        .padding(.horizontal, 20)
    }

    private func linkRow(icon: String, iconColor: Color, title: String) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 36, height: 36)

                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundStyle(iconColor)
                }

                Text(title)
                    .font(.system(.body, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Theme.textLight)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }

    private var creditsSection: some View {
        VStack(spacing: 8) {
            Text("Made with prayer and devotion.")
                .font(.system(.caption, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)

            Text("© 2025 Amave")
                .font(.system(.caption2, design: .serif))
                .foregroundStyle(Theme.textLight.opacity(0.7))
        }
    }
}
