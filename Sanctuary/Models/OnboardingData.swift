import SwiftUI

nonisolated enum AgeRange: String, CaseIterable, Identifiable, Codable, Sendable {
    case teen = "13–17"
    case youngAdult = "18–24"
    case adult = "25–34"
    case midLife = "35–49"
    case mature = "50–64"
    case elder = "65+"

    var id: String { rawValue }

    var label: String {
        switch self {
        case .teen: return "Youth"
        case .youngAdult: return "Young Adult"
        case .adult: return "Adult"
        case .midLife: return "Adult"
        case .mature: return "Elder"
        case .elder: return "Elder"
        }
    }

    var ageDescription: String {
        switch self {
        case .teen: return "Under 18"
        case .youngAdult: return "18–35"
        case .adult: return "25–34"
        case .midLife: return "36–64"
        case .mature: return "50–64"
        case .elder: return "65+"
        }
    }

    var icon: String {
        switch self {
        case .teen: return "leaf"
        case .youngAdult: return "sunrise"
        case .adult: return "sun.max"
        case .midLife: return "sun.max.fill"
        case .mature: return "moon.stars"
        case .elder: return "sparkles"
        }
    }
}

nonisolated enum Gender: String, CaseIterable, Identifiable, Codable, Sendable {
    case male = "Male"
    case female = "Female"
    case nonBinary = "Non-binary"
    case preferNotToSay = "Prefer not to say"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .male: return "figure.stand"
        case .female: return "figure.stand.dress"
        case .nonBinary: return "figure.2"
        case .preferNotToSay: return "hand.raised.slash"
        }
    }
}

nonisolated enum UserCountry: String, CaseIterable, Identifiable, Codable, Sendable {
    case unitedStates = "United States"
    case unitedKingdom = "United Kingdom"
    case canada = "Canada"
    case brazil = "Brazil"
    case mexico = "Mexico"
    case nigeria = "Nigeria"
    case southAfrica = "South Africa"
    case kenya = "Kenya"
    case philippines = "Philippines"
    case india = "India"
    case australia = "Australia"
    case germany = "Germany"
    case france = "France"
    case portugal = "Portugal"
    case spain = "Spain"
    case italy = "Italy"
    case colombia = "Colombia"
    case argentina = "Argentina"
    case ghana = "Ghana"
    case other = "Other"

    var id: String { rawValue }

    var flag: String {
        switch self {
        case .unitedStates: return "🇺🇸"
        case .unitedKingdom: return "🇬🇧"
        case .canada: return "🇨🇦"
        case .brazil: return "🇧🇷"
        case .mexico: return "🇲🇽"
        case .nigeria: return "🇳🇬"
        case .southAfrica: return "🇿🇦"
        case .kenya: return "🇰🇪"
        case .philippines: return "🇵🇭"
        case .india: return "🇮🇳"
        case .australia: return "🇦🇺"
        case .germany: return "🇩🇪"
        case .france: return "🇫🇷"
        case .portugal: return "🇵🇹"
        case .spain: return "🇪🇸"
        case .italy: return "🇮🇹"
        case .colombia: return "🇨🇴"
        case .argentina: return "🇦🇷"
        case .ghana: return "🇬🇭"
        case .other: return "🌍"
        }
    }

    func communityInsight(age: AgeRange?, gender: Gender?) -> String {
        let ageLabel: String
        switch age {
        case .teen: ageLabel = "teens"
        case .youngAdult: ageLabel = "young adults"
        case .adult: ageLabel = "adults in their late 20s and 30s"
        case .midLife: ageLabel = "people in their prime years"
        case .mature: ageLabel = "seasoned believers"
        case .elder: ageLabel = "wise elders"
        case nil: ageLabel = "believers"
        }

        switch self {
        case .unitedStates:
            return "The US has one of the largest faith communities on Amave. \(ageLabel.capitalized) like you make up 28% of our American community — and they report feeling 40% more connected to their faith."
        case .brazil:
            return "Brazil is our fastest-growing community! \(ageLabel.capitalized) in Brazil pray an average of 2.3 times daily through the app. You're joining an incredibly passionate group."
        case .nigeria:
            return "Nigeria has one of the most active prayer communities on Amave. \(ageLabel.capitalized) from Nigeria share 45% more prayers than the global average — truly inspiring devotion."
        case .philippines:
            return "The Filipino community on Amave is known for their deep devotion. \(ageLabel.capitalized) from the Philippines complete scripture journeys 60% faster than average."
        case .unitedKingdom:
            return "The UK community is growing beautifully. \(ageLabel.capitalized) in Britain are rediscovering faith — your group has grown 35% this year alone."
        case .india:
            return "India's diverse faith community brings unique depth to Amave. \(ageLabel.capitalized) from India contribute some of the most heartfelt prayers on our wall."
        case .southAfrica:
            return "South Africa's community radiates warmth and fellowship. \(ageLabel.capitalized) from SA are among the most active in community prayer — true prayer warriors."
        case .kenya:
            return "Kenya's faithful community on Amave is deeply inspiring. \(ageLabel.capitalized) from Kenya maintain the longest prayer streaks on average — 23 days!"
        default:
            return "Your country has a beautiful community of \(ageLabel) on Amave. Together, you'll discover how faith connects people across borders and cultures."
        }
    }
}

