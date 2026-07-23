import SwiftUI

struct LabMissionHeader: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(lab.environment.label, systemImage: lab.systemImage)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(lab.theme.color)
                Spacer()
                Text(mode.rawValue)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }

            Text(lab.scenario)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Label("Role: \(lab.role)", systemImage: "person.text.rectangle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(lab.objective)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Label(
                "Isolated training environment. Actions cannot change this device or a real system.",
                systemImage: "lock.shield"
            )
            .font(.caption.weight(.semibold))
            .foregroundStyle(.secondary)
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.green.opacity(0.09), in: RoundedRectangle(cornerRadius: 7))
        }
        .padding()
        .background(lab.theme.color.opacity(0.08))
    }
}

struct LabCheckpointSnapshot: Identifiable {
    let id: String
    let title: String
    let isComplete: Bool
    let coaching: String
}

struct LabCheckpointPanel: View {
    let checkpoints: [LabCheckpointSnapshot]
    let mode: LabInteractionMode
    let tint: Color

    @State private var isExpanded = false

    private var completedCount: Int {
        checkpoints.filter(\.isComplete).count
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Mission Progress")
                    .font(.headline)
                Spacer()
                Text("\(completedCount)/\(checkpoints.count)")
                    .font(.subheadline.monospacedDigit().weight(.bold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(
                value: Double(completedCount),
                total: Double(max(checkpoints.count, 1))
            )
            .tint(tint)

            DisclosureGroup("Mission steps", isExpanded: $isExpanded) {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(checkpoints) { checkpoint in
                        HStack(alignment: .top, spacing: 10) {
                            Image(systemName: checkpoint.isComplete ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(checkpoint.isComplete ? .green : .secondary)

                            VStack(alignment: .leading, spacing: 3) {
                                Text(checkpoint.title)
                                    .font(.subheadline.weight(.semibold))

                                if mode == .guided && !checkpoint.isComplete {
                                    Text(checkpoint.coaching)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
            .font(.subheadline.weight(.semibold))
            .tint(tint)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
    }
}

struct LabSubmissionBar: View {
    let title: String
    let isEnabled: Bool
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "checkmark.seal")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .controlSize(.large)
        .disabled(!isEnabled)
        .padding()
        .background(.bar)
    }
}

private func environmentScore(completed: Int, total: Int, penalty: Int = 0) -> Int {
    let base = Int((Double(completed) / Double(max(total, 1)) * 100).rounded())
    return min(100, max(0, base - penalty))
}

private enum TerminalLineKind {
    case system
    case command
    case output
    case error
    case success
}

private struct TerminalLine: Identifiable {
    let id = UUID()
    let text: String
    let kind: TerminalLineKind
}

private struct VirtualTerminalView: View {
    let prompt: String
    let lines: [TerminalLine]
    let suggestions: [String]
    let showSuggestions: Bool
    let onRun: (String) -> Void

    @State private var input = ""
    @FocusState private var inputFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                HStack(spacing: 6) {
                    Circle().fill(Color.red).frame(width: 9, height: 9)
                    Circle().fill(Color.yellow).frame(width: 9, height: 9)
                    Circle().fill(Color.green).frame(width: 9, height: 9)
                }

                Spacer()

                Text("StudyBuddy Terminal")
                    .font(.caption.monospaced().weight(.bold))
                    .foregroundStyle(Color.white.opacity(0.72))

                Spacer()

                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundStyle(Color.green)
                    .accessibilityLabel("Isolated")
            }
            .padding(.horizontal, 12)
            .frame(height: 36)
            .background(Color(red: 0.12, green: 0.13, blue: 0.15))

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 7) {
                        ForEach(lines) { line in
                            Text(line.text)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(color(for: line.kind))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                                .id(line.id)
                        }
                    }
                    .padding(12)
                }
                .frame(minHeight: 300, maxHeight: 380)
                .background(Color(red: 0.035, green: 0.045, blue: 0.055))
                .onChange(of: lines.count) {
                    guard let lastID = lines.last?.id else { return }
                    withAnimation {
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }

            HStack(spacing: 8) {
                Text(prompt)
                    .font(.caption.monospaced().weight(.bold))
                    .foregroundStyle(Color.green)

                TextField("Enter command", text: $input)
                    .font(.system(.body, design: .monospaced))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($inputFocused)
                    .onSubmit(runInput)

                Button(action: runInput) {
                    Image(systemName: "return")
                }
                .buttonStyle(.borderedProminent)
                .accessibilityLabel("Run command")
                .disabled(input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))

            if showSuggestions {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(suggestions, id: \.self) { suggestion in
                            Button(suggestion) {
                                input = suggestion
                                inputFocused = true
                            }
                            .buttonStyle(.bordered)
                            .font(.caption.monospaced())
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 10)
                }
                .background(Color(.secondarySystemBackground))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.primary.opacity(0.14))
        }
    }

    private func runInput() {
        let command = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !command.isEmpty else { return }
        input = ""
        onRun(command)
        inputFocused = true
    }

    private func color(for kind: TerminalLineKind) -> Color {
        switch kind {
        case .system: Color.cyan
        case .command: Color.white
        case .output: Color.white.opacity(0.82)
        case .error: Color(red: 1, green: 0.45, blue: 0.38)
        case .success: Color.green
        }
    }
}

struct NetworkTerminalSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var lines: [TerminalLine] = [
        TerminalLine(text: "StudyBuddy Network Shell 1.0", kind: .system),
        TerminalLine(text: "Ticket SB-1201-204 loaded. Type help for supported commands.", kind: .output)
    ]
    @State private var activityLog: [String] = []
    @State private var inspectedConfiguration = false
    @State private var gatewayReachable = false
    @State private var publicIPReachable = false
    @State private var observedDNSFailure = false
    @State private var cacheFlushed = false
    @State private var verifiedResolution = false
    @State private var unsupportedCommands = 0
    @State private var commandCount = 0

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "config",
                title: "Record the current IP configuration",
                isComplete: inspectedConfiguration,
                coaching: "Use ipconfig /all before changing the workstation."
            ),
            LabCheckpointSnapshot(
                id: "path",
                title: "Prove the local and external network path",
                isComplete: gatewayReachable && publicIPReachable,
                coaching: "Ping the default gateway and the known public test address."
            ),
            LabCheckpointSnapshot(
                id: "dns",
                title: "Observe the name-resolution failure",
                isComplete: observedDNSFailure,
                coaching: "Use nslookup against the ticket hostname."
            ),
            LabCheckpointSnapshot(
                id: "repair",
                title: "Apply a targeted DNS repair",
                isComplete: cacheFlushed,
                coaching: "Clear the resolver cache only after collecting evidence."
            ),
            LabCheckpointSnapshot(
                id: "verify",
                title: "Verify hostname resolution after repair",
                isComplete: verifiedResolution,
                coaching: "Repeat nslookup or ping the hostname after the repair."
            )
        ]
    }

    private var suggestions: [String] {
        if !inspectedConfiguration {
            return ["ipconfig /all", "help"]
        }
        if !gatewayReachable || !publicIPReachable {
            return ["ping 10.20.8.1", "ping 203.0.113.18", "nslookup portal.studybuddy.test"]
        }
        if !observedDNSFailure {
            return ["nslookup portal.studybuddy.test", "ipconfig /displaydns"]
        }
        if !cacheFlushed {
            return ["ipconfig /flushdns"]
        }
        return ["nslookup portal.studybuddy.test", "ping portal.studybuddy.test"]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Workstation Terminal")
                        .font(.headline)

                    VirtualTerminalView(
                        prompt: "C:\\>",
                        lines: lines,
                        suggestions: suggestions,
                        showSuggestions: mode == .guided,
                        onRun: run
                    )
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Terminal Work",
                isEnabled: commandCount >= 2,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    private func run(_ rawCommand: String) {
        let command = normalized(rawCommand)
        commandCount += 1
        activityLog.append("Ran \(rawCommand)")
        lines.append(TerminalLine(text: "C:\\> \(rawCommand)", kind: .command))

        switch command {
        case "help":
            appendOutput(
                "Supported: ipconfig /all, ipconfig /displaydns, ipconfig /flushdns, " +
                "ping <host>, nslookup <host>, cls"
            )

        case "cls", "clear":
            lines = [TerminalLine(text: "Terminal cleared.", kind: .system)]

        case "ipconfig /all", "ipconfig -all":
            inspectedConfiguration = true
            appendOutput(
                """
                Ethernet adapter Floor2:
                  IPv4 Address . . . . . : 10.20.8.44
                  Subnet Mask  . . . . . : 255.255.255.0
                  Default Gateway  . . . : 10.20.8.1
                  DNS Servers  . . . . . : 10.20.80.53
                  DHCP Enabled  . . . . . : Yes
                """
            )

        case "ipconfig /displaydns":
            appendOutput(
                cacheFlushed
                    ? "Resolver cache contains no negative entry for portal.studybuddy.test."
                    : "portal.studybuddy.test  Record Name: negative-cache  TTL: 742"
            )

        case "ipconfig /flushdns":
            cacheFlushed = true
            appendOutput("Successfully flushed the DNS Resolver Cache.", kind: .success)

        case "ping 10.20.8.1":
            gatewayReachable = true
            appendOutput("Reply from 10.20.8.1: bytes=32 time=1ms TTL=64", kind: .success)

        case "ping 203.0.113.18":
            publicIPReachable = true
            appendOutput("Reply from 203.0.113.18: bytes=32 time=18ms TTL=52", kind: .success)

        case "nslookup portal.studybuddy.test":
            if cacheFlushed {
                verifiedResolution = true
                appendOutput(
                    "Server: dns01.corp.studybuddy.test\nName: portal.studybuddy.test\nAddress: 203.0.113.18",
                    kind: .success
                )
            } else {
                observedDNSFailure = true
                appendOutput(
                    "Server: 10.20.80.53\n*** portal.studybuddy.test: cached name error",
                    kind: .error
                )
            }

        case "ping portal.studybuddy.test":
            if cacheFlushed {
                verifiedResolution = true
                appendOutput(
                    "Pinging portal.studybuddy.test [203.0.113.18]\nReply: bytes=32 time=18ms TTL=52",
                    kind: .success
                )
            } else {
                observedDNSFailure = true
                appendOutput("Ping request could not find host portal.studybuddy.test.", kind: .error)
            }

        default:
            unsupportedCommands += 1
            appendOutput(
                "'\(rawCommand)' is not available in this isolated training shell. Type help.",
                kind: .error
            )
        }
    }

    private func normalized(_ command: String) -> String {
        command
            .lowercased()
            .split(whereSeparator: \.isWhitespace)
            .joined(separator: " ")
    }

    private func appendOutput(_ text: String, kind: TerminalLineKind = .output) {
        lines.append(TerminalLine(text: text, kind: kind))
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed in the terminal."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(
            completed: completed,
            total: results.count,
            penalty: min(10, unsupportedCommands * 2)
        )
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You diagnosed and repaired the simulated DNS condition using terminal evidence."
                    : "The terminal state still has unverified or incomplete troubleshooting work."
            )
        )
    }
}

