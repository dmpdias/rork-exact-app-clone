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
    var signatureGlowing: Bool = false
    var showWelcomeInterstitial: Bool = false
    var welcomeTextVisible: Bool = false
    var welcomeLogoVisible: Bool = false
    var whiteDissolveActive: Bool = false
    var sacredTransitionComplete: Bool = false

    var countrySearchText: String = ""
    var aboutYouButtonVisible: Bool = false
    var aboutYouTransitionDirection: Bool = true
    var pathwayCardsRevealed: Int = 0

    let totalSteps: Int = 3

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
                currentStep = 2
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
        if currentStep >= 1 && currentStep <= 2 && !showInsight {
            let prepText: String
            switch currentStep {
            case 1: prepText = "Preparing your path..."
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
        default: return nil
        }
    }


}
