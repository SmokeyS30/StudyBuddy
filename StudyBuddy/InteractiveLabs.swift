import SwiftUI

enum LabInteractionMode: String, CaseIterable, Identifiable {
    case guided = "Guided"
    case challenge = "Challenge"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .guided: "lightbulb"
        case .challenge: "stopwatch"
        }
    }

    var detail: String {
        switch self {
        case .guided:
            "Use optional coaching and mobile command shortcuts while you work."
        case .challenge:
            "Work from the ticket alone. Coaching and command shortcuts are hidden."
        }
    }
}

enum LabTheme: String, Hashable {
    case cyan
    case green
    case indigo
    case orange
    case red
    case teal

    var color: Color {
        switch self {
        case .cyan: .cyan
        case .green: .green
        case .indigo: .indigo
        case .orange: .orange
        case .red: .red
        case .teal: .teal
        }
    }
}

enum LabEnvironmentKind: String, Hashable {
    case networkTerminal
    case printerWorkbench
    case serviceDesktop
    case malwareDesktop
    case firewallConsole
    case socConsole

    var label: String {
        switch self {
        case .networkTerminal: "Command terminal"
        case .printerWorkbench: "Hardware workbench"
        case .serviceDesktop: "Support workstation"
        case .malwareDesktop: "Incident workstation"
        case .firewallConsole: "Firewall console"
        case .socConsole: "SOC dashboard"
        }
    }
}

struct SimulationLabDefinition: Identifiable, Hashable {
    let id: String
    let examID: String
    let domainID: String
    let title: String
    let category: String
    let scenario: String
    let role: String
    let objective: String
    let estimatedMinutes: Int
    let systemImage: String
    let theme: LabTheme
    let environment: LabEnvironmentKind
}

struct SimulationCheckpointResult: Identifiable, Hashable {
    let id: String
    let title: String
    let isComplete: Bool
    let detail: String
}

struct SimulationEnvironmentReport: Hashable {
    let score: Int
    let checkpoints: [SimulationCheckpointResult]
    let activityLog: [String]
    let summary: String

    var didPass: Bool { score >= 75 }
}

struct SimulationRunResult: Hashable {
    let report: SimulationEnvironmentReport
    let elapsedSeconds: Int
}

enum InteractiveLabCatalog {
    static func labs(for examID: String) -> [SimulationLabDefinition] {
        switch examID {
        case ExamCatalog.aPlusCore1.id:
            core1Labs
        case ExamCatalog.aPlusCore2.id:
            core2Labs
        case ExamCatalog.securityPlus.id:
            securityLabs
        default:
            []
        }
    }

    private static let core1Labs: [SimulationLabDefinition] = [
        SimulationLabDefinition(
            id: "sim-1201-network-terminal-v1",
            examID: ExamCatalog.aPlusCore1.id,
            domainID: "1201-networking",
            title: "Floor 2 Name Resolution",
            category: "Live command terminal",
            scenario: "A relocated workstation reaches its gateway and public IP addresses, but names no longer resolve. Diagnose and repair the workstation from its terminal.",
            role: "Field technician",
            objective: "Use command-line network tools to separate addressing, connectivity, and DNS failures.",
            estimatedMinutes: 10,
            systemImage: "terminal",
            theme: .cyan,
            environment: .networkTerminal
        ),
        SimulationLabDefinition(
            id: "sim-1201-printer-workbench-v1",
            examID: ExamCatalog.aPlusCore1.id,
            domainID: "1201-hardware",
            title: "Loose Toner Service Call",
            category: "Interactive printer bench",
            scenario: "Labels leave the laser printer with toner that wipes away. Inspect the device, correct its configuration, and prove the repair without replacing good parts.",
            role: "Hardware technician",
            objective: "Match laser-printer media and fusing behavior to a safe, evidence-based repair.",
            estimatedMinutes: 9,
            systemImage: "printer",
            theme: .orange,
            environment: .printerWorkbench
        )
    ]