private enum PrinterBenchComponent: String, CaseIterable, Identifiable {
    case inputTray = "Input Tray"
    case toner = "Toner"
    case fuser = "Fuser"
    case output = "Output"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .inputTray: "tray.full"
        case .toner: "shippingbox"
        case .fuser: "heat.waves"
        case .output: "doc.text"
        }
    }
}

private enum PrinterMediaSetting: String, CaseIterable, Identifiable {
    case plain = "Plain"
    case labels = "Labels"
    case transparency = "Transparency"

    var id: String { rawValue }
}

struct PrinterWorkbenchSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var selectedComponent: PrinterBenchComponent = .inputTray
    @State private var inspectedComponents: Set<PrinterBenchComponent> = []
    @State private var mediaSetting: PrinterMediaSetting = .plain
    @State private var printedTestPage = false
    @State private var testPagePassed = false
    @State private var rubTestComplete = false
    @State private var ticketDocumented = false
    @State private var unnecessaryFuserReplacement = false
    @State private var activityLog: [String] = []

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "media",
                title: "Inspect the loaded media and tray configuration",
                isComplete: inspectedComponents.contains(.inputTray),
                coaching: "Open the input tray and compare the physical media with the configured media type."
            ),
            LabCheckpointSnapshot(
                id: "fuser",
                title: "Inspect the fuser before replacing parts",
                isComplete: inspectedComponents.contains(.fuser),
                coaching: "Check temperature and visible damage before deciding a fuser has failed."
            ),
            LabCheckpointSnapshot(
                id: "setting",
                title: "Configure the tray for label stock",
                isComplete: mediaSetting == .labels,
                coaching: "The printer needs the correct media profile to apply the proper fusing behavior."
            ),
            LabCheckpointSnapshot(
                id: "verify",
                title: "Print and physically verify a test label",
                isComplete: printedTestPage && testPagePassed && rubTestComplete,
                coaching: "Run a test page after the change, then perform the simulated rub test."
            ),
            LabCheckpointSnapshot(
                id: "document",
                title: "Document the repair",
                isComplete: ticketDocumented,
                coaching: "Save the observed cause, change, and verification in the service ticket."
            )
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Printer Workbench")
                            .font(.headline)
                        Spacer()
                        Label("SB-Laser 420", systemImage: "printer.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }

                    printerDiagram
                    componentInspector
                    configurationControls
                    verificationControls
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Service Ticket",
                isEnabled: !activityLog.isEmpty,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    private var printerDiagram: some View {
        VStack(spacing: 12) {
            Image(systemName: "printer.fill")
                .font(.system(size: 70, weight: .regular))
                .foregroundStyle(Color.primary.opacity(0.78))
                .frame(maxWidth: .infinity)
                .padding(.top, 12)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(PrinterBenchComponent.allCases) { component in
                    Button {
                        selectedComponent = component
                        inspectedComponents.insert(component)
                        activityLog.append("Inspected \(component.rawValue)")
                    } label: {
                        Label(component.rawValue, systemImage: component.systemImage)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedComponent == component ? lab.theme.color : .secondary)
                }
            }
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var componentInspector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(selectedComponent.rawValue, systemImage: selectedComponent.systemImage)
                .font(.headline)

            Text(observation(for: selectedComponent))
                .font(.callout)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            if selectedComponent == .fuser {
                Button(role: .destructive) {
                    unnecessaryFuserReplacement = true
                    activityLog.append("Replaced the fuser without evidence of failure")
                } label: {
                    Label("Replace Fuser", systemImage: "wrench.adjustable")
                }
                .buttonStyle(.bordered)
                .disabled(unnecessaryFuserReplacement)

                if unnecessaryFuserReplacement {
                    Text("The new fuser behaves the same. The removed unit tested within specification.")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var configurationControls: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Tray 1 Configuration")
                .font(.headline)

            Picker("Media type", selection: $mediaSetting) {
                ForEach(PrinterMediaSetting.allCases) { setting in
                    Text(setting.rawValue).tag(setting)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: mediaSetting) {
                printedTestPage = false
                testPagePassed = false
                rubTestComplete = false
                activityLog.append("Set Tray 1 media to \(mediaSetting.rawValue)")
            }

            LabeledContent("Physical media", value: "Laser labels")
            LabeledContent("Configured media", value: mediaSetting.rawValue)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var verificationControls: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Verification")
                .font(.headline)

            HStack {
                Button {
                    printedTestPage = true
                    testPagePassed = mediaSetting == .labels
                    rubTestComplete = false
                    activityLog.append("Printed a test label using \(mediaSetting.rawValue) mode")
                } label: {
                    Label("Print Test", systemImage: "doc.badge.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .tint(lab.theme.color)

                Button {
                    rubTestComplete = true
                    activityLog.append("Performed toner rub test")
                } label: {
                    Label("Rub Test", systemImage: "hand.tap")
                }
                .buttonStyle(.bordered)
                .disabled(!printedTestPage)
            }

            if printedTestPage {
                Label(
                    testPagePassed
                        ? "Test output: toner bonded evenly."
                        : "Test output: toner still wipes away.",
                    systemImage: testPagePassed ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
                )
                .font(.callout.weight(.semibold))
                .foregroundStyle(testPagePassed ? .green : .orange)
            }

            if rubTestComplete {
                Text(
                    testPagePassed
                        ? "Rub test passed. No loose toner transferred."
                        : "Rub test failed. Recheck media type and fusing requirements."
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Button {
                ticketDocumented = true
                activityLog.append("Saved cause, correction, and verification to ticket SB-1201-311")
            } label: {
                Label(ticketDocumented ? "Ticket Saved" : "Document Ticket", systemImage: "doc.text")
            }
            .buttonStyle(.bordered)
            .disabled(!rubTestComplete || ticketDocumented)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private func observation(for component: PrinterBenchComponent) -> String {
        switch component {
        case .inputTray:
            "Tray 1 contains laser-rated label stock. The printer control panel currently identifies the tray as Plain."
        case .toner:
            "The cartridge is seated correctly, has 64% remaining, and shows no spill or seal damage."
        case .fuser:
            "The fuser reaches its configured temperature, rotates freely, and has no visible film damage."
        case .output:
            "Text is complete and aligned, but toner on the label surface can be wiped away before correction."
        }
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed on the printer workbench."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(
            completed: completed,
            total: results.count,
            penalty: unnecessaryFuserReplacement ? 10 : 0
        )
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You corrected the simulated media mismatch and verified toner bonding."
                    : "The printer ticket still contains incomplete diagnosis, configuration, or verification work."
            )
        )
    }
}

private struct DesktopLauncherItem: Identifiable {
    let id: String
    let title: String
    let systemImage: String
}

private struct SimulationDesktopShell<Content: View>: View {
    let title: String
    let tint: Color
    let apps: [DesktopLauncherItem]
    let selectedAppID: String
    let onSelect: (String) -> Void
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "display")
                Text(title)
                    .font(.caption.weight(.bold))
                Spacer()
                Label("Training VM", systemImage: "lock.fill")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.green)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .frame(height: 38)
            .background(Color(red: 0.09, green: 0.15, blue: 0.19))

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4),
                spacing: 10
            ) {
                ForEach(apps) { app in
                    Button {
                        onSelect(app.id)
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: app.systemImage)
                                .font(.title2)
                                .frame(width: 38, height: 38)
                                .background(
                                    selectedAppID == app.id ? tint.opacity(0.24) : Color.white.opacity(0.12),
                                    in: RoundedRectangle(cornerRadius: 7)
                                )

                            Text(app.title)
                                .font(.caption2.weight(.semibold))
                                .lineLimit(1)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, minHeight: 66)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(10)
            .background(Color(red: 0.08, green: 0.27, blue: 0.31))

            VStack(spacing: 0) {
                HStack {
                    Circle()
                        .fill(tint)
                        .frame(width: 9, height: 9)
                    Text(apps.first { $0.id == selectedAppID }?.title ?? "Workspace")
                        .font(.caption.weight(.bold))
                    Spacer()
                    Image(systemName: "minus")
                    Image(systemName: "square")
                    Image(systemName: "xmark")
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 12)
                .frame(height: 36)
                .background(Color(.tertiarySystemBackground))

                content()
                    .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
                    .background(Color(.secondarySystemGroupedBackground))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 7))
        .overlay {
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color.primary.opacity(0.14))
        }
    }
}

