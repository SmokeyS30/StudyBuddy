import Foundation
import PDFKit
import SwiftUI
import UIKit

private enum StudyBuddyTab: Hashable {
    case today
    case plan
    case learn
    case practice
    case results
    case settings
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var selectedTab = StudyBuddyTab.today
    @State private var showSplash = true
    @State private var knownCompletedAchievementIDs: Set<String> = []
    @State private var celebratedAchievement: StudyAchievement?

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem { Label("Today", systemImage: "house") }
                    .tag(StudyBuddyTab.today)

                PlanView()
                    .tabItem { Label("Plan", systemImage: "calendar") }
                    .tag(StudyBuddyTab.plan)

                LearnView()
                    .tabItem { Label("Learn", systemImage: "book") }
                    .tag(StudyBuddyTab.learn)

                PracticeView()
                    .tabItem { Label("Practice", systemImage: "checkmark.seal") }
                    .tag(StudyBuddyTab.practice)

                ResultsView()
                    .tabItem { Label("Results", systemImage: "chart.line.uptrend.xyaxis") }
                    .tag(StudyBuddyTab.results)

                SettingsView(afterReset: returnToTodayAfterReset)
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .tag(StudyBuddyTab.settings)
            }

            if showSplash {
                WelcomeSplashView()
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }

            if let celebratedAchievement {
                AchievementCelebrationView(achievement: celebratedAchievement)
                    .transition(.opacity.combined(with: .scale(scale: 0.94)))
                    .zIndex(2)
            }
        }
        .onAppear {
            store.recordAppOpen()
            knownCompletedAchievementIDs = AchievementCatalog.completedIDs(store)
        }
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                store.recordAppOpen()
            }
        }
        .onChange(of: store.resetNavigationToken) {
            returnToTodayAfterReset()
        }
        .onChange(of: achievementCompletionSignature) {
            celebrateNewAchievementIfNeeded()
        }
        .task {
            await store.startAIServerMonitoring()
        }
        .task {
            guard showSplash else { return }
            try? await Task.sleep(nanoseconds: 5_000_000_000)
            withAnimation(.easeOut(duration: 0.45)) {
                showSplash = false
            }
        }
    }

    private var achievementCompletionSignature: String {
        AchievementCatalog.completedIDs(store).sorted().joined(separator: "|")
    }

    private func returnToTodayAfterReset() {
        withAnimation(.easeInOut(duration: 0.2)) {
            selectedTab = .today
        }
        knownCompletedAchievementIDs = AchievementCatalog.completedIDs(store)
    }

    private func celebrateNewAchievementIfNeeded() {
        let completed = AchievementCatalog.completedIDs(store)
        let newIDs = completed.subtracting(knownCompletedAchievementIDs)
        knownCompletedAchievementIDs = completed

        guard let newID = newIDs.sorted().first,
              let achievement = AchievementCatalog.achievements.first(where: { $0.id == newID }) else {
            return
        }

        withAnimation(.spring(response: 0.42, dampingFraction: 0.82)) {
            celebratedAchievement = achievement
        }

        Task {
            try? await Task.sleep(nanoseconds: 3_000_000_000)
            await MainActor.run {
                if celebratedAchievement?.id == achievement.id {
                    withAnimation(.easeOut(duration: 0.35)) {
                        celebratedAchievement = nil
                    }
                }
            }
        }
    }
}

struct WelcomeSplashView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.04, green: 0.10, blue: 0.20),
                    Color(red: 0.05, green: 0.31, blue: 0.34),
                    Color(red: 0.06, green: 0.42, blue: 0.31)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                VStack(spacing: 16) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 58, weight: .semibold))
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)

                    VStack(spacing: 8) {
                        Text("Welcome to")
                            .font(.title3.weight(.medium))
                            .foregroundStyle(.white.opacity(0.78))

                        Text("StudyBuddy")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }

                VStack(spacing: 12) {
                    Text(store.displayExamName)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Let’s get you exam-ready today.")
                        .font(.headline)
                        .foregroundStyle(.white.opacity(0.78))
                }
                .padding(.horizontal, 28)

                HStack(spacing: 12) {
                    SplashBadge(title: store.displayExamCode, systemImage: "number")
                    SplashBadge(title: "Welcome", systemImage: "sparkles")
                    SplashBadge(title: "Randomized", systemImage: "shuffle")
                }

                Spacer()

                ProgressView()
                    .tint(.white)
                    .padding(.bottom, 32)
            }
            .padding()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Welcome to StudyBuddy. \(store.displayExamName). Let's get you exam-ready today.")
    }
}

struct SplashBadge: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(.white.opacity(0.14), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(.white.opacity(0.22), lineWidth: 1)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.72)
    }
}

struct DashboardView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dashboardHeader
                    firstStudyCard
                    personalFocus
                    progressGrid
                    learningDashboard
                    achievements
                    adaptiveCoach
                    objectiveTracker
                    todayFocus
                    weakAreas
                    quickTips
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("StudyBuddy")
        }
    }

    private var dashboardHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(store.displayExamName)
                .font(.largeTitle.bold())
                .foregroundStyle(.primary)
                .lineLimit(2)
                .minimumScaleFactor(0.75)

            HStack(spacing: 12) {
                Label(store.displayExamCode, systemImage: "number")
                Label("\(store.daysUntilExam) days", systemImage: "clock")
                Label("\(Int(store.minutesPerDay)) min/day", systemImage: "timer")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .labelStyle(.titleAndIcon)

            Text(store.exam.summary)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            LinearGradient(colors: [.blue.opacity(0.18), .green.opacity(0.13)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 8, style: .continuous)
        )
    }

    @ViewBuilder
    private var personalFocus: some View {
        let focus = store.customFocus.trimmingCharacters(in: .whitespacesAndNewlines)
        if !focus.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                SectionHeader(title: "Personal Focus", systemImage: "pin")
                Text(focus)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var progressGrid: some View {
        let started = store.hasStartedStudying
        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricTile(title: "Plan", value: started ? store.overallProgress : 0, systemImage: "list.bullet.clipboard", tint: started ? .blue : .gray)
            MetricTile(title: "Cards", value: started ? store.flashcardProgress : 0, systemImage: "rectangle.stack", tint: started ? .orange : .gray)
            MetricTile(title: "Practice", value: started ? store.practiceProgress : 0, systemImage: "target", tint: started ? .green : .gray)
            MetricTile(title: "Readiness", value: started ? store.predictedPassChance : 0, systemImage: "chart.line.uptrend.xyaxis", tint: started ? .purple : .gray)
        }
    }

    private var learningDashboard: some View {
        let latest = store.attemptsForSelectedExam.first
        let started = store.hasStartedStudying
        return VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Learning Dashboard", systemImage: "gauge.with.dots.needle.67percent")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                StatPill(title: "Pass Prediction", value: started ? "\(Int(store.predictedPassChance * 100))%" : "--", systemImage: "checkmark.seal")
                StatPill(title: "Hours Studied", value: "\(store.totalStudyMinutes / 60)h", systemImage: "clock.badge.checkmark")
                StatPill(title: "Questions", value: "\(store.answeredQuestionIDs.count)", systemImage: "questionmark.circle")
                StatPill(title: "Streak", value: "\(store.estimatedDailyStreak)d", systemImage: "flame")
                StatPill(title: "Practice Exams", value: "\(store.attemptsForSelectedExam.count)", systemImage: "doc.text.magnifyingglass")
                StatPill(title: "PBQ Score", value: started ? latest.map { "\(Int($0.pbqPercent * 100))%" } ?? "--" : "--", systemImage: "puzzlepiece.extension")
                StatPill(title: "Confidence", value: started && store.confidenceAverage > 0 ? "\(Int(store.confidenceAverage * 100))%" : "--", systemImage: "waveform.path.ecg")
            }
        }
    }

    @ViewBuilder
    private var firstStudyCard: some View {
        if store.isFirstStudyRun {
            VStack(alignment: .leading, spacing: 12) {
                Label("First Study Run", systemImage: "sparkles")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.blue)

                Text("StudyBuddy set a starter plan: test in \(store.daysUntilExam) days and study \(Int(store.minutesPerDay)) minutes per day.")
                    .font(.headline)

                Text("Take one 10-question Quick Practice test first. After that, the dashboard, plan, readiness, weak objectives, and achievements start opening up with real data.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.blue.opacity(0.24), lineWidth: 1)
            }
        }
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Achievements", systemImage: "trophy")

            ForEach(AchievementCatalog.achievements) { achievement in
                AchievementProgressRow(achievement: achievement)
                    .environmentObject(store)
            }
        }
    }

    private var adaptiveCoach: some View {
        let weak = store.weakDomains(limit: 1).first
        return VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Adaptive Coach", systemImage: "brain.head.profile")

            VStack(alignment: .leading, spacing: 10) {
                Text(store.isFirstStudyRun ? "StudyBuddy is waiting for your first Quick Practice baseline." : weak.map { "StudyBuddy noticed \(store.objectiveReadiness(for: $0).rawValue.lowercased()) performance in \($0.title)." } ?? "StudyBuddy will personalize your next assignments after your first practice exam.")
                    .font(.headline)

                if store.isFirstStudyRun {
                    AdaptiveAssignmentRow(title: "Baseline first", detail: "Start with Practice > Quick so StudyBuddy can learn where to route you next.", systemImage: "play.circle")
                    AdaptiveAssignmentRow(title: "Default plan", detail: "\(Int(store.minutesPerDay)) minutes per day until \(store.examDate.formatted(date: .abbreviated, time: .omitted)).", systemImage: "calendar.badge.clock")
                } else if let weak {
                    AdaptiveAssignmentRow(title: "30 targeted questions", detail: weak.title, systemImage: "target")
                    AdaptiveAssignmentRow(title: "Spaced flashcards", detail: "Weak terms return more often.", systemImage: "rectangle.stack.badge.person.crop")
                    AdaptiveAssignmentRow(title: "PBQ drill", detail: "Scenario practice mapped to \(weak.title).", systemImage: "puzzlepiece.extension")
                    AdaptiveAssignmentRow(title: "Video and PBQ review", detail: "Use linked lessons and scenario drills after misses.", systemImage: "play.rectangle")
                    AdaptiveAssignmentRow(title: "Targeted exam rebuild", detail: "Next practice set prioritizes \(weak.title) and your selected difficulty.", systemImage: "wand.and.stars")
                } else {
                    AdaptiveAssignmentRow(title: "Start with Real Exam Mode", detail: "The first scored attempt unlocks objective-level routing.", systemImage: "checkmark.seal")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private var objectiveTracker: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Objective Tracker", systemImage: "checklist.checked")

            if store.isFirstStudyRun {
                ForEach(store.exam.domains) { domain in
                    StarterObjectiveRow(domain: domain)
                }
            } else {
                ForEach(store.exam.domains) { domain in
                    ObjectiveReadinessRow(
                        domain: domain,
                        readiness: store.objectiveReadiness(for: domain),
                        progress: store.progress(for: domain)
                    )
                }
            }
        }
    }

    private var todayFocus: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Today", systemImage: "sun.max")

            ForEach(store.todaysTasks()) { task in
                TaskRow(task: task, isComplete: store.completedTaskIDs.contains(task.id)) {
                    store.toggleTask(task)
                }
            }
        }
    }

    private var weakAreas: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Focus Areas", systemImage: "scope")

            ForEach(store.exam.domains.sorted { store.progress(for: $0) < store.progress(for: $1) }) { domain in
                DomainProgressRow(domain: domain, progress: store.progress(for: domain))
            }
        }
    }

    private var quickTips: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Coach Notes", systemImage: "lightbulb")

            ForEach(store.exam.quickTips.prefix(3), id: \.self) { tip in
                Text(tip)
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }
}

