import SwiftUI

struct OnboardingView: View {
    @State private var vm = OnboardingViewModel()
    @State private var particleSeeds: [ParticleSeed] = (0..<30).map { _ in
        ParticleSeed(x: Double.random(in: 0...1), y: Double.random(in: 0...1), size: Double.random(in: 2...5), opacity: Double.random(in: 0.1...0.3))
    }
    var onComplete: () -> Void
    var onShowLogin: () -> Void

    var body: some View {
        ZStack {
            backgroundLayer

            VStack(spacing: 0) {
                if vm.currentStep > 0 && vm.currentStep <= vm.totalSteps && !vm.showCongrats && !vm.showRating {
                    topBar
                }

                TabView(selection: $vm.currentStep) {
                    welcomeScreen.tag(0)
                    nameAgeScreen.tag(1)
                    prayerScreen.tag(2)
                    scriptureScreen.tag(3)
                    goalsScreen.tag(4)
                    challengeScreen.tag(5)
                    testimonialScreen.tag(6)
                    planScreen.tag(7)
                    signatureScreen.tag(8)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.5, dampingFraction: 0.85), value: vm.currentStep)
                .allowsHitTesting(!vm.showCongrats && !vm.showRating)
            }

            if vm.showCongrats {
                congratulationsOverlay
                    .transition(.opacity)
                    .zIndex(10)
            }

            if vm.showRating {
                ratingOverlay
                    .transition(.opacity)
                    .zIndex(11)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var backgroundLayer: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.96, green: 0.93, blue: 0.88),
                    Color(red: 0.92, green: 0.88, blue: 0.82),
                    Color(red: 0.94, green: 0.90, blue: 0.84)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Canvas { context, size in
                for seed in particleSeeds {
                    let point = CGPoint(x: seed.x * size.width, y: seed.y * size.height)
                    context.opacity = seed.opacity
                    context.fill(
                        Circle().path(in: CGRect(x: point.x, y: point.y, width: seed.size, height: seed.size)),
                        with: .color(Theme.particleDot)
                    )
                }
            }
            .ignoresSafeArea()
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                vm.previousStep()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Theme.textMedium)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            HStack(spacing: 6) {
                ForEach(1...vm.totalSteps, id: \.self) { step in
                    Capsule()
                        .fill(step <= vm.currentStep ? Theme.goldAccent : Theme.sandDark.opacity(0.2))
                        .frame(width: step == vm.currentStep ? 24 : 8, height: 4)
                        .animation(.spring(response: 0.3), value: vm.currentStep)
                }
            }

            Spacer()

            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    // MARK: - Welcome