private enum ServiceStartupType: String, CaseIterable, Identifiable {
    case automatic = "Automatic"
    case manual = "Manual"
    case disabled = "Disabled"

    var id: String { rawValue }
}

struct ServiceDesktopSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var selectedAppID = "services"
    @State private var openedApps: Set<String> = []
    @State private var eventLogReviewed = false
    @State private var servicePropertiesOpened = false
    @State private var pendingStartupType: ServiceStartupType = .manual
    @State private var appliedStartupType: ServiceStartupType = .manual
    @State private var serviceIsRunning = false
    @State private var rebootCount = 0
    @State private var verifiedAfterReboot = false
    @State private var ticketDocumented = false
    @State private var activityLog: [String] = []

    private let apps = [
        DesktopLauncherItem(id: "services", title: "Services", systemImage: "gearshape.2"),
        DesktopLauncherItem(id: "events", title: "Event Log", systemImage: "list.bullet.rectangle"),
        DesktopLauncherItem(id: "system", title: "System", systemImage: "desktopcomputer"),
        DesktopLauncherItem(id: "ticket", title: "Ticket", systemImage: "doc.text")
    ]

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "events",
                title: "Review startup and shutdown evidence",
                isComplete: eventLogReviewed,
                coaching: "Open Event Log and inspect the Inventory Agent entries."
            ),
            LabCheckpointSnapshot(
                id: "properties",
                title: "Inspect the service properties",
                isComplete: servicePropertiesOpened,
                coaching: "Open Services and select Inventory Agent."
            ),
            LabCheckpointSnapshot(
                id: "configure",
                title: "Apply Automatic startup",
                isComplete: appliedStartupType == .automatic,
                coaching: "Change the startup type and apply it before rebooting."
            ),
            LabCheckpointSnapshot(
                id: "reboot",
                title: "Restart the workstation",
                isComplete: rebootCount > 0,
                coaching: "Use System to simulate the failure condition after saving the change."
            ),
            LabCheckpointSnapshot(
                id: "verify",
                title: "Verify persistence and document the ticket",
                isComplete: verifiedAfterReboot && ticketDocumented,
                coaching: "Refresh Services after reboot, then save the result in the ticket."
            )
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Support Workstation")
                        .font(.headline)

                    SimulationDesktopShell(
                        title: "SB-CORP-044",
                        tint: lab.theme.color,
                        apps: apps,
                        selectedAppID: selectedAppID,
                        onSelect: selectApp
                    ) {
                        desktopContent
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Workstation Work",
                isEnabled: !activityLog.isEmpty,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    @ViewBuilder
    private var desktopContent: some View {
        switch selectedAppID {
        case "events":
            eventLogWindow
        case "system":
            systemWindow
        case "ticket":
            ticketWindow
        default:
            servicesWindow
        }
    }

    private var servicesWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Inventory Agent")
                        .font(.headline)
                    Text("Collects approved hardware inventory")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(serviceIsRunning ? "Running" : "Stopped")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(serviceIsRunning ? .green : .orange)
            }

            Button {
                servicePropertiesOpened = true
                activityLog.append("Opened Inventory Agent properties")
            } label: {
                Label("Open Properties", systemImage: "slider.horizontal.3")
            }
            .buttonStyle(.bordered)

            if servicePropertiesOpened {
                Picker("Startup type", selection: $pendingStartupType) {
                    ForEach(ServiceStartupType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Button {
                        appliedStartupType = pendingStartupType
                        activityLog.append("Applied \(pendingStartupType.rawValue) startup to Inventory Agent")
                    } label: {
                        Label("Apply", systemImage: "checkmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(lab.theme.color)

                    Button {
                        serviceIsRunning = true
                        activityLog.append("Started Inventory Agent manually")
                    } label: {
                        Label("Start", systemImage: "play.fill")
                    }
                    .buttonStyle(.bordered)
                    .disabled(serviceIsRunning)
                }

                LabeledContent("Applied type", value: appliedStartupType.rawValue)
                LabeledContent("Service account", value: "LocalSystem")
            }

            if rebootCount > 0 {
                Button {
                    verifiedAfterReboot = serviceIsRunning && appliedStartupType == .automatic
                    activityLog.append("Refreshed service status after reboot")
                } label: {
                    Label("Refresh After Reboot", systemImage: "arrow.clockwise")
                }
                .buttonStyle(.bordered)

                if verifiedAfterReboot {
                    Label("Inventory Agent persisted through reboot.", systemImage: "checkmark.seal.fill")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.green)
                }
            }
        }
        .padding()
    }

    private var eventLogWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("System Events")
                .font(.headline)

            eventRow(
                level: "Information",
                source: "Service Control Manager",
                detail: "Inventory Agent entered the running state after a manual request."
            )
            eventRow(
                level: "Information",
                source: "Service Control Manager",
                detail: "Normal shutdown completed. No Inventory Agent crash was recorded."
            )

            Button {
                eventLogReviewed = true
                activityLog.append("Reviewed Service Control Manager events")
            } label: {
                Label(eventLogReviewed ? "Evidence Reviewed" : "Mark Evidence Reviewed", systemImage: "doc.text.magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(eventLogReviewed)
        }
        .padding()
    }

    private var systemWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("System Controls")
                .font(.headline)

            LabeledContent("Computer", value: "SB-CORP-044")
            LabeledContent("Pending restart", value: "No")

            Button {
                rebootCount += 1
                serviceIsRunning = appliedStartupType == .automatic
                verifiedAfterReboot = false
                activityLog.append("Restarted workstation with service set to \(appliedStartupType.rawValue)")
            } label: {
                Label("Restart Workstation", systemImage: "power")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)

            if rebootCount > 0 {
                Text("Restart \(rebootCount) completed. Open Services and refresh the service status.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }

    private var ticketWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ticket SB-1202-188")
                .font(.headline)

            LabeledContent("Issue", value: "Agent stopped after reboot")
            LabeledContent("Startup type", value: appliedStartupType.rawValue)
            LabeledContent("Current status", value: serviceIsRunning ? "Running" : "Stopped")

            Button {
                ticketDocumented = true
                activityLog.append("Saved service cause, change, and reboot verification")
            } label: {
                Label(ticketDocumented ? "Ticket Saved" : "Save Resolution", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(!verifiedAfterReboot || ticketDocumented)
        }
        .padding()
    }

    private func eventRow(level: String, source: String, detail: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(level)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.blue)
                Spacer()
                Text(source)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text(detail)
                .font(.caption)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
    }

    private func selectApp(_ id: String) {
        selectedAppID = id
        openedApps.insert(id)
        activityLog.append("Opened \(apps.first { $0.id == id }?.title ?? id)")
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed in the support workstation."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(completed: completed, total: results.count)
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You repaired the simulated startup configuration and verified it through reboot."
                    : "The service ticket still has incomplete evidence, configuration, or persistence testing."
            )
        )
    }
}