struct ResultsView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var selectedExamID = ""

    private var selectedExam: ExamProfile {
        let examID = selectedExamID.isEmpty ? store.selectedExamID : selectedExamID
        return store.exams.first { $0.id == examID } ?? store.exam
    }

    private var attempts: [ExamAttemptRecord] {
        store.attempts(for: selectedExam.id)
    }

    private var latestAttempt: ExamAttemptRecord? {
        attempts.first
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    examPicker
                    resultsSummary
                    progressMetrics
                    scoreTrend
                    objectiveResults
                    adaptiveResultsCoach
                    attemptHistory
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Results")
            .onAppear {
                if selectedExamID.isEmpty {
                    selectedExamID = store.selectedExamID
                }
            }
        }
    }

    private var examPicker: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "Exam Results", systemImage: "chart.line.uptrend.xyaxis")

            Picker("Exam", selection: $selectedExamID) {
                ForEach(store.exams) { exam in
                    Text(exam.code).tag(exam.id)
                }
            }
            .pickerStyle(.segmented)

            Text(selectedExam.name)
                .font(.headline)
                .foregroundStyle(.secondary)
        }
    }

    private var resultsSummary: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(latestAttempt.map { $0.didPass ? "Estimated Pass Signal" : "Not Yet Passing" } ?? "No Exam Results Yet")
                        .font(.title2.bold())
                        .foregroundStyle(latestAttempt?.didPass == true ? .green : .primary)

                    Text(summaryCopy)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Image(systemName: latestAttempt?.didPass == true ? "checkmark.seal.fill" : "chart.bar.doc.horizontal")
                    .font(.title)
                    .foregroundStyle(latestAttempt?.didPass == true ? .green : .blue)
            }

            HStack(spacing: 12) {
                ResultsMetricCard(title: "Latest Score", value: latestAttempt.map { "\($0.scaledScore)" } ?? "--", detail: latestAttempt.map { "Pass: \($0.passingScore)" } ?? "Take a test", tint: .blue)
                ResultsMetricCard(title: "Readiness", value: "\(Int(store.predictedPassChance(for: selectedExam) * 100))%", detail: readinessLabel, tint: .purple)
            }

            if let latestAttempt {
                Text("Last attempt: \(latestAttempt.date.formatted(date: .abbreviated, time: .shortened)) · \(latestAttempt.title) · \(latestAttempt.difficulty.title)")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var progressMetrics: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Progress Snapshot", systemImage: "gauge.with.dots.needle.67percent")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                StatPill(title: "Attempts", value: "\(attempts.count)", systemImage: "doc.text.magnifyingglass")
                StatPill(title: "Study Time", value: "\(store.totalStudyMinutes(for: selectedExam) / 60)h", systemImage: "clock.badge.checkmark")
                StatPill(title: "Streak", value: "\(store.studyStreak(for: selectedExam.id))d", systemImage: "flame")
                StatPill(title: "Confidence", value: confidenceText, systemImage: "waveform.path.ecg")
                StatPill(title: "Questions", value: "\(store.answeredQuestionIDs(for: selectedExam.id).count)", systemImage: "questionmark.circle")
                StatPill(title: "PBQ Avg", value: pbqAverageText, systemImage: "puzzlepiece.extension")
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                MetricTile(title: "Plan Tasks", value: store.overallProgress(for: selectedExam), systemImage: "list.bullet.clipboard", tint: .blue)
                MetricTile(title: "Flashcards", value: store.flashcardProgress(for: selectedExam), systemImage: "rectangle.stack", tint: .orange)
                MetricTile(title: "Practice", value: store.practiceProgress(for: selectedExam), systemImage: "target", tint: .green)
                MetricTile(title: "Recent Accuracy", value: store.recentAccuracy(for: selectedExam.id) ?? 0, systemImage: "percent", tint: .purple)
            }
        }
    }

    @ViewBuilder
    private var scoreTrend: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Score Trend", systemImage: "point.topleft.down.curvedto.point.bottomright.up")

            if attempts.isEmpty {
                EmptyResultsCard(
                    title: "No trend yet",
                    detail: "Finish a Quick Practice set or Real Exam Mode attempt and StudyBuddy will start charting your score movement here."
                )
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    Text(scoreTrendSummary)
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    ForEach(Array(Array(attempts.prefix(6)).reversed())) { attempt in
                        ScoreTrendRow(attempt: attempt)
                    }
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var objectiveResults: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Objective Results", systemImage: "checklist.checked")

            ForEach(selectedExam.domains) { domain in
                ResultsDomainRow(
                    domain: domain,
                    readiness: store.objectiveReadiness(for: domain, in: selectedExam),
                    latestScore: latestAttempt?.domainPercents[domain.id],
                    planProgress: store.progress(for: domain, in: selectedExam)
                )
            }
        }
    }

    private var adaptiveResultsCoach: some View {
        let weak = store.weakDomains(for: selectedExam, limit: 2)
        return VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "What To Do Next", systemImage: "brain.head.profile")

            VStack(alignment: .leading, spacing: 10) {
                Text(nextStepCopy(weakDomains: weak))
                    .font(.headline)

                if attempts.isEmpty {
                    AdaptiveAssignmentRow(title: "Start baseline", detail: "Take one Quick Practice set so this page can measure your starting point.", systemImage: "play.circle")
                } else {
                    AdaptiveAssignmentRow(title: "Targeted recovery exam", detail: weak.first.map { "Practice should prioritize \($0.title)." } ?? "Practice should rotate all objectives.", systemImage: "wand.and.stars")
                    AdaptiveAssignmentRow(title: "Confidence repair", detail: confidenceCoachingCopy, systemImage: "waveform.path.ecg")
                    AdaptiveAssignmentRow(title: "PBQ drill", detail: "Repeat PBQ-style drills until the PBQ average stays above 80%.", systemImage: "puzzlepiece.extension")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }

    private var attemptHistory: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Attempt History", systemImage: "clock.arrow.circlepath")

            if attempts.isEmpty {
                EmptyResultsCard(
                    title: "Nothing recorded yet",
                    detail: "Scores appear after you finish Quick Practice or an Exam simulation from the Practice tab."
                )
            } else {
                ForEach(attempts.prefix(12)) { attempt in
                    AttemptHistoryRow(attempt: attempt)
                }
            }
        }
    }

    private var summaryCopy: String {
        guard let latestAttempt else {
            return "This screen tracks each exam separately. Start a practice set to unlock scores, objective progress, PBQ averages, confidence, and next-step coaching."
        }

        if latestAttempt.didPass && store.predictedPassChance(for: selectedExam) >= 0.85 {
            return "You are building a repeatable pass signal. Keep the streak alive and confirm it with another randomized exam."
        }

        if latestAttempt.didPass {
            return "Good latest score. StudyBuddy still checks confidence and weak objectives before calling it exam-ready."
        }

        return "This exam needs more targeted work. Use the weakest objectives below for your next study block and recovery exam."
    }

    private var readinessLabel: String {
        let chance = store.predictedPassChance(for: selectedExam)
        if chance >= 0.85 { return "Strong" }
        if chance >= 0.65 { return "Building" }
        return "Needs work"
    }

    private var confidenceText: String {
        let average = store.confidenceAverage(for: selectedExam.id)
        return average > 0 ? "\(Int(average * 100))%" : "--"
    }

    private var confidenceCoachingCopy: String {
        let average = store.confidenceAverage(for: selectedExam.id)
        if average == 0 { return "Complete a few attempts so StudyBuddy can infer known answers, narrowed choices, and guesses." }
        if average < 0.68 { return "Too many answers are guess-heavy. Slow down and review the explanations after each attempt." }
        return "Confidence is improving. StudyBuddy will keep using timing, changes, flags, and results to keep readiness realistic."
    }

    private var pbqAverageText: String {
        let recent = attempts.prefix(5).map(\.pbqPercent)
        guard !recent.isEmpty else { return "--" }
        return "\(Int((recent.reduce(0, +) / Double(recent.count)) * 100))%"
    }

    private var scoreTrendSummary: String {
        guard attempts.count >= 2,
              let latest = attempts.first,
              let previous = attempts.dropFirst().first else {
            return "StudyBuddy will compare your latest attempt against the previous one after you finish at least two attempts."
        }

        let delta = latest.percent - previous.percent
        if abs(delta) < 0.02 {
            return "Your latest score is about even with the prior attempt. Use objective results to break the plateau."
        }
        if delta > 0 {
            return "Your latest score improved by \(Int(delta * 100)) percentage points. Repeat it once more before trusting the trend."
        }
        return "Your latest score dropped by \(Int(abs(delta) * 100)) percentage points. Review the weak objectives before another full attempt."
    }

    private func nextStepCopy(weakDomains: [ExamDomain]) -> String {
        guard !attempts.isEmpty else {
            return "Start with one baseline test. After that, StudyBuddy can recommend the right recovery path for this exam."
        }

        if let first = weakDomains.first {
            return "Next study block: \(first.title). Spend \(max(20, Int(store.minutesPerDay / 2))) minutes there, then run a fresh targeted practice set."
        }

        return "No single objective is standing out as weak. Rotate PBQs, flashcards, and one full exam attempt."
    }
}

struct ResultsMetricCard: View {
    let title: String
    let value: String
    let detail: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(value)
                .font(.title.bold().monospacedDigit())
                .foregroundStyle(tint)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.subheadline.weight(.semibold))
            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct ScoreTrendRow: View {
    let attempt: ExamAttemptRecord

    private var tint: Color {
        attempt.didPass ? .green : .orange
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack {
                Text(attempt.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(attempt.scaledScore)")
                    .font(.caption.weight(.bold).monospacedDigit())
                    .foregroundStyle(tint)
            }

            ProgressView(value: attempt.percent)
                .tint(tint)

            Text("\(attempt.title) · \(attempt.difficulty.title) · \(Int(attempt.percent * 100))%")
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
    }
}

struct ResultsDomainRow: View {
    let domain: ExamDomain
    let readiness: ObjectiveReadiness
    let latestScore: Double?
    let planProgress: Double

    private var displayScore: Double {
        latestScore ?? planProgress
    }

    private var tint: Color {
        switch readiness {
        case .mastered:
            return .green
        case .needsReview:
            return .yellow
        case .weak:
            return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(domain.title)
                        .font(.headline)
                    Text(latestScore == nil ? "Plan progress shown until an exam result exists." : "Latest scored attempt")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(Int(displayScore * 100))%")
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(tint)
                    Text(readiness.rawValue)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(tint)
                }
            }

            ProgressView(value: displayScore)
                .tint(tint)

            Text(domain.focus)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct AttemptHistoryRow: View {
    let attempt: ExamAttemptRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(attempt.title)
                        .font(.headline)
                    Text(attempt.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(attempt.scaledScore)")
                        .font(.title3.bold().monospacedDigit())
                        .foregroundStyle(attempt.didPass ? .green : .orange)
                    Text(attempt.didPass ? "Pass signal" : "Review")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(attempt.didPass ? .green : .orange)
                }
            }

            ProgressView(value: attempt.percent)
                .tint(attempt.didPass ? .green : .orange)

            HStack {
                Label("\(Int(attempt.percent * 100))%", systemImage: "percent")
                Label("\(Int(attempt.pbqPercent * 100))% PBQ", systemImage: "puzzlepiece.extension")
                Label(attempt.difficulty.title, systemImage: "speedometer")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.72)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct EmptyResultsCard: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(detail)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

@MainActor
enum AchievementCatalog {
    static let achievements: [StudyAchievement] = [
        StudyAchievement(
            id: "baseline-breaker",
            title: "Baseline Breaker",
            detail: "Complete your first practice attempt for this exam.",
            systemImage: "flag.checkered",
            metric: .baselineAttempt,
            target: 1,
            unitLabel: "attempt"
        ),
        StudyAchievement(
            id: "question-marathon",
            title: "Question Marathon",
            detail: "Answer 250 practice questions for this exam.",
            systemImage: "figure.run",
            metric: .questionsAnswered,
            target: 250,
            unitLabel: "questions"
        ),
        StudyAchievement(
            id: "perfect-quick",
            title: "Perfect Quick Run",
            detail: "Score 100% on a 10-question Quick Practice set.",
            systemImage: "10.circle",
            metric: .perfectQuick,
            target: 1,
            unitLabel: "perfect run"
        ),
        StudyAchievement(
            id: "triple-pass",
            title: "Triple Pass Signal",
            detail: "Pass Real Exam Mode three times for the selected exam.",
            systemImage: "checkmark.seal",
            metric: .realExamPasses,
            target: 3,
            unitLabel: "passes"
        ),
        StudyAchievement(
            id: "pbq-champion",
            title: "PBQ Champion",
            detail: "Earn 80% or better on PBQs in five scored attempts.",
            systemImage: "puzzlepiece.extension",
            metric: .pbqStrongAttempts,
            target: 5,
            unitLabel: "strong PBQs"
        ),
        StudyAchievement(
            id: "nightmare-survivor",
            title: "Nightmare Survivor",
            detail: "Hit a 90% score in Nightmare Mode.",
            systemImage: "moon.stars",
            metric: .nightmarePass,
            target: 1,
            unitLabel: "run"
        ),
        StudyAchievement(
            id: "thirty-day-flame",
            title: "30-Day Flame",
            detail: "Build a 30-day study streak.",
            systemImage: "flame",
            metric: .studyStreak,
            target: 30,
            unitLabel: "days"
        ),
        StudyAchievement(
            id: "objective-sweeper",
            title: "Objective Sweeper",
            detail: "Complete every planned study task for this exam.",
            systemImage: "checklist.checked",
            metric: .planComplete,
            target: 1,
            unitLabel: "plan"
        ),
        StudyAchievement(
            id: "card-master",
            title: "Card Master",
            detail: "Master every flashcard in the selected exam deck.",
            systemImage: "rectangle.stack.badge.checkmark",
            metric: .flashcardsMastered,
            target: 1,
            unitLabel: "deck"
        ),
        StudyAchievement(
            id: "confidence-climber",
            title: "Confidence Climber",
            detail: "Reach a strong inferred confidence signal across at least three attempts.",
            systemImage: "waveform.path.ecg",
            metric: .confidenceStrong,
            target: 0.86,
            unitLabel: "signal"
        )
    ]

    static func completedIDs(_ store: StudyBuddyStore) -> Set<String> {
        Set(achievements.filter { progress(for: $0, store: store) >= 1 }.map(\.id))
    }

    static func progress(for achievement: StudyAchievement, store: StudyBuddyStore) -> Double {
        let raw = rawValue(for: achievement, store: store)
        switch achievement.metric {
        case .planComplete, .flashcardsMastered:
            return min(max(raw, 0), 1)
        case .confidenceStrong:
            guard store.attemptsForSelectedExam.count >= 3 else { return 0 }
            return min(max(raw / max(achievement.target, 0.1), 0), 1)
        default:
            return min(max(raw / max(achievement.target, 1), 0), 1)
        }
    }

    static func progressText(for achievement: StudyAchievement, store: StudyBuddyStore) -> String {
        let raw = rawValue(for: achievement, store: store)
        switch achievement.metric {
        case .planComplete, .flashcardsMastered:
            return "\(Int(progress(for: achievement, store: store) * 100))%"
        case .confidenceStrong:
            let attempts = store.attemptsForSelectedExam.count
            return attempts < 3 ? "\(attempts)/3 attempts" : "\(confidenceLabel(raw))"
        default:
            return "\(Int(min(raw, achievement.target)))/\(Int(achievement.target)) \(achievement.unitLabel)"
        }
    }

    private static func rawValue(for achievement: StudyAchievement, store: StudyBuddyStore) -> Double {
        let attempts = store.attemptsForSelectedExam
        switch achievement.metric {
        case .baselineAttempt:
            return attempts.isEmpty ? 0 : 1
        case .questionsAnswered:
            return Double(store.lifetimeQuestionWork)
        case .perfectQuick:
            return attempts.contains { $0.sessionMode == .quick && $0.percent >= 1.0 } ? 1 : 0
        case .realExamPasses:
            return Double(attempts.filter { $0.sessionMode == .realExam && $0.didPass }.count)
        case .pbqStrongAttempts:
            return Double(attempts.filter { $0.pbqPercent >= 0.8 }.count)
        case .nightmarePass:
            return attempts.contains { $0.sessionMode == .nightmareMode && $0.percent >= 0.9 } ? 1 : 0
        case .studyStreak:
            return Double(store.estimatedDailyStreak)
        case .planComplete:
            return store.overallProgress
        case .flashcardsMastered:
            return store.flashcardProgress
        case .confidenceStrong:
            return store.confidenceAverage
        }
    }

    private static func confidenceLabel(_ value: Double) -> String {
        if value >= 0.86 { return "Strong signal" }
        if value >= 0.68 { return "Building signal" }
        return "Guess-heavy"
    }
}

struct AchievementProgressRow: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let achievement: StudyAchievement

    private var progress: Double {
        AchievementCatalog.progress(for: achievement, store: store)
    }

    private var isComplete: Bool {
        progress >= 1
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isComplete ? "checkmark.seal.fill" : achievement.systemImage)
                    .font(.title3)
                    .foregroundStyle(isComplete ? .green : .blue)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(achievement.title)
                            .font(.headline)
                        Spacer()
                        Text(AchievementCatalog.progressText(for: achievement, store: store))
                            .font(.caption.weight(.bold).monospacedDigit())
                            .foregroundStyle(isComplete ? .green : .secondary)
                    }

                    Text(achievement.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            ProgressView(value: progress)
                .tint(isComplete ? .green : .blue)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(isComplete ? Color.green.opacity(0.32) : Color.clear, lineWidth: 1)
        }
    }
}

