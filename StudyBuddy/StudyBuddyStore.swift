import Foundation
import SwiftUI

@MainActor
final class StudyBuddyStore: ObservableObject {
    private enum Keys {
        static let selectedExamID = "studybuddy.selectedExamID"
        static let examDate = "studybuddy.examDate"
        static let minutesPerDay = "studybuddy.minutesPerDay"
        static let completedTasks = "studybuddy.completedTasks"
        static let masteredCards = "studybuddy.masteredCards"
        static let answeredQuestions = "studybuddy.answeredQuestions"
        static let customExamName = "studybuddy.customExamName"
        static let customExamCode = "studybuddy.customExamCode"
        static let customFocus = "studybuddy.customFocus"
    }

    let exams = ExamCatalog.exams

    @Published var selectedExamID: String {
        didSet {
            UserDefaults.standard.set(selectedExamID, forKey: Keys.selectedExamID)
            loadProgressForSelectedExam()
        }
    }

    @Published var examDate: Date {
        didSet { UserDefaults.standard.set(examDate, forKey: Keys.examDate) }
    }

    @Published var minutesPerDay: Double {
        didSet { UserDefaults.standard.set(minutesPerDay, forKey: Keys.minutesPerDay) }
    }

    @Published var completedTaskIDs: Set<String> {
        didSet { saveStringSet(completedTaskIDs, key: Keys.completedTasks) }
    }

    @Published var masteredCardIDs: Set<String> {
        didSet { saveStringSet(masteredCardIDs, key: Keys.masteredCards) }
    }

    @Published var answeredQuestionIDs: Set<String> {
        didSet { saveStringSet(answeredQuestionIDs, key: Keys.answeredQuestions) }
    }

    @Published var customExamName: String {
        didSet { UserDefaults.standard.set(customExamName, forKey: Keys.customExamName) }
    }

    @Published var customExamCode: String {
        didSet { UserDefaults.standard.set(customExamCode, forKey: Keys.customExamCode) }
    }

    @Published var customFocus: String {
        didSet { UserDefaults.standard.set(customFocus, forKey: Keys.customFocus) }
    }

    init() {
        let defaults = UserDefaults.standard
        let savedDate = defaults.object(forKey: Keys.examDate) as? Date
        let savedExamID = defaults.string(forKey: Keys.selectedExamID)
        let knownExamIDs = Set(ExamCatalog.exams.map(\.id))
        let resolvedExamID = savedExamID.flatMap { knownExamIDs.contains($0) ? $0 : nil } ?? ExamCatalog.aPlusCore2.id
        selectedExamID = resolvedExamID
        examDate = savedDate ?? Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now
        minutesPerDay = defaults.object(forKey: Keys.minutesPerDay) as? Double ?? 45
        completedTaskIDs = Self.loadStringSet(key: Self.scopedKey(Keys.completedTasks, examID: resolvedExamID))
        masteredCardIDs = Self.loadStringSet(key: Self.scopedKey(Keys.masteredCards, examID: resolvedExamID))
        answeredQuestionIDs = Self.loadStringSet(key: Self.scopedKey(Keys.answeredQuestions, examID: resolvedExamID))
        customExamName = defaults.string(forKey: Keys.customExamName) ?? ""
        customExamCode = defaults.string(forKey: Keys.customExamCode) ?? ""
        customFocus = defaults.string(forKey: Keys.customFocus) ?? ""
    }

    var exam: ExamProfile {
        exams.first { $0.id == selectedExamID } ?? ExamCatalog.aPlusCore2
    }

    var simulations: [ExamSimulation] {
        ExamCatalog.simulations(for: exam.id)
    }

    var displayExamName: String {
        let trimmed = customExamName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? exam.name : trimmed
    }

    var displayExamCode: String {
        let trimmed = customExamCode.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? exam.code : trimmed
    }

    var daysUntilExam: Int {
        let start = Calendar.current.startOfDay(for: .now)
        let end = Calendar.current.startOfDay(for: examDate)
        return max(0, Calendar.current.dateComponents([.day], from: start, to: end).day ?? 0)
    }

    var overallProgress: Double {
        guard !exam.studyTasks.isEmpty else { return 0 }
        return Double(completedTaskIDs.count) / Double(exam.studyTasks.count)
    }

    var flashcardProgress: Double {
        guard !exam.flashcards.isEmpty else { return 0 }
        return Double(masteredCardIDs.count) / Double(exam.flashcards.count)
    }

    var practiceProgress: Double {
        guard !exam.practiceQuestions.isEmpty else { return 0 }
        return Double(answeredQuestionIDs.count) / Double(exam.practiceQuestions.count)
    }

    func progress(for domain: ExamDomain) -> Double {
        let tasks = exam.studyTasks.filter { $0.domainID == domain.id }
        guard !tasks.isEmpty else { return 0 }
        let done = tasks.filter { completedTaskIDs.contains($0.id) }.count
        return Double(done) / Double(tasks.count)
    }

    func tasks(for domain: ExamDomain) -> [StudyTask] {
        exam.studyTasks.filter { $0.domainID == domain.id }
    }

    func todaysTasks() -> [StudyTask] {
        let remaining = exam.studyTasks.filter { !completedTaskIDs.contains($0.id) }
        guard !remaining.isEmpty else { return Array(exam.studyTasks.prefix(3)) }

        let sortedDomains = exam.domains.sorted {
            progress(for: $0) == progress(for: $1) ? $0.weight > $1.weight : progress(for: $0) < progress(for: $1)
        }

        var selected: [StudyTask] = []
        var usedIDs = Set<String>()

        for domain in sortedDomains {
            if let task = remaining.first(where: { $0.domainID == domain.id && !usedIDs.contains($0.id) }) {
                selected.append(task)
                usedIDs.insert(task.id)
            }
            if selected.count == 3 { break }
        }

        if selected.count < 3 {
            selected.append(contentsOf: remaining.filter { !usedIDs.contains($0.id) }.prefix(3 - selected.count))
        }

        return selected
    }

    func toggleTask(_ task: StudyTask) {
        if completedTaskIDs.contains(task.id) {
            completedTaskIDs.remove(task.id)
        } else {
            completedTaskIDs.insert(task.id)
        }
    }

    func toggleFlashcard(_ card: Flashcard) {
        if masteredCardIDs.contains(card.id) {
            masteredCardIDs.remove(card.id)
        } else {
            masteredCardIDs.insert(card.id)
        }
    }

    func markQuestionAnswered(_ question: PracticeQuestion) {
        answeredQuestionIDs.insert(question.id)
    }

    func resetProgress() {
        completedTaskIDs = []
        masteredCardIDs = []
        answeredQuestionIDs = []
    }

    private func loadProgressForSelectedExam() {
        completedTaskIDs = Self.loadStringSet(key: Self.scopedKey(Keys.completedTasks, examID: selectedExamID))
        masteredCardIDs = Self.loadStringSet(key: Self.scopedKey(Keys.masteredCards, examID: selectedExamID))
        answeredQuestionIDs = Self.loadStringSet(key: Self.scopedKey(Keys.answeredQuestions, examID: selectedExamID))
    }

    private static func scopedKey(_ base: String, examID: String) -> String {
        "\(base).\(examID)"
    }

    private static func loadStringSet(key: String) -> Set<String> {
        guard let data = UserDefaults.standard.data(forKey: key),
              let values = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return Set(values)
    }

    private func saveStringSet(_ value: Set<String>, key: String) {
        guard let data = try? JSONEncoder().encode(Array(value)) else { return }
        UserDefaults.standard.set(data, forKey: Self.scopedKey(key, examID: selectedExamID))
    }
}