    private static let core2Labs: [SimulationLabDefinition] = [
        SimulationLabDefinition(
            id: "sim-1202-service-desktop-v1",
            examID: ExamCatalog.aPlusCore2.id,
            domainID: "1202-os",
            title: "Service Fails After Reboot",
            category: "Interactive support workstation",
            scenario: "A required inventory agent starts manually but remains stopped after every reboot. Use the workstation tools to identify, repair, and verify the startup problem.",
            role: "Endpoint support technician",
            objective: "Use service controls and event evidence to correct a persistent startup issue.",
            estimatedMinutes: 10,
            systemImage: "desktopcomputer",
            theme: .indigo,
            environment: .serviceDesktop
        ),
        SimulationLabDefinition(
            id: "sim-1202-malware-desktop-v1",
            examID: ExamCatalog.aPlusCore2.id,
            domainID: "1202-security",
            title: "Redirecting Browser Ticket",
            category: "Interactive incident workstation",
            scenario: "A business workstation shows browser redirects and an unfamiliar startup entry. Contain, investigate, remediate, verify, and document the ticket.",
            role: "Support security technician",
            objective: "Apply a defensible malware-removal workflow without destroying evidence or restoring connectivity too early.",
            estimatedMinutes: 12,
            systemImage: "shield.lefthalf.filled",
            theme: .red,
            environment: .malwareDesktop
        )
    ]

    private static let securityLabs: [SimulationLabDefinition] = [
        SimulationLabDefinition(
            id: "sim-701-firewall-console-v1",
            examID: ExamCatalog.securityPlus.id,
            domainID: "701-architecture",
            title: "Exposed Admin Interface",
            category: "Interactive firewall console",
            scenario: "A branch firewall permits management HTTPS from any IPv4 address. Restrict the rule, enable useful logging, and validate allowed and denied traffic.",
            role: "Security administrator",
            objective: "Apply least privilege to an administrative service and prove the control with packet tests.",
            estimatedMinutes: 10,
            systemImage: "firewall",
            theme: .teal,
            environment: .firewallConsole
        ),
        SimulationLabDefinition(
            id: "sim-701-soc-console-v1",
            examID: ExamCatalog.securityPlus.id,
            domainID: "701-operations",
            title: "Impossible Travel Investigation",
            category: "Interactive SOC dashboard",
            scenario: "A user account records successful sign-ins from distant locations minutes apart, followed by a suspicious mailbox rule. Investigate and contain the incident.",
            role: "SOC analyst",
            objective: "Correlate identity and activity evidence, preserve findings, and take proportionate containment actions.",
            estimatedMinutes: 12,
            systemImage: "waveform.path.ecg.rectangle",
            theme: .green,
            environment: .socConsole
        )
    ]
}

