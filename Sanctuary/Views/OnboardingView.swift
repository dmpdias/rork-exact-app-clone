import SwiftUI
import AuthenticationServices

struct OnboardingView: View {
    @State private var vm = OnboardingViewModel()
    @State private var particleSeeds: [ParticleSeed] = (0..<30).map { _ in
        ParticleSeed(x: Double.random(in: 0...1), y: Double.random(in: 0...1), size: Double.random(in: 2...5), opacity: Double.random(in: 0.1...0.3))
    }

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
                if vm.currentStep > 1 && vm.currentStep < vm.totalSteps {
                    topBar
                }

                TabView(selection: $vm.currentStep) {
                    welcomeScreen.tag(0)
                    aboutYouScreen.tag(1)
                    spiritualPathScreen.tag(2)
                    covenantScreen.tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(response: 0.55, dampingFraction: 0.82), value: vm.currentStep)
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

    @State private var pathwaySelectHaptic: Int = 0
    @State private var covenantHapticTrigger: Int = 0
    @State private var rhythmSelectHaptic: Int = 0

    // MARK: - Spiritual Path

    private var spiritualPathScreen: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Image("BandIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 40)
                    .scaleEffect(vm.selectedSpiritualStyles.isEmpty ? 1.0 : 1.04)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: vm.selectedSpiritualStyles.count)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(spacing: 10) {
                            Text("How do you seek the Lord?")
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundStyle(Theme.textDark)
                                .multilineTextAlignment(.center)
                                .lineSpacing(2)

                            Text("Choose the path that resonates most with your soul.")
                                .font(.system(size: 15, design: .default))
                                .foregroundStyle(Theme.textMedium)
                                .multilineTextAlignment(.center)
                                .tracking(0.2)
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                        VStack(spacing: 12) {
                            ForEach(Array(SpiritualStyle.allCases.enumerated()), id: \.element.id) { index, style in
                                if index < vm.pathwayCardsRevealed {
                                    Button {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            vm.toggleSpiritualStyle(style)
                                            vm.showInsight = false
                                        }
                                        pathwaySelectHaptic += 1
                                    } label: {
                                        pathwayCard(style)
                                    }
                                    .buttonStyle(.plain)
                                    .transition(.asymmetric(
                                        insertion: .move(edge: .bottom).combined(with: .opacity),
                                        removal: .opacity
                                    ))
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .sensoryFeedback(.impact(weight: .medium), trigger: pathwaySelectHaptic)

                        if vm.showInsight, let insight = vm.currentInsight {
                            insightCard(insight)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.95).combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }

                        Spacer(minLength: 120)
                    }
                    .safeAreaInset(edge: .bottom) {
                        continueButton(title: vm.pathwayButtonText) { vm.nextStep() }
                            .opacity(vm.canProceed ? 1 : 0.4)
                            .disabled(!vm.canProceed)
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .onAppear {
            vm.pathwayCardsRevealed = 0
            Task {
                for i in 1...SpiritualStyle.allCases.count {
                    try? await Task.sleep(for: .milliseconds(100 * i))
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        vm.pathwayCardsRevealed = i
                    }
                }
            }
        }
    }

    private func pathwayCard(_ style: SpiritualStyle) -> some View {
        let isSelected = vm.selectedSpiritualStyles.contains(style)

        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.goldAccent.opacity(0.18) : Color(red: 0.96, green: 0.94, blue: 0.91))
                    .frame(width: 52, height: 52)

