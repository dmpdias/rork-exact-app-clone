import SwiftUI

struct PrayerRoomsView: View {
    @State private var selectedCountry: RoomCountry = .all
    @State private var hasAppeared: Bool = false
    private let rooms: [PrayerRoom] = PrayerRoom.samples

    private var filteredRooms: [PrayerRoom] {
        if selectedCountry == .all { return rooms }
        return rooms.filter { $0.countryFlag == selectedCountry.countryFlag }
    }

    private var topRooms: [PrayerRoom] {
        Array(rooms.sorted { $0.activeNow > $1.activeNow }.prefix(3))
    }

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                titleSection
                    .padding(.top, 4)

                countryFilterRow

                if !topRooms.isEmpty {
                    topGroupsSection
                }

                allRoomsSection
            }
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
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

            Text("Unite in collective prayer")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 8)
        }
    }

    private var countryFilterRow: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(RoomCountry.allCases, id: \.self) { country in
                    Button {
                        withAnimation(.spring(duration: 0.3)) {
                            selectedCountry = country
                        }
                    } label: {
                        VStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(selectedCountry == country ? Theme.textDark : Theme.sandLight)
                                    .frame(width: 48, height: 48)

                                Text(country.flag)
                                    .font(.system(size: 22))
                            }

                            Text(country.label)
                                .font(.system(size: 11, weight: selectedCountry == country ? .semibold : .regular, design: .serif))
                                .foregroundStyle(selectedCountry == country ? Theme.textDark : Theme.textLight)
                        }
                    }
                    .sensoryFeedback(.selection, trigger: selectedCountry == country)
                }
            }
        }
        .contentMargins(.horizontal, 24)
        .scrollIndicators(.hidden)
    }

    private var topGroupsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.goldAccent)
                Text("TOP ROOMS")
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textMedium)
            }
            .padding(.horizontal, 24)

            ScrollView(.horizontal) {
                HStack(spacing: 14) {
                    ForEach(topRooms) { room in
                        TopRoomCard(room: room)
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : 10)
                    }
                }
            }
            .contentMargins(.horizontal, 24)
            .scrollIndicators(.hidden)
        }
    }

    private var allRoomsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 6) {
                Image(systemName: "door.left.hand.open")
                    .font(.system(size: 13))
                    .foregroundStyle(Theme.goldAccent)
                Text("ALL ROOMS")
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .tracking(1.5)
                    .foregroundStyle(Theme.textMedium)
            }
            .padding(.horizontal, 24)

            LazyVStack(spacing: 12) {
                ForEach(filteredRooms) { room in
                    RoomListCard(room: room)
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : 8)
                }

                if filteredRooms.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "door.left.hand.closed")
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.textLight.opacity(0.5))
                        Text("No rooms in this region yet")
                            .font(.system(size: 15, design: .serif))
                            .foregroundStyle(Theme.textLight)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

struct TopRoomCard: View {
    let room: PrayerRoom

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.warmBeige, Theme.sandDark.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)

                    Image(systemName: room.icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.goldAccent)
                }

                if room.isLive {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.red)
                            .frame(width: 6, height: 6)
                        Text("LIVE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.red.opacity(0.8))
                    }
                }

                Spacer()

                Text(room.countryFlag)
                    .font(.system(size: 18))
            }

            Text(room.name)
                .font(.system(size: 16, weight: .semibold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .lineLimit(1)

            Text(room.description)
                .font(.system(size: 12, design: .serif))
                .foregroundStyle(Theme.textLight)
                .lineLimit(2)
                .frame(height: 32, alignment: .top)

            Spacer(minLength: 0)

            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 10))
                    Text("\(room.activeNow) praying")
                        .font(.system(size: 11, weight: .medium, design: .serif))
                }
                .foregroundStyle(Theme.goldDark)

                Spacer()

                Button {
                } label: {
                    Text("Join")
                        .font(.system(size: 12, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.cream)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Theme.textDark, in: Capsule())
                }
            }
        }
        .padding(16)
        .frame(width: 220, height: 200)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Theme.cream, Theme.sandLight],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.warmBeige.opacity(0.4), lineWidth: 0.5)
        )
    }
}

struct RoomListCard: View {
    let room: PrayerRoom

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.warmBeige, Theme.sandDark.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 48, height: 48)

                Image(systemName: room.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Theme.goldAccent)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(room.name)
                        .font(.system(size: 15, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .lineLimit(1)

                    Text(room.countryFlag)
                        .font(.system(size: 14))

                    if room.isLive {
                        HStack(spacing: 3) {
                            Circle()
                                .fill(.red)
                                .frame(width: 5, height: 5)
                            Text("LIVE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(.red.opacity(0.8))
                        }
                    }
                }

                HStack(spacing: 12) {
                    HStack(spacing: 3) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 9))
                        Text("\(room.memberCount)")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(Theme.textLight)

                    HStack(spacing: 3) {
                        Circle()
                            .fill(Theme.goldAccent)
                            .frame(width: 5, height: 5)
                        Text("\(room.activeNow) active")
                            .font(.system(size: 11, weight: .medium, design: .serif))
                    }
                    .foregroundStyle(Theme.goldDark)
                }
            }

            Spacer()

            Button {
            } label: {
                Text("Join")
                    .font(.system(size: 12, weight: .semibold, design: .serif))
                    .foregroundStyle(Theme.cream)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 7)
                    .background(Theme.textDark, in: Capsule())
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(
                    LinearGradient(
                        colors: [Theme.cream, Theme.sandLight],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Theme.warmBeige.opacity(0.4), lineWidth: 0.5)
        )
    }
}