    private var welcomeScreen: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.goldLight.opacity(0.3), Theme.goldAccent.opacity(0.05)],
                                center: .center,
                                startRadius: 20,
                                endRadius: 80
                            )
                        )
                        .frame(width: 160, height: 160)

                    Image(systemName: "flame.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.goldLight, Theme.goldDark],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .symbolEffect(.breathe)
                }

                VStack(spacing: 12) {
                    Text("Sanctuary")
                        .font(.system(size: 42, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text("Your sacred space for\nprayer, scripture & growth.")
                        .font(.system(size: 18, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }

                Text("Let's build your personal journey together.\nIt only takes a moment.")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.top, 8)
            }

            Spacer()

            VStack(spacing: 16) {
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                        vm.currentStep = 1
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text("Begin Your Journey")
                            .font(.system(.body, design: .serif))
                            .fontWeight(.semibold)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Theme.cream)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.cardBrown, Theme.cardOlive],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .padding(.horizontal, 32)

                Button {
                    onShowLogin()
                } label: {
                    Text("I already have an account")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .underline()
                }
            }
            .padding(.bottom, 50)
        }
    }

    // MARK: - Name & Age

    private var nameAgeScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                questionHeader(
                    label: "GETTING TO KNOW YOU",
                    title: "What should we\ncall you?",
                    subtitle: "Your name helps us personalize your experience."
                )

                VStack(alignment: .leading, spacing: 8) {
                    Text("YOUR NAME")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)

                    TextField("", text: $vm.userName, prompt: Text("Enter your first name").foregroundStyle(Theme.textLight.opacity(0.6)))
                        .font(.system(size: 20, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 20)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Theme.sandLight.opacity(0.6))
                                .strokeBorder(Theme.sandDark.opacity(0.2), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 24)

                VStack(alignment: .leading, spacing: 12) {
                    Text("YOUR AGE")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(AgeRange.allCases) { age in
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    vm.selectedAge = age
                                }
                            } label: {
                                Text(age.rawValue)
                                    .font(.system(.subheadline, design: .serif))
                                    .fontWeight(.medium)
                                    .foregroundStyle(vm.selectedAge == age ? Theme.cream : Theme.textDark)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(vm.selectedAge == age ? Theme.cardBrown : Theme.sandLight.opacity(0.6))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(vm.selectedAge == age ? Theme.goldAccent.opacity(0.5) : Theme.sandDark.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton { vm.nextStep() }
                    .opacity(vm.canProceed ? 1 : 0.4)
                    .disabled(!vm.canProceed)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .scrollIndicators(.hidden)
    }

    // MARK: - Prayer

    private var prayerScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                questionHeader(
                    label: "YOUR PRAYER LIFE",
                    title: "How often do you\npray?",
                    subtitle: "There's no wrong answer — every prayer counts."
                )

                VStack(spacing: 10) {
                    ForEach(PrayerFrequency.allCases) { freq in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedPrayerFrequency = freq
                                vm.showInsight = false
                            }
                        } label: {
                            optionRow(
                                icon: freq.icon,
                                text: freq.rawValue,
                                isSelected: vm.selectedPrayerFrequency == freq
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                if vm.showInsight, let insight = vm.currentInsight {
                    insightCard(insight)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton {
                    vm.nextStep()
                }
                .opacity(vm.canProceed ? 1 : 0.4)
                .disabled(!vm.canProceed)
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Scripture

    private var scriptureScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                questionHeader(
                    label: "SCRIPTURE READING",
                    title: "How often do you\nread the Bible?",
                    subtitle: "Scripture is food for the soul."
                )

                VStack(spacing: 10) {
                    ForEach(ScriptureFrequency.allCases) { freq in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedScriptureFrequency = freq
                                vm.showInsight = false
                            }
                        } label: {
                            optionRow(
                                icon: freq.icon,
                                text: freq.rawValue,
                                isSelected: vm.selectedScriptureFrequency == freq
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                if vm.showInsight, let insight = vm.currentInsight {
                    insightCard(insight)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton { vm.nextStep() }
                    .opacity(vm.canProceed ? 1 : 0.4)
                    .disabled(!vm.canProceed)
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Goals

    private var goalsScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                questionHeader(
                    label: "YOUR HEART'S DESIRE",
                    title: "What are you\nseeking?",
                    subtitle: "Choose up to 3 that resonate with your spirit."
                )

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(SpiritualGoal.allCases) { goal in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                vm.toggleGoal(goal)
                            }
                        } label: {
                            goalCard(goal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                if !vm.selectedGoals.isEmpty {
                    VStack(spacing: 6) {
                        HStack(spacing: 4) {
                            ForEach(vm.selectedGoals) { goal in
                                Text(goal.rawValue)
                                    .font(.system(size: 12, weight: .medium, design: .serif))
                                    .foregroundStyle(Theme.cream)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Capsule().fill(goal.color.opacity(0.8)))
                            }
                        }

                        Text("\(vm.selectedGoals.count) of 3 selected")
                            .font(.system(size: 12, design: .serif))
                            .foregroundStyle(Theme.textLight)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton { vm.nextStep() }
                    .opacity(vm.canProceed ? 1 : 0.4)
                    .disabled(!vm.canProceed)
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Challenge

    private var challengeScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                questionHeader(
                    label: "BEING HONEST",
                    title: "What's your biggest\nchallenge?",
                    subtitle: "We all face struggles — naming them is the first step."
                )

                VStack(spacing: 10) {
                    ForEach(SpiritualChallenge.allCases) { challenge in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedChallenge = challenge
                                vm.showInsight = false
                            }
                        } label: {
                            optionRow(
                                icon: challenge.icon,
                                text: challenge.rawValue,
                                isSelected: vm.selectedChallenge == challenge
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)

                if vm.showInsight, let insight = vm.currentInsight {
                    insightCard(insight)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton { vm.nextStep() }
                    .opacity(vm.canProceed ? 1 : 0.4)
                    .disabled(!vm.canProceed)
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Plan

    private var planScreen: some View {
        let plan = vm.generatePlan()

        return ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.goldLight.opacity(0.3), Theme.goldAccent.opacity(0.05)],
                                    center: .center,
                                    startRadius: 15,
                                    endRadius: 55
                                )
                            )
                            .frame(width: 100, height: 100)

                        Image(systemName: "sparkles")
                            .font(.system(size: 38))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldLight, Theme.goldDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .symbolEffect(.breathe)
                    }

                    Text("\(plan.userName),\nhere's your path.")
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)

                    Text("Crafted from everything you've shared.")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textMedium)
                }
                .padding(.top, 20)

                VStack(spacing: 0) {
                    ForEach(Array(plan.commitments.enumerated()), id: \.element.id) { index, commitment in
                        HStack(alignment: .top, spacing: 16) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Circle()
                                        .fill(Theme.goldAccent.opacity(0.15))
                                        .frame(width: 44, height: 44)

                                    Image(systemName: commitment.icon)
                                        .font(.system(size: 18))
                                        .foregroundStyle(Theme.goldDark)
                                }

                                if index < plan.commitments.count - 1 {
                                    Rectangle()
                                        .fill(Theme.goldAccent.opacity(0.2))
                                        .frame(width: 2)
                                        .frame(maxHeight: .infinity)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(commitment.title)
                                    .font(.system(.body, design: .serif))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.textDark)

                                Text(commitment.description)
                                    .font(.system(.subheadline, design: .serif))
                                    .foregroundStyle(Theme.textMedium)
                                    .lineSpacing(2)
                            }
                            .padding(.bottom, index < plan.commitments.count - 1 ? 24 : 0)

                            Spacer()
                        }
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Theme.sandLight.opacity(0.7))
                        .strokeBorder(Theme.goldAccent.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal, 24)

                VStack(spacing: 10) {
                    Text("\"" + plan.verse + "\"")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)

                    Text("— " + plan.verseReference)
                        .font(.system(size: 12, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 20)

                Spacer(minLength: 100)
            }
            .safeAreaInset(edge: .bottom) {
                continueButton(title: "Sign Your Commitment") {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                        vm.currentStep = 8
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Testimonials

    private var testimonialScreen: some View {
        ScrollView {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.goldLight.opacity(0.25), Theme.goldAccent.opacity(0.05)],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 100, height: 100)

                        Image(systemName: "heart.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldLight, Theme.goldDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .symbolEffect(.breathe)
                    }

                    Text("Lives Transformed")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)

                    Text("See how Sanctuary has touched\nthousands of hearts.")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                .padding(.top, 20)

                impactStatsRow

                VStack(spacing: 14) {
                    testimonialCard(
                        initials: "S.M.",
                        name: "Sarah, 28",
                        text: "I was lost and anxious every day. Sanctuary gave me a rhythm of prayer that completely changed my mornings. I feel peace for the first time in years.",
                        color: Color(red: 0.55, green: 0.75, blue: 0.65)
                    )

                    testimonialCard(
                        initials: "J.R.",
                        name: "James, 42",
                        text: "I hadn't opened a Bible in 15 years. The guided scripture readings made it feel approachable again. Now I read every single day.",
                        color: Color(red: 0.45, green: 0.62, blue: 0.78)
                    )

                    testimonialCard(
                        initials: "M.L.",
                        name: "Maria, 35",
                        text: "The community prayer wall showed me I'm not alone. Strangers praying for my family — it moved me to tears.",
                        color: Color(red: 0.65, green: 0.60, blue: 0.80)
                    )
                }
                .padding(.horizontal, 24)

                VStack(spacing: 16) {
                    Text("How does this make you feel?")
                        .font(.system(.body, design: .serif))
                        .fontWeight(.medium)
                        .foregroundStyle(Theme.textDark)

                    HStack(spacing: 20) {
                        ForEach(reactionOptions, id: \.symbol) { option in
                            Button {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    vm.selectedTestimonialReaction = option.symbol
                                }
                            } label: {
                                VStack(spacing: 6) {
                                    Text(option.symbol)
                                        .font(.system(size: 36))
                                        .scaleEffect(vm.selectedTestimonialReaction == option.symbol ? 1.25 : 1.0)

                                    Text(option.label)
                                        .font(.system(size: 10, weight: .medium, design: .serif))
                                        .foregroundStyle(vm.selectedTestimonialReaction == option.symbol ? Theme.textDark : Theme.textLight)
                                }
                                .frame(width: 60)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(vm.selectedTestimonialReaction == option.symbol ? Theme.goldAccent.opacity(0.15) : Color.clear)
                                        .strokeBorder(vm.selectedTestimonialReaction == option.symbol ? Theme.goldAccent.opacity(0.4) : Color.clear, lineWidth: 1.5)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if let reaction = vm.selectedTestimonialReaction {
                        Text(reactionResponse(for: reaction))
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textMedium)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)
                            .padding(.horizontal, 24)
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.95).combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .padding(.top, 8)

                Spacer(minLength: 100)
            }
            .padding(.top, 24)
            .safeAreaInset(edge: .bottom) {
                continueButton { vm.nextStep() }
                    .opacity(vm.canProceed ? 1 : 0.4)
                    .disabled(!vm.canProceed)
            }
        }
        .scrollIndicators(.hidden)
    }

    private var impactStatsRow: some View {
        HStack(spacing: 0) {
            impactStat(value: "47K+", label: "Lives\nTouched", icon: "person.3.fill")
            impactDivider
            impactStat(value: "92%", label: "Feel More\nPeaceful", icon: "leaf.fill")
            impactDivider
            impactStat(value: "3.2M", label: "Prayers\nShared", icon: "hands.sparkles")
        }
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Theme.sandLight.opacity(0.7))
                .strokeBorder(Theme.goldAccent.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }

    private var impactDivider: some View {
        Rectangle()
            .fill(Theme.sandDark.opacity(0.15))
            .frame(width: 1, height: 50)
    }

    private func impactStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(Theme.goldDark)

            Text(value)
                .font(.system(size: 22, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)

            Text(label)
                .font(.system(size: 10, weight: .medium, design: .serif))
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity)
    }

    private func testimonialCard(initials: String, name: String, text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 44, height: 44)

                Text(initials)
                    .font(.system(size: 14, weight: .bold, design: .serif))
                    .foregroundStyle(color)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.system(.subheadline, design: .serif))
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textDark)

                Text("\"\(text)\"")
                    .font(.system(size: 14, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.4))
                .strokeBorder(Theme.sandDark.opacity(0.1), lineWidth: 1)
        )
    }

    private var reactionOptions: [(symbol: String, label: String)] {
        [
            ("\u{1F60A}", "Hopeful"),
            ("\u{1F62D}", "Moved"),
            ("\u{2764}\u{FE0F}", "Inspired"),
            ("\u{1F64F}", "Grateful")
        ]
    }

    private func reactionResponse(for symbol: String) -> String {
        switch symbol {
        case "\u{1F60A}":
            return "That hope you feel? It's just the beginning. Your journey is about to grow even deeper."
        case "\u{1F62D}":
            return "Tears of compassion are a gift. Your tender heart is exactly what this community needs."
        case "\u{2764}\u{FE0F}":
            return "That inspiration is God speaking to you. You're ready for something beautiful."
        case "\u{1F64F}":
            return "Gratitude opens every door. You're already walking in the right spirit."
        default:
            return "Your heart is in the right place. Let's build your path together."
        }
    }

    // MARK: - Signature

    private var signatureScreen: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "signature")
                    .font(.system(size: 32))
                    .foregroundStyle(Theme.goldAccent)

                Text("Seal your covenant.")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .foregroundStyle(Theme.textDark)

                Text("Sign below to commit to your\npersonalized spiritual journey.")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
            }

            Spacer().frame(height: 32)

            VStack(spacing: 0) {
                SignatureCanvasView(
                    hasDrawn: $vm.hasSigned,
                    inkColor: UIColor(Theme.textDark),
                    lineWidth: 3
                )
                .frame(height: 160)

                Rectangle()
                    .fill(Theme.textLight.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 24)

                Text(vm.userName.isEmpty ? "Your Name" : vm.userName)
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .padding(.top, 8)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.5))
                    .strokeBorder(Theme.sandDark.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 16) {
                Button {
                    vm.triggerCongrats()
                } label: {
                    HStack(spacing: 10) {
                        Text("Seal My Commitment")
                            .font(.system(.body, design: .serif))
                            .fontWeight(.semibold)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Theme.cream)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: vm.hasSigned ? [Theme.cardBrown, Theme.cardOlive] : [Theme.sandDark.opacity(0.4), Theme.sandDark.opacity(0.3)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .disabled(!vm.hasSigned)
                .padding(.horizontal, 32)
                .animation(.spring(response: 0.3), value: vm.hasSigned)

                if !vm.hasSigned {
                    Text("Use your finger to sign above")
                        .font(.system(size: 13, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
            }
            .padding(.bottom, 50)
        }
    }

    // MARK: - Reusable Components

    private func questionHeader(label: String, title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .tracking(2)
                .foregroundStyle(Theme.goldDark)

            Text(title)
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .lineSpacing(2)

            Text(subtitle)
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(Theme.textMedium)
                .lineSpacing(2)
        }
        .padding(.horizontal, 24)
    }

    private func optionRow(icon: String, text: String, isSelected: Bool) -> some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.goldAccent.opacity(0.15) : Theme.sandLight.opacity(0.8))
                    .frame(width: 44, height: 44)

                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? Theme.goldDark : Theme.textMedium)
            }

            Text(text)
                .font(.system(.body, design: .serif))
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)

            Spacer()

            ZStack {
                Circle()
                    .strokeBorder(isSelected ? Theme.goldAccent : Theme.sandDark.opacity(0.25), lineWidth: 2)
                    .frame(width: 24, height: 24)

                if isSelected {
                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 14, height: 14)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Theme.sandLight : Theme.sandLight.opacity(0.4))
                .strokeBorder(isSelected ? Theme.goldAccent.opacity(0.3) : Theme.sandDark.opacity(0.1), lineWidth: 1)
        )
    }

    private func goalCard(_ goal: SpiritualGoal) -> some View {
        let isSelected = vm.selectedGoals.contains(goal)

        return VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(isSelected ? goal.color.opacity(0.2) : Theme.sandLight.opacity(0.8))
                    .frame(width: 52, height: 52)

                Image(systemName: goal.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? goal.color : Theme.textMedium)
            }

            Text(goal.rawValue)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.medium)
                .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? goal.color.opacity(0.08) : Theme.sandLight.opacity(0.4))
                .strokeBorder(isSelected ? goal.color.opacity(0.4) : Theme.sandDark.opacity(0.1), lineWidth: 1.5)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }

    private func insightCard(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 20))
                .foregroundStyle(Theme.goldAccent)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 6) {
                Text("DID YOU KNOW?")
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1.5)
                    .foregroundStyle(Theme.goldDark)

                Text(text)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [Theme.goldAccent.opacity(0.08), Theme.goldLight.opacity(0.04)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .strokeBorder(Theme.goldAccent.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }

    // MARK: - Congratulations Overlay

    private var congratulationsOverlay: some View {
        ZStack {
            Theme.cream.opacity(0.97)
                .ignoresSafeArea()

            Canvas { context, size in
                for seed in particleSeeds {
                    let point = CGPoint(x: seed.x * size.width, y: seed.y * size.height)
                    context.opacity = seed.opacity * 0.5
                    context.fill(
                        Circle().path(in: CGRect(x: point.x, y: point.y, width: seed.size * 2, height: seed.size * 2)),
                        with: .color(Theme.goldAccent)
                    )
                }
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 24) {
                    ZStack {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .strokeBorder(
                                    Theme.goldAccent.opacity(vm.congratsAnimated ? 0 : 0.4),
                                    lineWidth: 2
                                )
                                .frame(width: vm.congratsAnimated ? CGFloat(200 + i * 60) : 80,
                                       height: vm.congratsAnimated ? CGFloat(200 + i * 60) : 80)
                                .animation(
                                    .easeOut(duration: 1.5).delay(Double(i) * 0.2),
                                    value: vm.congratsAnimated
                                )
                        }

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.goldLight.opacity(0.4), Theme.goldAccent.opacity(0.1)],
                                    center: .center,
                                    startRadius: 20,
                                    endRadius: 70
                                )
                            )
                            .frame(width: 140, height: 140)
                            .scaleEffect(vm.congratsAnimated ? 1.0 : 0.3)

                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 64))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldLight, Theme.goldDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .scaleEffect(vm.congratsAnimated ? 1.0 : 0.1)
                            .opacity(vm.congratsAnimated ? 1.0 : 0)
                    }

                    VStack(spacing: 10) {
                        Text("Everything is ready,")
                            .font(.system(size: 18, design: .serif))
                            .foregroundStyle(Theme.textMedium)
                            .opacity(vm.congratsAnimated ? 1 : 0)
                            .offset(y: vm.congratsAnimated ? 0 : 15)
                            .animation(.spring(response: 0.6).delay(0.4), value: vm.congratsAnimated)

                        Text("\(vm.userName.isEmpty ? "Friend" : vm.userName).")
                            .font(.system(size: 38, weight: .bold, design: .serif))
                            .foregroundStyle(Theme.textDark)
                            .opacity(vm.congratsAnimated ? 1 : 0)
                            .offset(y: vm.congratsAnimated ? 0 : 15)
                            .animation(.spring(response: 0.6).delay(0.55), value: vm.congratsAnimated)
                    }

                    VStack(spacing: 6) {
                        Text("Your sanctuary is prepared.")
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Theme.textMedium)

                        Text("You are now closer to God.")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.goldDark)
                    }
                    .opacity(vm.congratsAnimated ? 1 : 0)
                    .offset(y: vm.congratsAnimated ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.7), value: vm.congratsAnimated)

                    HStack(spacing: 8) {
                        Image(systemName: "quote.opening")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.goldAccent)

                        Text("The Lord bless you and keep you.")
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textMedium)

                        Image(systemName: "quote.closing")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.goldAccent)
                    }
                    .padding(.top, 8)
                    .opacity(vm.congratsAnimated ? 1 : 0)
                    .animation(.spring(response: 0.6).delay(0.9), value: vm.congratsAnimated)

                    Text("— Numbers 6:24")
                        .font(.system(size: 12, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                        .opacity(vm.congratsAnimated ? 1 : 0)
                        .animation(.spring(response: 0.6).delay(1.0), value: vm.congratsAnimated)
                }

                Spacer()

                Button {
                    vm.triggerRating()
                } label: {
                    HStack(spacing: 10) {
                        Text("Continue")
                            .font(.system(.body, design: .serif))
                            .fontWeight(.semibold)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .foregroundStyle(Theme.cream)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [Theme.cardBrown, Theme.cardOlive],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
                }
                .padding(.horizontal, 32)
                .opacity(vm.congratsAnimated ? 1 : 0)
                .animation(.spring(response: 0.5).delay(1.2), value: vm.congratsAnimated)
                .padding(.bottom, 50)
            }
        }
    }

    // MARK: - Rating Overlay

    private var ratingOverlay: some View {
        ZStack {
            Theme.cream.opacity(0.97)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 28) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.goldLight.opacity(0.3), Theme.goldAccent.opacity(0.05)],
                                    center: .center,
                                    startRadius: 15,
                                    endRadius: 55
                                )
                            )
                            .frame(width: 110, height: 110)

                        Image(systemName: "star.circle.fill")
                            .font(.system(size: 52))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Theme.goldLight, Theme.goldDark],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .symbolEffect(.breathe)
                    }

                    VStack(spacing: 10) {
                        Text("One last thing...")
                            .font(.system(size: 16, design: .serif))
                            .foregroundStyle(Theme.textMedium)

                        Text("Help us reach\nmore souls?")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(Theme.textDark)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }

                    Text("Your rating helps others discover\ntheir path to God.")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)

                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                                    vm.ratingStars = star
                                }
                            } label: {
                                Image(systemName: star <= vm.ratingStars ? "star.fill" : "star")
                                    .font(.system(size: 38))
                                    .foregroundStyle(
                                        star <= vm.ratingStars
                                        ? AnyShapeStyle(LinearGradient(colors: [Theme.goldLight, Theme.goldDark], startPoint: .top, endPoint: .bottom))
                                        : AnyShapeStyle(Theme.sandDark.opacity(0.3))
                                    )
                                    .scaleEffect(star <= vm.ratingStars ? 1.15 : 1.0)
                            }
                            .buttonStyle(.plain)
                            .sensoryFeedback(.selection, trigger: vm.ratingStars)
                        }
                    }
                    .padding(.vertical, 8)

                    if vm.ratingStars > 0 {
                        Text(ratingMessage)
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.goldDark)
                            .transition(.scale(scale: 0.95).combined(with: .opacity))
                    }
                }

                Spacer()

                VStack(spacing: 14) {
                    Button {
                        onComplete()
                    } label: {
                        HStack(spacing: 10) {
                            Text(vm.ratingStars > 0 ? "Enter Sanctuary" : "Enter Sanctuary")
                                .font(.system(.body, design: .serif))
                                .fontWeight(.semibold)

                            Image(systemName: "arrow.right")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundStyle(Theme.cream)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: [Theme.cardBrown, Theme.cardOlive],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                    }
                    .padding(.horizontal, 32)

                    Button {
                        onComplete()
                    } label: {
                        Text("Maybe later")
                            .font(.system(.subheadline, design: .serif))
                            .foregroundStyle(Theme.textLight)
                    }
                }
                .padding(.bottom, 50)
            }
        }
    }

    private var ratingMessage: String {
        switch vm.ratingStars {
        case 1: return "We'll do better for you."
        case 2: return "Thank you for your honesty."
        case 3: return "We're glad you're here."
        case 4: return "Wonderful — thank you!"
        case 5: return "God bless you! \u{2728}"
        default: return ""
        }
    }

    // MARK: - Reusable Components

    private func continueButton(title: String = "Continue", action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(.body, design: .serif))
                    .fontWeight(.semibold)

                Image(systemName: "arrow.right")
                    .font(.system(size: 13, weight: .semibold))
            }
            .foregroundStyle(Theme.cream)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [Theme.cardBrown, Theme.cardOlive],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 16)
        .background(
            LinearGradient(
                colors: [Theme.cream.opacity(0), Theme.cream.opacity(0.95), Theme.cream],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

private struct ParticleSeed {
    let x: Double
    let y: Double
    let size: Double
    let opacity: Double
}
