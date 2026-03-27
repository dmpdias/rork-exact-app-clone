import SwiftUI

struct CounselorChatView: View {
    @State private var viewModel = CounselorViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var hasAppeared: Bool = false
    @State private var scrollDownPulse: Bool = false
    @State private var avatarRingRotation: Double = 0

    var body: some View {
        ZStack {
            Theme.cream
                .ignoresSafeArea()

            ParticleBackgroundView(seed: 77)
                .ignoresSafeArea()
                .opacity(0.4)

            VStack(spacing: 0) {
                headerBar

                if viewModel.messages.isEmpty {
                    emptyState
                } else {
                    chatMessages
                }

                inputBar
            }

            if viewModel.showStarters {
                startersOverlay
            }
        }
        .sheet(isPresented: $viewModel.showPersonaPicker) {
            CounselorPersonaPickerView(selectedPersona: $viewModel.selectedPersona)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                scrollDownPulse = true
            }
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                avatarRingRotation = 360
            }
        }
    }

    private var headerBar: some View {
        HStack(spacing: 14) {
            Button {
                if !viewModel.messages.isEmpty {
                    viewModel.clearConversation()
                }
            } label: {
                Image(systemName: viewModel.messages.isEmpty ? "ellipsis" : "arrow.counterclockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Theme.textMedium)
                    .frame(width: 36, height: 36)
                    .background(Theme.sandLight)
                    .clipShape(Circle())
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Counselor")
                    .font(.system(.subheadline, design: .serif, weight: .medium))
                    .foregroundStyle(Theme.textDark)

                Text(viewModel.selectedPersona.title)
                    .font(.system(.caption2, design: .serif))
                    .foregroundStyle(Theme.textLight)
            }

            Spacer()

            Button {
                viewModel.showPersonaPicker = true
            } label: {
                counselorAvatar
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
    }

    private var counselorAvatar: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [Theme.goldLight.opacity(0.3), Theme.goldAccent, Theme.goldDark, Theme.goldLight.opacity(0.3)],
                        center: .center
                    ),
                    lineWidth: 2.5
                )
                .frame(width: 46, height: 46)
                .rotationEffect(.degrees(avatarRingRotation))

            Circle()
                .fill(Theme.cream)
                .frame(width: 40, height: 40)

            Image(systemName: viewModel.selectedPersona.icon)
                .font(.system(size: 17))
                .foregroundStyle(Theme.goldDark)
                .contentTransition(.symbolEffect(.replace))

            Image(systemName: "arrow.triangle.2.circlepath")
                .font(.system(size: 7, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 16, height: 16)
                .background(Theme.goldDark)
                .clipShape(Circle())
                .offset(x: 15, y: 15)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.goldAccent.opacity(0.15), Theme.cream.opacity(0)],
                                center: .center,
                                startRadius: 0,
                                endRadius: 60
                            )
                        )
                        .frame(width: 100, height: 100)

                    Image(systemName: viewModel.selectedPersona.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(Theme.goldDark.opacity(0.7))
                }

                VStack(spacing: 6) {
                    Text(viewModel.selectedPersona.name)
                        .font(.system(size: 26, weight: .regular, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text("Ready to listen and guide you")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textLight)
                        .italic()
                }
            }
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 12)

            Spacer()
                .frame(height: 32)

            featuredStartersSection

            Spacer()
                .frame(height: 24)

            VStack(spacing: 14) {
                Text("Scroll down to explore more topics")
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .italic()

                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.showStarters = true
                    }
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(Theme.sandLight)
                                .shadow(color: Theme.sandDark.opacity(0.12), radius: 8, y: 2)
                        )
                }
                .scaleEffect(scrollDownPulse ? 1.06 : 1.0)
                .opacity(scrollDownPulse ? 1 : 0.65)
            }
            .padding(.bottom, 20)
        }
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.height < -60 {
                        withAnimation(.spring(duration: 0.4)) {
                            viewModel.showStarters = true
                        }
                    }
                }
        )
    }

    private var featuredStartersSection: some View {
        VStack(spacing: 10) {
            ForEach(CounselorViewModel.featuredStarters) { starter in
                Button {
                    viewModel.sendStarter(starter)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: starter.icon)
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.goldDark)
                            .frame(width: 32, height: 32)
                            .background(Theme.goldAccent.opacity(0.1))
                            .clipShape(Circle())

                        Text(starter.prompt)
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Theme.textDark)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Theme.textLight)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 13)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(.white.opacity(0.65))
                            .shadow(color: Theme.sandDark.opacity(0.05), radius: 8, y: 2)
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
    }

    private var chatMessages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message, personaIcon: viewModel.selectedPersona.icon)
                            .id(message.id)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .bottom)),
                                removal: .opacity
                            ))
                    }

                    if viewModel.isTyping {
                        typingIndicator
                            .id("typing")
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _, _ in
                withAnimation(.easeOut(duration: 0.3)) {
                    if viewModel.isTyping {
                        proxy.scrollTo("typing", anchor: .bottom)
                    } else if let lastMessage = viewModel.messages.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var typingIndicator: some View {
        HStack(alignment: .bottom) {
            Image(systemName: viewModel.selectedPersona.icon)
                .font(.system(size: 10))
                .foregroundStyle(Theme.goldAccent)
                .frame(width: 22, height: 22)
                .background(Theme.goldAccent.opacity(0.12))
                .clipShape(Circle())
                .padding(.bottom, 4)

            TypingDotsView()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Theme.sandLight)
                .clipShape(.rect(cornerRadius: 18, style: .continuous))
            Spacer()
        }
    }

    private var inputBar: some View {
        HStack(spacing: 12) {
            TextField("Ask anything…", text: $viewModel.inputText)
                .font(.system(.body, design: .serif))
                .foregroundStyle(Theme.textDark)
                .focused($isInputFocused)
                .onSubmit {
                    viewModel.sendMessage()
                }

            Button {
                viewModel.sendMessage()
            } label: {
                Image(systemName: "arrow.up")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Theme.textLight : .white)
                    .frame(width: 32, height: 32)
                    .background(
                        Circle()
                            .fill(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Theme.sandLight : Theme.textDark)
                    )
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(.white.opacity(0.85))
                .shadow(color: Theme.sandDark.opacity(0.08), radius: 12, y: 2)
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private var startersOverlay: some View {
        ZStack {
            Theme.cream.opacity(0.97)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(duration: 0.35)) {
                        viewModel.showStarters = false
                    }
                }

            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(duration: 0.35)) {
                            viewModel.showStarters = false
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Theme.textMedium)
                            .frame(width: 36, height: 36)
                            .background(Theme.sandLight)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)

                Text("What's on your heart?")
                    .font(.system(size: 26, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("Choose a conversation starter\nor type your own below")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .multilineTextAlignment(.center)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(Array(ConversationStarter.starters.enumerated()), id: \.element.id) { index, starter in
                            StarterCardView(starter: starter, delay: Double(index) * 0.05) {
                                viewModel.sendStarter(starter)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 16)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
