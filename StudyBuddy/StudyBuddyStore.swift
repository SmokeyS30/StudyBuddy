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
        static let studyActivityDates = "studybuddy.studyActivityDates"
        static let appOpenDates = "studybuddy.appOpenDates"
        static let selectedDifficulty = "studybuddy.selectedDifficulty"
        static let examAttempts = "studybuddy.examAttempts"
        static let aiServerURL = "studybuddy.aiServerURL"
        static let aiStudentID = "studybuddy.aiStudentID"
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

    @Published var studyActivityDates: Set<String> {
        didSet { saveStringSet(studyActivityDates, key: Keys.studyActivityDates) }
    }

    @Published var appOpenDates: Set<String> {
        didSet { Self.saveGlobalStringSet(appOpenDates, key: Keys.appOpenDates) }
    }

    @Published var selectedDifficulty: StudyBuddyDifficultyLevel {
        didSet { UserDefaults.standard.set(selectedDifficulty.rawValue, forKey: Keys.selectedDifficulty) }
    }

    @Published var examAttempts: [ExamAttemptRecord] {
        didSet { saveAttempts() }
    }

    @Published var aiServerURL: String {
        didSet { UserDefaults.standard.set(aiServerURL, forKey: Keys.aiServerURL) }
    }

    @Published var aiServerStatus: AIServerStatus = .notChecked
    @Published var aiServerMessage: String = "StudyBuddy will check the AI tutor server when the app starts."
    @Published var aiServerModel: String = "--"
    @Published var aiServerOpenAIConfigured: Bool = false
    @Published var aiServerOpenAIKeyStatus: String = "missing"
    @Published private(set) var resetNavigationToken = 0

    let aiStudentID: String
    private var aiServerMonitorStarted = false

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
        studyActivityDates = Self.loadStringSet(key: Self.scopedKey(Keys.studyActivityDates, examID: resolvedExamID))
        appOpenDates = Self.loadStringSet(key: Keys.appOpenDates)
        selectedDifficulty = StudyBuddyDifficultyLevel(rawValue: defaults.string(forKey: Keys.selectedDifficulty) ?? "") ?? .realExam
        examAttempts = Self.loadAttempts()
        let savedAIServerURL = defaults.string(forKey: Keys.aiServerURL)
        let shouldMigrateAIServerURL = Self.shouldReplaceSavedAIServerURL(savedAIServerURL)
        let resolvedAIServerURL = shouldMigrateAIServerURL
            ? Self.defaultAIServerURL
            : savedAIServerURL ?? Self.defaultAIServerURL
        aiServerURL = resolvedAIServerURL
        if shouldMigrateAIServerURL {
            defaults.set(resolvedAIServerURL, forKey: Keys.aiServerURL)
        }
        aiStudentID = Self.loadOrCreateStudentID(defaults: defaults)
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

    var hasStartedStudying: Bool {
        !completedTaskIDs.isEmpty
            || !masteredCardIDs.isEmpty
            || !answeredQuestionIDs.isEmpty
            || !attemptsForSelectedExam.isEmpty
    }

    var isFirstStudyRun: Bool {
        !hasStartedStudying
    }

    var lifetimeQuestionWork: Int {
        max(answeredQuestionIDs.count, attemptsForSelectedExam.map(\.possiblePoints).reduce(0, +))
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

    var attemptsForSelectedExam: [ExamAttemptRecord] {
        attempts(for: selectedExamID)
    }

    func attempts(for examID: String) -> [ExamAttemptRecord] {
        examAttempts
            .filter { $0.examID == examID }
            .sorted { $0.date > $1.date }
    }

    func completedTaskIDs(for examID: String) -> Set<String> {
        if examID == selectedExamID { return completedTaskIDs }
        return Self.loadStringSet(key: Self.scopedKey(Keys.completedTasks, examID: examID))
    }

    func masteredCardIDs(for examID: String) -> Set<String> {
        if examID == selectedExamID { return masteredCardIDs }
        return Self.loadStringSet(key: Self.scopedKey(Keys.masteredCards, examID: examID))
    }

    func answeredQuestionIDs(for examID: String) -> Set<String> {
        if examID == selectedExamID { return answeredQuestionIDs }
        return Self.loadStringSet(key: Self.scopedKey(Keys.answeredQuestions, examID: examID))
    }

    func studyActivityDates(for examID: String) -> Set<String> {
        if examID == selectedExamID { return studyActivityDates }
        return Self.loadStringSet(key: Self.scopedKey(Keys.studyActivityDates, examID: examID))
    }

    func overallProgress(for exam: ExamProfile) -> Double {
        guard !exam.studyTasks.isEmpty else { return 0 }
        return Double(completedTaskIDs(for: exam.id).count) / Double(exam.studyTasks.count)
    }

    func flashcardProgress(for exam: ExamProfile) -> Double {
        guard !exam.flashcards.isEmpty else { return 0 }
        return Double(masteredCardIDs(for: exam.id).count) / Double(exam.flashcards.count)
    }

    func practiceProgress(for exam: ExamProfile) -> Double {
        let answeredCount = answeredQuestionIDs(for: exam.id).count
        guard !exam.practiceQuestions.isEmpty else { return answeredCount > 0 ? 1 : 0 }
        return min(Double(answeredCount) / Double(exam.practiceQuestions.count), 1)
    }

    func totalStudyMinutes(for exam: ExamProfile) -> Int {
        let completed = completedTaskIDs(for: exam.id)
        return exam.studyTasks.compactMap { completed.contains($0.id) ? $0.minutes : nil }.reduce(0, +)
    }

    func studyStreak(for examID: String) -> Int {
        currentAppOpenStreak()
    }

    func progress(for domain: ExamDomain, in exam: ExamProfile) -> Double {
        let tasks = exam.studyTasks.filter { $0.domainID == domain.id }
        guard !tasks.isEmpty else { return 0 }
        let completed = completedTaskIDs(for: exam.id)
        let done = tasks.filter { completed.contains($0.id) }.count
        return Double(done) / Double(tasks.count)
    }

    func objectiveReadiness(for domain: ExamDomain, in exam: ExamProfile) -> ObjectiveReadiness {
        if let domainAccuracy = attempts(for: exam.id).compactMap({ $0.domainPercents[domain.id] }).prefix(5).average {
            if domainAccuracy >= 0.85 { return .mastered }
            if domainAccuracy >= 0.65 { return .needsReview }
            return .weak
        }

        let domainProgress = progress(for: domain, in: exam)
        if domainProgress >= 0.85 { return .mastered }
        if domainProgress >= 0.45 { return .needsReview }
        return .weak
    }

    func weakDomains(for exam: ExamProfile, limit: Int = 2) -> [ExamDomain] {
        exam.domains
            .sorted { lhs, rhs in
                let lhsScore = attempts(for: exam.id).compactMap { $0.domainPercents[lhs.id] }.prefix(5).average ?? progress(for: lhs, in: exam)
                let rhsScore = attempts(for: exam.id).compactMap { $0.domainPercents[rhs.id] }.prefix(5).average ?? progress(for: rhs, in: exam)
                return lhsScore == rhsScore ? lhs.weight > rhs.weight : lhsScore < rhsScore
            }
            .prefix(limit)
            .map { $0 }
    }

    func recentAccuracy(for examID: String) -> Double? {
        let recent = attempts(for: examID).prefix(5)
        guard !recent.isEmpty else { return nil }
        return recent.map(\.percent).reduce(0, +) / Double(recent.count)
    }

    func confidenceAverage(for examID: String) -> Double {
        let recent = attempts(for: examID).prefix(8).compactMap(\.confidenceScore)
        guard !recent.isEmpty else { return 0 }
        return recent.reduce(0, +) / Double(recent.count)
    }

    func predictedPassChance(for exam: ExamProfile) -> Double {
        let plan = overallProgress(for: exam)
        let cards = flashcardProgress(for: exam)
        let practice = practiceProgress(for: exam)
        let progressBlend = (plan * 0.25) + (cards * 0.2) + (practice * 0.25)
        let attempts = attempts(for: exam.id)
        let accuracy = recentAccuracy(for: exam.id) ?? 0
        let examBlend = attempts.isEmpty ? 0 : accuracy * 0.3
        let target = attempts.first?.difficulty.readinessTarget ?? selectedDifficulty.readinessTarget
        let chance = (progressBlend + examBlend) / max(target, 0.1)
        return min(max(chance, 0.05), 0.98)
    }

    var recentAccuracy: Double {
        let recent = attemptsForSelectedExam.prefix(5)
        guard !recent.isEmpty else {
            return (overallProgress + flashcardProgress + practiceProgress) / 3
        }
        return recent.map(\.percent).reduce(0, +) / Double(recent.count)
    }

    var predictedPassChance: Double {
        let progressBlend = (overallProgress * 0.25) + (flashcardProgress * 0.2) + (practiceProgress * 0.25)
        let examBlend = attemptsForSelectedExam.isEmpty ? 0 : recentAccuracy * 0.3
        let base = attemptsForSelectedExam.isEmpty ? progressBlend : progressBlend + examBlend
        let chance = base / max(selectedDifficulty.readinessTarget, 0.1)
        return min(max(chance, 0.05), 0.98)
    }

    var totalStudyMinutes: Int {
        completedTaskIDs.compactMap { completedID in
            exam.studyTasks.first { $0.id == completedID }?.minutes
        }
        .reduce(0, +)
    }

    var estimatedDailyStreak: Int {
        currentAppOpenStreak()
    }

    var confidenceAverage: Double {
        let recent = attemptsForSelectedExam.prefix(8).compactMap(\.confidenceScore)
        guard !recent.isEmpty else { return 0 }
        return recent.reduce(0, +) / Double(recent.count)
    }

    var confidenceLabel: String {
        guard confidenceAverage > 0 else { return "Not learned yet" }
        if confidenceAverage >= 0.86 { return "Strong" }
        if confidenceAverage >= 0.68 { return "Mixed" }
        return "Guess-heavy"
    }

    var studyPlanRecommendation: StudyPlanRecommendation {
        let weak = weakDomains(limit: exam.domains.count)
        let progressGap = isFirstStudyRun ? 1 : 1 - min((overallProgress + flashcardProgress + practiceProgress) / 3, 1)
        let readinessGap = max(selectedDifficulty.readinessTarget - recentAccuracy, 0)
        let minimumDaily = max(Int(minutesPerDay), 30)
        let suggestedMinutes = isFirstStudyRun
            ? max(Int(minutesPerDay), 45)
            : min(180, max(minimumDaily, Int((45 + (progressGap * 55) + (readinessGap * 70)).rounded())))
        let recommendedDate: Date
        if isFirstStudyRun {
            recommendedDate = examDate
        } else {
            let recommendedDays = max(10, Int(ceil((Double(exam.studyTasks.count - completedTaskIDs.count) * 0.75) + (readinessGap * 24))))
            recommendedDate = Calendar.current.date(byAdding: .day, value: recommendedDays, to: .now) ?? examDate
        }
        let domains = weak.isEmpty ? exam.domains : weak

        let domainPlan = domains.map { domain in
            let readiness = objectiveReadiness(for: domain)
            let multiplier: Double
            switch readiness {
            case .mastered:
                multiplier = 0.7
            case .needsReview:
                multiplier = 1.0
            case .weak:
                multiplier = 1.35
            }
            let minutes = max(20, Int((Double(suggestedMinutes) * (Double(domain.weight) / 100.0) * multiplier).rounded()))
            return StudyDomainRecommendation(
                id: domain.id,
                domainTitle: domain.title,
                readiness: readiness,
                suggestedMinutes: minutes,
                focus: domain.focus
            )
        }

        let nextStep: String
        if isFirstStudyRun {
            nextStep = "First study run: take one 10-question Quick Practice test so StudyBuddy can measure your baseline and choose the next objective."
        } else if let firstWeak = domainPlan.first(where: { $0.readiness == .weak }) {
            nextStep = "Start with \(firstWeak.domainTitle), then run a targeted quick exam before moving on."
        } else if attemptsForSelectedExam.isEmpty {
            nextStep = "Complete one quick test so StudyBuddy can tune the plan with real performance data."
        } else {
            nextStep = "Keep cycling weak objectives, PBQs, and one full exam until your pass signal repeats."
        }

        return StudyPlanRecommendation(
            dailyMinutes: suggestedMinutes,
            recommendedExamDate: recommendedDate,
            confidenceSummary: confidenceLabel,
            nextStep: nextStep,
            domainPlan: domainPlan
        )
    }

    var resolvedAIServerURL: URL? {
        let trimmed = aiServerURL.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : URL(string: trimmed)
    }

    private static var defaultAIServerURL: String {
        "https://studybuddy-ai-server-m5zi.onrender.com"
    }

    private static func shouldReplaceSavedAIServerURL(_ savedURL: String?) -> Bool {
        guard let savedURL else { return true }
        let normalized = savedURL.trimmingCharacters(in: .whitespacesAndNewlines)
        return [
            "http://127.0.0.1:8787",
            "http://localhost:8787",
            "https://studybuddy-ai.example.com"
        ].contains(normalized)
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
            markStudyActivity()
        }
    }

    func toggleFlashcard(_ card: Flashcard) {
        if masteredCardIDs.contains(card.id) {
            masteredCardIDs.remove(card.id)
        } else {
            masteredCardIDs.insert(card.id)
            markStudyActivity()
        }
    }

    func markQuestionAnswered(_ question: PracticeQuestion) {
        answeredQuestionIDs.insert(question.id)
        markStudyActivity()
    }

    func startAIServerMonitoring() async {
        guard !aiServerMonitorStarted else { return }
        aiServerMonitorStarted = true
        defer { aiServerMonitorStarted = false }

        let startupRetryDelays: [UInt64] = [0, 3, 8, 15]
        for delaySeconds in startupRetryDelays {
            if delaySeconds > 0 {
                aiServerMessage = "AI tutor server is not reachable yet. Retrying automatically..."
                do {
                    try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
                } catch {
                    return
                }
            }

            await checkAIServerHealth()
            if aiServerStatus == .online { break }
        }

        while !Task.isCancelled {
            let delaySeconds: UInt64 = aiServerStatus == .online ? 300 : 30
            do {
                try await Task.sleep(nanoseconds: delaySeconds * 1_000_000_000)
            } catch {
                return
            }
            await checkAIServerHealth()
        }
    }

    func checkAIServerHealth() async {
        guard let baseURL = resolvedAIServerURL else {
            aiServerStatus = .offline
            aiServerMessage = "Add your StudyBuddy AI server URL in Settings."
            aiServerModel = "--"
            aiServerOpenAIConfigured = false
            aiServerOpenAIKeyStatus = "missing"
            return
        }

        aiServerStatus = .checking
        aiServerMessage = "Checking \(baseURL.absoluteString)..."

        var healthURL = baseURL
        healthURL.append(path: "health")

        var request = URLRequest(url: healthURL)
        request.timeoutInterval = 4

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                aiServerStatus = .offline
                aiServerMessage = "The AI server did not return a healthy response."
                aiServerModel = "--"
                aiServerOpenAIConfigured = false
                aiServerOpenAIKeyStatus = "missing"
                return
            }

            let health = try JSONDecoder().decode(AIServerHealthResponse.self, from: data)
            aiServerStatus = health.ok ? .online : .offline
            aiServerModel = health.model ?? "--"
            aiServerOpenAIConfigured = health.openaiConfigured ?? false
            aiServerOpenAIKeyStatus = health.openaiKeyStatus ?? (aiServerOpenAIConfigured ? "configured" : "missing")
            if health.ok && aiServerOpenAIKeyStatus == "invalid-prefix" {
                aiServerMessage = "AI server is online, but the saved key is not an OpenAI API key. OpenAI keys start with sk-."
            } else {
                aiServerMessage = health.ok
                    ? "AI tutor server is reachable for \(health.exams?.count ?? 0) StudyBuddy exams."
                    : "AI tutor server responded, but it is not healthy."
            }
        } catch {
            aiServerStatus = .offline
            aiServerMessage = "Could not reach the AI server: \(error.localizedDescription)"
            aiServerModel = "--"
            aiServerOpenAIConfigured = false
            aiServerOpenAIKeyStatus = "missing"
        }
    }

    func recordAttempt(_ attempt: ExamAttemptRecord) {
        examAttempts.insert(attempt, at: 0)
        markStudyActivity()
        if examAttempts.count > 40 {
            examAttempts = Array(examAttempts.prefix(40))
        }
    }

    func recordAppOpen(date: Date = .now) {
        appOpenDates.insert(Self.activityDateKey(for: date))
    }

    func objectiveReadiness(for domain: ExamDomain) -> ObjectiveReadiness {
        if let domainAccuracy = attemptsForSelectedExam.compactMap({ $0.domainPercents[domain.id] }).prefix(5).average {
            if domainAccuracy >= 0.85 { return .mastered }
            if domainAccuracy >= 0.65 { return .needsReview }
            return .weak
        }

        let domainProgress = progress(for: domain)
        if domainProgress >= 0.85 { return .mastered }
        if domainProgress >= 0.45 { return .needsReview }
        return .weak
    }

    func weakDomains(limit: Int = 2) -> [ExamDomain] {
        exam.domains
            .sorted { lhs, rhs in
                let lhsScore = attemptsForSelectedExam.compactMap { $0.domainPercents[lhs.id] }.prefix(5).average ?? progress(for: lhs)
                let rhsScore = attemptsForSelectedExam.compactMap { $0.domainPercents[rhs.id] }.prefix(5).average ?? progress(for: rhs)
                return lhsScore == rhsScore ? lhs.weight > rhs.weight : lhsScore < rhsScore
            }
            .prefix(limit)
            .map { $0 }
    }

    func resetProgress() {
        let defaults = UserDefaults.standard
        for exam in exams {
            [
                Keys.completedTasks,
                Keys.masteredCards,
                Keys.answeredQuestions,
                Keys.studyActivityDates
            ].forEach { key in
                defaults.removeObject(forKey: Self.scopedKey(key, examID: exam.id))
            }
        }

        completedTaskIDs = []
        masteredCardIDs = []
        answeredQuestionIDs = []
        studyActivityDates = []
        appOpenDates = []
        examAttempts = []
        selectedDifficulty = .realExam
        minutesPerDay = 45
        examDate = Calendar.current.date(byAdding: .day, value: 30, to: .now) ?? .now
        resetNavigationToken += 1
    }

    private func loadProgressForSelectedExam() {
        completedTaskIDs = Self.loadStringSet(key: Self.scopedKey(Keys.completedTasks, examID: selectedExamID))
        masteredCardIDs = Self.loadStringSet(key: Self.scopedKey(Keys.masteredCards, examID: selectedExamID))
        answeredQuestionIDs = Self.loadStringSet(key: Self.scopedKey(Keys.answeredQuestions, examID: selectedExamID))
        studyActivityDates = Self.loadStringSet(key: Self.scopedKey(Keys.studyActivityDates, examID: selectedExamID))
    }

    private func markStudyActivity(date: Date = .now) {
        studyActivityDates.insert(Self.activityDateKey(for: date))
    }

    private func currentStudyStreak(referenceDate: Date = .now) -> Int {
        Self.currentStudyStreak(from: studyActivityDates, referenceDate: referenceDate)
    }

    private func currentAppOpenStreak(referenceDate: Date = .now) -> Int {
        Self.currentStudyStreak(from: appOpenDates, referenceDate: referenceDate)
    }

    private static func currentStudyStreak(from activityDates: Set<String>, referenceDate: Date = .now) -> Int {
        guard !activityDates.isEmpty else { return 0 }
        var streak = 0
        var cursor = Calendar.current.startOfDay(for: referenceDate)

        while activityDates.contains(Self.activityDateKey(for: cursor)) {
            streak += 1
            guard let previous = Calendar.current.date(byAdding: .day, value: -1, to: cursor) else {
                break
            }
            cursor = previous
        }

        return streak
    }

    private static func activityDateKey(for date: Date) -> String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", components.year ?? 0, components.month ?? 0, components.day ?? 0)
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

    private static func saveGlobalStringSet(_ value: Set<String>, key: String) {
        guard let data = try? JSONEncoder().encode(Array(value)) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private static func loadAttempts() -> [ExamAttemptRecord] {
        guard let data = UserDefaults.standard.data(forKey: Keys.examAttempts),
              let attempts = try? JSONDecoder().decode([ExamAttemptRecord].self, from: data) else {
            return []
        }
        return attempts
    }

    private func saveAttempts() {
        guard let data = try? JSONEncoder().encode(examAttempts) else { return }
        UserDefaults.standard.set(data, forKey: Keys.examAttempts)
    }

    private static func loadOrCreateStudentID(defaults: UserDefaults) -> String {
        if let saved = defaults.string(forKey: Keys.aiStudentID), !saved.isEmpty {
            return saved
        }
        let created = UUID().uuidString
        defaults.set(created, forKey: Keys.aiStudentID)
        return created
    }
}

private extension Collection where Element == Double {
    var average: Double? {
        guard !isEmpty else { return nil }
        return reduce(0, +) / Double(count)
    }
}