nonisolated enum PrayerFrequency: String, CaseIterable, Identifiable, Codable, Sendable {
    case rarely = "I'm finding my way back"
    case weekly = "When the moment calls"
    case daily = "Part of my daily rhythm"
    case multiple = "The Liturgy of the Hours, and more"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .rarely: return "moon.stars"
        case .weekly: return "leaf"
        case .daily: return "sun.max"
        case .multiple: return "flame.fill"
        }
    }

    func insight(for age: AgeRange?) -> String {
        switch self {
        case .rarely:
            return "You're taking the first step — and that's what matters most. Many who start here discover a rhythm that transforms their days."
        case .weekly:
            return "You're building a beautiful foundation. 62% of people in your age group share this rhythm — and those who grow it report deeper peace."
        case .daily:
            return "Daily prayer is a powerful discipline. Studies show daily prayer reduces anxiety by 35% and strengthens emotional resilience."
        case .multiple:
            return "You have the heart of a devoted prayer warrior. Only 12% of believers pray this frequently — you're in rare, beautiful company."
        }
    }
}

nonisolated enum ScriptureFrequency: String, CaseIterable, Identifiable, Codable, Sendable {
    case never = "I haven't started yet"
    case occasionally = "When it speaks to me"
    case weekly = "Regular reading"
    case daily = "Daily — the Word is my bread"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .never: return "book.closed"
        case .occasionally: return "book"
        case .weekly: return "text.book.closed"
        case .daily: return "book.fill"
        }
    }

    func insight(for prayer: PrayerFrequency?) -> String {
        switch self {
        case .never:
            return "No worries — Amave will guide you gently into scripture with short, meaningful passages chosen just for you."
        case .occasionally:
            return "Even occasional reading plants seeds. People who pair scripture with prayer — like you're doing — see 3x more spiritual growth."
        case .weekly:
            if prayer == .daily || prayer == .multiple {
                return "Combined with your prayer life, this creates a powerful rhythm. You're already living what many aspire to."
            }
            return "Consistent readers report 40% more clarity in life decisions. Your discipline is already bearing fruit."
        case .daily:
            return "Daily scripture readers report the highest levels of inner peace and purpose. You're nourishing your soul beautifully."
        }
    }
}

nonisolated enum SpiritualGoal: String, CaseIterable, Identifiable, Codable, Sendable {
    case peace = "Inner Peace"
    case community = "Community"
    case guidance = "Divine Guidance"
    case healing = "Healing"
    case discipline = "Spiritual Discipline"
    case knowledge = "Biblical Knowledge"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .peace: return "leaf.fill"
        case .community: return "person.2.fill"
        case .guidance: return "star.fill"
        case .healing: return "heart.fill"
        case .discipline: return "flame.fill"
        case .knowledge: return "book.fill"
        }
    }

    var color: Color {
        switch self {
        case .peace: return Color(red: 0.55, green: 0.75, blue: 0.65)
        case .community: return Color(red: 0.65, green: 0.60, blue: 0.80)
        case .guidance: return Color(red: 0.85, green: 0.72, blue: 0.35)
        case .healing: return Color(red: 0.82, green: 0.52, blue: 0.52)
        case .discipline: return Color(red: 0.85, green: 0.62, blue: 0.35)
        case .knowledge: return Color(red: 0.45, green: 0.62, blue: 0.78)
        }
    }
}