struct MalwareDesktopSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var selectedAppID = "network"
    @State private var isIsolated = false
    @State private var isolatedBeforeScan = false
    @State private var startupReviewed = false
    @State private var startupItemDisabled = false
    @State private var definitionsUpdated = false
    @State private var scanCompleted = false
    @State private var threatQuarantined = false
    @State private var networkRestored = false
    @State private var browserVerified = false
    @State private var ticketDocumented = false
    @State private var unsafeScanAttempt = false
    @State private var activityLog: [String] = []

    private let apps = [
        DesktopLauncherItem(id: "network", title: "Network", systemImage: "network.slash"),
        DesktopLauncherItem(id: "startup", title: "Startup", systemImage: "list.bullet.rectangle.portrait"),
        DesktopLauncherItem(id: "scanner", title: "Scanner", systemImage: "shield.checkered"),
        DesktopLauncherItem(id: "browser", title: "Browser", systemImage: "safari"),
        DesktopLauncherItem(id: "ticket", title: "Ticket", systemImage: "doc.text")
    ]

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "isolate",
                title: "Isolate the workstation",
                isComplete: isolatedBeforeScan,
                coaching: "Disconnect the simulated network before scanning or remediation."
            ),
            LabCheckpointSnapshot(
                id: "startup",
                title: "Inspect and disable the suspicious startup item",
                isComplete: startupReviewed && startupItemDisabled,
                coaching: "Review Startup and disable BrowserSyncHelper after recording its details."
            ),
            LabCheckpointSnapshot(
                id: "scan",
                title: "Update and run the security scan",
                isComplete: definitionsUpdated && scanCompleted,
                coaching: "Update definitions, then scan while the workstation remains isolated."
            ),
            LabCheckpointSnapshot(
                id: "quarantine",
                title: "Quarantine the detected threat",
                isComplete: threatQuarantined,
                coaching: "Move the detected artifact into the simulated quarantine."
            ),
            LabCheckpointSnapshot(
                id: "verify",
                title: "Restore connectivity and verify the browser",
                isComplete: networkRestored && browserVerified,
                coaching: "Restore the network only after remediation, then run the browser verification."
            ),
            LabCheckpointSnapshot(
                id: "document",
                title: "Document the incident ticket",
                isComplete: ticketDocumented,
                coaching: "Save containment, indicators, remediation, and verification."
            )
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Incident Workstation")
                            .font(.headline)
                        Spacer()
                        Label(
                            isIsolated ? "Isolated" : "Connected",
                            systemImage: isIsolated ? "network.slash" : "network"
                        )
                        .font(.caption.weight(.bold))
                        .foregroundStyle(isIsolated ? .orange : .green)
                    }

                    SimulationDesktopShell(
                        title: "SB-FIN-117",
                        tint: lab.theme.color,
                        apps: apps,
                        selectedAppID: selectedAppID,
                        onSelect: selectApp
                    ) {
                        desktopContent
                    }
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Incident Work",
                isEnabled: !activityLog.isEmpty,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    @ViewBuilder
    private var desktopContent: some View {
        switch selectedAppID {
        case "startup":
            startupWindow
        case "scanner":
            scannerWindow
        case "browser":
            browserWindow
        case "ticket":
            incidentTicketWindow
        default:
            networkWindow
        }
    }

    private var networkWindow: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Network Adapter")
                .font(.headline)

            LabeledContent("Ethernet", value: isIsolated ? "Disconnected" : "Connected")
            LabeledContent("Corporate access", value: isIsolated ? "Blocked" : "Available")

            if isIsolated {
                Button {
                    isIsolated = false
                    networkRestored = threatQuarantined && startupItemDisabled && scanCompleted
                    activityLog.append("Restored workstation network connectivity")
                } label: {
                    Label("Restore Network", systemImage: "network")
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
            } else {
                Button {
                    isIsolated = true
                    if !scanCompleted {
                        isolatedBeforeScan = true
                    }
                    networkRestored = false
                    browserVerified = false
                    activityLog.append("Isolated workstation from the network")
                } label: {
                    Label("Isolate Workstation", systemImage: "network.slash")
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
        }
        .padding()
    }

    private var startupWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Startup Applications")
                .font(.headline)

            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("BrowserSyncHelper")
                        .font(.subheadline.weight(.semibold))
                    Text("Publisher: Unknown | Path: AppData/bsync.exe")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(startupItemDisabled ? "Disabled" : "Enabled")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(startupItemDisabled ? .orange : .green)
            }
            .padding(10)
            .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
            .onTapGesture {
                startupReviewed = true
                activityLog.append("Inspected BrowserSyncHelper startup metadata")
            }

            Button {
                startupReviewed = true
                startupItemDisabled = true
                activityLog.append("Disabled BrowserSyncHelper startup entry")
            } label: {
                Label("Disable Selected Item", systemImage: "nosign")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(startupItemDisabled)
        }
        .padding()
    }

    private var scannerWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Endpoint Scanner")
                .font(.headline)

            LabeledContent("Definitions", value: definitionsUpdated ? "Current" : "4 days old")
            LabeledContent("Last scan", value: scanCompleted ? "Completed" : "Not run")

            Button {
                definitionsUpdated = true
                activityLog.append("Updated scanner definitions")
            } label: {
                Label("Update Definitions", systemImage: "arrow.down.circle")
            }
            .buttonStyle(.bordered)
            .disabled(definitionsUpdated)

            Button {
                if !isIsolated {
                    unsafeScanAttempt = true
                }
                scanCompleted = definitionsUpdated
                activityLog.append(
                    isIsolated
                        ? "Ran full scan while isolated"
                        : "Attempted scan while workstation remained connected"
                )
            } label: {
                Label("Run Full Scan", systemImage: "magnifyingglass")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(!definitionsUpdated || scanCompleted)

            if scanCompleted {
                VStack(alignment: .leading, spacing: 6) {
                    Label("PUA.Redirector.BSync detected", systemImage: "exclamationmark.shield.fill")
                        .font(.callout.weight(.semibold))
                        .foregroundStyle(.orange)
                    Text("Path: AppData/bsync.exe | Startup persistence detected")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Button {
                        threatQuarantined = true
                        activityLog.append("Quarantined PUA.Redirector.BSync")
                    } label: {
                        Label(threatQuarantined ? "Quarantined" : "Move to Quarantine", systemImage: "archivebox")
                    }
                    .buttonStyle(.bordered)
                    .disabled(threatQuarantined)
                }
                .padding(10)
                .background(Color.orange.opacity(0.09), in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
    }

    private var browserWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Browser Verification")
                .font(.headline)

            LabeledContent("Network", value: isIsolated ? "Offline" : "Online")
            LabeledContent("Startup item", value: startupItemDisabled ? "Disabled" : "Enabled")
            LabeledContent("Threat", value: threatQuarantined ? "Quarantined" : "Active")

            Button {
                browserVerified = !isIsolated && threatQuarantined && startupItemDisabled && scanCompleted
                activityLog.append("Ran clean-browser redirect verification")
            } label: {
                Label("Open Clean Test Page", systemImage: "safari")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(isIsolated)

            if browserVerified {
                Label("Verification passed: no redirect or startup relaunch.", systemImage: "checkmark.seal.fill")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(.green)
            }
        }
        .padding()
    }

    private var incidentTicketWindow: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ticket SB-1202-341")
                .font(.headline)

            LabeledContent("Containment", value: isolatedBeforeScan ? "Recorded" : "Missing")
            LabeledContent("Indicator", value: scanCompleted ? "bsync.exe" : "Pending")
            LabeledContent("Remediation", value: threatQuarantined ? "Quarantined" : "Pending")
            LabeledContent("Verification", value: browserVerified ? "Passed" : "Pending")

            Button {
                ticketDocumented = true
                activityLog.append("Saved incident evidence, containment, remediation, and verification")
            } label: {
                Label(ticketDocumented ? "Ticket Saved" : "Save Incident Notes", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(!browserVerified || ticketDocumented)
        }
        .padding()
    }

    private func selectApp(_ id: String) {
        selectedAppID = id
        activityLog.append("Opened \(apps.first { $0.id == id }?.title ?? id)")
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed in the incident workstation."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(
            completed: completed,
            total: results.count,
            penalty: unsafeScanAttempt ? 8 : 0
        )
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You contained, remediated, and verified the simulated browser-redirect incident."
                    : "The incident workflow still has missing containment, remediation, verification, or documentation."
            )
        )
    }
}