struct AchievementCelebrationView: View {
    let achievement: StudyAchievement
    @State private var animate = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.38)
                .ignoresSafeArea()

            ForEach(0..<28, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2, style: .continuous)
                    .fill(confettiColor(index))
                    .frame(width: CGFloat(8 + (index % 4) * 3), height: CGFloat(18 + (index % 3) * 5))
                    .rotationEffect(.degrees(animate ? Double(index * 31) : Double(index * 9)))
                    .offset(
                        x: CGFloat((index % 7) - 3) * 52,
                        y: animate ? CGFloat(240 + (index % 5) * 42) : -220
                    )
                    .opacity(animate ? 0.88 : 0)
                    .animation(.easeOut(duration: 1.5).delay(Double(index % 7) * 0.05), value: animate)
            }

            VStack(spacing: 18) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 58, weight: .bold))
                    .foregroundStyle(.yellow)
                    .symbolEffect(.bounce, value: animate)

                Text("Achievement Complete")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)

                Text(achievement.title)
                    .font(.title2.weight(.heavy))
                    .foregroundStyle(.blue)
                    .multilineTextAlignment(.center)

                Text("Great work. This one took real progress.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(28)
            .frame(maxWidth: 330)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.white.opacity(0.35), lineWidth: 1)
            }
            .scaleEffect(animate ? 1 : 0.86)
            .animation(.spring(response: 0.42, dampingFraction: 0.72), value: animate)
            .padding()
        }
        .onAppear {
            animate = true
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Achievement complete. \(achievement.title). Great work.")
    }

    private func confettiColor(_ index: Int) -> Color {
        [.yellow, .blue, .green, .orange, .purple, .pink][index % 6]
    }
}