struct HandsOnLabsList: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var mode: LabInteractionMode = .guided

    private var labs: [SimulationLabDefinition] {
        InteractiveLabCatalog.labs(for: store.exam.id)
    }

    private var completedCount: Int {
        labs.filter { (store.labBestScores[$0.id] ?? 0) >= 75 }.count
    }

    var body: some View {
        List {
            Section {
                Picker("Lab mode", selection: $mode) {
                    ForEach(LabInteractionMode.allCases) { mode in
                        Label(mode.rawValue, systemImage: mode.systemImage)
                            .tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                Text(mode.detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)

                ProgressView(
                    value: Double(completedCount),
                    total: Double(max(labs.count, 1))
                )
                .tint(.green)

                LabeledContent("Completed", value: "\(completedCount) of \(labs.count)")
                    .font(.subheadline.weight(.semibold))
            } header: {
                Text("Simulation mode")
            }

            Section {
                ForEach(labs) { lab in
                    NavigationLink {
                        SimulationLabSessionView(lab: lab, mode: mode)
                    } label: {
                        SimulationLabRow(
                            lab: lab,
                            bestScore: store.labBestScores[lab.id]
                        )
                    }
                }
            } header: {
                Text("\(store.displayExamCode) environments")
            } footer: {
                Text("StudyBuddy uses isolated educational simulations. Commands and configuration changes affect only the lab state, never the device or a real network.")
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct SimulationLabRow: View {
    let lab: SimulationLabDefinition
    let bestScore: Int?

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: lab.systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(lab.theme.color)
                .frame(width: 36, height: 36)
                .background(lab.theme.color.opacity(0.12), in: RoundedRectangle(cornerRadius: 7))

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(lab.title)
                        .font(.headline)
                    Spacer(minLength: 8)
                    if let bestScore {
                        Text("\(bestScore)%")
                            .font(.subheadline.monospacedDigit().weight(.bold))
                            .foregroundStyle(bestScore >= 75 ? .green : .orange)
                    }
                }

                Text(lab.environment.label)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(lab.theme.color)

                Text(lab.scenario)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)

                Label("\(lab.estimatedMinutes) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct SimulationLabSessionView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let lab: SimulationLabDefinition
    let mode: LabInteractionMode

    @State private var result: SimulationRunResult?
    @State private var startedAt = Date.now
    @State private var runID = UUID()
    @State private var successTrigger = 0

    var body: some View {
        Group {
            if let result {
                SimulationLabResultView(
                    lab: lab,
                    mode: mode,
                    result: result,
                    restart: restart
                )
            } else {
                environment
                    .id(runID)
            }
        }
        .navigationTitle(lab.title)
        .navigationBarTitleDisplayMode(.inline)
        .sensoryFeedback(.success, trigger: successTrigger)
    }

    @ViewBuilder
    private var environment: some View {
        switch lab.environment {
        case .networkTerminal:
            NetworkTerminalSimulation(lab: lab, mode: mode, onComplete: finish)
        case .printerWorkbench:
            PrinterWorkbenchSimulation(lab: lab, mode: mode, onComplete: finish)
        case .serviceDesktop:
            ServiceDesktopSimulation(lab: lab, mode: mode, onComplete: finish)
        case .malwareDesktop:
            MalwareDesktopSimulation(lab: lab, mode: mode, onComplete: finish)
        case .firewallConsole:
            FirewallConsoleSimulation(lab: lab, mode: mode, onComplete: finish)
        case .socConsole:
            SOCConsoleSimulation(lab: lab, mode: mode, onComplete: finish)
        }
    }

    private func finish(_ report: SimulationEnvironmentReport) {
        let elapsed = max(1, Int(Date.now.timeIntervalSince(startedAt)))
        result = SimulationRunResult(report: report, elapsedSeconds: elapsed)
        store.recordLabResult(labID: lab.id, score: report.score)
        if report.didPass {
            successTrigger += 1
        }
    }

    private func restart() {
        result = nil
        startedAt = .now
        runID = UUID()
    }
}

private struct SimulationLabResultView: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let result: SimulationRunResult
    let restart: () -> Void

    private var elapsedLabel: String {
        let minutes = result.elapsedSeconds / 60
        let seconds = result.elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private var completedCount: Int {
        result.report.checkpoints.filter(\.isComplete).count
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    Image(systemName: result.report.didPass ? "checkmark.seal.fill" : "wrench.and.screwdriver.fill")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(result.report.didPass ? .green : .orange)

                    Text(result.report.didPass ? "Environment Passed" : "More Practice Needed")
                        .font(.title.bold())
                        .multilineTextAlignment(.center)

                    Text("\(result.report.score)%")
                        .font(.system(size: 46, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text(result.report.summary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 18) {
                        Label("\(completedCount)/\(result.report.checkpoints.count)", systemImage: "checkmark.circle")
                        Label(elapsedLabel, systemImage: "clock")
                        Label(mode.rawValue, systemImage: mode.systemImage)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background((result.report.didPass ? Color.green : Color.orange).opacity(0.09))

                VStack(alignment: .leading, spacing: 18) {
                    Text("Hands-on Review")
                        .font(.title3.bold())

                    ForEach(result.report.checkpoints) { checkpoint in
                        VStack(alignment: .leading, spacing: 6) {
                            Label(
                                checkpoint.title,
                                systemImage: checkpoint.isComplete ? "checkmark.circle.fill" : "xmark.circle.fill"
                            )
                            .font(.headline)
                            .foregroundStyle(checkpoint.isComplete ? .green : .red)

                            Text(checkpoint.detail)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }

                        if checkpoint.id != result.report.checkpoints.last?.id {
                            Divider()
                        }
                    }

                    if !result.report.activityLog.isEmpty {
                        Divider()

                        Text("Activity Log")
                            .font(.headline)

                        ForEach(Array(result.report.activityLog.suffix(10).enumerated()), id: \.offset) { _, entry in
                            Label(entry, systemImage: "clock.arrow.circlepath")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Button(action: restart) {
                        Label("Reset Environment", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(lab.theme.color)
                    .controlSize(.large)
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
}
