import Foundation

struct ExamProfile: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let code: String
    let summary: String
    let domains: [ExamDomain]
    let studyTasks: [StudyTask]
    let flashcards: [Flashcard]
    let practiceQuestions: [PracticeQuestion]
    let quickTips: [String]
    let disclaimer: String
}

struct ExamDomain: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let weight: Int
    let focus: String
    let objectives: [String]
}

struct StudyTask: Identifiable, Codable, Hashable {
    let id: String
    let domainID: String
    let title: String
    let detail: String
    let minutes: Int
}

struct Flashcard: Identifiable, Codable, Hashable {
    let id: String
    let domainID: String
    let front: String
    let back: String
}

struct PracticeQuestion: Identifiable, Codable, Hashable {
    let id: String
    let domainID: String
    let prompt: String
    let choices: [String]
    let answerIndex: Int
    let explanation: String
}

enum ExamItemKind: String, Codable, Hashable {
    case singleChoice
    case multipleSelect
    case matching
    case ordering
}

struct ExamSimulation: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let timeLimitMinutes: Int
    let targetQuestionCount: Int
    let minimumScaledScore: Int
    let maximumScaledScore: Int
    let passingScaledScore: Int
    let performanceItems: [ExamItem]
}

struct ExamItem: Identifiable, Codable, Hashable {
    let id: String
    let domainID: String
    let kind: ExamItemKind
    let prompt: String
    let choices: [String]
    let correctChoiceIndexes: [Int]
    let matchingPrompts: [String]
    let matchingAnswers: [String]
    let correctMatches: [Int]
    let correctOrder: [String]
    let explanation: String
    let points: Int
    let isPerformanceBased: Bool
}

struct ExamAnswer: Codable, Hashable {
    var selectedIndexes: Set<Int> = []
    var selectedMatches: [Int: Int] = [:]
    var orderedItems: [String] = []
}

struct ExamResult: Hashable {
    let rawPoints: Int
    let possiblePoints: Int
    let scaledScore: Int
    let passingScore: Int
    let percent: Double

    var didPass: Bool {
        scaledScore >= passingScore
    }
}

enum StudyBuddyDifficultyLevel: String, CaseIterable, Identifiable, Codable, Hashable {
    case beginner
    case certificationReady
    case realExam
    case nightmareMode

    var id: String { rawValue }

    var title: String {
        switch self {
        case .beginner:
            return "Beginner"
        case .certificationReady:
            return "Certification Ready"
        case .realExam:
            return "Real Exam"
        case .nightmareMode:
            return "Nightmare Mode"
        }
    }

    var summary: String {
        switch self {
        case .beginner:
            return "Builds recall and exam vocabulary with fewer PBQs."
        case .certificationReady:
            return "Uses tougher scenarios and tighter distractors."
        case .realExam:
            return "Uses full exam timing, PBQs first, and no coaching until results."
        case .nightmareMode:
            return "Harder-than-exam pacing with longer scenarios, multi-select pressure, and stricter readiness expectations."
        }
    }

    var readinessTarget: Double {
        switch self {
        case .beginner:
            return 0.65
        case .certificationReady:
            return 0.78
        case .realExam:
            return 0.84
        case .nightmareMode:
            return 0.90
        }
    }
}

enum ConfidenceLevel: String, CaseIterable, Identifiable, Codable, Hashable {
    case guessed
    case narrowed
    case knewIt

    var id: String { rawValue }

    var title: String {
        switch self {
        case .guessed:
            return "Guessed"
        case .narrowed:
            return "Narrowed it down"
        case .knewIt:
            return "Knew it"
        }
    }

    var weight: Double {
        switch self {
        case .guessed:
            return 0.45
        case .narrowed:
            return 0.75
        case .knewIt:
            return 1
        }
    }
}

enum ExamSessionMode: String, CaseIterable, Identifiable, Codable, Hashable {
    case quick
    case realExam
    case speedTraining
    case stressMode
    case nightmareMode

    var id: String { rawValue }

    var title: String {
        switch self {
        case .quick:
            return "Quick Practice"
        case .realExam:
            return "Real Exam Mode"
        case .speedTraining:
            return "Speed Training"
        case .stressMode:
            return "Exam Stress Mode"
        case .nightmareMode:
            return "Nightmare Mode"
        }
    }
}

enum ObjectiveReadiness: String, Codable, Hashable {
    case mastered = "Mastered"
    case needsReview = "Needs Review"
    case weak = "Weak"
}

