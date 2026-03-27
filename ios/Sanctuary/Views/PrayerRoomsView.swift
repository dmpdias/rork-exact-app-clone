import SwiftUI

struct PrayerRoomsView: View {
    private let rooms: [PrayerRoom] = PrayerRoom.sanctuaryRooms
    @State private var activeIndex: Int = 0
    @State private var hasAppeared: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            titleSection
                .padding(.top, 4)
                .padding(.bottom, 6)

            goldenThread
                .padding(.bottom, 0)

            sanctuaryDeck
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.7)) {
                hasAppeared = true
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("Prayer Rooms")
                .font(.system(size: 32, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 12)

            Text("Enter a sanctuary of collective prayer")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
    }

    private var goldenThread: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Theme.goldAccent.opacity(0.0), Theme.goldAccent.opacity(0.6), Theme.goldAccent.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(width: 1, height: 32)
            .opacity(hasAppeared ? 1 : 0)
    }

    private var sanctuaryDeck: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20) {
                ForEach(Array(rooms.enumerated()), id: \.element.id) { index, room in
                    SanctuaryRoomCard(room: room, isActive: activeIndex == index)
                        .containerRelativeFrame(.vertical) { height, _ in
                            height * 0.72
                        }
                        .scrollTransition(.interactive) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.3)
                                .scaleEffect(phase.isIdentity ? 1 : 0.88)
                                .blur(radius: phase.isIdentity ? 0 : 3)
                        }
                        .id(index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: Binding(
            get: { activeIndex as Int? },
            set: { activeIndex = $0 ?? 0 }
        ))
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .contentMargins(.horizontal, 24)
        .sensoryFeedback(.selection, trigger: activeIndex)
    }
}

struct SanctuaryRoomCard: View {
    let room: PrayerRoom
    let isActive: Bool

    @State private var glowPhase: Bool = false
    @State private var showInterior: Bool = false

    private let avatarColors: [Color] = [
        Color(red: 0.72, green: 0.62, blue: 0.52),
        Color(red: 0.62, green: 0.55, blue: 0.48),
        Color(red: 0.78, green: 0.68, blue: 0.58),
    ]

    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 20)

            roomIcon
                .padding(.bottom, 20)

            Text(room.name)
                .font(.system(size: 26, weight: .regular, design: .serif))
                .foregroundStyle(Theme.textDark)
                .padding(.bottom, 8)

            Text(room.description)
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 24)
                .padding(.bottom, 28)

            presenceRow
                .padding(.bottom, 24)

            enterButton

            Spacer(minLength: 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Theme.cream,
                            Theme.sandLight,
                            Theme.warmBeige.opacity(0.5),
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Theme.goldAccent.opacity(0.15), lineWidth: 1)
        )
        .clipShape(.rect(cornerRadius: 24))
    }

    private var roomIcon: some View {
        ZStack {
            Circle()
                .fill(Theme.goldAccent.opacity(0.08))
                .frame(width: 88, height: 88)
                .scaleEffect(glowPhase ? 1.15 : 1.0)
                .opacity(glowPhase ? 0.6 : 0.3)

            Circle()
                .fill(Theme.goldAccent.opacity(0.12))
                .frame(width: 72, height: 72)
                .scaleEffect(glowPhase ? 1.08 : 1.0)
                .opacity(glowPhase ? 0.8 : 0.5)

            Circle()
                .fill(
                    RadialGradient(
                        colors: [Theme.warmBeige, Theme.sandLight],
                        center: .center,
                        startRadius: 0,
                        endRadius: 28
                    )
                )
                .frame(width: 56, height: 56)

            Image(systemName: room.icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundStyle(Theme.goldAccent)
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 2.4)
                .repeatForever(autoreverses: true)
            ) {
                glowPhase = true
            }
        }
    }

    private var presenceRow: some View {
        HStack(spacing: 10) {
            HStack(spacing: -8) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(avatarColors[index].opacity(0.6))
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(Theme.cream, lineWidth: 2)
                        )
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 12))
                                .foregroundStyle(Theme.cream.opacity(0.8))
                        )
                }
            }

            Text("\(room.activeNow) praying")
                .font(.system(size: 14, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textMedium)
        }
    }

    private var enterButton: some View {
        Button {
            showInterior = true
        } label: {
            Text("Enter Prayer Room")
                .font(.system(size: 15, weight: .medium, design: .serif))
                .foregroundStyle(Theme.goldAccent)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .stroke(Theme.goldAccent.opacity(0.5), lineWidth: 1)
                )
        }
        .sensoryFeedback(.impact(weight: .light), trigger: showInterior)
        .fullScreenCover(isPresented: $showInterior) {
            SanctuaryRoomInteriorView(room: room)
        }
    }
}
