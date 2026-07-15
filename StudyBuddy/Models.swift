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

extension ExamProfile {
    func domain(with id: String) -> ExamDomain? {
        domains.first { $0.id == id }
    }
}

extension PracticeQuestion {
    func randomizedChoices() -> PracticeQuestion {
        let indexedChoices = choices.enumerated().shuffled()
        let newChoices = indexedChoices.map(\.element)
        let newAnswerIndex = indexedChoices.firstIndex { $0.offset == answerIndex } ?? answerIndex

        return PracticeQuestion(
            id: id,
            domainID: domainID,
            prompt: prompt,
            choices: newChoices,
            answerIndex: newAnswerIndex,
            explanation: explanation
        )
    }

    var examItem: ExamItem {
        return ExamItem(
            id: id,
            domainID: domainID,
            kind: .singleChoice,
            prompt: prompt,
            choices: choices,
            correctChoiceIndexes: [answerIndex],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: explanation,
            points: 1,
            isPerformanceBased: false
        )
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

    func randomizedItems(for exam: ExamProfile) -> [ExamItem] {
        let bank = items(for: exam)
        guard !bank.isEmpty else { return [] }

        var selected: [ExamItem] = []
        var sequence = 0

        while selected.count < targetQuestionCount {
            for item in bank.shuffled() {
                selected.append(item.sessionCopy(sequence: sequence))
                sequence += 1

                if selected.count == targetQuestionCount {
                    break
                }
            }
        }

        return selected
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