struct ExamAttemptRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let examID: String
    let simulationID: String
    let title: String
    let date: Date
    let sessionMode: ExamSessionMode
    let difficulty: StudyBuddyDifficultyLevel
    let rawPoints: Int
    let possiblePoints: Int
    let scaledScore: Int
    let passingScore: Int
    let percent: Double
    let durationSeconds: Int
    let flaggedCount: Int
    let guessedCount: Int
    let pbqPercent: Double
    let domainPercents: [String: Double]
    let confidenceScore: Double?

    var didPass: Bool {
        scaledScore >= passingScore
    }
}

struct StudyDomainRecommendation: Identifiable, Codable, Hashable {
    let id: String
    let domainTitle: String
    let readiness: ObjectiveReadiness
    let suggestedMinutes: Int
    let focus: String
}

struct StudyPlanRecommendation: Codable, Hashable {
    let dailyMinutes: Int
    let recommendedExamDate: Date
    let confidenceSummary: String
    let nextStep: String
    let domainPlan: [StudyDomainRecommendation]
}

enum AchievementMetric: String, Codable, Hashable {
    case baselineAttempt
    case questionsAnswered
    case perfectQuick
    case realExamPasses
    case pbqStrongAttempts
    case nightmarePass
    case studyStreak
    case planComplete
    case flashcardsMastered
    case confidenceStrong
}

struct StudyAchievement: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let detail: String
    let systemImage: String
    let metric: AchievementMetric
    let target: Double
    let unitLabel: String
}

struct AITutorMistakeContext: Codable, Hashable {
    let studentId: String
    let examID: String
    let examName: String
    let examCode: String
    let domainTitle: String
    let objective: String
    let questionPrompt: String
    let selectedAnswerSummary: String
    let correctAnswerSummary: String
    let explanation: String
    let itemKind: String
    let wasCorrect: Bool
    let isPerformanceBased: Bool
    let difficulty: String
    let confidence: String
    let sessionMode: String
    let targetStudyMinutes: Int
}

struct AIExamAttemptUpload: Codable, Hashable {
    let studentId: String
    let examID: String
    let examName: String
    let examCode: String
    let attempt: ExamAttemptRecord
    let weakDomains: [String]
}

enum AIServerStatus: String, Codable, Hashable {
    case notChecked = "Not checked"
    case checking = "Checking"
    case online = "Online"
    case offline = "Offline"
}

struct AIServerHealthResponse: Codable, Hashable {
    let ok: Bool
    let service: String?
    let model: String?
    let openaiConfigured: Bool?
    let openaiKeyStatus: String?
    let exams: [String]?
}

struct AITutorAssignment: Identifiable, Codable, Hashable {
    let type: String
    let title: String
    let detail: String
    let count: Int?

    var id: String {
        "\(type)-\(title)-\(detail)"
    }
}

struct AITutorResponse: Codable, Hashable {
    let sessionId: String
    let coachMessage: String
    let mistakePattern: String
    let guidingQuestions: [String]
    let assignments: [AITutorAssignment]
    let nextAction: String
    let source: String
}

struct AITutorChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let role: String
    let content: String

    init(id: UUID = UUID(), role: String, content: String) {
        self.id = id
        self.role = role
        self.content = content
    }
}

struct AITutorChatRequest: Codable, Hashable {
    let context: AITutorMistakeContext
    let messages: [AITutorChatMessage]
}

struct AITutorChatResponse: Codable, Hashable {
    let sessionId: String
    let reply: String
    let source: String
}

extension ExamProfile {
    func domain(with id: String) -> ExamDomain? {
        domains.first { $0.id == id }
    }
}

extension PracticeQuestion {
    func withMinimumChoices(minimumCount: Int = 4) -> PracticeQuestion {
        let correctAnswer = choices.indices.contains(answerIndex)
            ? choices[answerIndex]
            : choices.first ?? "Use the best-supported answer from the scenario"
        let requiredCount = max(minimumCount, 2)
        var safeChoices: [String] = []
        var seen = Set<String>()

        func normalized(_ value: String) -> String {
            value
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { !$0.isEmpty }
                .joined(separator: " ")
        }

        func appendUnique(_ value: String) {
            let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            let key = normalized(trimmed)
            guard !key.isEmpty, !seen.contains(key) else { return }
            seen.insert(key)
            safeChoices.append(trimmed)
        }

        appendUnique(correctAnswer)
        for (index, choice) in choices.enumerated() where index != answerIndex {
            appendUnique(choice)
        }

        for fallback in Self.fallbackChoices(for: domainID) where safeChoices.count < requiredCount {
            appendUnique(fallback)
        }

        var fillerIndex = 1
        while safeChoices.count < requiredCount {
            appendUnique("Compare the scenario evidence with a reversible remediation path \(fillerIndex)")
            fillerIndex += 1
        }

        return PracticeQuestion(
            id: id,
            domainID: domainID,
            prompt: prompt,
            choices: safeChoices,
            answerIndex: 0,
            explanation: explanation
        )
    }