                Image(systemName: style.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.goldDark : Theme.textMedium)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(style.rawValue)
                    .font(.system(size: 17, weight: .semibold, design: .serif))
                    .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)

                Text(style.subtitle)
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 4)

            ZStack {
                Circle()
                    .strokeBorder(isSelected ? Theme.goldAccent : Theme.sandDark.opacity(0.2), lineWidth: 2)
                    .frame(width: 26, height: 26)

                if isSelected {
                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 16, height: 16)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    isSelected
                    ? Color.white.opacity(0.85)
                    : Color.white.opacity(0.45)
                )
                .strokeBorder(
                    isSelected
                    ? Theme.goldAccent.opacity(0.6)
                    : Theme.sandDark.opacity(0.08),
                    lineWidth: isSelected ? 1.5 : 1
                )
                .shadow(color: isSelected ? Theme.goldAccent.opacity(0.15) : Color.black.opacity(0.03), radius: isSelected ? 12 : 4, y: 2)
        )
        .scaleEffect(isSelected ? 1.015 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }

    // MARK: - Covenant Screen (Step 3)

    private var covenantScreen: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.97)
                .ignoresSafeArea()

            if vm.showWelcomeInterstitial {
                sacredTransitionOverlay
                    .zIndex(100)
            }

            if vm.whiteDissolveActive {
                Color.white
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .zIndex(200)
            }

            VStack(spacing: 0) {
                HStack {
                    Button {
                        vm.goBackCovenantSub()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Theme.textMedium)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    covenantLogoAnchor

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()

                ZStack {
                    if vm.covenantSubStep == 0 {
                        covenantRhythmStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? -60 : 60))
                            ))
                    } else if vm.covenantSubStep == 1 {
                        covenantReminderStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? -60 : 60))
                            ))
                    } else if vm.covenantSubStep == 2 {
                        covenantSignatureStep
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? 60 : -60)),
                                removal: .opacity.combined(with: .offset(x: vm.covenantTransitionForward ? -60 : 60))
                            ))
                    }
                }
                .sensoryFeedback(.selection, trigger: covenantHapticTrigger)

                Spacer()

                VStack(spacing: 14) {
                    if vm.covenantSubStep < 2 {
                        Button {
                            covenantHapticTrigger += 1
                            if vm.covenantSubStep == 1 {
                                vm.requestNotificationPermission()
                            }
                            vm.advanceCovenantSub()
                        } label: {
                            HStack(spacing: 8) {
                                Text(covenantButtonTitle)
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
                        .opacity(vm.canProceedCovenantSub && vm.covenantButtonVisible ? 1 : 0.35)
                        .disabled(!vm.canProceedCovenantSub)
                        .scaleEffect(vm.covenantButtonVisible && vm.canProceedCovenantSub ? 1.0 : 0.96)
                    } else {
                        Button {
                            beginSacredTransition()
                        } label: {
                            HStack(spacing: 10) {
                                Text("Amen. I commit")
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
                        .opacity(vm.hasSigned ? 1 : 0)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: vm.hasSigned)
                        .sensoryFeedback(.success, trigger: vm.sacredTransitionComplete)
                    }

                    Text(covenantFooterText)
                        .font(.system(size: 12, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textLight)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            vm.covenantSubStep = 0
            vm.covenantButtonVisible = false
            vm.signatureGlowing = false
            vm.showWelcomeInterstitial = false
            vm.whiteDissolveActive = false
            vm.sacredTransitionComplete = false
            Task {
                try? await Task.sleep(for: .milliseconds(500))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    vm.covenantButtonVisible = true
                }
            }
        }
    }

    private var covenantLogoAnchor: some View {
        ShimmerLogoView(logoOpacity: 1.0)
            .frame(height: 60)
    }

    private var covenantButtonTitle: String {
        switch vm.covenantSubStep {
        case 0: return "Step Forward"
        case 1: return "Set Time"
        default: return "Continue"
        }
    }

    private var covenantFooterText: String {
        switch vm.covenantSubStep {
        case 0: return "Next: Set your sacred reminder"
        case 1: return "Next: Seal your commitment"
        case 2: return vm.hasSigned ? "" : "Your signature seals this sacred moment"
        default: return ""
        }
    }

    // MARK: - Covenant Sub-Steps

    private var covenantRhythmStep: some View {
        VStack(spacing: 32) {
            Text("In what rhythm will\nyou walk with us?")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            VStack(spacing: 12) {
                ForEach(DailyRhythm.allCases) { rhythm in
                    Button {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            vm.selectedDailyRhythm = rhythm
                        }
                        rhythmSelectHaptic += 1
                    } label: {
                        rhythmCard(rhythm)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            .sensoryFeedback(.impact(weight: .medium), trigger: rhythmSelectHaptic)
        }
    }

    private func rhythmCard(_ rhythm: DailyRhythm) -> some View {
        let isSelected = vm.selectedDailyRhythm == rhythm

        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(isSelected ? Theme.goldAccent.opacity(0.18) : Color(red: 0.96, green: 0.94, blue: 0.91))
                    .frame(width: 52, height: 52)

                Image(systemName: rhythm.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Theme.goldDark : Theme.textMedium)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(rhythm.rawValue)
                    .font(.system(size: 17, weight: .semibold, design: .serif))
                    .foregroundStyle(isSelected ? Theme.textDark : Theme.textMedium)

                Text(rhythm.subtitle)
                    .font(.system(size: 13, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 4)

            ZStack {
                Circle()
                    .strokeBorder(isSelected ? Theme.goldAccent : Theme.sandDark.opacity(0.2), lineWidth: 2)
                    .frame(width: 26, height: 26)

                if isSelected {
                    Circle()
                        .fill(Theme.goldAccent)
                        .frame(width: 16, height: 16)
                        .transition(.scale.combined(with: .opacity))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(
                    isSelected
                    ? Color.white.opacity(0.85)
                    : Color.white.opacity(0.45)
                )
                .strokeBorder(
                    isSelected
                    ? Theme.goldAccent.opacity(0.6)
                    : Theme.sandDark.opacity(0.08),
                    lineWidth: isSelected ? 1.5 : 1
                )
                .shadow(color: isSelected ? Theme.goldAccent.opacity(0.15) : Color.black.opacity(0.03), radius: isSelected ? 12 : 4, y: 2)
        )
        .scaleEffect(isSelected ? 1.015 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }

    private var covenantReminderStep: some View {
        VStack(spacing: 32) {
            Text("When shall we call\nyou to prayer?")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            Text("A gentle reminder to pause, breathe,\nand enter your sacred time.")
                .font(.system(size: 15, design: .serif))
                .foregroundStyle(Theme.textMedium)
                .multilineTextAlignment(.center)
                .lineSpacing(3)

            DatePicker(
                "Prayer Time",
                selection: $vm.reminderTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(height: 160)
            .padding(.horizontal, 48)

            Text("Amave would like to gently remind\nyou of your quiet time.")
                .font(.system(size: 13, design: .serif))
                .italic()
                .foregroundStyle(Theme.textLight)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }

    private var covenantSignatureStep: some View {
        VStack(spacing: 24) {
            Text("Seal your Commitment.")
                .font(.system(size: 30, weight: .bold, design: .serif))
                .foregroundStyle(Theme.textDark)
                .multilineTextAlignment(.center)

            Text("I commit to this space as a sanctuary\nfor my soul, to seek peace, and to walk\nin grace with the Amave community.")
                .font(.system(size: 15, design: .serif))
                .italic()
                .foregroundStyle(Theme.textMedium)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 16)

            VStack(spacing: 0) {
                SignatureCanvasView(
                    hasDrawn: $vm.hasSigned,
                    inkColor: UIColor(Theme.textDark),
                    lineWidth: 2.5
                )
                .frame(height: 140)

                LinearGradient(
                    colors: [Theme.goldAccent.opacity(0.1), Theme.goldAccent.opacity(0.5), Theme.goldAccent.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(height: 1.5)
                .padding(.horizontal, 24)

                Text(vm.userName.isEmpty ? "Your Name" : vm.userName)
                    .font(.system(.caption, design: .serif))
                    .foregroundStyle(Theme.textLight)
                    .tracking(1)
                    .padding(.top, 10)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.5))
                    .strokeBorder(vm.hasSigned ? Theme.goldAccent.opacity(0.3) : Theme.sandDark.opacity(0.15), lineWidth: 1)
            )
            .padding(.horizontal, 32)
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

    // MARK: - Sacred Transition

    private var sacredTransitionOverlay: some View {
        ZStack {
            Color(red: 0.99, green: 0.98, blue: 0.97)
                .ignoresSafeArea()

            VStack(spacing: 28) {
                ShimmerLogoView(logoOpacity: vm.welcomeLogoVisible ? 1.0 : 0.0)
                    .frame(height: 80)
                    .scaleEffect(vm.welcomeLogoVisible ? 1.0 : 0.9)
                    .animation(.easeOut(duration: 0.6), value: vm.welcomeLogoVisible)

                VStack(spacing: 8) {
                    Text("Welcome home, \(vm.userName.trimmingCharacters(in: .whitespaces)).")
                        .font(.system(size: 28, weight: .semibold, design: .serif))
                        .foregroundStyle(Theme.textDark)
                        .multilineTextAlignment(.center)
                        .opacity(vm.welcomeTextVisible ? 1 : 0)
                        .offset(y: vm.welcomeTextVisible ? 0 : 12)
                        .animation(.easeOut(duration: 0.7), value: vm.welcomeTextVisible)
                }
            }
        }
        .transition(.opacity)
    }

    private func beginSacredTransition() {
        vm.signatureGlowing = true
        vm.sacredTransitionComplete = true

        Task {
            withAnimation(.easeOut(duration: 0.5)) {
                vm.showWelcomeInterstitial = true
            }

            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.easeOut(duration: 0.5)) {
                vm.welcomeLogoVisible = true
            }

            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.easeOut(duration: 0.6)) {
                vm.welcomeTextVisible = true
            }

            try? await Task.sleep(for: .seconds(1.5))

            withAnimation(.easeIn(duration: 0.6)) {
                vm.whiteDissolveActive = true
            }

            try? await Task.sleep(for: .milliseconds(600))
            onComplete()
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