struct StatPill: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.blue)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(.headline.monospacedDigit())
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.76)
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct AdaptiveAssignmentRow: View {
    let title: String
    let detail: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(.green)
                .frame(width: 22)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline.weight(.semibold))
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct ObjectiveReadinessRow: View {
    let domain: ExamDomain
    let readiness: ObjectiveReadiness
    let progress: Double

    private var tint: Color {
        switch readiness {
        case .mastered:
            return .green
        case .needsReview:
            return .yellow
        case .weak:
            return .red
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(tint)
                    .frame(width: 10, height: 10)
                Text(domain.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                Spacer()
                Text(readiness.rawValue)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(tint)
            }

            ProgressView(value: progress)
                .tint(tint)

            Text("\(domain.weight)% of exam blueprint")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct StarterObjectiveRow: View {
    let domain: ExamDomain

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Circle()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 10, height: 10)
                Text(domain.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                Spacer()
                Text("Waiting")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: 0)
                .tint(.gray)

            Text("Take a baseline Quick Practice test to unlock objective readiness.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct PlanView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        NavigationStack {
            List {
                firstStudyPlanIntro
                aiStudyTarget

                Section("Schedule") {
                    DatePicker("Exam date", selection: $store.examDate, displayedComponents: .date)
                    VStack(alignment: .leading) {
                        Text("Daily study target: \(Int(store.minutesPerDay)) minutes")
                        Slider(value: $store.minutesPerDay, in: 15...120, step: 5)
                    }
                }

                ForEach(store.exam.domains) { domain in
                    Section {
                        ForEach(store.tasks(for: domain)) { task in
                            VStack(alignment: .leading, spacing: 8) {
                                TaskRow(task: task, isComplete: store.completedTaskIDs.contains(task.id)) {
                                    store.toggleTask(task)
                                }

                                if store.completedTaskIDs.contains(task.id) {
                                    Label(taskFollowUp(for: domain), systemImage: store.objectiveReadiness(for: domain) == .weak ? "arrow.clockwise.circle" : "checkmark.seal")
                                        .font(.caption)
                                        .foregroundStyle(store.objectiveReadiness(for: domain) == .weak ? .orange : .secondary)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    } header: {
                        HStack {
                            Text(domain.title)
                            Spacer()
                            Text("\(domain.weight)%")
                        }
                    } footer: {
                        Text(domain.focus)
                    }
                }
            }
            .navigationTitle("Study Plan")
        }
    }

    @ViewBuilder
    private var firstStudyPlanIntro: some View {
        if store.isFirstStudyRun {
            Section("First-Time Setup") {
                VStack(alignment: .leading, spacing: 10) {
                    Label("Starter target: \(Int(store.minutesPerDay)) minutes per day", systemImage: "timer")
                        .font(.headline)
                    Label("Starter exam date: \(store.examDate.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar")
                        .font(.subheadline.weight(.semibold))
                    Text("Before StudyBuddy tells you what to study next, complete one 10-question Quick Practice test. That baseline unlocks objective routing, readiness estimates, weak areas, and achievement progress.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
    }

    private var aiStudyTarget: some View {
        let recommendation = store.studyPlanRecommendation
        return Section(
            header: Text("StudyBuddy AI Target"),
            footer: Text("This recommendation updates as you complete tasks, answer questions, generate confidence signals, and finish exams.")
        ) {
            VStack(alignment: .leading, spacing: 12) {
                Label("Recommended daily target: \(recommendation.dailyMinutes) minutes", systemImage: "timer")
                    .font(.headline)
                Label("Suggested exam date: \(recommendation.recommendedExamDate.formatted(date: .abbreviated, time: .omitted))", systemImage: "calendar.badge.clock")
                    .font(.subheadline.weight(.semibold))
                Label("Confidence: \(recommendation.confidenceSummary)", systemImage: "waveform.path.ecg")
                    .font(.subheadline.weight(.semibold))

                Text(recommendation.nextStep)
                    .font(.callout)
                    .foregroundStyle(.secondary)

                HStack {
                    Button {
                        store.minutesPerDay = Double(recommendation.dailyMinutes)
                    } label: {
                        Label("Apply Target", systemImage: "checkmark.circle")
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        store.examDate = recommendation.recommendedExamDate
                    } label: {
                        Label("Use Date", systemImage: "calendar")
                    }
                    .buttonStyle(.bordered)
                }

                Divider()

                ForEach(recommendation.domainPlan) { domain in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: readinessIcon(for: domain.readiness))
                            .foregroundStyle(readinessTint(for: domain.readiness))
                            .frame(width: 22)

                        VStack(alignment: .leading, spacing: 4) {
                            HStack {
                                Text(domain.domainTitle)
                                    .font(.subheadline.weight(.semibold))
                                Spacer()
                                Text("\(domain.suggestedMinutes) min")
                                    .font(.caption.weight(.bold).monospacedDigit())
                            }
                            Text(domain.focus)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    private func taskFollowUp(for domain: ExamDomain) -> String {
        switch store.objectiveReadiness(for: domain) {
        case .weak:
            return "Completed, but keep reviewing this area before moving on."
        case .needsReview:
            return "Good progress. Do a quick quiz before leaving this topic."
        case .mastered:
            return "Solid. Move to the next weakest category."
        }
    }

    private func readinessIcon(for readiness: ObjectiveReadiness) -> String {
        switch readiness {
        case .mastered:
            return "checkmark.circle.fill"
        case .needsReview:
            return "exclamationmark.circle.fill"
        case .weak:
            return "xmark.octagon.fill"
        }
    }

    private func readinessTint(for readiness: ObjectiveReadiness) -> Color {
        switch readiness {
        case .mastered:
            return .green
        case .needsReview:
            return .yellow
        case .weak:
            return .red
        }
    }
}

struct LearnView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var mode = LearnMode.objectives
    @State private var flashcardIndex = 0

    enum LearnMode: String, CaseIterable, Identifiable {
        case objectives = "Objectives"
        case flashcards = "Cards"
        case sheets = "Sheets"
        case videos = "Videos"
        case tips = "Tips"

        var id: String { rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Mode", selection: $mode) {
                    ForEach(LearnMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.menu)
                .padding()

                Group {
                    switch mode {
                    case .objectives:
                        ObjectiveList()
                    case .flashcards:
                        FlashcardDeck(index: $flashcardIndex)
                    case .sheets:
                        CheatSheetsList()
                    case .videos:
                        VideoResourcesList()
                    case .tips:
                        TipsList()
                    }
                }
            }
            .navigationTitle("Learn")
        }
    }
}

struct ObjectiveList: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        List {
            ForEach(store.exam.domains) { domain in
                Section {
                    ForEach(domain.objectives, id: \.self) { objective in
                        Label(objective, systemImage: "circle")
                            .labelStyle(.titleAndIcon)
                    }
                } header: {
                    HStack {
                        Text(domain.title)
                        Spacer()
                        Text("\(domain.weight)%")
                    }
                } footer: {
                    Text(domain.focus)
                }
            }
        }
    }
}

struct FlashcardDeck: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @Binding var index: Int
    @State private var showingAnswer = false
    @State private var deck: [Flashcard] = []

    var body: some View {
        let cards = deck.isEmpty ? store.exam.flashcards : deck

        if store.exam.flashcards.isEmpty {
            ContentUnavailableView("No Flashcards", systemImage: "rectangle.stack", description: Text("Add flashcards in ExamCatalog.swift."))
        } else {
            let card = cards[index % cards.count]

            VStack(spacing: 18) {
            Spacer(minLength: 12)

            VStack(alignment: .leading, spacing: 16) {
                Text(showingAnswer ? "Answer" : "Question")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text(showingAnswer ? card.back : card.front)
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 180, alignment: .topLeading)
                    .contentTransition(.opacity)
            }
            .padding(22)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .padding(.horizontal)
            .onTapGesture {
                withAnimation(.easeInOut) {
                    showingAnswer.toggle()
                }
            }

            if let domain = store.exam.domain(with: card.domainID) {
                Label(domain.title, systemImage: "tag")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Button {
                    previous(cards: cards)
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
                .buttonStyle(.bordered)

                Button {
                    store.toggleFlashcard(card)
                } label: {
                    Label(store.masteredCardIDs.contains(card.id) ? "Marked" : "Know It", systemImage: store.masteredCardIDs.contains(card.id) ? "checkmark.circle.fill" : "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)

                Button {
                    next(cards: cards)
                } label: {
                    Label("Next", systemImage: "chevron.right")
                }
                .buttonStyle(.bordered)
            }
            .labelStyle(.iconOnly)
            .controlSize(.large)

            Text("\(store.masteredCardIDs.count) of \(cards.count) mastered")
                .font(.footnote)
                .foregroundStyle(.secondary)

            Button {
                resetDeck()
            } label: {
                Label("Shuffle deck", systemImage: "shuffle")
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .background(Color(.systemGroupedBackground))
        .onAppear {
            if deck.isEmpty {
                resetDeck()
            }
        }
        .onChange(of: store.selectedExamID) {
            resetDeck()
        }
        }
    }

    private func previous(cards: [Flashcard]) {
        guard !cards.isEmpty else { return }
        showingAnswer = false
        index = (index - 1 + cards.count) % cards.count
    }

    private func next(cards: [Flashcard]) {
        guard !cards.isEmpty else { return }
        showingAnswer = false
        index = (index + 1) % cards.count
    }

    private func resetDeck() {
        let weakDomainIDs = Set(store.weakDomains(limit: 2).map(\.id))
        deck = store.exam.flashcards.shuffled().sorted {
            flashcardPriority($0, weakDomainIDs: weakDomainIDs) > flashcardPriority($1, weakDomainIDs: weakDomainIDs)
        }
        index = 0
        showingAnswer = false
    }

    private func flashcardPriority(_ card: Flashcard, weakDomainIDs: Set<String>) -> Int {
        var priority = 0
        if weakDomainIDs.contains(card.domainID) { priority += 2 }
        if !store.masteredCardIDs.contains(card.id) { priority += 1 }
        return priority
    }
}

struct TipsList: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        List {
            Section("Study Strategy") {
                ForEach(store.exam.quickTips, id: \.self) { tip in
                    Label(tip, systemImage: "sparkle")
                }
            }

            Section("Legal") {
                Text(store.exam.disclaimer)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct LabScenario: Identifiable, Hashable {
    let id: String
    let title: String
    let domainID: String
    let systemImage: String
    let scenario: String
    let objective: String
    let steps: [String]
    let successCriteria: [String]
}

struct HandsOnLabsList: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        List {
            Section {
                ForEach(labs) { lab in
                    NavigationLink {
                        InteractiveLabView(lab: lab)
                    } label: {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(lab.title, systemImage: lab.systemImage)
                                .font(.headline)
                            Text(lab.scenario)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .lineLimit(3)
                            if let domain = store.exam.domain(with: lab.domainID) {
                                Label(domain.title, systemImage: "tag")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            } header: {
                Text("Objective-Aligned Interactive Labs")
            } footer: {
                Text("These are original StudyBuddy labs mapped to exam objective areas. They are not official CompTIA labs or live exam PBQs.")
            }

            Section("Mobile Lab Tips") {
                Text("Use each lab like a ticket: read the scenario, complete steps in order, check success criteria, then run a quick practice set for the same domain.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var labs: [LabScenario] {
        if store.exam.id == ExamCatalog.securityPlus.id {
            return [
                LabScenario(id: "701-lab-firewall", title: "Firewall Rule Triage", domainID: "701-architecture", systemImage: "firewall", scenario: "A branch firewall allows broad inbound management access. Reduce exposure without blocking required business traffic.", objective: "Apply security principles to secure enterprise infrastructure.", steps: ["Identify the overly broad source and destination", "Preserve required service access", "Restrict management traffic to approved admin networks", "Add logging for denied management attempts", "Document the risk reduction and rollback path"], successCriteria: ["Least privilege is applied", "Required traffic still works", "Logging supports later review"]),
                LabScenario(id: "701-lab-incident", title: "Phishing Incident Ticket", domainID: "701-operations", systemImage: "tray.full", scenario: "A user reports a suspicious message with a URL and attachment. Triage it without spreading the threat.", objective: "Use data sources to support an investigation.", steps: ["Record sender, subject, URL, attachment hash, and recipient", "Search for additional recipients", "Preserve evidence before deleting artifacts", "Block malicious indicators through approved controls", "Notify the incident lead and document user guidance"], successCriteria: ["Evidence is preserved", "Scope is checked", "Containment is documented"]),
                LabScenario(id: "701-lab-logs", title: "Authentication Log Review", domainID: "701-operations", systemImage: "doc.text.magnifyingglass", scenario: "Successful MFA appears after impossible travel alerts. Decide what evidence proves compromise or false positive.", objective: "Analyze indicators of malicious activity.", steps: ["Compare sign-in times, IPs, user agent, and location", "Check MFA method and prompt history", "Review risky mailbox or privileged actions", "Revoke sessions if compromise is likely", "Write a concise incident note"], successCriteria: ["Account risk is classified", "Response action matches evidence", "Notes include indicators"])
            ]
        }

        if store.exam.id == ExamCatalog.aPlusCore1.id {
            return [
                LabScenario(id: "1201-lab-network", title: "DHCP and DNS Console", domainID: "1201-networking", systemImage: "network", scenario: "A workstation can ping an IP address but cannot browse by name after moving desks.", objective: "Diagnose wired and wireless symptoms with low-risk tools.", steps: ["Check link lights and adapter status", "Run IP configuration review", "Compare DNS server and gateway against a known-good device", "Flush or renew only after recording evidence", "Verify hostname and web access"], successCriteria: ["DNS vs DHCP is separated", "No destructive action is taken first", "Original workflow is verified"]),
                LabScenario(id: "1201-lab-printer", title: "Printer Defect Sort", domainID: "1201-hardware", systemImage: "printer", scenario: "Three printers report loose toner, missing inkjet lines, and thermal labels printing blank.", objective: "Match printer technology to first maintenance step.", steps: ["Identify printer technology first", "Map loose toner to fuser or media checks", "Map missing inkjet lines to cleaning and alignment", "Map blank thermal labels to media type and orientation", "Document likely first action for each"], successCriteria: ["Printer type drives the fix", "Parts are not replaced blindly", "Each symptom has a first check"]),
                LabScenario(id: "1201-lab-mobile", title: "Mobile Hardware Triage", domainID: "1201-mobile", systemImage: "iphone", scenario: "A phone overheats and charges only when the cable is held at an angle.", objective: "Recognize mobile charging, battery, and port symptoms safely.", steps: ["Stop unsafe charging behavior", "Inspect charger, cable, port debris, and physical damage", "Check battery health and swelling signs", "Test with known-good accessories", "Escalate repair if the port or battery is unsafe"], successCriteria: ["Safety is handled first", "Known-good testing is used", "Repair escalation is justified"])
            ]
        }

        return [
            LabScenario(id: "1202-lab-windows", title: "Windows Support Desktop", domainID: "1202-os", systemImage: "desktopcomputer", scenario: "A required service fails after each reboot and the user reports the problem began after an update.", objective: "Collect Windows evidence before repair.", steps: ["Open Services and check startup type", "Review Event Viewer or Reliability Monitor", "Check recent updates and startup changes", "Apply the least disruptive fix", "Restart and verify the service remains running"], successCriteria: ["Evidence source matches symptom", "Fix is reversible", "Verification survives reboot"]),
            LabScenario(id: "1202-lab-linux", title: "Linux Permission Terminal", domainID: "1202-os", systemImage: "terminal", scenario: "A script cannot run after being copied to a Linux workstation.", objective: "Use command-line tools to inspect file permissions.", steps: ["Use ls -l to inspect permissions", "Identify owner and group", "Use chmod only if execute permission is missing", "Use chown only if ownership is wrong", "Run the script and document the command used"], successCriteria: ["Permissions are inspected first", "chmod and chown are not confused", "The fix is verified"]),
            LabScenario(id: "1202-lab-malware", title: "Malware Response Flow", domainID: "1202-security", systemImage: "shield.lefthalf.filled", scenario: "A workstation shows browser redirects and unexpected startup entries.", objective: "Follow malware removal order without skipping containment.", steps: ["Identify symptoms and recent changes", "Quarantine or isolate according to policy", "Preserve useful logs and user data", "Remediate with updated tools", "Verify browser, startup, and network behavior", "Educate the user"], successCriteria: ["Order is defensible", "Evidence is not destroyed early", "Recovery is verified"])
        ]
    }
}

struct InteractiveLabView: View {
    let lab: LabScenario
    @State private var completedSteps: Set<Int> = []

    private var progress: Double {
        Double(completedSteps.count) / Double(max(lab.steps.count, 1))
    }

    var body: some View {
        List {
            Section("Scenario") {
                Text(lab.scenario)
                    .font(.callout)
                Label(lab.objective, systemImage: "checkmark.seal")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Section("Lab Steps") {
                ForEach(Array(lab.steps.enumerated()), id: \.offset) { index, step in
                    Button {
                        if completedSteps.contains(index) {
                            completedSteps.remove(index)
                        } else {
                            completedSteps.insert(index)
                        }
                    } label: {
                        HStack(alignment: .top, spacing: 12) {
                            Image(systemName: completedSteps.contains(index) ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(completedSteps.contains(index) ? .green : .secondary)
                            Text(step)
                                .foregroundStyle(.primary)
                            Spacer(minLength: 0)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Success Criteria") {
                ForEach(lab.successCriteria, id: \.self) { criterion in
                    Label(criterion, systemImage: "target")
                }
            }

            Section("Progress") {
                ProgressView(value: progress)
                Text("\(completedSteps.count) of \(lab.steps.count) steps complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Button {
                    completedSteps = []
                } label: {
                    Label("Reset Lab", systemImage: "arrow.clockwise")
                }
            }
        }
        .navigationTitle(lab.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheatSheet: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let sections: [(heading: String, bullets: [String])]

    static func == (lhs: CheatSheet, rhs: CheatSheet) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct CheatSheetsList: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        List {
            Section {
                ForEach(sheets) { sheet in
                    NavigationLink {
                        CheatSheetPDFScreen(sheet: sheet, examLabel: "\(store.displayExamName) \(store.displayExamCode)")
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Label(sheet.title, systemImage: "doc.richtext")
                                .font(.headline)
                            Text(sheet.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("In-App PDF Review Sheets")
            } footer: {
                Text("Each sheet opens as a generated PDF inside StudyBuddy and is mapped to the selected exam.")
            }

            Section("Current Exam") {
                Text("\(store.displayExamName) \(store.displayExamCode)")
                    .font(.callout.weight(.semibold))
            }
        }
    }

    private var sheets: [CheatSheet] {
        var common = [
            CheatSheet(id: "ports", title: "Ports and Protocols", subtitle: "Service clues, port numbers, and exam traps.", sections: [
                ("Must Know", ["DNS: 53 for name resolution", "DHCP: 67/68 for address leases", "HTTP/HTTPS: 80/443 for web traffic", "RDP: 3389 for Windows remote GUI", "SSH: 22 for secure terminal access"]),
                ("Exam Clue", ["If IP works but names fail, think DNS.", "If a device self-assigns 169.254.x.x, think DHCP path.", "If remote access is secure terminal, think SSH before Telnet."])
            ]),
            CheatSheet(id: "tcpip", title: "TCP/IP Troubleshooting", subtitle: "Fast path for DHCP, DNS, gateway, and routing symptoms.", sections: [
                ("Order", ["Check physical or radio link", "Check IP, subnet mask, gateway, and DNS", "Compare against a known-good device", "Use ping, traceroute, nslookup, and logs", "Verify the original user workflow"]),
                ("Common Patterns", ["APIPA means DHCP failed or cannot be reached.", "Wrong gateway breaks off-subnet traffic.", "Wrong DNS breaks names while IP connectivity may still work."])
            ]),
            CheatSheet(id: "cloud", title: "Cloud and Virtualization", subtitle: "Service models, snapshots, sync, and responsibility.", sections: [
                ("Models", ["IaaS: customer configures virtual infrastructure", "PaaS: customer deploys apps on provider platform", "SaaS: provider delivers the complete app"]),
                ("Traps", ["Snapshots are not independent backups.", "Offline file access usually needs explicit sync.", "Cloud questions often ask who owns the layer."])
            ])
        ]

        if store.exam.id == ExamCatalog.aPlusCore1.id {
            common += [
                CheatSheet(id: "hardware", title: "Core 1 Hardware", subtitle: "Storage, RAID, connectors, power, and printers.", sections: [
                    ("Storage", ["NVMe is a protocol over PCIe; M.2 is a form factor.", "RAID 0 improves performance but has no redundancy.", "RAID 1 mirrors but is not a backup."]),
                    ("Printers", ["Laser loose toner points to fuser or media.", "Inkjet missing lines points to cleaning, ink, or alignment.", "Thermal blank labels can be wrong media orientation."])
                ]),
                CheatSheet(id: "wifi", title: "Wi-Fi and Mobile", subtitle: "Bands, pairing, mobile safety, and laptop symptoms.", sections: [
                    ("Wireless", ["2.4 GHz usually travels farther; 5 GHz usually offers more throughput at shorter range.", "Interference, channel plan, AP placement, and roaming all matter.", "Guest isolation prevents access to internal resources."]),
                    ("Mobile", ["Swollen batteries are safety issues.", "Charging failures need known-good cable, charger, and port checks.", "App-specific failures often point to permissions or selected device settings."])
                ])
            ]
        } else if store.exam.id == ExamCatalog.securityPlus.id {
            common += [
                CheatSheet(id: "secops", title: "Security Operations", subtitle: "Incident response, SIEM, logs, and vulnerability priority.", sections: [
                    ("Incident Response", ["Prepare, detect/analyze, contain, eradicate, recover, learn.", "Containment should reduce harm while preserving evidence.", "Recovery must verify integrity and absence of reinfection."]),
                    ("Logs", ["Correlate identity, endpoint, DNS, firewall, proxy, cloud, and app logs.", "Process tree and command line matter for living-off-the-land activity.", "Missing logs create detection blind spots."])
                ]),
                CheatSheet(id: "crypto-risk", title: "Crypto and Risk", subtitle: "Security concepts, controls, and governance traps.", sections: [
                    ("Crypto", ["Hashing supports integrity and password verification.", "Encryption supports confidentiality.", "Digital signatures support integrity, authentication, and non-repudiation.", "Certificates bind identities to public keys."]),
                    ("Risk", ["Mitigate reduces likelihood or impact.", "Transfer shifts financial impact.", "Avoid removes the activity.", "Accept requires owner approval and residual risk documentation."])
                ])
            ]
        } else {
            common += [
                CheatSheet(id: "windows", title: "Windows Tools", subtitle: "Commands, consoles, and evidence sources for Core 2.", sections: [
                    ("Commands", ["ipconfig /all shows IP configuration.", "sfc /scannow checks protected system files.", "gpupdate refreshes Group Policy.", "diskpart manages disks, volumes, and partitions."]),
                    ("Consoles", ["Services checks startup type and dependencies.", "Event Viewer and Reliability Monitor show evidence over time.", "Task Manager helps scope startup and resource problems."])
                ]),
                CheatSheet(id: "malware", title: "Malware and Operations", subtitle: "Removal order, tickets, privacy, and change control.", sections: [
                    ("Malware Order", ["Identify symptoms", "Quarantine or isolate", "Disable restore points if required", "Remediate", "Update and scan", "Verify and educate"]),
                    ("Operations", ["Good tickets include symptoms, evidence, actions, results, verification, and user guidance.", "Production changes need approval, schedule, rollback, and communication."])
                ])
            ]
        }

        return common
    }
}

struct CheatSheetPDFScreen: View {
    let sheet: CheatSheet
    let examLabel: String

    var body: some View {
        CheatSheetPDFView(data: CheatSheetPDFRenderer.data(for: sheet, examLabel: examLabel))
            .navigationTitle(sheet.title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct CheatSheetPDFView: UIViewRepresentable {
    let data: Data

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.document = PDFDocument(data: data)
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = PDFDocument(data: data)
    }
}

enum CheatSheetPDFRenderer {
    static func data(for sheet: CheatSheet, examLabel: String) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)

        return renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = 36
            draw("StudyBuddy", at: &y, pageRect: pageRect, font: .boldSystemFont(ofSize: 14), color: .secondaryLabel)
            draw(sheet.title, at: &y, pageRect: pageRect, font: .boldSystemFont(ofSize: 26), color: .label)
            draw(examLabel, at: &y, pageRect: pageRect, font: .systemFont(ofSize: 14), color: .secondaryLabel)
            y += 10

            for section in sheet.sections {
                draw(section.heading, at: &y, pageRect: pageRect, font: .boldSystemFont(ofSize: 17), color: .label)
                for bullet in section.bullets {
                    draw("- \(bullet)", at: &y, pageRect: pageRect, font: .systemFont(ofSize: 13), color: .label, inset: 16)
                }
                y += 8
            }

            draw("Original StudyBuddy review material. Verify final exam objectives with the current vendor objective document before testing.", at: &y, pageRect: pageRect, font: .italicSystemFont(ofSize: 11), color: .secondaryLabel)
        }
    }

    private static func draw(
        _ text: String,
        at y: inout CGFloat,
        pageRect: CGRect,
        font: UIFont,
        color: UIColor,
        inset: CGFloat = 0
    ) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ]
        let rect = CGRect(x: 36 + inset, y: y, width: pageRect.width - 72 - inset, height: 90)
        let attributed = NSAttributedString(string: text, attributes: attributes)
        let height = attributed.boundingRect(with: rect.size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
        attributed.draw(in: CGRect(x: rect.minX, y: y, width: rect.width, height: ceil(height) + 4))
        y += ceil(height) + 8
    }
}

struct VideoResourcesList: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        List {
            Section {
                Link(destination: URL(string: "https://www.professormesser.com/")!) {
                    Label("Professor Messer", systemImage: "play.rectangle")
                }
                Link(destination: URL(string: "https://www.comptia.org/training/resources/exam-objectives")!) {
                    Label("CompTIA exam objectives", systemImage: "doc.text")
                }
                Link(destination: URL(string: "https://support.apple.com/guide/deployment/welcome/web")!) {
                    Label("Apple deployment reference", systemImage: "apple.logo")
                }
                Link(destination: URL(string: "https://learn.microsoft.com/windows/")!) {
                    Label("Microsoft Windows documentation", systemImage: "window.vertical.closed")
                }
            } header: {
                Text("Review After Misses")
            } footer: {
                Text("StudyBuddy routes missed questions to the weakest objective first. Use these sources for legal, high-quality review instead of copied exam-bank content.")
            }
        }
    }
}

struct PracticeView: View {
    enum PracticeMode: String, CaseIterable, Identifiable {
        case quick = "Quick"
        case exam = "Exam"

        var id: String { rawValue }
    }

    @EnvironmentObject private var store: StudyBuddyStore
    @State private var mode = PracticeMode.quick

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    Picker("Practice mode", selection: $mode) {
                        ForEach(PracticeMode.allCases) { mode in
                            Text(mode.rawValue).tag(mode)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Difficulty", selection: $store.selectedDifficulty) {
                        ForEach(StudyBuddyDifficultyLevel.allCases) { difficulty in
                            Text(difficulty.title).tag(difficulty)
                        }
                    }
                    .pickerStyle(.menu)

                    Text(store.selectedDifficulty.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()

                switch mode {
                case .quick:
                    QuickPracticeView()
                case .exam:
                    ExamSimulationListView()
                }
            }
            .navigationTitle("Practice")
        }
    }
}

struct QuickPracticeResponse: Identifiable, Hashable {
    let id = UUID()
    let question: PracticeQuestion
    let selectedIndex: Int
    let confidence: ConfidenceLevel

    var isCorrect: Bool {
        selectedIndex == question.answerIndex
    }
}

struct QuickPracticeView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var questions: [PracticeQuestion] = []
    @State private var index = 0
    @State private var selectedIndex: Int?
    @State private var correctCount = 0
    @State private var selectedConfidence = ConfidenceLevel.narrowed
    @State private var questionStartedAt = Date()
    @State private var responses: [QuickPracticeResponse] = []
    @State private var showResult = false

    var body: some View {
        VStack(spacing: 0) {
            if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle", description: Text("Add practice prompts in ExamCatalog.swift."))
            } else if showResult {
                QuickPracticeResultView(
                    questions: questions,
                    responses: responses,
                    difficulty: store.selectedDifficulty,
                    restart: restart
                )
            } else {
                questionContent
            }
        }
        .background(Color(.systemGroupedBackground))
        .toolbar {
            Button {
                restart()
            } label: {
                Label("Restart", systemImage: "arrow.clockwise")
            }
        }
        .onAppear {
            if questions.isEmpty {
                restart()
            }
        }
        .onChange(of: store.selectedExamID) {
            restart()
        }
        .onChange(of: store.selectedDifficulty) {
            restart()
        }
    }

    private var questionContent: some View {
        let question = questions[index]
        let answered = selectedIndex != nil

        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Text("Short Test: \(index + 1) of \(questions.count)")
                        .font(.subheadline.weight(.semibold))
                    Spacer()
                    Text(store.selectedDifficulty.title)
                        .font(.subheadline.weight(.semibold))
                }
                .foregroundStyle(.secondary)

                if let domain = store.exam.domain(with: question.domainID) {
                    Label(domain.title, systemImage: "tag")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                }

                Text(question.prompt)
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 8) {
                    Label("StudyBuddy confidence estimate", systemImage: "waveform.path.ecg")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)

                    ConfidenceEstimateCard(
                        confidence: answered ? selectedConfidence : nil,
                        detail: answered
                            ? "Estimated from answer time, correctness, and selected difficulty."
                            : "StudyBuddy will estimate this after you answer."
                    )
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(spacing: 10) {
                    ForEach(Array(question.choices.enumerated()), id: \.offset) { optionIndex, choice in
                        Button {
                            choose(optionIndex, for: question)
                        } label: {
                            HStack {
                                Text(choice)
                                    .multilineTextAlignment(.leading)
                                Spacer()
                                if answered {
                                    Image(systemName: iconName(for: optionIndex, answer: question.answerIndex))
                                }
                            }
                            .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                        }
                        .buttonStyle(.bordered)
                        .tint(tint(for: optionIndex, selected: selectedIndex, answer: question.answerIndex))
                        .disabled(answered)
                    }
                }

                if answered {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(selectedIndex == question.answerIndex ? "Correct" : "Review This")
                            .font(.headline)
                        Text(question.explanation)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                    Button {
                        index == questions.count - 1 ? finish() : advance()
                    } label: {
                        Label(index == questions.count - 1 ? "Finish" : "Next", systemImage: "arrow.right.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding()
        }
    }

    private func choose(_ optionIndex: Int, for question: PracticeQuestion) {
        guard selectedIndex == nil else { return }
        let elapsed = Date().timeIntervalSince(questionStartedAt)
        let inferredConfidence = ConfidenceEstimator.quickPractice(
            isCorrect: optionIndex == question.answerIndex,
            elapsedSeconds: elapsed,
            difficulty: store.selectedDifficulty
        )
        selectedConfidence = inferredConfidence
        selectedIndex = optionIndex
        store.markQuestionAnswered(question)
        responses.append(QuickPracticeResponse(question: question, selectedIndex: optionIndex, confidence: inferredConfidence))
        if optionIndex == question.answerIndex {
            correctCount += 1
        }
    }

    private func advance() {
        selectedIndex = nil
        selectedConfidence = .narrowed
        if index == questions.count - 1 {
            finish()
        } else {
            index += 1
            questionStartedAt = .now
        }
    }

    private func finish() {
        selectedIndex = nil
        showResult = true
        recordQuickAttempt()
    }

    private func restart() {
        let weakDomainIDs = Set(store.weakDomains(limit: 2).map(\.id))
        let activeExamDomainIDs = Set(store.exam.domains.map(\.id))
        let bank = ExamCatalog.practiceQuestions(
            for: store.exam.id,
            difficulty: store.selectedDifficulty,
            minimumCount: 80
        )
        .filter { activeExamDomainIDs.contains($0.domainID) }
        .shuffled()
        .sorted {
            quickPriority($0, weakDomainIDs: weakDomainIDs) > quickPriority($1, weakDomainIDs: weakDomainIDs)
        }
        questions = Array(bank.prefix(10))
        .map { $0.randomizedChoices() }
        index = 0
        selectedIndex = nil
        selectedConfidence = .narrowed
        questionStartedAt = .now
        correctCount = 0
        responses = []
        showResult = false
    }

    private func recordQuickAttempt() {
        guard !responses.isEmpty else { return }
        let percent = Double(correctCount) / Double(max(questions.count, 1))
        let passingScore = store.simulations.last?.passingScaledScore ?? 700
        let scaledScore = 100 + Int((800 * percent).rounded())
        let domainPercents = Dictionary(grouping: responses, by: { $0.question.domainID }).mapValues { domainResponses in
            let correct = domainResponses.filter(\.isCorrect).count
            return Double(correct) / Double(max(domainResponses.count, 1))
        }
        let confidenceScore = responses.map { $0.confidence.weight }.average ?? 0
        let attempt = ExamAttemptRecord(
            id: UUID(),
            examID: store.exam.id,
            simulationID: "quick-\(store.selectedDifficulty.rawValue)",
            title: "Quick Practice",
            date: .now,
            sessionMode: .quick,
            difficulty: store.selectedDifficulty,
            rawPoints: correctCount,
            possiblePoints: questions.count,
            scaledScore: scaledScore,
            passingScore: passingScore,
            percent: percent,
            durationSeconds: 0,
            flaggedCount: 0,
            guessedCount: responses.filter { $0.confidence == .guessed }.count,
            pbqPercent: 0,
            domainPercents: domainPercents,
            confidenceScore: confidenceScore
        )
        store.recordAttempt(attempt)

        guard let baseURL = store.resolvedAIServerURL else { return }
        let upload = AIExamAttemptUpload(
            studentId: store.aiStudentID,
            examID: store.exam.id,
            examName: store.displayExamName,
            examCode: store.displayExamCode,
            attempt: attempt,
            weakDomains: store.weakDomains(limit: 3).map(\.title)
        )

        Task {
            try? await StudyBuddyAIClient(baseURL: baseURL).recordAttempt(upload)
        }
    }

    private func quickPriority(_ question: PracticeQuestion, weakDomainIDs: Set<String>) -> Int {
        var priority = 0
        if weakDomainIDs.contains(question.domainID) { priority += 4 }
        if !store.answeredQuestionIDs.contains(question.id) { priority += 2 }
        return priority
    }

    private func tint(for optionIndex: Int, selected: Int?, answer: Int) -> Color {
        guard let selected else { return .blue }
        if optionIndex == answer { return .green }
        if optionIndex == selected { return .red }
        return .gray
    }

    private func iconName(for optionIndex: Int, answer: Int) -> String {
        optionIndex == answer ? "checkmark.circle.fill" : "circle"
    }
}

struct ConfidenceEstimateCard: View {
    let confidence: ConfidenceLevel?
    let detail: String

    private let levels = ConfidenceLevel.allCases

    private var progress: Double {
        guard let confidence,
              let index = levels.firstIndex(of: confidence) else { return 0 }
        return Double(index) / Double(max(levels.count - 1, 1))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.tertiarySystemFill))
                        .frame(height: 12)

                    Capsule()
                        .fill((confidence.map(levelTint) ?? .secondary).gradient)
                        .frame(width: confidence == nil ? 12 : max(12, proxy.size.width * progress), height: 12)

                    HStack {
                        ForEach(levels) { level in
                            Circle()
                                .fill(confidence == level ? levelTint(level) : Color(.systemBackground))
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Circle()
                                        .stroke(levelTint(level), lineWidth: confidence == level ? 3 : 2)
                                }
                                .overlay {
                                    Image(systemName: markerIcon(for: level))
                                        .font(.caption2.weight(.bold))
                                        .foregroundStyle(confidence == level ? .white : levelTint(level))
                                }

                            if level != levels.last {
                                Spacer()
                            }
                        }
                    }
                }
                .frame(height: 34)
            }
            .frame(height: 34)

            HStack {
                ForEach(levels) { level in
                    Text(level.title)
                        .font(.caption.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(confidence == level ? levelTint(level).opacity(0.18) : Color(.tertiarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(confidence == level ? levelTint(level) : Color.clear, lineWidth: 1.5)
                        }
                }
            }

            Text(detail)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("StudyBuddy confidence estimate. Current estimate: \(confidence?.title ?? "Not estimated yet")")
    }

    private func levelTint(_ level: ConfidenceLevel) -> Color {
        switch level {
        case .guessed:
            return .orange
        case .narrowed:
            return .blue
        case .knewIt:
            return .green
        }
    }

    private func markerIcon(for level: ConfidenceLevel) -> String {
        switch level {
        case .guessed:
            return "questionmark"
        case .narrowed:
            return "arrow.triangle.branch"
        case .knewIt:
            return "checkmark"
        }
    }
}

struct ConfidenceSignalBar: View {
    let value: Double

    private var clampedValue: Double {
        min(max(value, 0), 1)
    }

    private var markerColor: Color {
        if clampedValue >= 0.86 { return .green }
        if clampedValue >= 0.68 { return .blue }
        return .orange
    }

    private var signalLabel: String {
        if clampedValue >= 0.86 { return "Knew It" }
        if clampedValue >= 0.68 { return "Narrowed It" }
        return "Likely Guessed"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { proxy in
                let markerX = max(12, min(proxy.size.width - 12, proxy.size.width * clampedValue))

                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.orange, .blue, .green],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 14)

                    Circle()
                        .fill(markerColor)
                        .frame(width: 28, height: 28)
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 3)
                        }
                        .shadow(color: markerColor.opacity(0.34), radius: 8, x: 0, y: 3)
                        .offset(x: markerX - 14)
                }
                .frame(height: 30)
            }
            .frame(height: 30)

            HStack {
                Text("Guessing")
                Spacer()
                Text(signalLabel)
                    .foregroundStyle(markerColor)
                Spacer()
                Text("Knew It")
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(.secondary)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Confidence signal: \(signalLabel)")
    }
}

enum ConfidenceEstimator {
    static func quickPractice(isCorrect: Bool, elapsedSeconds: TimeInterval, difficulty: StudyBuddyDifficultyLevel) -> ConfidenceLevel {
        let fastLimit = difficulty == .beginner ? 9.0 : 14.0
        let slowLimit = difficulty == .nightmareMode ? 55.0 : 42.0

        if isCorrect && elapsedSeconds <= fastLimit {
            return .knewIt
        }

        if !isCorrect && elapsedSeconds <= fastLimit {
            return .guessed
        }

        if isCorrect && elapsedSeconds <= slowLimit {
            return .narrowed
        }

        return isCorrect ? .narrowed : .guessed
    }

    static func examItem(
        scoreRatio: Double,
        elapsedSeconds: TimeInterval,
        answerChanges: Int,
        wasFlagged: Bool,
        difficulty: StudyBuddyDifficultyLevel,
        isPerformanceBased: Bool
    ) -> ConfidenceLevel {
        let fastLimit = isPerformanceBased ? 35.0 : (difficulty == .beginner ? 10.0 : 16.0)
        let slowLimit = isPerformanceBased ? 120.0 : (difficulty == .nightmareMode ? 70.0 : 48.0)

        if scoreRatio >= 0.95 && elapsedSeconds <= fastLimit && answerChanges <= 1 && !wasFlagged {
            return .knewIt
        }

        if scoreRatio < 0.5 && (elapsedSeconds <= fastLimit || answerChanges == 0) {
            return .guessed
        }

        if wasFlagged || answerChanges >= 2 || elapsedSeconds >= slowLimit {
            return scoreRatio >= 0.5 ? .narrowed : .guessed
        }

        if scoreRatio >= 0.75 {
            return .narrowed
        }

        return .guessed
    }
}

struct QuickPracticeResultView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let questions: [PracticeQuestion]
    let responses: [QuickPracticeResponse]
    let difficulty: StudyBuddyDifficultyLevel
    let restart: () -> Void

    private var correctCount: Int {
        responses.filter(\.isCorrect).count
    }

    private var percent: Double {
        Double(correctCount) / Double(max(questions.count, 1))
    }

    private var confidenceAverage: Double {
        responses.map { $0.confidence.weight }.average ?? 0
    }

    private var weakestDomain: ExamDomain? {
        let grouped = Dictionary(grouping: responses, by: { $0.question.domainID })
        let weakestID = grouped
            .map { domainID, domainResponses in
                (domainID, Double(domainResponses.filter(\.isCorrect).count) / Double(max(domainResponses.count, 1)))
            }
            .sorted { $0.1 < $1.1 }
            .first?.0
        return weakestID.flatMap { store.exam.domain(with: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    Label(percent >= difficulty.readinessTarget ? "Strong Quick Score" : "Keep Training", systemImage: percent >= difficulty.readinessTarget ? "checkmark.seal.fill" : "target")
                        .font(.title2.bold())
                        .foregroundStyle(percent >= difficulty.readinessTarget ? .green : .orange)

                    Text("\(correctCount) / \(questions.count)")
                        .font(.system(size: 50, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    ProgressView(value: percent)
                        .tint(percent >= difficulty.readinessTarget ? .green : .orange)

                    Text("\(Int(percent * 100))% on \(difficulty.title)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "StudyBuddy Next Step", systemImage: "brain.head.profile")
                    Text(nextStep)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Confidence signal", systemImage: "waveform.path.ecg")
                            .font(.subheadline.weight(.semibold))
                        ConfidenceSignalBar(value: confidenceAverage)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "Review", systemImage: "doc.text.magnifyingglass")
                    ForEach(responses) { response in
                        VStack(alignment: .leading, spacing: 8) {
                            Label(response.isCorrect ? "Correct" : "Missed", systemImage: response.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .font(.caption.weight(.bold))
                                .foregroundStyle(response.isCorrect ? .green : .orange)
                            Text(response.question.prompt)
                                .font(.headline)
                            Text("Correct answer: \(response.question.choices[response.question.answerIndex])")
                                .font(.callout.weight(.semibold))
                            Text(response.question.explanation)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Label("Confidence: \(response.confidence.title)", systemImage: "waveform.path.ecg")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }

                Button {
                    restart()
                } label: {
                    Label("Start Fresh Targeted Set", systemImage: "shuffle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
            .padding()
        }
    }

    private var nextStep: String {
        if let weakestDomain {
            return "Your next quick set should keep pressure on \(weakestDomain.title). Study that objective for \(max(20, Int(store.minutesPerDay / 2))) minutes, then restart Quick Practice for a new batch."
        }
        if percent >= difficulty.readinessTarget && confidenceAverage >= 0.8 {
            return "This was a good signal. Move up one difficulty or run a full exam simulation."
        }
        return "Restart for a fresh batch. StudyBuddy will keep separating lucky answers from real mastery automatically."
    }
}

struct ExamSimulationListView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(simulationCards) { card in
                    NavigationLink {
                        ExamSimulatorView(
                            simulation: card.simulation,
                            exam: store.exam,
                            difficulty: card.difficulty,
                            sessionMode: card.mode,
                            focusDomainIDs: card.focusDomainIDs
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: card.systemImage)
                                    .foregroundStyle(card.tint)
                                Text(card.simulation.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }

                            Text(card.simulation.description)
                                .font(.callout)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 14) {
                                Label("\(card.simulation.timeLimitMinutes) min", systemImage: "clock")
                                Label("\(card.simulation.targetQuestionCount) questions", systemImage: "list.number")
                                Label("Pass \(card.simulation.passingScaledScore)", systemImage: "checkmark.seal")
                                Label(card.difficulty.title, systemImage: "speedometer")
                            }
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Label("Scoring note", systemImage: "info.circle")
                        .font(.headline)
                    Text("CompTIA's exact scoring algorithm is proprietary. StudyBuddy uses a CompTIA-style 100-900 scaled-score estimate with public pass thresholds and weighted practice items.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var simulationCards: [ExamModeCard] {
        guard let base = store.simulations.last else { return [] }
        let weakDomainIDs = Set(store.weakDomains(limit: 2).map(\.id))
        return [
            ExamModeCard(
                simulation: base.configured(
                    id: "\(base.id)-targeted",
                    title: "AI Targeted Recovery Exam",
                    description: "A fresh 25-question rebuild weighted toward your weakest objectives, confidence gaps, and selected difficulty.",
                    timeLimitMinutes: 30,
                    targetQuestionCount: 25
                ),
                mode: .quick,
                difficulty: store.selectedDifficulty,
                systemImage: "wand.and.stars",
                tint: .purple,
                focusDomainIDs: weakDomainIDs
            ),
            ExamModeCard(
                simulation: base.configured(
                    id: "\(base.id)-real",
                    title: "Real Exam Mode",
                    description: "Flagship simulation: up to 90 randomized items, public exam time limit, PBQs first, no hints, review screen, and delayed explanations.",
                    timeLimitMinutes: 90,
                    targetQuestionCount: 90
                ),
                mode: .realExam,
                difficulty: store.selectedDifficulty,
                systemImage: "checkmark.seal",
                tint: .blue,
                focusDomainIDs: []
            ),
            ExamModeCard(
                simulation: base.configured(
                    id: "\(base.id)-speed",
                    title: "Speed Training",
                    description: "25 randomized items in 20 minutes to build exam-day pace without sacrificing scenario quality.",
                    timeLimitMinutes: 20,
                    targetQuestionCount: 25
                ),
                mode: .speedTraining,
                difficulty: store.selectedDifficulty,
                systemImage: "timer",
                tint: .green,
                focusDomainIDs: []
            ),
            ExamModeCard(
                simulation: base.configured(
                    id: "\(base.id)-stress",
                    title: "Exam Stress Mode",
                    description: "Full-length randomized exam with stronger timer warnings, mixed question difficulty, and PBQ pressure.",
                    timeLimitMinutes: 90,
                    targetQuestionCount: 90
                ),
                mode: .stressMode,
                difficulty: store.selectedDifficulty,
                systemImage: "bolt.trianglebadge.exclamationmark",
                tint: .orange,
                focusDomainIDs: []
            ),
            ExamModeCard(
                simulation: base.configured(
                    id: "\(base.id)-nightmare",
                    title: "Nightmare Mode",
                    description: "Harder than the certification exam: long troubleshooting prompts, multi-select traps, PBQs first, and a 90%+ readiness target.",
                    timeLimitMinutes: 90,
                    targetQuestionCount: 90,
                    passingScaledScore: min(base.maximumScaledScore, base.passingScaledScore + 75)
                ),
                mode: .nightmareMode,
                difficulty: .nightmareMode,
                systemImage: "moon.stars",
                tint: .purple,
                focusDomainIDs: []
            )
        ]
    }
}

struct ExamModeCard: Identifiable {
    let simulation: ExamSimulation
    let mode: ExamSessionMode
    let difficulty: StudyBuddyDifficultyLevel
    let systemImage: String
    let tint: Color
    let focusDomainIDs: Set<String>

    var id: String { simulation.id }
}

struct ExamSimulatorView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let simulation: ExamSimulation
    let exam: ExamProfile
    let difficulty: StudyBuddyDifficultyLevel
    let sessionMode: ExamSessionMode
    let focusDomainIDs: Set<String>

    @State private var items: [ExamItem] = []
    @State private var currentIndex = 0
    @State private var answers: [String: ExamAnswer] = [:]
    @State private var draftAnswer = ExamAnswer()
    @State private var remainingSeconds = 0
    @State private var phase = ExamPhase.taking
    @State private var flaggedItemIDs: Set<String> = []
    @State private var confidenceByItemID: [String: ConfidenceLevel] = [:]
    @State private var itemStartedAtByID: [String: Date] = [:]
    @State private var answerChangeCounts: [String: Int] = [:]
    @State private var showEndConfirmation = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private enum ExamPhase {
        case taking
        case review
        case result
    }

    var body: some View {
        Group {
            if phase == .result {
                ExamResultView(
                    simulation: simulation,
                    exam: exam,
                    items: items,
                    answers: answers,
                    flaggedItemIDs: flaggedItemIDs,
                    confidenceByItemID: confidenceByItemID,
                    sessionMode: sessionMode,
                    difficulty: difficulty
                )
            } else if items.isEmpty {
                ContentUnavailableView("No Exam Items", systemImage: "doc.questionmark", description: Text("Add practice exam items in ExamCatalog.swift."))
            } else if phase == .review {
                examReviewContent
            } else {
                examContent
            }
        }
        .navigationTitle(sessionMode.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if phase != .result && !items.isEmpty {
                Button {
                    saveDraft()
                    phase = .review
                } label: {
                    Label("Review", systemImage: "list.bullet.rectangle")
                }

                Button {
                    showEndConfirmation = true
                } label: {
                    Label("End", systemImage: "flag.checkered")
                }
            }
        }
        .onAppear(perform: startIfNeeded)
        .onReceive(timer) { _ in
            guard phase != .result, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            if remainingSeconds == 0 {
                submitExam()
            }
        }
        .confirmationDialog("End exam early?", isPresented: $showEndConfirmation, titleVisibility: .visible) {
            Button("Submit Exam Now", role: .destructive) {
                submitExam()
            }
            Button("Keep Working", role: .cancel) {}
        } message: {
            Text("StudyBuddy will score only the answers saved so far.")
        }
    }

    private var examContent: some View {
        let item = items[currentIndex]

        return ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Label(formattedTime, systemImage: "clock")
                    Spacer()
                    Text("\(currentIndex + 1) of \(items.count)")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(timerTint)

                ProgressView(value: Double(currentIndex + 1), total: Double(items.count))
                    .tint(progressTint)

                HStack(spacing: 10) {
                    if item.isPerformanceBased {
                        Label("Performance-based item", systemImage: "puzzlepiece.extension")
                            .foregroundStyle(.orange)
                    } else {
                        Label(difficulty.title, systemImage: "speedometer")
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button {
                        toggleFlag(for: item)
                    } label: {
                        Label(flaggedItemIDs.contains(item.id) ? "Flagged" : "Flag", systemImage: flaggedItemIDs.contains(item.id) ? "flag.fill" : "flag")
                    }
                    .buttonStyle(.bordered)
                    .tint(flaggedItemIDs.contains(item.id) ? .orange : .blue)
                }
                .font(.caption.weight(.bold))
                .textCase(.uppercase)

                if let domain = exam.domain(with: item.domainID) {
                    Label(domain.title, systemImage: "tag")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                }

                Text(item.prompt)
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                ExamItemAnswerView(item: item, answer: $draftAnswer)

                confidenceMeter(for: item)

                HStack {
                    Button {
                        previous()
                    } label: {
                        Label("Back", systemImage: "chevron.left")
                    }
                    .buttonStyle(.bordered)
                    .disabled(currentIndex == 0)

                    Spacer()

                    Button {
                        saveDraft()
                        phase = .review
                    } label: {
                        Label("Review", systemImage: "list.bullet.rectangle")
                    }
                    .buttonStyle(.bordered)

                    Button {
                        nextOrReview()
                    } label: {
                        Label(currentIndex == items.count - 1 ? "Review" : "Next", systemImage: currentIndex == items.count - 1 ? "list.bullet.rectangle" : "chevron.right")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .controlSize(.large)

                Text("This simulator uses original practice items. It is not a real CompTIA exam and does not contain actual exam questions.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var examReviewContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(formattedTime, systemImage: "clock")
                            .foregroundStyle(timerTint)
                        Spacer()
                        Label("\(flaggedItemIDs.count) flagged", systemImage: "flag")
                    }
                    .font(.headline.monospacedDigit())

                    Text("Review your answers before submitting. Explanations stay locked until the exam is scored.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 52), spacing: 10)], spacing: 10) {
                        ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                            Button {
                                jump(to: index)
                            } label: {
                                VStack(spacing: 4) {
                                    Text("\(index + 1)")
                                        .font(.headline.monospacedDigit())
                                    Image(systemName: reviewIcon(for: item))
                                        .font(.caption.weight(.bold))
                                }
                                .frame(width: 52, height: 52)
                            }
                            .buttonStyle(.bordered)
                            .tint(reviewTint(for: item))
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    Label("Session Summary", systemImage: "doc.text.magnifyingglass")
                        .font(.headline)
                    Text("\(answeredCount) answered, \(unansweredCount) unanswered, \(pbqCount) PBQs, \(flaggedItemIDs.count) flagged.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                HStack {
                    Button {
                        jump(to: currentIndex)
                    } label: {
                        Label("Return", systemImage: "arrow.uturn.backward")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.large)

                    Button {
                        submitExam()
                    } label: {
                        Label("Submit Exam", systemImage: "checkmark.circle.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private func confidenceMeter(for item: ExamItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("StudyBuddy confidence estimate", systemImage: "waveform.path.ecg")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ConfidenceEstimateCard(
                confidence: isAnswered(item) ? inferredConfidence(for: item, answer: draftAnswer) : nil,
                detail: isAnswered(item)
                    ? "Estimated from time spent, answer changes, flags, correctness, and difficulty."
                    : "StudyBuddy will estimate this after you work the item."
            )
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private var timerTint: Color {
        if remainingSeconds < 300 { return .red }
        if sessionMode == .stressMode && remainingSeconds < 900 { return .orange }
        return .secondary
    }

    private var progressTint: Color {
        switch sessionMode {
        case .nightmareMode:
            return .purple
        case .stressMode:
            return .orange
        case .speedTraining:
            return .green
        default:
            return .blue
        }
    }

    private var answeredCount: Int {
        items.filter(isAnswered).count
    }

    private var unansweredCount: Int {
        items.count - answeredCount
    }

    private var pbqCount: Int {
        items.filter(\.isPerformanceBased).count
    }

    private func startIfNeeded() {
        guard items.isEmpty else { return }
        let generatedItems = simulation.randomizedItems(for: exam, difficulty: difficulty)
        if focusDomainIDs.isEmpty {
            items = generatedItems
        } else {
            items = generatedItems.shuffled().sorted {
                targetedPriority($0) > targetedPriority($1)
            }
        }
        remainingSeconds = simulation.timeLimitMinutes * 60
        draftAnswer = defaultAnswer(for: items.first)
        beginTrackingCurrentItem()
    }

    private func targetedPriority(_ item: ExamItem) -> Int {
        var priority = 0
        if focusDomainIDs.contains(item.domainID) { priority += 4 }
        if item.isPerformanceBased { priority += 1 }
        return priority
    }

    private func defaultAnswer(for item: ExamItem?) -> ExamAnswer {
        guard let item else { return ExamAnswer() }
        if item.kind == .ordering {
            return ExamAnswer(orderedItems: item.correctOrder.shuffled())
        }
        return ExamAnswer()
    }

    private func saveDraft() {
        guard items.indices.contains(currentIndex) else { return }
        let item = items[currentIndex]
        if isAnswered(item), answers[item.id] != draftAnswer {
            answerChangeCounts[item.id, default: 0] += 1
        }
        answers[item.id] = draftAnswer
        if isAnswered(item) {
            confidenceByItemID[item.id] = inferredConfidence(for: item, answer: draftAnswer)
        } else {
            confidenceByItemID.removeValue(forKey: item.id)
        }
    }

    private func beginTrackingCurrentItem() {
        guard items.indices.contains(currentIndex) else { return }
        let itemID = items[currentIndex].id
        if itemStartedAtByID[itemID] == nil {
            itemStartedAtByID[itemID] = .now
        }
    }

    private func inferredConfidence(for item: ExamItem, answer: ExamAnswer) -> ConfidenceLevel {
        let elapsed = Date().timeIntervalSince(itemStartedAtByID[item.id] ?? .now)
        let scoreRatio = Double(item.score(for: answer)) / Double(max(item.points, 1))
        return ConfidenceEstimator.examItem(
            scoreRatio: scoreRatio,
            elapsedSeconds: elapsed,
            answerChanges: answerChangeCounts[item.id] ?? 0,
            wasFlagged: flaggedItemIDs.contains(item.id),
            difficulty: difficulty,
            isPerformanceBased: item.isPerformanceBased
        )
    }

    private func previous() {
        saveDraft()
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        draftAnswer = answers[items[currentIndex].id] ?? defaultAnswer(for: items[currentIndex])
        beginTrackingCurrentItem()
    }

    private func nextOrReview() {
        saveDraft()
        if currentIndex == items.count - 1 {
            phase = .review
        } else {
            currentIndex += 1
            draftAnswer = answers[items[currentIndex].id] ?? defaultAnswer(for: items[currentIndex])
            beginTrackingCurrentItem()
        }
    }

    private func jump(to index: Int) {
        saveDraft()
        guard items.indices.contains(index) else { return }
        currentIndex = index
        draftAnswer = answers[items[currentIndex].id] ?? defaultAnswer(for: items[currentIndex])
        beginTrackingCurrentItem()
        phase = .taking
    }

    private func toggleFlag(for item: ExamItem) {
        if flaggedItemIDs.contains(item.id) {
            flaggedItemIDs.remove(item.id)
        } else {
            flaggedItemIDs.insert(item.id)
        }
    }

    private func submitExam() {
        guard phase != .result else { return }
        saveDraft()
        let result = simulation.result(for: answers, items: items)
        let attempt = ExamAttemptRecord(
            id: UUID(),
            examID: exam.id,
            simulationID: simulation.id,
            title: simulation.title,
            date: .now,
            sessionMode: sessionMode,
            difficulty: difficulty,
            rawPoints: result.rawPoints,
            possiblePoints: result.possiblePoints,
            scaledScore: result.scaledScore,
            passingScore: result.passingScore,
            percent: result.percent,
            durationSeconds: max(0, (simulation.timeLimitMinutes * 60) - remainingSeconds),
            flaggedCount: flaggedItemIDs.count,
            guessedCount: confidenceByItemID.values.filter { $0 == .guessed }.count,
            pbqPercent: percent(for: items.filter(\.isPerformanceBased)),
            domainPercents: domainPercents(),
            confidenceScore: confidenceByItemID.values.map(\.weight).average
        )
        store.recordAttempt(attempt)
        uploadAttempt(attempt)
        phase = .result
    }

    private func isAnswered(_ item: ExamItem) -> Bool {
        let answer = answers[item.id] ?? (items.indices.contains(currentIndex) && items[currentIndex].id == item.id ? draftAnswer : ExamAnswer())
        switch item.kind {
        case .singleChoice, .multipleSelect:
            return !answer.selectedIndexes.isEmpty
        case .matching:
            return answer.selectedMatches.count == item.matchingPrompts.count
        case .ordering:
            return !answer.orderedItems.isEmpty
        }
    }

    private func reviewIcon(for item: ExamItem) -> String {
        if flaggedItemIDs.contains(item.id) { return "flag.fill" }
        return isAnswered(item) ? "checkmark" : "minus"
    }

    private func reviewTint(for item: ExamItem) -> Color {
        if flaggedItemIDs.contains(item.id) { return .orange }
        return isAnswered(item) ? .green : .gray
    }

    private func domainPercents() -> [String: Double] {
        Dictionary(grouping: items, by: \.domainID).mapValues { domainItems in
            percent(for: domainItems)
        }
    }

    private func percent(for scoredItems: [ExamItem]) -> Double {
        let possible = scoredItems.reduce(0) { $0 + $1.points }
        guard possible > 0 else { return 0 }
        let earned = scoredItems.reduce(0) { total, item in
            total + item.score(for: answers[item.id] ?? ExamAnswer())
        }
        return Double(earned) / Double(possible)
    }

    private func uploadAttempt(_ attempt: ExamAttemptRecord) {
        guard let baseURL = store.resolvedAIServerURL else { return }
        let upload = AIExamAttemptUpload(
            studentId: store.aiStudentID,
            examID: exam.id,
            examName: store.displayExamName,
            examCode: store.displayExamCode,
            attempt: attempt,
            weakDomains: store.weakDomains(limit: 3).map(\.title)
        )

        Task {
            try? await StudyBuddyAIClient(baseURL: baseURL).recordAttempt(upload)
        }
    }
}

struct ExamItemAnswerView: View {
    let item: ExamItem
    @Binding var answer: ExamAnswer

    var body: some View {
        switch item.kind {
        case .singleChoice:
            singleChoice
        case .multipleSelect:
            multipleSelect
        case .matching:
            matching
        case .ordering:
            ordering
        }
    }

    private var singleChoice: some View {
        VStack(spacing: 10) {
            ForEach(Array(item.choices.enumerated()), id: \.offset) { index, choice in
                Button {
                    answer.selectedIndexes = [index]
                } label: {
                    HStack {
                        Text(choice)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: answer.selectedIndexes.contains(index) ? "largecircle.fill.circle" : "circle")
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var multipleSelect: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select all that apply.")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.secondary)

            ForEach(Array(item.choices.enumerated()), id: \.offset) { index, choice in
                Button {
                    if answer.selectedIndexes.contains(index) {
                        answer.selectedIndexes.remove(index)
                    } else {
                        answer.selectedIndexes.insert(index)
                    }
                } label: {
                    HStack {
                        Text(choice)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        Image(systemName: answer.selectedIndexes.contains(index) ? "checkmark.square.fill" : "square")
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private var matching: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Match each row to the best answer.")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.secondary)

            ForEach(Array(item.matchingPrompts.enumerated()), id: \.offset) { promptIndex, prompt in
                VStack(alignment: .leading, spacing: 8) {
                    Text(prompt)
                        .font(.headline)

                    Picker("Answer", selection: Binding(
                        get: { answer.selectedMatches[promptIndex] ?? -1 },
                        set: { newValue in
                            if newValue == -1 {
                                answer.selectedMatches.removeValue(forKey: promptIndex)
                            } else {
                                answer.selectedMatches[promptIndex] = newValue
                            }
                        }
                    )) {
                        Text("Choose answer").tag(-1)
                        ForEach(Array(item.matchingAnswers.enumerated()), id: \.offset) { answerIndex, value in
                            Text(value).tag(answerIndex)
                        }
                    }
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }
        }
    }

    private var ordering: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Drag rows into the best order.")
                .font(.callout.weight(.semibold))
                .foregroundStyle(.secondary)

            List {
                ForEach(answer.orderedItems, id: \.self) { value in
                    HStack {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.secondary)
                        Text(value)
                    }
                }
                .onMove { source, destination in
                    answer.orderedItems.move(fromOffsets: source, toOffset: destination)
                }
            }
            .environment(\.editMode, .constant(.active))
            .frame(minHeight: CGFloat(max(answer.orderedItems.count, 3) * 54))
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
    }
}

struct ExamResultView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let simulation: ExamSimulation
    let exam: ExamProfile
    let items: [ExamItem]
    let answers: [String: ExamAnswer]
    let flaggedItemIDs: Set<String>
    let confidenceByItemID: [String: ConfidenceLevel]
    let sessionMode: ExamSessionMode
    let difficulty: StudyBuddyDifficultyLevel

    var body: some View {
        let result = simulation.result(for: answers, items: items)

        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 12) {
                    Label(result.didPass ? "Estimated Pass" : "Estimated Not Yet", systemImage: result.didPass ? "checkmark.seal.fill" : "exclamationmark.triangle.fill")
                        .font(.title2.bold())
                        .foregroundStyle(result.didPass ? .green : .orange)

                    Text("\(result.scaledScore)")
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text("Passing score: \(result.passingScore) on a \(simulation.minimumScaledScore)-\(simulation.maximumScaledScore) scale")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    ProgressView(value: result.percent)
                        .tint(result.didPass ? .green : .orange)

                    Text("\(result.rawPoints) of \(result.possiblePoints) practice points")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)

                    Text("Mode: \(sessionMode.title) · Difficulty: \(difficulty.title)")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    Label("Readiness Prediction", systemImage: "brain.head.profile")
                        .font(.headline)
                    Text(readinessCopy(for: result))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(Int(predictedChance(for: result) * 100))% predicted chance of passing")
                        .font(.title3.weight(.bold))
                        .monospacedDigit()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    Label("Next Training Exam", systemImage: "wand.and.stars")
                        .font(.headline)
                    Text(adaptiveNextStep)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("Go back to Practice > Exam and start AI Targeted Recovery Exam for a fresh set focused on the weakest areas.")
                        .font(.callout.weight(.semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 8) {
                    Label("Scoring note", systemImage: "info.circle")
                        .font(.headline)
                    Text("CompTIA's exact scoring algorithm and real item weights are proprietary. This result is a StudyBuddy estimate using original practice items, partial credit for PBQ-style items, and the public-style scaled-score range.")
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))

                VStack(alignment: .leading, spacing: 10) {
                    SectionHeader(title: "Objective Breakdown", systemImage: "chart.bar.doc.horizontal")
                    ForEach(exam.domains) { domain in
                        DomainScoreRow(domain: domain, percent: domainPercent(for: domain.id))
                    }
                }

                SectionHeader(title: "Review", systemImage: "doc.text.magnifyingglass")

                ForEach(items) { item in
                    ExamReviewCard(
                        item: item,
                        domain: exam.domain(with: item.domainID),
                        answer: answers[item.id] ?? ExamAnswer(),
                        earnedPoints: item.score(for: answers[item.id] ?? ExamAnswer()),
                        difficulty: difficulty,
                        confidence: confidenceByItemID[item.id],
                        wasFlagged: flaggedItemIDs.contains(item.id)
                    )
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private func predictedChance(for result: ExamResult) -> Double {
        let confidenceAverage = confidenceByItemID.values.map(\.weight).average ?? 0.72
        let confidenceAdjusted = (result.percent * 0.78) + (confidenceAverage * 0.22)
        return min(max(confidenceAdjusted / max(difficulty.readinessTarget, 0.1), 0.05), 0.98)
    }

    private func readinessCopy(for result: ExamResult) -> String {
        if difficulty == .nightmareMode && result.percent >= 0.9 {
            return "Strong signal: 90%+ in Nightmare Mode means you are handling pressure, ambiguity, and PBQs well."
        }
        if result.didPass {
            return "You are above this simulator's pass line. Keep drilling weak objectives and PBQs until your score is repeatable."
        }
        return "You are not at a repeatable pass signal yet. StudyBuddy will route your next practice toward the lowest objective areas."
    }

    private var adaptiveNextStep: String {
        if let weak = store.weakDomains(limit: 1).first {
            return "StudyBuddy sees the next best recovery area as \(weak.title). Spend \(max(20, Int(store.minutesPerDay / 2))) minutes there, then run the targeted recovery exam before another full-length attempt."
        }
        return "Complete one targeted recovery exam so StudyBuddy can compare confidence, score, and objective performance before your next full-length attempt."
    }

    private func domainPercent(for domainID: String) -> Double {
        let domainItems = items.filter { $0.domainID == domainID }
        let possible = domainItems.reduce(0) { $0 + $1.points }
        guard possible > 0 else { return 0 }
        let earned = domainItems.reduce(0) { total, item in
            total + item.score(for: answers[item.id] ?? ExamAnswer())
        }
        return Double(earned) / Double(possible)
    }
}

struct ExamReviewCard: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var showTutor = false

    let item: ExamItem
    let domain: ExamDomain?
    let answer: ExamAnswer
    let earnedPoints: Int
    let difficulty: StudyBuddyDifficultyLevel
    let confidence: ConfidenceLevel?
    let wasFlagged: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(item.isPerformanceBased ? "PBQ" : "Question", systemImage: item.isPerformanceBased ? "puzzlepiece.extension" : "questionmark.circle")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                if wasFlagged {
                    Image(systemName: "flag.fill")
                        .foregroundStyle(.orange)
                }
                Text("\(earnedPoints)/\(item.points)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(earnedPoints == item.points ? .green : .orange)
            }

            Text(item.prompt)
                .font(.headline)

            Text("Why the correct answer works")
                .font(.subheadline.weight(.semibold))

            Text(item.explanation)
                .font(.callout)
                .foregroundStyle(.secondary)

            if !correctAnswerText.isEmpty {
                Text("Correct answer: \(correctAnswerText)")
                    .font(.callout.weight(.semibold))
            }

            Text("Why the wrong answers are wrong")
                .font(.subheadline.weight(.semibold))

            Text(wrongAnswerGuidance)
                .font(.callout)
                .foregroundStyle(.secondary)

            Button {
                showTutor = true
            } label: {
                Label(earnedPoints == item.points ? "Reinforce with AI Tutor" : "Study Mistake with AI Tutor", systemImage: "brain.head.profile")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Label(domain?.title ?? "Mapped objective", systemImage: "tag")
                Label("Difficulty: \(difficulty.title)", systemImage: "speedometer")
                Label("StudyBuddy confidence: \(confidence?.title ?? "Not estimated")", systemImage: "waveform.path.ecg")
                Label("Common mistake: \(commonMistake)", systemImage: "exclamationmark.triangle")
                Label("Average user score: local analytics will improve as more attempts are recorded.", systemImage: "person.2")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .sheet(isPresented: $showTutor) {
            AITutorSheet(context: tutorContext)
                .environmentObject(store)
        }
    }

    private var correctAnswerText: String {
        switch item.kind {
        case .singleChoice, .multipleSelect:
            return item.correctChoiceIndexes
                .compactMap { item.choices.indices.contains($0) ? item.choices[$0] : nil }
                .joined(separator: ", ")
        case .matching:
            return item.matchingPrompts.enumerated().map { index, prompt in
                let answerIndex = item.correctMatches.indices.contains(index) ? item.correctMatches[index] : -1
                let answer = item.matchingAnswers.indices.contains(answerIndex) ? item.matchingAnswers[answerIndex] : "Unknown"
                return "\(prompt): \(answer)"
            }
            .joined(separator: "; ")
        case .ordering:
            return item.correctOrder.joined(separator: " > ")
        }
    }

    private var wrongAnswerGuidance: String {
        switch item.kind {
        case .singleChoice:
            return "The distractors are designed to sound technically possible. The exam-day move is to match the scenario constraint to the best first or most complete action."
        case .multipleSelect:
            return "Multi-select misses usually come from selecting a true statement that does not answer this exact scenario, or from overlooking one required control."
        case .matching:
            return "Matching errors usually happen when two terms feel related. Use the action verb, protocol behavior, or workflow role to separate them."
        case .ordering:
            return "Ordering errors usually come from skipping verification, documentation, containment, or other process steps that exam scenarios expect."
        }
    }

    private var commonMistake: String {
        if item.isPerformanceBased {
            return "Rushing PBQs before reading every constraint."
        }
        if item.kind == .multipleSelect {
            return "Choosing every true answer instead of every required answer."
        }
        return "Picking the first familiar term instead of the best fit for the scenario."
    }

    private var selectedAnswerText: String {
        switch item.kind {
        case .singleChoice, .multipleSelect:
            let selected = answer.selectedIndexes
                .sorted()
                .compactMap { item.choices.indices.contains($0) ? item.choices[$0] : nil }
            return selected.isEmpty ? "No answer selected" : selected.joined(separator: ", ")
        case .matching:
            let selected = item.matchingPrompts.enumerated().map { index, prompt in
                let answerIndex = answer.selectedMatches[index] ?? -1
                let selectedAnswer = item.matchingAnswers.indices.contains(answerIndex) ? item.matchingAnswers[answerIndex] : "No answer"
                return "\(prompt): \(selectedAnswer)"
            }
            return selected.joined(separator: "; ")
        case .ordering:
            return answer.orderedItems.isEmpty ? "No order submitted" : answer.orderedItems.joined(separator: " > ")
        }
    }

    private var tutorContext: AITutorMistakeContext {
        AITutorMistakeContext(
            studentId: store.aiStudentID,
            examID: store.exam.id,
            examName: store.displayExamName,
            examCode: store.displayExamCode,
            domainTitle: domain?.title ?? "General",
            objective: domain?.objectives.first ?? domain?.focus ?? "General review",
            questionPrompt: item.prompt,
            selectedAnswerSummary: selectedAnswerText,
            correctAnswerSummary: correctAnswerText,
            explanation: item.explanation,
            itemKind: item.kind.rawValue,
            wasCorrect: earnedPoints == item.points,
            isPerformanceBased: item.isPerformanceBased,
            difficulty: difficulty.title,
            confidence: confidence?.title ?? "Not marked",
            sessionMode: "Exam review",
            targetStudyMinutes: Int(store.minutesPerDay)
        )
    }
}

struct DomainScoreRow: View {
    let domain: ExamDomain
    let percent: Double

    private var tint: Color {
        if percent >= 0.85 { return .green }
        if percent >= 0.65 { return .yellow }
        return .red
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(domain.title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(Int(percent * 100))%")
                    .font(.caption.weight(.bold).monospacedDigit())
                    .foregroundStyle(tint)
            }

            ProgressView(value: percent)
                .tint(tint)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct AITutorSheet: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @Environment(\.dismiss) private var dismiss

    let context: AITutorMistakeContext

    @State private var tutorResponse: AITutorResponse?
    @State private var messages: [AITutorChatMessage] = []
    @State private var input = ""
    @State private var isLoading = false
    @State private var isSending = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        contextSummary

                        if isLoading {
                            ProgressView("Starting tutor session...")
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        }

                        if let errorMessage {
                            VStack(alignment: .leading, spacing: 10) {
                                Label("AI Tutor Unavailable", systemImage: "exclamationmark.triangle")
                                    .font(.headline)
                                    .foregroundStyle(.orange)
                                Text(errorMessage)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Button {
                                    Task { await loadTutor() }
                                } label: {
                                    Label("Retry", systemImage: "arrow.clockwise")
                                }
                                .buttonStyle(.bordered)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                        }

                        if let tutorResponse {
                            tutorResponseContent(tutorResponse)
                        }

                        ForEach(messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                    .padding()
                }

                Divider()
                chatInputBar
            }
            .navigationTitle("AI Tutor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Done") {
                    dismiss()
                }
            }
            .task {
                await loadTutor()
            }
        }
    }

    private var contextSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("\(context.examName) \(context.examCode)", systemImage: "checkmark.seal")
                .font(.headline)
            Text(context.domainTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(context.wasCorrect ? "This answer was correct. The tutor will reinforce the reasoning." : "This answer was missed. The tutor will guide you through the mistake.")
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func tutorResponseContent(_ response: AITutorResponse) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Label(response.source == "openai" ? "Coach" : "Local Coach", systemImage: "brain.head.profile")
                .font(.headline)

            Text(response.coachMessage)
                .font(.callout)

            VStack(alignment: .leading, spacing: 8) {
                Text("Guiding Questions")
                    .font(.subheadline.weight(.semibold))
                ForEach(response.guidingQuestions, id: \.self) { question in
                    Label(question, systemImage: "questionmark.circle")
                        .font(.callout)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Assigned Practice")
                    .font(.subheadline.weight(.semibold))
                ForEach(response.assignments) { assignment in
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: assignmentIcon(for: assignment.type))
                            .foregroundStyle(.blue)
                            .frame(width: 22)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(assignment.title)
                                .font(.callout.weight(.semibold))
                            Text(assignment.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Text(response.nextAction)
                .font(.callout.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private var chatInputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask a follow-up", text: $input, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...3)

            Button {
                Task { await sendMessage() }
            } label: {
                Image(systemName: isSending ? "hourglass" : "paperplane.fill")
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.borderedProminent)
            .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
            .accessibilityLabel("Send")
        }
        .padding()
        .background(Color(.systemBackground))
    }

    private func loadTutor() async {
        guard tutorResponse == nil, !isLoading else { return }
        guard let baseURL = store.resolvedAIServerURL else {
            errorMessage = "Add your StudyBuddy AI server URL in Settings."
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let response = try await StudyBuddyAIClient(baseURL: baseURL).tutor(for: context)
            tutorResponse = response
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    private func sendMessage() async {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let baseURL = store.resolvedAIServerURL else { return }

        let userMessage = AITutorChatMessage(role: "user", content: trimmed)
        messages.append(userMessage)
        input = ""
        isSending = true

        do {
            let response = try await StudyBuddyAIClient(baseURL: baseURL).chat(context: context, messages: messages)
            messages.append(AITutorChatMessage(role: "assistant", content: response.reply))
        } catch {
            messages.append(AITutorChatMessage(role: "assistant", content: "I could not reach the AI server. Check the server URL in Settings and try again."))
        }

        isSending = false
    }

    private func assignmentIcon(for type: String) -> String {
        switch type.lowercased() {
        case "questions":
            return "questionmark.circle"
        case "flashcards":
            return "rectangle.stack"
        case "pbq":
            return "puzzlepiece.extension"
        case "lab":
            return "terminal"
        case "video":
            return "play.rectangle"
        default:
            return "target"
        }
    }
}

struct ChatBubble: View {
    let message: AITutorChatMessage

    private var isUser: Bool {
        message.role == "user"
    }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 42) }

            Text(message.content)
                .font(.callout)
                .padding(12)
                .background(isUser ? Color.blue : Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .foregroundStyle(isUser ? .white : .primary)

            if !isUser { Spacer(minLength: 42) }
        }
    }
}

struct StudyBuddyAIClient {
    let baseURL: URL

    func tutor(for context: AITutorMistakeContext) async throws -> AITutorResponse {
        try await post("api/tutor/mistake", body: context)
    }

    func chat(context: AITutorMistakeContext, messages: [AITutorChatMessage]) async throws -> AITutorChatResponse {
        try await post("api/tutor/chat", body: AITutorChatRequest(context: context, messages: messages))
    }

    func recordAttempt(_ upload: AIExamAttemptUpload) async throws -> AITutorResponse {
        try await post("api/learning/attempt", body: upload)
    }

    private func post<RequestBody: Encodable, ResponseBody: Decodable>(_ path: String, body: RequestBody) async throws -> ResponseBody {
        var url = baseURL
        url.append(path: path)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StudyBuddyAIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let message = String(data: data, encoding: .utf8) ?? "Server returned \(httpResponse.statusCode)."
            throw StudyBuddyAIError.server(message)
        }

        return try JSONDecoder().decode(ResponseBody.self, from: data)
    }
}

enum StudyBuddyAIError: LocalizedError {
    case invalidResponse
    case server(String)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The AI server returned an unreadable response."
        case .server(let message):
            return message
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var showResetConfirmation = false
    var afterReset: () -> Void = {}

    var body: some View {
        NavigationStack {
            Form {
                Section("Active Exam") {
                    Picker("Exam", selection: $store.selectedExamID) {
                        ForEach(store.exams) { exam in
                            Text("\(exam.name) \(exam.code)").tag(exam.id)
                        }
                    }
                }

                Section("Exam Label") {
                    TextField("Exam name", text: $store.customExamName, prompt: Text(store.exam.name))
                    TextField("Exam code", text: $store.customExamCode, prompt: Text(store.exam.code))
                    TextField("Personal focus", text: $store.customFocus, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                Section("AI Tutor Server") {
                    TextField("Server URL", text: $store.aiServerURL, prompt: Text("https://your-studybuddy-ai-server.com"))
                        .keyboardType(.URL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    LabeledContent("Status", value: store.aiServerStatus.rawValue)
                    LabeledContent("Model", value: store.aiServerModel)
                    LabeledContent("OpenAI key", value: openAIKeyLabel)
                    LabeledContent("Student profile", value: String(store.aiStudentID.prefix(8)))
                    Button {
                        Task {
                            await store.checkAIServerHealth()
                        }
                    } label: {
                        Label(store.aiServerStatus == .checking ? "Checking..." : "Check AI Server Now", systemImage: "network")
                    }
                    .disabled(store.aiServerStatus == .checking)
                    Text("Default server: https://studybuddy-ai-server-m5zi.onrender.com. Use http://127.0.0.1:8787 only if you intentionally run the local Node server in the simulator.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    Text(store.aiServerMessage)
                        .font(.footnote)
                        .foregroundStyle(store.aiServerStatus == .online ? .green : .secondary)
                }

                Section("Built-In Content") {
                    LabeledContent("Default exam", value: "\(store.exam.name) \(store.exam.code)")
                    LabeledContent("Available exams", value: "\(store.exams.count)")
                    LabeledContent("Domains", value: "\(store.exam.domains.count)")
                    LabeledContent("Practice prompts", value: "\(store.exam.practiceQuestions.count)")
                    LabeledContent("Exam modes", value: "4")
                    LabeledContent("Flashcards", value: "\(store.exam.flashcards.count)")
                }

                Section("Updates") {
                    LabeledContent("Version", value: "2.7")
                    LabeledContent("Build", value: "17")
                    LabeledContent("Update channel", value: "TestFlight/App Store")
                    LabeledContent("Automatic updates", value: "Managed by iOS")
                    LabeledContent("Compatibility", value: "SwiftUI, iOS 17+")
                }

                Section("Progress") {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Label("Reset all StudyBuddy progress", systemImage: "trash")
                    }
                }

                Section("Disclaimer") {
                    Text(store.exam.disclaimer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Reset all progress?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("Reset", role: .destructive) {
                    store.resetProgress()
                    afterReset()
                }
            } message: {
                Text("Study plan progress, flashcards, answered questions, exam attempts, results, achievements, confidence learning, and streak history for every exam will be cleared on this device.")
            }
        }
    }

    private var openAIKeyLabel: String {
        switch store.aiServerOpenAIKeyStatus {
        case "configured":
            return "Configured"
        case "invalid-prefix":
            return "Invalid key"
        default:
            return store.aiServerOpenAIConfigured ? "Configured" : "Not configured"
        }
    }
}

struct MetricTile: View {
    let title: String
    let value: Double
    let systemImage: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: systemImage)
                    .font(.headline)
                    .foregroundStyle(tint)
                Spacer()
                Text("\(Int(value * 100))%")
                    .font(.headline.monospacedDigit())
            }

            ProgressView(value: value)
                .tint(tint)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct SectionHeader: View {
    let title: String
    let systemImage: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.title3.weight(.bold))
            .foregroundStyle(.primary)
    }
}

struct TaskRow: View {
    let task: StudyTask
    let isComplete: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isComplete ? .green : .secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 6) {
                    Text(task.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(task.detail)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Label("\(task.minutes) min", systemImage: "timer")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isComplete ? "Mark \(task.title) incomplete" : "Mark \(task.title) complete")
    }
}

struct DomainProgressRow: View {
    let domain: ExamDomain
    let progress: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(domain.title)
                    .font(.headline)
                Spacer()
                Text("\(domain.weight)%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            Text(domain.focus)
                .font(.callout)
                .foregroundStyle(.secondary)

            ProgressView(value: progress)
                .tint(progress > 0.66 ? .green : .orange)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StudyBuddyStore())
    }
}

private extension Collection where Element == Double {
    var average: Double? {
        guard !isEmpty else { return nil }
        return reduce(0, +) / Double(count)
    }
}