    func randomizedChoices() -> PracticeQuestion {
        let safeQuestion = withMinimumChoices()
        let indexedChoices = safeQuestion.choices.enumerated().shuffled()
        let newChoices = indexedChoices.map(\.element)
        let newAnswerIndex = indexedChoices.firstIndex { $0.offset == safeQuestion.answerIndex } ?? safeQuestion.answerIndex

        return PracticeQuestion(
            id: safeQuestion.id,
            domainID: safeQuestion.domainID,
            prompt: safeQuestion.prompt,
            choices: newChoices,
            answerIndex: newAnswerIndex,
            explanation: safeQuestion.explanation
        )
    }

    var examItem: ExamItem {
        let safeQuestion = withMinimumChoices()
        return ExamItem(
            id: safeQuestion.id,
            domainID: safeQuestion.domainID,
            kind: .singleChoice,
            prompt: safeQuestion.prompt,
            choices: safeQuestion.choices,
            correctChoiceIndexes: [safeQuestion.answerIndex],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: safeQuestion.explanation,
            points: 1,
            isPerformanceBased: false
        )
    }

    private static func fallbackChoices(for domainID: String) -> [String] {
        if domainID.contains("network") {
            return [
                "DHCP lease, scope, or reservation problem",
                "DNS resolution or record problem",
                "Incorrect gateway, VLAN, or route selection",
                "Wireless attenuation, interference, or channel overlap",
                "Firewall rule or ACL blocking the required traffic"
            ]
        }

        if domainID.contains("hardware") {
            return [
                "Power delivery, thermal, or firmware visibility issue",
                "Storage controller, connector, or media compatibility issue",
                "Incorrect peripheral interface or cable selection",
                "Printer feed, imaging, transfer, or fusing fault",
                "Replace the component only after confirming scope and diagnostics"
            ]
        }

        if domainID.contains("security") || domainID.contains("threat") || domainID.contains("701") {
            return [
                "Preserve evidence, contain the scope, and document the incident path",
                "Identity, authorization, or conditional access misconfiguration",
                "Network segmentation, least privilege, or control validation issue",
                "User-targeted social engineering or credential exposure",
                "Risk transfer, exception approval, or governance decision"
            ]
        }

        if domainID.contains("os") || domainID.contains("operations") || domainID.contains("troubleshooting") {
            return [
                "Review logs, recent changes, services, and startup configuration",
                "Use a reversible fix, verify the user workflow, and document the result",
                "Protect user data before destructive repair or recovery steps",
                "Escalate only after collecting evidence and confirming scope",
                "Validate policy, change control, and rollback requirements"
            ]
        }

        if domainID.contains("cloud") {
            return [
                "Shared-responsibility boundary or service-model mismatch",
                "Snapshot, backup, or rollback requirement",
                "Resource scaling, availability, or region selection issue",
                "Access policy, tenant, or provider-managed control problem",
                "Connectivity path between local and hosted resources"
            ]
        }

        return [
            "Collect scope, evidence, and recent-change history first",
            "Choose the lowest-risk reversible action and verify afterward",
            "Protect user data before destructive recovery",
            "Document the result and escalation reason",
            "Compare the symptom against the objective being tested"
        ]
    }
}

extension ExamItem {
    func sessionCopy(sequence: Int) -> ExamItem {
        let indexedChoices = choices.enumerated().shuffled()
        let randomizedChoices = indexedChoices.map(\.element)
        let randomizedCorrectChoiceIndexes = correctChoiceIndexes.compactMap { originalIndex in
            indexedChoices.firstIndex { $0.offset == originalIndex }
        }

        let indexedMatchingAnswers = matchingAnswers.enumerated().shuffled()
        let randomizedMatchingAnswers = indexedMatchingAnswers.map(\.element)
        let randomizedCorrectMatches = correctMatches.map { originalIndex in
            indexedMatchingAnswers.firstIndex { $0.offset == originalIndex } ?? originalIndex
        }

        return ExamItem(
            id: "\(id)-session-\(sequence)-\(UUID().uuidString)",
            domainID: domainID,
            kind: kind,
            prompt: prompt,
            choices: randomizedChoices,
            correctChoiceIndexes: randomizedCorrectChoiceIndexes,
            matchingPrompts: matchingPrompts,
            matchingAnswers: randomizedMatchingAnswers,
            correctMatches: randomizedCorrectMatches,
            correctOrder: correctOrder,
            explanation: explanation,
            points: points,
            isPerformanceBased: isPerformanceBased
        )
    }

