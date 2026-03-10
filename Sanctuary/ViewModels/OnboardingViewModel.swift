import SwiftUI
import UserNotifications

@Observable
@MainActor
class OnboardingViewModel {
    var currentStep: Int = 0
    var aboutYouSubStep: Int = 0
    var userName: String = ""
    var selectedAge: AgeRange?
    var selectedGender: Gender?
    var selectedCountry: UserCountry?
    var massAttendance: MassAttendance?
    var selectedSacraments: [Sacrament] = []
    var selectedSpiritualStyles: Set<SpiritualStyle> = []
    var selectedPrayerFrequency: PrayerFrequency?
    var selectedScriptureFrequency: ScriptureFrequency?
    var selectedGoals: [SpiritualGoal] = []
    var selectedChallenge: SpiritualChallenge?
    var showInsight: Bool = false
    var planGenerated: Bool = false
    var hasSigned: Bool = false
    var selectedDailyRhythm: DailyRhythm?
    var covenantSubStep: Int = 0
    var covenantTransitionForward: Bool = true
    var reminderTime: Date = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }()
    var notificationPermissionGranted: Bool = false
    var notificationRequested: Bool = false
    var covenantButtonVisible: Bool = false
    var lightLeakActive: Bool = false

    var countrySearchText: String = ""
    var aboutYouButtonVisible: Bool = false
    var aboutYouTransitionDirection: Bool = true
    var pathwayCardsRevealed: Int = 0

    let totalSteps: Int = 5

    func advanceCovenantSub() {
        covenantButtonVisible = false
        if covenantSubStep < 2 {
            covenantTransitionForward = true
            withAnimation(.easeInOut(duration: 0.8)) {
                covenantSubStep += 1
            }
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    covenantButtonVisible = true
                }
            }
        }
    }

    func goBackCovenantSub() {
        if covenantSubStep > 0 {
            covenantButtonVisible = false
            covenantTransitionForward = false
            withAnimation(.easeInOut(duration: 0.8)) {
                covenantSubStep -= 1
            }
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    covenantButtonVisible = true
                }
            }
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                currentStep = 4
            }
        }
    }

    var canProceedCovenantSub: Bool {
        switch covenantSubStep {
        case 0: return selectedDailyRhythm != nil
        case 1: return true
        case 2: return hasSigned
        default: return false
        }
    }

    func requestNotificationPermission() {
        guard !notificationRequested else { return }
        notificationRequested = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            Task { @MainActor in
                self.notificationPermissionGranted = granted
            }
        }
    }
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

    var canProceedAboutYouSub: Bool {
        switch aboutYouSubStep {
        case 0: return !userName.trimmingCharacters(in: .whitespaces).isEmpty
        case 1: return selectedAge != nil
        case 2: return selectedCountry != nil
        default: return false
        }
    }

    var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !userName.trimmingCharacters(in: .whitespaces).isEmpty && selectedAge != nil && selectedCountry != nil
        case 2: return !selectedSpiritualStyles.isEmpty
        case 3: return selectedPrayerFrequency != nil && selectedScriptureFrequency != nil
        default: return true
        }
    }

    var pathwayButtonText: String {
        let count = selectedSpiritualStyles.count
        if count == 0 { return "Choose your path" }
        if count == 1 { return "Commit to this Path" }
        return "Commit to these \(count) Paths"
    }

    func toggleSpiritualStyle(_ style: SpiritualStyle) {
        if selectedSpiritualStyles.contains(style) {
            selectedSpiritualStyles.remove(style)
        } else {
            selectedSpiritualStyles.insert(style)
        }
    }

    func advanceAboutYouSub() {
        guard canProceedAboutYouSub else { return }
        aboutYouButtonVisible = false
        if aboutYouSubStep < 2 {
            aboutYouTransitionDirection = true
            withAnimation(.easeInOut(duration: 0.8)) {
                aboutYouSubStep += 1
            }
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    aboutYouButtonVisible = true
                }
            }
        } else {
            withAnimation(.spring(response: 0.55, dampingFraction: 0.82)) {
                showInsight = false
                isPreparingInsight = false
                currentStep = 2
            }
        }
    }

    func goBackAboutYouSub() {
        if aboutYouSubStep > 0 {
            aboutYouButtonVisible = false
            aboutYouTransitionDirection = false
            withAnimation(.easeInOut(duration: 0.8)) {
                aboutYouSubStep -= 1
            }
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    aboutYouButtonVisible = true
                }
            }
        } else {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                currentStep = 0
            }
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
        case 2: return !selectedSpiritualStyles.isEmpty ? "All paths lead to Christ. Every room in His house is yours." : nil
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

        let style = selectedSpiritualStyles.first ?? .traditional
        switch style {
        case .traditional:
            commitments.append(PlanCommitment(
                icon: "flame.fill",
                title: "The Holy Rosary, guided daily",
                description: "Walk through the mysteries each day with Father Anthony"
            ))
        case .contemplative:
            commitments.append(PlanCommitment(
                icon: "figure.mind.and.body",
                title: "Morning prayers for mercy and the world",
                description: "Start each day with prayers for mercy and justice with Sister Ana"
            ))
        case .charismatic:
            commitments.append(PlanCommitment(
                icon: "bird.fill",
                title: "Five sacred minutes, every day",
                description: "Honest conversations about faith with Brother Miguel"
            ))
        case .devotional:
            commitments.append(PlanCommitment(
                icon: "rosette",
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
        case .contemplative:
            verseInfo = ("Be still, and know that I am God. I will be exalted among the nations, I will be exalted in the earth.", "Psalm 46:10")
        case .charismatic:
            verseInfo = ("The Lord is my shepherd, I lack nothing. He makes me lie down in green pastures, he leads me beside quiet waters, he refreshes my soul.", "Psalm 23:1-3")
        case .devotional:
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
