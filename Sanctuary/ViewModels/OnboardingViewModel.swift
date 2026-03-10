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

    let totalSteps: Int = 5
    var showCountryPicker: Bool = false
    var isPreparingInsight: Bool = false
    var preparingText: String = ""

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
        default: return true
        }
    }

    func nextStep() {
        if currentStep >= 1 && currentStep <= 3 && !showInsight {
            let prepText: String
            switch currentStep {
            case 1: prepText = "Preparing your path..."
            case 3: prepText = "Reflecting on your heart..."
            default: prepText = ""
            }

            if !prepText.isEmpty {
                preparingText = prepText
                withAnimation(.spring(response: 0.4)) {
                    isPreparingInsight = true
                }
                Task {
                    try? await Task.sleep(for: .seconds(1.2))
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                        isPreparingInsight = false
                        showInsight = true
                    }
                }
            } else {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    showInsight = true
                }
            }
            return
        }

        withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
            showInsight = false
            isPreparingInsight = false
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
        case 2: return selectedSpiritualStyle != nil ? "All paths lead to Christ. Every room in His house is yours." : nil
        case 3: return faithPracticeInsight
        default: return nil
        }
    }

    var faithPracticeInsight: String? {
        guard let prayer = selectedPrayerFrequency, let scripture = selectedScriptureFrequency else { return nil }
        let isBeginning = (prayer == .rarely && (scripture == .never || scripture == .occasionally)) || ((prayer == .rarely || prayer == .weekly) && scripture == .never)
        if isBeginning {
            return "A beautiful beginning. Grace meets you exactly where you are."
        }
        if prayer == .daily || prayer == .multiple || scripture == .daily {
            return "Your faithfulness is a gift. Let us help you go deeper."
        }
        return prayer.insight(for: selectedAge)
    }

    func generatePlan() -> PersonalizedPlan {
        var commitments: [PlanCommitment] = []

        let style = selectedSpiritualStyle ?? .traditional
        switch style {
        case .traditional:
            commitments.append(PlanCommitment(
                icon: "building.columns.fill",
                title: "The Holy Rosary, guided daily",
                description: "Walk through the mysteries each day with Father Anthony"
            ))
        case .progressive:
            commitments.append(PlanCommitment(
                icon: "hands.sparkles",
                title: "Morning prayers for mercy and the world",
                description: "Start each day with prayers for mercy and justice with Sister Ana"
            ))
        case .contemporary:
            commitments.append(PlanCommitment(
                icon: "sparkles",
                title: "Five sacred minutes, every day",
                description: "Honest conversations about faith with Brother Miguel"
            ))
        case .intellectual:
            commitments.append(PlanCommitment(
                icon: "book.closed.fill",
                title: "Into the depths of the Word",
                description: "Explore theology and philosophy of the Word with Professor Peter"
            ))
        }

        if let prayer = selectedPrayerFrequency {
            switch prayer {
            case .rarely:
                commitments.append(PlanCommitment(
                    icon: "bell.fill",
                    title: "Gentle invitations to pause and pray",
                    description: "Build your rhythm with kind nudges throughout the day"
                ))
            case .weekly:
                commitments.append(PlanCommitment(
                    icon: "calendar.badge.clock",
                    title: "A rhythm for your prayer life",
                    description: "A weekly framework to deepen and anchor your practice"
                ))
            case .daily, .multiple:
                commitments.append(PlanCommitment(
                    icon: "flame.fill",
                    title: "Contemplative depths for your soul",
                    description: "Enrich your devotion with contemplative and intercessory prayers"
                ))
            }
        } else {
            commitments.append(PlanCommitment(
                icon: "bell.fill",
                title: "Gentle invitations to pause and pray",
                description: "Build your rhythm with kind nudges throughout the day"
            ))
        }

        let countryName = selectedCountry?.rawValue ?? "your country"
        commitments.append(PlanCommitment(
            icon: "person.3.fill",
            title: "Pray alongside the faithful in \(countryName)",
            description: "Connect with believers near you praying together every day"
        ))

        let verseInfo: (String, String)
        switch style {
        case .traditional:
            verseInfo = ("Trust in the Lord with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.", "Proverbs 3:5-6")
        case .progressive:
            verseInfo = ("Blessed are the merciful, for they will be shown mercy. Blessed are the peacemakers, for they will be called children of God.", "Matthew 5:7-9")
        case .contemporary:
            verseInfo = ("The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters, he refreshes my soul.", "Psalm 23:1-3")
        case .intellectual:
            verseInfo = ("In the beginning was the Word, and the Word was with God, and the Word was God. Through him all things were made.", "John 1:1-3")
        }

        return PersonalizedPlan(
            userName: userName.trimmingCharacters(in: .whitespaces),
            spiritualStyle: style,
            commitments: commitments,
            verse: verseInfo.0,
            verseReference: verseInfo.1
        )
    }
}