    func score(for answer: ExamAnswer) -> Int {
        switch kind {
        case .singleChoice:
            return answer.selectedIndexes == Set(correctChoiceIndexes) ? points : 0
        case .multipleSelect:
            return answer.selectedIndexes == Set(correctChoiceIndexes) ? points : 0
        case .matching:
            guard !correctMatches.isEmpty else { return 0 }
            let correct = correctMatches.enumerated().filter { promptIndex, answerIndex in
                answer.selectedMatches[promptIndex] == answerIndex
            }.count
            return Int(((Double(correct) / Double(correctMatches.count)) * Double(points)).rounded())
        case .ordering:
            guard !correctOrder.isEmpty else { return 0 }
            let correct = correctOrder.enumerated().filter { index, value in
                answer.orderedItems.indices.contains(index) && answer.orderedItems[index] == value
            }.count
            return Int(((Double(correct) / Double(correctOrder.count)) * Double(points)).rounded())
        }
    }
}

extension ExamSimulation {
    func items(for exam: ExamProfile) -> [ExamItem] {
        performanceItems + exam.practiceQuestions.map(\.examItem)
    }

    func randomizedItems(for exam: ExamProfile, difficulty: StudyBuddyDifficultyLevel = .realExam) -> [ExamItem] {
        let pbqBank = performanceItems.shuffled()
        let questionBank = ExamCatalog.practiceQuestions(
            for: exam.id,
            difficulty: difficulty,
            minimumCount: max(targetQuestionCount * 2, 140)
        )
        .map(\.examItem)
        .shuffled()
        guard !pbqBank.isEmpty || !questionBank.isEmpty else { return [] }

        var selected: [ExamItem] = []
        var usedPromptKeys = Set<String>()
        var sequence = 0
        let pbqCount: Int
        switch difficulty {
        case .beginner:
            pbqCount = min(1, pbqBank.count)
        case .certificationReady:
            pbqCount = min(2, pbqBank.count)
        case .realExam:
            pbqCount = min(max(3, pbqBank.count / 2), pbqBank.count)
        case .nightmareMode:
            pbqCount = pbqBank.count
        }

        for item in pbqBank.prefix(pbqCount) where selected.count < targetQuestionCount {
            appendUnique(item, to: &selected, usedPromptKeys: &usedPromptKeys, sequence: &sequence)
        }

        while selected.count < targetQuestionCount {
            let bank = questionBank.isEmpty ? pbqBank : questionBank.shuffled()
            guard !bank.isEmpty else { break }

            for item in bank {
                appendUnique(item, to: &selected, usedPromptKeys: &usedPromptKeys, sequence: &sequence)

                if selected.count == targetQuestionCount {
                    break
                }
            }

            if bank.allSatisfy({ usedPromptKeys.contains($0.prompt.normalizedPromptKey) }) {
                break
            }
        }

        return selected
    }

    private func appendUnique(
        _ item: ExamItem,
        to selected: inout [ExamItem],
        usedPromptKeys: inout Set<String>,
        sequence: inout Int
    ) {
        let key = item.prompt.normalizedPromptKey
        guard !usedPromptKeys.contains(key) else { return }
        selected.append(item.sessionCopy(sequence: sequence))
        usedPromptKeys.insert(key)
        sequence += 1
    }

    func configured(
        id: String,
        title: String,
        description: String,
        timeLimitMinutes: Int,
        targetQuestionCount: Int,
        passingScaledScore: Int? = nil
    ) -> ExamSimulation {
        ExamSimulation(
            id: id,
            title: title,
            description: description,
            timeLimitMinutes: timeLimitMinutes,
            targetQuestionCount: targetQuestionCount,
            minimumScaledScore: minimumScaledScore,
            maximumScaledScore: maximumScaledScore,
            passingScaledScore: passingScaledScore ?? self.passingScaledScore,
            performanceItems: performanceItems
        )
    }

    func result(for answers: [String: ExamAnswer], exam: ExamProfile) -> ExamResult {
        result(for: answers, items: items(for: exam))
    }

    func result(for answers: [String: ExamAnswer], items allItems: [ExamItem]) -> ExamResult {
        let possible = allItems.reduce(0) { $0 + $1.points }
        let raw = allItems.reduce(0) { total, item in
            total + item.score(for: answers[item.id] ?? ExamAnswer())
        }
        let percent = possible == 0 ? 0 : Double(raw) / Double(possible)
        let scaled = minimumScaledScore + Int((Double(maximumScaledScore - minimumScaledScore) * percent).rounded())

        return ExamResult(
            rawPoints: raw,
            possiblePoints: possible,
            scaledScore: scaled,
            passingScore: passingScaledScore,
            percent: percent
        )
    }
}

private extension String {
    var normalizedPromptKey: String {
        lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
}