private enum FirewallWorkspaceTab: String, CaseIterable, Identifiable {
    case rules = "Rules"
    case editor = "Editor"
    case tester = "Tester"
    case audit = "Audit"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .rules: "list.bullet.rectangle"
        case .editor: "slider.horizontal.3"
        case .tester: "arrow.left.arrow.right"
        case .audit: "doc.text.magnifyingglass"
        }
    }
}

private enum FirewallSourceScope: String, CaseIterable, Identifiable {
    case anyIPv4 = "Any IPv4"
    case adminSubnet = "Admin subnet"
    case branchLAN = "Branch LAN"

    var id: String { rawValue }

    var cidr: String {
        switch self {
        case .anyIPv4: "0.0.0.0/0"
        case .adminSubnet: "10.40.5.0/24"
        case .branchLAN: "10.40.0.0/16"
        }
    }
}

private enum PacketTestSource: String, CaseIterable, Identifiable {
    case admin = "Admin workstation"
    case internet = "Internet host"
    case branchUser = "Branch user"

    var id: String { rawValue }

    var address: String {
        switch self {
        case .admin: "10.40.5.27"
        case .internet: "198.51.100.91"
        case .branchUser: "10.40.22.18"
        }
    }
}

struct FirewallConsoleSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var selectedTab: FirewallWorkspaceTab = .rules
    @State private var ruleReviewed = false
    @State private var pendingSource: FirewallSourceScope = .anyIPv4
    @State private var appliedSource: FirewallSourceScope = .anyIPv4
    @State private var pendingLogging = false
    @State private var appliedLogging = false
    @State private var ruleApplied = false
    @State private var selectedPacketSource: PacketTestSource = .admin
    @State private var adminAllowedTest = false
    @State private var internetDeniedTest = false
    @State private var branchDeniedTest = false
    @State private var disabledRequiredRule = false
    @State private var activityLog: [String] = []

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "review",
                title: "Inspect the exposed management rule",
                isComplete: ruleReviewed,
                coaching: "Open Admin HTTPS and review its source, destination, service, and logging."
            ),
            LabCheckpointSnapshot(
                id: "scope",
                title: "Restrict the source to the admin subnet",
                isComplete: ruleApplied && appliedSource == .adminSubnet,
                coaching: "The approved management source is 10.40.5.0/24."
            ),
            LabCheckpointSnapshot(
                id: "logging",
                title: "Enable rule logging",
                isComplete: ruleApplied && appliedLogging,
                coaching: "Enable logging before applying the corrected rule."
            ),
            LabCheckpointSnapshot(
                id: "allow",
                title: "Prove approved admin access still works",
                isComplete: adminAllowedTest,
                coaching: "Use Packet Tester with the admin workstation source."
            ),
            LabCheckpointSnapshot(
                id: "deny",
                title: "Prove unapproved sources are denied",
                isComplete: internetDeniedTest && branchDeniedTest,
                coaching: "Test both an internet host and a normal branch user."
            )
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("Branch Edge Firewall", systemImage: "firewall.fill")
                            .font(.headline)
                        Spacer()
                        Label("Training", systemImage: "lock.fill")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.green)
                    }

                    firewallTabBar
                    firewallWorkspace
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Firewall Change",
                isEnabled: !activityLog.isEmpty,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    private var firewallTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FirewallWorkspaceTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Label(tab.rawValue, systemImage: tab.systemImage)
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedTab == tab ? lab.theme.color : .secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var firewallWorkspace: some View {
        switch selectedTab {
        case .rules:
            rulesWorkspace
        case .editor:
            editorWorkspace
        case .tester:
            testerWorkspace
        case .audit:
            auditWorkspace
        }
    }

    private var rulesWorkspace: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Rule")
                    .font(.caption.weight(.bold))
                Spacer()
                Text("Source")
                    .font(.caption.weight(.bold))
                Text("Action")
                    .font(.caption.weight(.bold))
                    .frame(width: 54)
            }
            .foregroundStyle(.secondary)

            firewallRuleRow(
                title: "Admin HTTPS",
                source: appliedSource.cidr,
                action: disabledRequiredRule ? "Off" : "Allow",
                isWarning: appliedSource == .anyIPv4
            ) {
                ruleReviewed = true
                pendingSource = appliedSource
                pendingLogging = appliedLogging
                selectedTab = .editor
                activityLog.append("Opened Admin HTTPS rule")
            }

            firewallReadOnlyRuleRow(
                title: "Outbound Web",
                source: "10.40.0.0/16",
                action: "Allow",
                isWarning: false
            )

            firewallReadOnlyRuleRow(
                title: "Default Inbound",
                source: "Any",
                action: "Deny",
                isWarning: false
            )
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var editorWorkspace: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Admin HTTPS")
                .font(.headline)

            LabeledContent("Destination", value: "Branch Firewall")
            LabeledContent("Service", value: "TCP 443")
            LabeledContent("Action", value: "Allow")

            Picker("Source", selection: $pendingSource) {
                ForEach(FirewallSourceScope.allCases) { source in
                    Text(source.rawValue).tag(source)
                }
            }

            LabeledContent("Source CIDR", value: pendingSource.cidr)

            Toggle("Log matching traffic", isOn: $pendingLogging)

            HStack {
                Button {
                    appliedSource = pendingSource
                    appliedLogging = pendingLogging
                    ruleApplied = true
                    disabledRequiredRule = false
                    adminAllowedTest = false
                    internetDeniedTest = false
                    branchDeniedTest = false
                    activityLog.append(
                        "Applied Admin HTTPS source \(pendingSource.cidr), logging \(pendingLogging ? "on" : "off")"
                    )
                } label: {
                    Label("Apply Rule", systemImage: "checkmark")
                }
                .buttonStyle(.borderedProminent)
                .tint(lab.theme.color)

                Button(role: .destructive) {
                    disabledRequiredRule = true
                    ruleApplied = false
                    activityLog.append("Disabled the required Admin HTTPS rule")
                } label: {
                    Label("Disable", systemImage: "nosign")
                }
                .buttonStyle(.bordered)
            }

            if appliedSource == .anyIPv4 {
                Label("Exposure: management is reachable from every IPv4 source.", systemImage: "exclamationmark.triangle.fill")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.orange)
            } else if ruleApplied {
                Label("Pending verification: validate both allowed and denied sources.", systemImage: "checkmark.circle")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var testerWorkspace: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Packet Tester")
                .font(.headline)

            Picker("Source host", selection: $selectedPacketSource) {
                ForEach(PacketTestSource.allCases) { source in
                    Text(source.rawValue).tag(source)
                }
            }

            LabeledContent("Source IP", value: selectedPacketSource.address)
            LabeledContent("Destination", value: "Branch Firewall")
            LabeledContent("Service", value: "TCP 443")

            Button {
                runPacketTest()
            } label: {
                Label("Run Packet Test", systemImage: "play.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(disabledRequiredRule)

            packetResult
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    @ViewBuilder
    private var packetResult: some View {
        let isAllowed = packetIsAllowed(selectedPacketSource)
        if activityLog.contains(where: { $0.contains("Tested \(selectedPacketSource.address)") }) {
            Label(
                isAllowed ? "Packet allowed by Admin HTTPS." : "Packet denied by Default Inbound.",
                systemImage: isAllowed ? "checkmark.circle.fill" : "xmark.octagon.fill"
            )
            .font(.callout.weight(.semibold))
            .foregroundStyle(isAllowed ? .green : .orange)

            if appliedLogging {
                Text("A matching audit entry was written.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var auditWorkspace: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Firewall Audit")
                .font(.headline)

            if activityLog.isEmpty {
                Text("No simulated changes or tests recorded.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(Array(activityLog.suffix(12).enumerated()), id: \.offset) { _, entry in
                    Label(entry, systemImage: "doc.text")
                        .font(.caption)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 300, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private func firewallRuleRow(
        title: String,
        source: String,
        action: String,
        isWarning: Bool,
        actionHandler: @escaping () -> Void
    ) -> some View {
        Button(action: actionHandler) {
            HStack {
                Image(systemName: isWarning ? "exclamationmark.triangle.fill" : "checkmark.circle")
                    .foregroundStyle(isWarning ? .orange : .secondary)

                Text(title)
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(source)
                    .font(.caption.monospaced())
                    .foregroundStyle(.secondary)
                Text(action)
                    .font(.caption.weight(.bold))
                    .frame(width: 54)
            }
            .padding(10)
            .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    private func firewallReadOnlyRuleRow(
        title: String,
        source: String,
        action: String,
        isWarning: Bool
    ) -> some View {
        HStack {
            Image(systemName: isWarning ? "exclamationmark.triangle.fill" : "checkmark.circle")
                .foregroundStyle(isWarning ? .orange : .secondary)

            Text(title)
                .font(.subheadline.weight(.semibold))
            Spacer()
            Text(source)
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
            Text(action)
                .font(.caption.weight(.bold))
                .frame(width: 54)
        }
        .padding(10)
        .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
    }

    private func packetIsAllowed(_ source: PacketTestSource) -> Bool {
        guard !disabledRequiredRule else { return false }
        return switch appliedSource {
        case .anyIPv4:
            true
        case .adminSubnet:
            source == .admin
        case .branchLAN:
            source == .admin || source == .branchUser
        }
    }

    private func runPacketTest() {
        let allowed = packetIsAllowed(selectedPacketSource)
        switch selectedPacketSource {
        case .admin:
            adminAllowedTest = allowed && appliedSource == .adminSubnet
        case .internet:
            internetDeniedTest = !allowed && appliedSource == .adminSubnet
        case .branchUser:
            branchDeniedTest = !allowed && appliedSource == .adminSubnet
        }
        activityLog.append(
            "Tested \(selectedPacketSource.address) to TCP 443: \(allowed ? "allowed" : "denied")"
        )
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed in the firewall console."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(
            completed: completed,
            total: results.count,
            penalty: disabledRequiredRule ? 10 : 0
        )
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You restricted the simulated management rule and proved least-privilege behavior."
                    : "The firewall change still has missing scope, logging, or packet-test validation."
            )
        )
    }
}

private enum SOCWorkspaceTab: String, CaseIterable, Identifiable {
    case alerts = "Alerts"
    case identity = "Identity"
    case activity = "Activity"
    case response = "Response"
    case notes = "Notes"

    var id: String { rawValue }

    var systemImage: String {
        switch self {
        case .alerts: "bell.badge"
        case .identity: "person.badge.key"
        case .activity: "list.bullet.clipboard"
        case .response: "shield.checkered"
        case .notes: "note.text"
        }
    }
}

private enum IncidentClassification: String, CaseIterable, Identifiable {
    case unclassified = "Unclassified"
    case falsePositive = "False positive"
    case confirmedCompromise = "Confirmed compromise"

    var id: String { rawValue }
}

struct SOCConsoleSimulation: View {
    let lab: SimulationLabDefinition
    let mode: LabInteractionMode
    let onComplete: (SimulationEnvironmentReport) -> Void

    @State private var selectedTab: SOCWorkspaceTab = .alerts
    @State private var alertOpened = false
    @State private var reviewedEvidence: Set<String> = []
    @State private var evidencePreserved = false
    @State private var classification: IncidentClassification = .unclassified
    @State private var sessionsRevoked = false
    @State private var credentialResetQueued = false
    @State private var mailboxRuleRemoved = false
    @State private var noteText = ""
    @State private var noteSaved = false
    @State private var activityLog: [String] = []

    private var checkpoints: [LabCheckpointSnapshot] {
        [
            LabCheckpointSnapshot(
                id: "alert",
                title: "Open and scope the impossible-travel alert",
                isComplete: alertOpened,
                coaching: "Open alert IT-701-94 and record the user and time window."
            ),
            LabCheckpointSnapshot(
                id: "identity",
                title: "Correlate both sign-ins and MFA evidence",
                isComplete: reviewedEvidence.isSuperset(of: ["local-signin", "remote-signin", "mfa"]),
                coaching: "Inspect the New York sign-in, overseas sign-in, and MFA history."
            ),
            LabCheckpointSnapshot(
                id: "activity",
                title: "Inspect post-authentication activity",
                isComplete: reviewedEvidence.contains("mailbox-rule"),
                coaching: "Review the mailbox rule created after the remote sign-in."
            ),
            LabCheckpointSnapshot(
                id: "classify",
                title: "Preserve evidence and classify the incident",
                isComplete: evidencePreserved && classification == .confirmedCompromise,
                coaching: "Preserve the evidence snapshot before recording the classification."
            ),
            LabCheckpointSnapshot(
                id: "contain",
                title: "Contain the compromised account",
                isComplete: sessionsRevoked && credentialResetQueued && mailboxRuleRemoved,
                coaching: "Revoke sessions, queue a credential reset, and remove the malicious mailbox rule."
            ),
            LabCheckpointSnapshot(
                id: "notes",
                title: "Save an analyst incident note",
                isComplete: noteSaved,
                coaching: "Write a brief evidence and response summary in Notes."
            )
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                LabMissionHeader(lab: lab, mode: mode)
                Divider()
                LabCheckpointPanel(checkpoints: checkpoints, mode: mode, tint: lab.theme.color)
                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label("StudyBuddy SOC", systemImage: "waveform.path.ecg.rectangle")
                            .font(.headline)
                        Spacer()
                        Text("1 high alert")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.red)
                    }

                    socTabBar
                    socWorkspace
                }
                .padding()
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            LabSubmissionBar(
                title: "Submit Investigation",
                isEnabled: !activityLog.isEmpty,
                tint: lab.theme.color,
                action: submit
            )
        }
    }

    private var socTabBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SOCWorkspaceTab.allCases) { tab in
                    Button {
                        selectedTab = tab
                    } label: {
                        Label(tab.rawValue, systemImage: tab.systemImage)
                    }
                    .buttonStyle(.bordered)
                    .tint(selectedTab == tab ? lab.theme.color : .secondary)
                }
            }
        }
    }

    @ViewBuilder
    private var socWorkspace: some View {
        switch selectedTab {
        case .alerts:
            alertWorkspace
        case .identity:
            identityWorkspace
        case .activity:
            activityWorkspace
        case .response:
            responseWorkspace
        case .notes:
            notesWorkspace
        }
    }

    private var alertWorkspace: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Alert Queue")
                .font(.headline)

            Button {
                alertOpened = true
                activityLog.append("Opened impossible-travel alert IT-701-94")
            } label: {
                HStack(alignment: .top, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Impossible travel with successful MFA")
                            .font(.subheadline.weight(.bold))
                        Text("User: a.chen | New York to Warsaw in 14 minutes")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("High")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.red)
                }
                .padding(10)
                .background(Color.red.opacity(0.08), in: RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)

            if alertOpened {
                LabeledContent("Alert ID", value: "IT-701-94")
                LabeledContent("Window", value: "14 minutes")
                LabeledContent("Account", value: "a.chen@corp.test")

                Button {
                    selectedTab = .identity
                } label: {
                    Label("Investigate Identity", systemImage: "arrow.right")
                }
                .buttonStyle(.borderedProminent)
                .tint(lab.theme.color)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var identityWorkspace: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Identity Evidence")
                .font(.headline)

            evidenceButton(
                id: "local-signin",
                title: "09:02 New York sign-in",
                detail: "Known managed laptop | 10.12.44.8 | expected browser"
            )
            evidenceButton(
                id: "remote-signin",
                title: "09:16 Warsaw sign-in",
                detail: "Unmanaged browser | 198.51.100.77 | new user agent"
            )
            evidenceButton(
                id: "mfa",
                title: "09:16 MFA event",
                detail: "Push approved after four denied prompts in 90 seconds"
            )

            if reviewedEvidence.isSuperset(of: ["local-signin", "remote-signin", "mfa"]) {
                Label(
                    "Correlation: impossible timing, new device, and MFA fatigue indicators.",
                    systemImage: "link"
                )
                .font(.caption.weight(.semibold))
                .foregroundStyle(.orange)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var activityWorkspace: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Post-authentication Activity")
                .font(.headline)

            evidenceButton(
                id: "mailbox-rule",
                title: "09:19 Mailbox rule created",
                detail: "Rule 'Invoices' forwards finance mail externally and marks it read"
            )

            LabeledContent("Privileged changes", value: "None")
            LabeledContent("File downloads", value: "3 finance documents")
            LabeledContent("External forwarding", value: "Enabled by new rule")
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var responseWorkspace: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Classification and Response")
                .font(.headline)

            Button {
                evidencePreserved = true
                activityLog.append("Preserved identity and mailbox evidence snapshot")
            } label: {
                Label(evidencePreserved ? "Evidence Preserved" : "Preserve Evidence Snapshot", systemImage: "archivebox")
            }
            .buttonStyle(.bordered)
            .disabled(evidencePreserved)

            Picker("Classification", selection: $classification) {
                ForEach(IncidentClassification.allCases) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .onChange(of: classification) {
                activityLog.append("Classified alert as \(classification.rawValue)")
            }

            Divider()

            responseButton(
                title: "Revoke Active Sessions",
                systemImage: "person.crop.circle.badge.xmark",
                isComplete: sessionsRevoked
            ) {
                sessionsRevoked = true
                activityLog.append("Revoked active account sessions")
            }

            responseButton(
                title: "Queue Credential Reset",
                systemImage: "key.horizontal",
                isComplete: credentialResetQueued
            ) {
                credentialResetQueued = true
                activityLog.append("Queued identity-verified credential reset")
            }

            responseButton(
                title: "Remove Mailbox Rule",
                systemImage: "envelope.badge.shield.half.filled",
                isComplete: mailboxRuleRemoved
            ) {
                mailboxRuleRemoved = true
                activityLog.append("Removed malicious external-forwarding rule")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private var notesWorkspace: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Analyst Note")
                .font(.headline)

            TextEditor(text: $noteText)
                .frame(minHeight: 150)
                .padding(8)
                .scrollContentBackground(.hidden)
                .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
                .overlay(alignment: .topLeading) {
                    if noteText.isEmpty {
                        Text("Summarize evidence, classification, containment, and follow-up...")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .padding(14)
                            .allowsHitTesting(false)
                    }
                }

            Text("\(noteText.count) characters")
                .font(.caption.monospacedDigit())
                .foregroundStyle(.secondary)

            Button {
                noteSaved = true
                activityLog.append("Saved analyst incident note")
            } label: {
                Label(noteSaved ? "Note Saved" : "Save Incident Note", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(noteText.trimmingCharacters(in: .whitespacesAndNewlines).count < 30 || noteSaved)
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 320, alignment: .topLeading)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 7))
    }

    private func evidenceButton(id: String, title: String, detail: String) -> some View {
        Button {
            reviewedEvidence.insert(id)
            activityLog.append("Reviewed \(title)")
        } label: {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: reviewedEvidence.contains(id) ? "checkmark.circle.fill" : "doc.text.magnifyingglass")
                    .foregroundStyle(reviewedEvidence.contains(id) ? .green : lab.theme.color)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline.weight(.semibold))
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 0)
            }
            .padding(10)
            .background(Color(.tertiarySystemBackground), in: RoundedRectangle(cornerRadius: 6))
        }
        .buttonStyle(.plain)
    }

    private func responseButton(
        title: String,
        systemImage: String,
        isComplete: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Label(isComplete ? "\(title) Complete" : title, systemImage: systemImage)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.bordered)
        .disabled(!evidencePreserved || classification != .confirmedCompromise || isComplete)
    }

    private func submit() {
        let results = checkpoints.map {
            SimulationCheckpointResult(
                id: $0.id,
                title: $0.title,
                isComplete: $0.isComplete,
                detail: $0.isComplete
                    ? "Completed in the SOC console."
                    : $0.coaching
            )
        }
        let completed = results.filter(\.isComplete).count
        let score = environmentScore(completed: completed, total: results.count)
        onComplete(
            SimulationEnvironmentReport(
                score: score,
                checkpoints: results,
                activityLog: activityLog,
                summary: score >= 75
                    ? "You correlated the simulated evidence, classified the compromise, and completed containment."
                    : "The investigation still has missing evidence review, classification, containment, or documentation."
            )
        )
    }
}
