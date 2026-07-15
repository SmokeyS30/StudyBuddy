import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Today", systemImage: "house") }

            PlanView()
                .tabItem { Label("Plan", systemImage: "calendar") }

            LearnView()
                .tabItem { Label("Learn", systemImage: "book") }

            PracticeView()
                .tabItem { Label("Practice", systemImage: "checkmark.seal") }

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape") }
        }
    }
}

struct DashboardView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    dashboardHeader
                    personalFocus
                    progressGrid
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
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            MetricTile(title: "Plan", value: store.overallProgress, systemImage: "list.bullet.clipboard", tint: .blue)
            MetricTile(title: "Cards", value: store.flashcardProgress, systemImage: "rectangle.stack", tint: .orange)
            MetricTile(title: "Practice", value: store.practiceProgress, systemImage: "target", tint: .green)
            MetricTile(title: "Readiness", value: (store.overallProgress + store.flashcardProgress + store.practiceProgress) / 3, systemImage: "chart.line.uptrend.xyaxis", tint: .purple)
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

struct PlanView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        NavigationStack {
            List {
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
                            TaskRow(task: task, isComplete: store.completedTaskIDs.contains(task.id)) {
                                store.toggleTask(task)
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
}

struct LearnView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var mode = LearnMode.objectives
    @State private var flashcardIndex = 0

    enum LearnMode: String, CaseIterable, Identifiable {
        case objectives = "Objectives"
        case flashcards = "Cards"
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
                .pickerStyle(.segmented)
                .padding()

                Group {
                    switch mode {
                    case .objectives:
                        ObjectiveList()
                    case .flashcards:
                        FlashcardDeck(index: $flashcardIndex)
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
        deck = store.exam.flashcards.shuffled()
        index = 0
        showingAnswer = false
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

struct PracticeView: View {
    enum PracticeMode: String, CaseIterable, Identifiable {
        case quick = "Quick"
        case exam = "Exam"

        var id: String { rawValue }
    }

    @State private var mode = PracticeMode.quick

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Practice mode", selection: $mode) {
                    ForEach(PracticeMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
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

struct QuickPracticeView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var questions: [PracticeQuestion] = []
    @State private var index = 0
    @State private var selectedIndex: Int?
    @State private var correctCount = 0

    var body: some View {
        VStack(spacing: 0) {
            if questions.isEmpty {
                ContentUnavailableView("No Questions", systemImage: "questionmark.circle", description: Text("Add practice prompts in ExamCatalog.swift."))
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
                    Text("Score \(correctCount)")
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
                        advance()
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
        selectedIndex = optionIndex
        store.markQuestionAnswered(question)
        if optionIndex == question.answerIndex {
            correctCount += 1
        }
    }

    private func advance() {
        selectedIndex = nil
        if index == questions.count - 1 {
            restart()
        } else {
            index += 1
        }
    }

    private func restart() {
        questions = Array(store.exam.practiceQuestions.shuffled().prefix(10)).map { $0.randomizedChoices() }
        index = 0
        selectedIndex = nil
        correctCount = 0
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

struct ExamSimulationListView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(store.simulations) { simulation in
                    NavigationLink {
                        ExamSimulatorView(simulation: simulation, exam: store.exam)
                    } label: {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "timer")
                                    .foregroundStyle(.blue)
                                Text(simulation.title)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.bold))
                                    .foregroundStyle(.secondary)
                            }

                            Text(simulation.description)
                                .font(.callout)
                                .foregroundStyle(.secondary)

                            HStack(spacing: 14) {
                                Label("\(simulation.timeLimitMinutes) min", systemImage: "clock")
                                Label("\(simulation.targetQuestionCount) questions", systemImage: "list.number")
                                Label("Pass \(simulation.passingScaledScore)", systemImage: "checkmark.seal")
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
}

struct ExamSimulatorView: View {
    let simulation: ExamSimulation
    let exam: ExamProfile

    @State private var items: [ExamItem] = []
    @State private var currentIndex = 0
    @State private var answers: [String: ExamAnswer] = [:]
    @State private var draftAnswer = ExamAnswer()
    @State private var remainingSeconds = 0
    @State private var isFinished = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        Group {
            if isFinished {
                ExamResultView(simulation: simulation, items: items, answers: answers)
            } else if items.isEmpty {
                ContentUnavailableView("No Exam Items", systemImage: "doc.questionmark", description: Text("Add practice exam items in ExamCatalog.swift."))
            } else {
                examContent
            }
        }
        .navigationTitle("Simulation")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !isFinished && !items.isEmpty {
                Button {
                    finishExam()
                } label: {
                    Label("Finish", systemImage: "flag.checkered")
                }
            }
        }
        .onAppear(perform: startIfNeeded)
        .onReceive(timer) { _ in
            guard !isFinished, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            if remainingSeconds == 0 {
                finishExam()
            }
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
                .foregroundStyle(remainingSeconds < 300 ? .red : .secondary)

                ProgressView(value: Double(currentIndex + 1), total: Double(items.count))

                if item.isPerformanceBased {
                    Label("Performance-based item", systemImage: "puzzlepiece.extension")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.orange)
                        .textCase(.uppercase)
                }

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
                        nextOrFinish()
                    } label: {
                        Label(currentIndex == items.count - 1 ? "Submit" : "Next", systemImage: currentIndex == items.count - 1 ? "checkmark.circle.fill" : "chevron.right")
                    }
                    .buttonStyle(.borderedProminent)
                }

                Text("This simulator uses original practice items. It is not a real CompTIA exam and does not contain actual exam questions.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }

    private var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private func startIfNeeded() {
        guard items.isEmpty else { return }
        items = simulation.randomizedItems(for: exam)
        remainingSeconds = simulation.timeLimitMinutes * 60
        draftAnswer = defaultAnswer(for: items.first)
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
        answers[items[currentIndex].id] = draftAnswer
    }

    private func previous() {
        saveDraft()
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        draftAnswer = answers[items[currentIndex].id] ?? defaultAnswer(for: items[currentIndex])
    }

    private func nextOrFinish() {
        saveDraft()
        if currentIndex == items.count - 1 {
            finishExam()
        } else {
            currentIndex += 1
            draftAnswer = answers[items[currentIndex].id] ?? defaultAnswer(for: items[currentIndex])
        }
    }

    private func finishExam() {
        saveDraft()
        isFinished = true
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
    let simulation: ExamSimulation
    let items: [ExamItem]
    let answers: [String: ExamAnswer]

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

                SectionHeader(title: "Review", systemImage: "doc.text.magnifyingglass")

                ForEach(items) { item in
                    ExamReviewCard(item: item, answer: answers[item.id] ?? ExamAnswer(), earnedPoints: item.score(for: answers[item.id] ?? ExamAnswer()))
                }
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct ExamReviewCard: View {
    let item: ExamItem
    let answer: ExamAnswer
    let earnedPoints: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label(item.isPerformanceBased ? "PBQ" : "Question", systemImage: item.isPerformanceBased ? "puzzlepiece.extension" : "questionmark.circle")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text("\(earnedPoints)/\(item.points)")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(earnedPoints == item.points ? .green : .orange)
            }

            Text(item.prompt)
                .font(.headline)

            Text(item.explanation)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

struct SettingsView: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var showResetConfirmation = false

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

                Section("Built-In Content") {
                    LabeledContent("Default exam", value: "\(store.exam.name) \(store.exam.code)")
                    LabeledContent("Available exams", value: "\(store.exams.count)")
                    LabeledContent("Domains", value: "\(store.exam.domains.count)")
                    LabeledContent("Practice prompts", value: "\(store.exam.practiceQuestions.count)")
                    LabeledContent("Exam simulations", value: "\(store.simulations.count)")
                    LabeledContent("Flashcards", value: "\(store.exam.flashcards.count)")
                }

                Section("Updates") {
                    LabeledContent("Update channel", value: "TestFlight/App Store")
                    LabeledContent("Automatic updates", value: "Managed by iOS")
                    LabeledContent("Compatibility", value: "SwiftUI, iOS 17+")
                }

                Section("Progress") {
                    Button(role: .destructive) {
                        showResetConfirmation = true
                    } label: {
                        Label("Reset current exam progress", systemImage: "trash")
                    }
                }

                Section("Disclaimer") {
                    Text(store.exam.disclaimer)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog("Reset progress for \(store.exam.code)?", isPresented: $showResetConfirmation, titleVisibility: .visible) {
                Button("Reset", role: .destructive) {
                    store.resetProgress()
                }
            } message: {
                Text("Study plan, flashcard, and practice progress for the selected exam will be cleared on this device.")
            }
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

#Preview {
    ContentView()
        .environmentObject(StudyBuddyStore())
}
