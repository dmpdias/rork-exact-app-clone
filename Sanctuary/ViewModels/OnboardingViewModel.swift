import SwiftUI

@Observable
@MainActor
class OnboardingViewModel {
    var currentStep: Int = 0
    var userName: String = ""
    var selectedAge: AgeRange?
    var selectedGender: Gender?
    var selectedCountry: UserCountry?
    var massAttendance: MassAttendance?
    var selectedSacraments: [Sacrament] = []
    var selectedSpiritualStyle: SpiritualStyle?
    var selectedPrayerFrequency: PrayerFrequency?
    var selectedScriptureFrequency: ScriptureFrequency?
    var selectedGoals: [SpiritualGoal] = []
    var selectedChallenge: SpiritualChallenge?
    var showInsight: Bool = false
    var planGenerated: Bool = false
    var hasSigned: Bool = false
    var selectedTestimonialReaction: String? = nil
    var showCongrats: Bool = false
    var showRating: Bool = false
    var congratsAnimated: Bool = false
    var ratingStars: Int = 0
    var countrySearchText: String = ""

    let totalSteps: Int = 9
    var showCountryPicker: Bool = false

    var progress: Double {
        Double(currentStep) / Double(totalSteps + 1)
    }

    var filteredCountries: [UserCountry] {
        if countrySearchText.isEmpty {
            return UserCountry.allCases
        }
        return UserCountry.allCases.filter {
            $0.rawValue.localizedStandardContains(countrySearchText)
        }
    }

    var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !userName.trimmingCharacters(in: .whitespaces).isEmpty && selectedAge != nil && selectedGender != nil && selectedCountry != nil
        case 2: return selectedSpiritualStyle != nil
        case 3: return selectedPrayerFrequency != nil && selectedScriptureFrequency != nil
        case 4: return !selectedGoals.isEmpty
        case 5: return selectedChallenge != nil
        case 6: return selectedTestimonialReaction != nil
        default: return true
        }
    }

    func nextStep() {
        if currentStep >= 1 && currentStep <= 6 && !showInsight {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                showInsight = true
            }
            return
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            showInsight = false
            currentStep += 1
        }
    }

    func toggleSacrament(_ sacrament: Sacrament) {
        if selectedSacraments.contains(sacrament) {
            selectedSacraments.removeAll { $0 == sacrament }
        } else {
            selectedSacraments.append(sacrament)
        }
    }

    func triggerCongrats() {
        showCongrats = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                self.congratsAnimated = true
            }
        }
    }

    func triggerRating() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            showCongrats = false
            showRating = true
        }
    }

    func previousStep() {
        guard currentStep > 0 else { return }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
            showInsight = false
            currentStep -= 1
        }
    }

    func toggleGoal(_ goal: SpiritualGoal) {
        if selectedGoals.contains(goal) {
            selectedGoals.removeAll { $0 == goal }
        } else if selectedGoals.count < 3 {
            selectedGoals.append(goal)
        }
    }

    var currentInsight: String? {
        switch currentStep {
        case 1:
            return selectedCountry?.communityInsight(age: selectedAge, gender: selectedGender)
        case 2: return selectedSpiritualStyle != nil ? "All paths lead to Christ. You're welcome here." : nil
        case 3: return faithPracticeInsight
        case 5: return selectedChallenge?.insight(for: selectedGoals)
        default: return nil
        }
    }

    var faithPracticeInsight: String? {
        guard let prayer = selectedPrayerFrequency, let scripture = selectedScriptureFrequency else { return nil }
        let isBeginning = (prayer == .rarely && (scripture == .never || scripture == .occasionally)) || ((prayer == .rarely || prayer == .weekly) && scripture == .never)
        if isBeginning {
            return "Perfect starting point. We'll grow together, step by step."
        }
        if prayer == .daily || prayer == .multiple || scripture == .daily {
            return "Your consistency is beautiful. Let's deepen it."
        }
        return prayer.insight(for: selectedAge)
    }

    func generatePlan() -> PersonalizedPlan {
        var commitments: [PlanCommitment] = []

        if let prayer = selectedPrayerFrequency {
            switch prayer {
            case .rarely, .weekly:
                commitments.append(PlanCommitment(
                    icon: "hands.sparkles",
                    title: "Daily Prayer Moment",
                    description: "Start with a guided 3-minute prayer each morning"
                ))
            case .daily:
                commitments.append(PlanCommitment(
                    icon: "hands.sparkles",
                    title: "Deepen Your Prayer",
                    description: "Explore different prayer styles — contemplative, intercessory, gratitude"
                ))
            case .multiple:
                commitments.append(PlanCommitment(
                    icon: "hands.sparkles",
                    title: "Prayer Warrior Path",
                    description: "Lead prayers on the Community Wall and mentor new believers"
                ))
            }
        }

        if let scripture = selectedScriptureFrequency {
            switch scripture {
            case .never, .occasionally:
                commitments.append(PlanCommitment(
                    icon: "book.fill",
                    title: "Scripture Discovery",
                    description: "One meaningful verse each day with guided reflection"
                ))
            case .weekly:
                commitments.append(PlanCommitment(
                    icon: "book.fill",
                    title: "Reading Journey",
                    description: "Follow a structured reading plan through the Gospels"
                ))
            case .daily:
                commitments.append(PlanCommitment(
                    icon: "book.fill",
                    title: "Deep Study Path",
                    description: "In-depth chapter studies with historical context and application"
                ))
            }
        }

        for goal in selectedGoals.prefix(2) {
            switch goal {
            case .peace:
                commitments.append(PlanCommitment(
                    icon: "leaf.fill",
                    title: "Sacred Stillness",
                    description: "Evening reflection moments to find peace before rest"
                ))
            case .community:
                commitments.append(PlanCommitment(
                    icon: "person.2.fill",
                    title: "Fellowship Connection",
                    description: "Join a prayer group and share your journey with others"
                ))
            case .guidance:
                commitments.append(PlanCommitment(
                    icon: "star.fill",
                    title: "Divine Wisdom",
                    description: "Weekly Counselor sessions for life's biggest questions"
                ))
            case .healing:
                commitments.append(PlanCommitment(
                    icon: "heart.fill",
                    title: "Healing Journey",
                    description: "Guided emotional prayers and scripture for restoration"
                ))
            case .discipline:
                commitments.append(PlanCommitment(
                    icon: "flame.fill",
                    title: "Faithful Rhythm",
                    description: "Build an unbreakable streak with daily devotion tracking"
                ))
            case .knowledge:
                commitments.append(PlanCommitment(
                    icon: "text.book.closed.fill",
                    title: "Biblical Mastery",
                    description: "Structured courses through books of the Bible"
                ))
            }
        }

        let verseOptions: [(String, String)] = [
            ("\"For I know the plans I have for you,\" declares the Lord, \"plans to prosper you and not to harm you, plans to give you hope and a future.\"", "Jeremiah 29:11"),
            ("Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.", "Proverbs 3:5-6"),
            ("I can do all this through him who gives me strength.", "Philippians 4:13"),
            ("Be strong and courageous. Do not be afraid; do not be discouraged, for the Lord your God will be with you wherever you go.", "Joshua 1:9")
        ]

        let selected = verseOptions[commitments.count % verseOptions.count]

        return PersonalizedPlan(
            userName: userName.trimmingCharacters(in: .whitespaces),
            commitments: commitments,
            verse: selected.0,
            verseReference: selected.1
        )
    }
}
