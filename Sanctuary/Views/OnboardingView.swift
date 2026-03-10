import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @State private var vm = OnboardingViewModel()
    @State private var particleSeeds: [ParticleSeed] = (0..<30).map { _ in
        ParticleSeed(x: Double.random(in: 0...1), y: Double.random(in: 0...1), size: Double.random(in: 2...5), opacity: Double.random(in: 0.1...0.3))
    }
    @State private var planRevealed: Bool = false
    @State private var planNodeRevealCount: Int = 0
    @State private var splashPhase: Int = 0
    @State private var splashGlowIntensity: Double = 0.3
    @State private var splashHapticFired: Bool = false
    var onComplete: () -> Void
    var onShowLogin: () -> Void

    var body: some View {
        ZStack {
            if vm.currentStep == 0 {
                CathedralBackgroundView(glowIntensity: splashGlowIntensity)
                    .transition(.opacity)
            } else {
                backgroundLayer
                    .transition(.opacity)
            }

            VStack(spacing: 0) {
                if vm.currentStep > 1 && vm.currentStep <= vm.totalSteps && !vm.showCongrats && !vm.showRating {
                    topBar
                }

                TabView(selection: $vm.currentStep) {
                    welcomeScreen.tag(0)
                    aboutYouScreen.tag(1)
                    spiritualPathScreen.tag(2)
                    faithPracticeScreen.tag(3)
                    planScreen.tag(4)
                    signatureScreen.tag(5)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.55, dampingFraction: 0.82), value: vm.currentStep)
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
            .sensoryFeedback(.selection, trigger: vm.currentStep)

            Spacer()

            HStack(spacing: 6) {
                ForEach(1...vm.totalSteps, id: \.self) { step in
                    Capsule()
                        .fill(step <= vm.currentStep ? Theme.goldAccent : Theme.sandDark.opacity(0.2))
                        .frame(width: step == vm.currentStep ? 24 : 8, height: 4)
                        .shadow(color: step == vm.currentStep ? Theme.goldAccent.opacity(0.4) : .clear, radius: 4)
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

            VStack(spacing: 20) {
                ShimmerLogoView(logoOpacity: splashPhase >= 1 ? 1.0 : 0.0)
                    .frame(height: 160)
                    .animation(.easeOut(duration: 0.8), value: splashPhase)

                VStack(spacing: 14) {
                    Text("Amave")
                        .font(.system(size: 44, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.cream)
                        .opacity(splashPhase >= 2 ? 1 : 0)
                        .offset(y: splashPhase >= 2 ? 0 : 8)
                        .animation(.easeOut(duration: 0.5), value: splashPhase)

                    Text("Peace.")
                        .font(.system(size: 56, weight: .heavy, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.goldLight, Theme.goldAccent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(splashPhase >= 2 ? 1 : 0)
                        .offset(y: splashPhase >= 2 ? 0 : 12)
                        .animation(.easeOut(duration: 0.6).delay(0.15), value: splashPhase)
                }

                Text("Your sacred companion for\nthe Catholic life")
                    .font(.system(size: 16, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textCream.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .opacity(splashPhase >= 3 ? 1 : 0)
                    .offset(y: splashPhase >= 3 ? 0 : 16)
                    .animation(.spring(response: 0.6, dampingFraction: 0.75), value: splashPhase)
            }

            Spacer()

            VStack(spacing: 14) {
                Button {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                        vm.currentStep = 1
                    }
                } label: {
                    HStack(spacing: 10) {
                        Text("Enter the Sanctuary")
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
                            .fill(Color.white.opacity(0.08))
                    )
                    .overlay(
                        Capsule()
                            .strokeBorder(
                                LinearGradient(
                                    colors: [Theme.goldLight.opacity(0.6), Theme.goldAccent.opacity(0.3), Theme.goldLight.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Theme.goldAccent.opacity(0.2), radius: 12, y: 4)
                }
                .sensoryFeedback(.impact(flexibility: .soft), trigger: vm.currentStep)
                .padding(.horizontal, 32)

                SignInWithAppleButton(.signUp) { request in
                    request.requestedScopes = [.fullName, .email]
                } onCompletion: { result in
                    switch result {
                    case .success:
                        onComplete()
                    case .failure:
                        break
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 52)
                .clipShape(.rect(cornerRadius: 26))
                .padding(.horizontal, 32)

                Button {
                    onShowLogin()
                } label: {
                    Text("I already have an account")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textCream.opacity(0.6))
                        .underline()
                }
            }
            .opacity(splashPhase >= 3 ? 1 : 0)
            .offset(y: splashPhase >= 3 ? 0 : 40)
            .animation(.spring(response: 0.65, dampingFraction: 0.72), value: splashPhase)
            .padding(.bottom, 50)
        }
        .onAppear {
            startSplashChoreography()
        }
        .sensoryFeedback(.success, trigger: splashHapticFired)
    }

    private func startSplashChoreography() {
        guard splashPhase == 0 else { return }
        Task {
            withAnimation(.easeOut(duration: 0.8)) {
                splashPhase = 1
                splashGlowIntensity = 0.6
            }

            try? await Task.sleep(for: .milliseconds(800))
            withAnimation(.easeOut(duration: 0.5)) {
                splashPhase = 2
                splashGlowIntensity = 0.85
            }

            try? await Task.sleep(for: .milliseconds(600))
            withAnimation(.spring(response: 0.65, dampingFraction: 0.72)) {
                splashPhase = 3
                splashGlowIntensity = 1.0
            }

            try? await Task.sleep(for: .milliseconds(600))
            splashHapticFired = true
        }
    }

    // MARK: - About You

    @State private var aboutYouHapticTrigger: Int = 0

    private var aboutYouScreen: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button {
                        vm.goBackAboutYouSub()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.textMedium)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    aboutYouLogoAnchor

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()

                ZStack {
                    if vm.aboutYouSubStep == 0 {
                        aboutYouNameStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? -60 : 60))
                            ))
                    } else if vm.aboutYouSubStep == 1 {
                        aboutYouSeasonStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? -60 : 60))
                            ))
                    } else if vm.aboutYouSubStep == 2 {
                        aboutYouCountryStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.aboutYouTransitionDirection ? -60 : 60))
                            ))
                    }
                }
                .sensoryFeedback(.selection, trigger: aboutYouHapticTrigger)

                Spacer()

                VStack(spacing: 14) {
                    if !vm.userName.trimmingCharacters(in: .whitespaces).isEmpty {
                        Text("Peace be with you, \(vm.userName.trimmingCharacters(in: .whitespaces)). We are preparing your path.")
                            .font(.system(size: 13, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textLight)
                            .multilineTextAlignment(.center)
                            .transition(.opacity)
                            .padding(.horizontal, 32)
                    }

                    Button {
                        aboutYouHapticTrigger += 1
                        vm.advanceAboutYouSub()
                    } label: {
                        HStack(spacing: 8) {
                            Text("Step Forward")
                                .font(.system(.body, design: .default))
                                .fontWeight(.semibold)
                                .tracking(0.3)

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
                    .opacity(vm.canProceedAboutYouSub && vm.aboutYouButtonVisible ? 1 : 0.35)
                    .disabled(!vm.canProceedAboutYouSub)
                    .scaleEffect(vm.aboutYouButtonVisible && vm.canProceedAboutYouSub ? 1.0 : 0.96)

                    Text("Next: Discover your spiritual style")
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            vm.aboutYouSubStep = 0
            vm.aboutYouButtonVisible = false
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    vm.aboutYouButtonVisible = true
                }
            }
        }
        .sheet(isPresented: $vm.showCountryPicker) {
            countryPickerSheet
        }
    }

    private var aboutYouLogoAnchor: some View {
        Image("BandIcon")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: 40)
            .scaleEffect(vm.aboutYouButtonVisible ? 1.0 : 1.04)
            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: vm.aboutYouSubStep)
    }

    private var aboutYouNameStep: some View {
        VStack(spacing: 24) {
            Text("How shall we address\nyou in prayer?")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(spacing: 0) {
                TextField("", text: $vm.userName, prompt: Text("Your first name").foregroundStyle(Theme.textLight.opacity(0.4)))
                    .font(.system(size: 24, design: .serif))
                    .foregroundStyle(Theme.textDark)
                    .multilineTextAlignment(.center)
                    .autocorrectionDisabled()
                    .padding(.vertical, 12)
                    .onChange(of: vm.userName) { _, newValue in
                        if !newValue.trimmingCharacters(in: .whitespaces).isEmpty && !vm.aboutYouButtonVisible {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                vm.aboutYouButtonVisible = true
                            }
                        }
                    }

                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Theme.goldAccent.opacity(0.2), Theme.goldAccent.opacity(0.6), Theme.goldAccent.opacity(0.2)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 1.5)
                    .padding(.horizontal, 40)
            }
            .padding(.horizontal, 48)
        }
        .padding(.horizontal, 24)
    }

    private var aboutYouSeasonStep: some View {
        VStack(spacing: 32) {
            Text("What season of life\nare you in?")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach([
                        AgeRange.teen,
                        AgeRange.youngAdult,
                        AgeRange.midLife,
                        AgeRange.elder
                    ]) { age in
                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.65)) {
                                vm.selectedAge = age
                            }
                            if !vm.aboutYouButtonVisible {
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    vm.aboutYouButtonVisible = true
                                }
                            }
                        } label: {
                            let isSelected = vm.selectedAge == age
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(isSelected ? Theme.goldAccent.opacity(0.15) : Color(red: 0.96, green: 0.94, blue: 0.91))
                                        .frame(width: 56, height: 56)

                                    Image(systemName: age.icon)
                                        .font(.system(size: 22))
                                        .foregroundStyle(isSelected ? Theme.goldDark : Theme.textLight)
                                }

                                VStack(spacing: 3) {
                                    Text(age.label)
                                        .font(.system(size: 15, weight: .semibold, design: .serif))
                                        .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)

                                    Text(aboutYouAgeSubtitle(age))
                                        .font(.system(size: 12, design: .default))
                                        .foregroundStyle(Theme.textLight)
                                        .tracking(0.3)
                                }
                            }
                            .frame(width: 90)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(isSelected ? Theme.goldAccent.opacity(0.06) : Color.white.opacity(0.6))
                                    .strokeBorder(isSelected ? Theme.goldAccent.opacity(0.5) : Theme.sandDark.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                            )
                            .scaleEffect(isSelected ? 1.05 : 1.0)
                        }
                        .buttonStyle(.plain)
                        .sensoryFeedback(.selection, trigger: vm.selectedAge)
                    }
                }
                .padding(.horizontal, 24)
            }
            .contentMargins(.horizontal, 8)
        }
    }

    private func aboutYouAgeSubtitle(_ age: AgeRange) -> String {
        switch age {
        case .teen: return "Under 18"
        case .youngAdult: return "18–35"
        case .midLife: return "36–64"
        case .elder: return "65+"
        default: return age.rawValue
        }
    }

    private var aboutYouCountryStep: some View {
        VStack(spacing: 32) {
            Text("Where do you\ncall home?")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            Button {
                vm.showCountryPicker = true
            } label: {
                HStack(spacing: 16) {
                    if let country = vm.selectedCountry {
                        Text(country.flag)
                            .font(.system(size: 28))

                        Text(country.rawValue)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundStyle(Theme.textDark)
                    } else {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.96, green: 0.94, blue: 0.91))
                                .frame(width: 48, height: 48)

                            Image(systemName: "globe")
                                .font(.system(size: 20))
                                .foregroundStyle(Theme.textLight)
                        }

                        Text("Select your country")
                            .font(.system(size: 18, design: .serif))
                            .foregroundStyle(Theme.textLight.opacity(0.6))
                    }

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.textLight.opacity(0.5))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.6))
                        .strokeBorder(
                            vm.selectedCountry != nil ? Theme.goldAccent.opacity(0.4) : Theme.sandDark.opacity(0.12),
                            lineWidth: vm.selectedCountry != nil ? 1.5 : 1
                        )
                )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 32)
            .onChange(of: vm.selectedCountry) { _, newValue in
                if newValue != nil && !vm.aboutYouButtonVisible {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        vm.aboutYouButtonVisible = true
                    }
                }
            }
        }
    }

    private var countryPickerSheet: some View {
        NavigationStack {
            List {
                ForEach(vm.filteredCountries) { country in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            vm.selectedCountry = country
                            vm.showInsight = false
                        }
                        vm.showCountryPicker = false
                    } label: {
                        HStack {
                            Text(country.rawValue)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Theme.textDark)

                            Spacer()

                            if vm.selectedCountry == country {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.goldDark)
                            }
                        }
                    }
                }
            }
            .searchable(text: $vm.countrySearchText, prompt: "Search country")
            .navigationTitle("Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        vm.showCountryPicker = false
                    }
                    .font(.system(.body, design: .serif))
                    .fontWeight(.semibold)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }

    // MARK: - Spiritual Path

    private var spiritualPathScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                questionHeader(
                    label: "YOUR WAY OF FAITH",
                    title: "How does the Spirit\nmove in your life?",
                    subtitle: "There are many rooms in the Father\u{2019}s house.\nWhich one calls to you?"
                )

                Text("This shapes your daily prayers, reflections, and the voice of your spiritual guide.")
                    .font(.system(size: 13, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .padding(.horizontal, 24)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(Array(SpiritualStyle.allCases.enumerated()), id: \.element.id) { index, style in
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                vm.selectedSpiritualStyle = style
                                vm.showInsight = false
                            }
                        } label: {
                            spiritualStyleCard(style)
                        }
                        .buttonStyle(.plain)
                        .sensoryFeedback(.selection, trigger: vm.selectedSpiritualStyle)
                    }
                }
                .padding(.horizontal, 24)

                if let style = vm.selectedSpiritualStyle {
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Theme.goldDark)

                        Text(style.guideName)
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.goldDark)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Theme.goldAccent.opacity(0.08))
                            .strokeBorder(Theme.goldAccent.opacity(0.2), lineWidth: 1)
                    )
                    .padding(.horizontal, 24)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .opacity
                    ))
                    .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: vm.selectedSpiritualStyle)
                }

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

    private func spiritualStyleCard(_ style: SpiritualStyle) -> some View {
        let isSelected = vm.selectedSpiritualStyle == style

        return VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.goldAccent.opacity(0.15) : Theme.sandLight.opacity(0.8))
                    .frame(width: 52, height: 52)

                Image(systemName: style.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.goldDark : Theme.textMedium)
            }

            Text(style.rawValue)
                .font(.system(.subheadline, design: .serif))
                .fontWeight(.semibold)
                .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)

            Text(style.subtitle)
                .font(.system(size: 11, design: .serif))
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Theme.goldAccent.opacity(0.06) : Theme.sandLight.opacity(0.4))
                .strokeBorder(isSelected ? Theme.goldAccent.opacity(0.5) : Theme.sandDark.opacity(0.1), lineWidth: isSelected ? 2 : 1)
                .shadow(color: isSelected ? Theme.goldAccent.opacity(0.2) : .clear, radius: 8)
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
    }

    // MARK: - Faith Practice

    private var faithPracticeScreen: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 3 of 5")
                        .font(.system(size: 12, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                        .padding(.horizontal, 24)

                    questionHeader(
                        label: "YOUR LIFE OF PRAYER",
                        title: "Prayer & the Word",
                        subtitle: "Two pillars of the Catholic life. Where is your heart today?"
                    )

                    Text("This helps us know when and how to invite you to prayer \u{2014} never to overwhelm, always to accompany.")
                        .font(.system(size: 13, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                        .padding(.horizontal, 24)
                        .padding(.top, 4)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("YOUR PRAYER LIFE")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)
                        .padding(.horizontal, 24)

                    Text("Whether it\u{2019}s the morning Angelus, a quiet Rosary, or a whispered intention before sleep \u{2014} every word reaches Him.")
                        .font(.system(size: 14, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .lineSpacing(3)
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
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
                            .sensoryFeedback(.selection, trigger: vm.selectedPrayerFrequency)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("THE WORD IN YOUR LIFE")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Theme.textLight)
                        .padding(.horizontal, 24)

                    Text("From the daily Gospel at Mass to lectio divina at home \u{2014} the Word is living and active. We\u{2019}ll match your rhythm.")
                        .font(.system(size: 14, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .lineSpacing(3)
                        .padding(.horizontal, 24)

                    VStack(spacing: 8) {
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
                            .sensoryFeedback(.selection, trigger: vm.selectedScriptureFrequency)
                        }
                    }
                    .padding(.horizontal, 24)
                }

                if vm.isPreparingInsight {
                    preparingInsightView(vm.preparingText)
                        .transition(.opacity)
                }

                if vm.showInsight, let insight = vm.currentInsight {
                    insightCard(insight)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95).combined(with: .opacity),
                            removal: .opacity
                        ))
                }

                Spacer(minLength: 120)
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
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Step 4 of 5")
                        .font(.system(size: 12, weight: .medium, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                        .padding(.horizontal, 24)

                    Text("YOUR COVENANT")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(2)
                        .foregroundStyle(Theme.goldDark)
                        .padding(.horizontal, 24)
                }
                .padding(.top, 20)

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

                    Text("\(plan.userName),\nyour path has been prepared")
                        .font(.system(size: 28, weight: .bold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)

                    Text("In the tradition of \(plan.spiritualStyle.rawValue) faith")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textMedium)
                }

                if !planRevealed {
                    preparingInsightView("Weaving your covenant...")
                        .onAppear {
                            Task {
                                try? await Task.sleep(for: .seconds(1.5))
                                withAnimation(.spring(response: 0.6)) {
                                    planRevealed = true
                                }
                                for i in 0..<plan.commitments.count {
                                    try? await Task.sleep(for: .seconds(0.4))
                                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                        planNodeRevealCount = i + 1
                                    }
                                }
                            }
                        }
                } else {
                    VStack(spacing: 0) {
                        ForEach(Array(plan.commitments.enumerated()), id: \.element.id) { index, commitment in
                            if index < planNodeRevealCount {
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
                                .transition(.asymmetric(
                                    insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .opacity
                                ))
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
                    .sensoryFeedback(.success, trigger: planNodeRevealCount == plan.commitments.count)

                    VStack(spacing: 10) {
                        Text("\u{201C}" + plan.verse + "\u{201D}")
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textMedium)
                            .multilineTextAlignment(.center)
                            .lineSpacing(3)

                        Text("\u{2014} " + plan.verseReference)
                            .font(.system(size: 12, weight: .semibold, design: .serif))
                            .foregroundStyle(Theme.goldDark)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .opacity(planNodeRevealCount >= plan.commitments.count ? 1 : 0)
                    .animation(.easeIn(duration: 0.5), value: planNodeRevealCount)
                }

                Spacer(minLength: 100)
            }
            .safeAreaInset(edge: .bottom) {
                continueButton(title: "Seal Your Covenant") {
                    withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                        vm.currentStep = 5
                    }
                }
                .opacity(planRevealed && planNodeRevealCount >= plan.commitments.count ? 1 : 0.4)
                .disabled(!planRevealed || planNodeRevealCount < plan.commitments.count)
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            planRevealed = false
            planNodeRevealCount = 0
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

                Text("Place your mark below \u{2014} a covenant\nbetween you and the path ahead.")
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(Theme.textMedium)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)

                Text("A covenant is a sacred promise. Take your time.")
                    .font(.system(size: 13, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textLight)
                    .padding(.top, 2)
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
                    .strokeBorder(vm.hasSigned ? Theme.goldAccent.opacity(0.3) : Theme.sandDark.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal, 32)

            Spacer()

            VStack(spacing: 16) {
                Button {
                    vm.triggerCongrats()
                } label: {
                    HStack(spacing: 10) {
                        Text("Amen. I commit.")
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
                .sensoryFeedback(.impact(weight: .heavy), trigger: vm.showCongrats)

                if !vm.hasSigned {
                    Text("Your signature seals this sacred moment")
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
                        .transition(.scale.combined(with: .opacity))
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
        .scaleEffect(isSelected ? 1.01 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
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

    private func preparingInsightView(_ text: String) -> some View {
        HStack(spacing: 12) {
            ProgressView()
                .tint(Theme.goldDark)

            Text(text)
                .font(.system(.subheadline, design: .serif))
                .italic()
                .foregroundStyle(Theme.goldDark)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Theme.goldAccent.opacity(0.06))
                .strokeBorder(Theme.goldAccent.opacity(0.15), lineWidth: 1)
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
                                .fill(
                                    RadialGradient(
                                        colors: [Theme.goldAccent.opacity(vm.congratsAnimated ? 0 : 0.15), Theme.goldAccent.opacity(0)],
                                        center: .center,
                                        startRadius: 20,
                                        endRadius: CGFloat(100 + i * 30)
                                    )
                                )
                                .frame(width: vm.congratsAnimated ? CGFloat(200 + i * 60) : 80,
                                       height: vm.congratsAnimated ? CGFloat(200 + i * 60) : 80)
                                .overlay(
                                    Circle()
                                        .strokeBorder(
                                            Theme.goldAccent.opacity(vm.congratsAnimated ? 0 : 0.4),
                                            lineWidth: 2
                                        )
                                )
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
                            .rotationEffect(.degrees(vm.congratsAnimated ? 5 : 0))
                            .opacity(vm.congratsAnimated ? 1.0 : 0)
                    }
                    .sensoryFeedback(.success, trigger: vm.congratsAnimated)

                    VStack(spacing: 10) {
                        Text("It is finished.")
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
                        Text("Your sanctuary awaits.")
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(Theme.textMedium)

                        Text("You are already closer to God.")
                            .font(.system(.body, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.goldDark)
                    }
                    .opacity(vm.congratsAnimated ? 1 : 0)
                    .offset(y: vm.congratsAnimated ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.85), value: vm.congratsAnimated)

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
                    .animation(.spring(response: 0.6).delay(1.05), value: vm.congratsAnimated)

                    Text("\u{2014} Numbers 6:24")
                        .font(.system(size: 12, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.goldDark)
                        .opacity(vm.congratsAnimated ? 1 : 0)
                        .animation(.spring(response: 0.6).delay(1.15), value: vm.congratsAnimated)
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
                .animation(.spring(response: 0.5).delay(1.3), value: vm.congratsAnimated)
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
                        Text("Before you enter...")
                            .font(.system(size: 16, design: .serif))
                            .foregroundStyle(Theme.textMedium)

                        Text("Help others find\ntheir way home?")
                            .font(.system(size: 30, weight: .bold, design: .serif))
                            .foregroundStyle(Theme.textDark)
                            .multilineTextAlignment(.center)
                            .lineSpacing(2)
                    }

                    Text("A moment of your grace helps another\nsoul find this sanctuary.")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundStyle(Theme.textMedium)
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)

                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { star in
                            Button {
                                withAnimation(.spring(response: 0.25, dampingFraction: 0.5).delay(Double(star - 1) * 0.1)) {
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
                            Text("Enter Your Sanctuary")
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
        case 1: return "We hear you. We\u{2019}ll do better."
        case 2: return "Thank you for your honesty."
        case 3: return "Thank you. We\u{2019}re glad you\u{2019}re here."
        case 4: return "Your kindness is a blessing."
        case 5: return "Deo gratias."
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