nonisolated enum SpiritualChallenge: String, CaseIterable, Identifiable, Codable, Sendable {
    case consistency = "Staying Consistent"
    case doubt = "Doubts & Questions"
    case distraction = "Distractions"
    case loneliness = "Feeling Alone"
    case understanding = "Understanding Scripture"
    case time = "Finding Time"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .consistency: return "arrow.triangle.2.circlepath"
        case .doubt: return "questionmark.circle"
        case .distraction: return "eye.slash"
        case .loneliness: return "person.fill.questionmark"
        case .understanding: return "text.magnifyingglass"
        case .time: return "clock"
        }
    }

    func insight(for goals: [SpiritualGoal]) -> String {
        switch self {
        case .consistency:
            return "73% of believers share this challenge. Amave's gentle daily reminders and streak tracking are designed exactly for this — small, faithful steps."
        case .doubt:
            return "Doubt is not the opposite of faith — it's part of the journey. Our Counselor feature offers a safe space to explore your deepest questions."
        case .distraction:
            return "In our noisy world, 68% struggle with this. Amave's guided moments create a sacred bubble — even 5 minutes can center your spirit."
        case .loneliness:
            if goals.contains(.community) {
                return "You're already seeking community — that's beautiful. Our Fellowship and Prayer Wall connect you with believers who understand your journey."
            }
            return "You're not alone in feeling alone. Our Community features connect thousands of believers who lift each other up daily."
        case .understanding:
            if goals.contains(.knowledge) {
                return "Your desire to learn is a gift. Our Journey courses break down scripture into beautiful, digestible lessons with rich context."
            }
            return "Scripture becomes clearer with guidance. Amave's Living Word feature brings passages alive with context and reflection."
        case .time:
            return "Even 5 minutes with God can transform a day. Amave is built for busy lives — quick devotions, bite-sized scripture, prayers on the go."
        }
    }
}

nonisolated enum MassAttendance: String, CaseIterable, Identifiable, Codable, Sendable {
    case weekly = "Weekly"
    case whenICan = "When I can"
    case online = "Online"
    case reconnecting = "Reconnecting"

    var id: String { rawValue }

    var insight: String? {
        switch self {
        case .reconnecting: return "Welcome back. The Church is always open."
        case .weekly: return "Your devotion is beautiful. Let's deepen it."
        case .online: return "Faith transcends walls. You're still part of the Body."
        case .whenICan: return nil
        }
    }
}

nonisolated enum Sacrament: String, CaseIterable, Identifiable, Codable, Sendable {
    case eucharist = "Eucharist"
    case confession = "Confession"
    case confirmation = "Confirmation"
    case marriage = "Marriage"
    case exploring = "I'm exploring"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .eucharist: return "cup.and.saucer.fill"
        case .confession: return "hand.raised.fill"
        case .confirmation: return "flame.fill"
        case .marriage: return "heart.fill"
        case .exploring: return "sparkle"
        }
    }
}

nonisolated enum SpiritualStyle: String, CaseIterable, Identifiable, Codable, Sendable {
    case traditional = "Traditional"
    case progressive = "Progressive"
    case contemporary = "Contemporary"
    case intellectual = "Intellectual"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .traditional: return "building.columns.fill"
        case .progressive: return "hands.sparkles"
        case .contemporary: return "sparkles"
        case .intellectual: return "book.closed.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .traditional: return "The Liturgy, Sacred Tradition, and the wisdom of the Saints"
        case .progressive: return "Mercy, justice, and the living spirit of Vatican II"
        case .contemporary: return "Faith woven into the fabric of everyday life"
        case .intellectual: return "Theology, philosophy, and the great questions of the soul"
        }
    }

    var guideName: String {
        switch self {
        case .traditional: return "Father Anthony will walk with you"
        case .progressive: return "Sister Ana will walk with you"
        case .contemporary: return "Brother Miguel will walk with you"
        case .intellectual: return "Professor Peter will walk with you"
        }
    }
}

nonisolated struct PersonalizedPlan: Sendable {
    let userName: String
    let spiritualStyle: SpiritualStyle
    let commitments: [PlanCommitment]
    let verse: String
    let verseReference: String
}

nonisolated struct PlanCommitment: Identifiable, Sendable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}
