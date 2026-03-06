import SwiftUI

struct CounselorChatView: View {
    @State private var viewModel = CounselorViewModel()
    @FocusState private var isInputFocused: Bool
    @State private var dragOffset: CGFloat = 0
    @State private var hasAppeared: Bool = false
    @State private var scrollDownPulse: Bool = false

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
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                hasAppeared = true
            }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                scrollDownPulse = true
            }
        }
    }

    private var headerBar: some View {
        HStack {
            Button {
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Theme.textDark)
            }

            Spacer()

            Text("Counselor")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)

            Spacer()

            Image("BandIcon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 28, height: 37)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    private var emptyState: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 8) {
                Text("Type to Ask")
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("Scroll to Generate")
                    .font(.system(size: 28, weight: .regular, design: .serif))
                    .foregroundStyle(Theme.textDark)
            }
            .opacity(hasAppeared ? 1 : 0)
            .offset(y: hasAppeared ? 0 : 12)

            Spacer()

            VStack(spacing: 16) {
                softGlow

                Button {
                    withAnimation(.spring(duration: 0.4)) {
                        viewModel.showStarters = true
                    }
                } label: {
                    Image(systemName: "arrow.down")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.textMedium)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(Theme.sandLight)
                                .shadow(color: Theme.sandDark.opacity(0.15), radius: 8, y: 2)
                        )
                }
                .scaleEffect(scrollDownPulse ? 1.05 : 1.0)
                .opacity(scrollDownPulse ? 1 : 0.7)
            }
            .padding(.bottom, 24)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height > 0 {
                        dragOffset = value.translation.height
                    }
                }
                .onEnded { value in
                    if value.translation.height > 60 {
                        withAnimation(.spring(duration: 0.4)) {
                            viewModel.showStarters = true
                        }
                    }
                    dragOffset = 0
                }
        )
    }

    private var softGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Theme.warmBeige.opacity(0.6),
                        Theme.cream.opacity(0.0)
                    ],
                    center: .center,
                    startRadius: 0,
                    endRadius: 100
                )
            )
            .frame(width: 200, height: 200)
            .blur(radius: 30)
    }

    private var chatMessages: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.messages) { message in
                        ChatBubbleView(message: message)
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
            TextField("Ask Anything", text: $viewModel.inputText)
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
