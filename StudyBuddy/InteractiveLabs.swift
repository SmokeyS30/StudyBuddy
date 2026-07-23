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
            "Check each decision as you work and use optional coaching."
        case .challenge:
            "Complete the entire ticket before StudyBuddy grades your work."
        }
    }
}

enum LabChallengeKind: Hashable {
    case single
    case multiple
    case sequence
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

struct LabEvidence: Identifiable, Hashable {
    let id: String
    let title: String
    let value: String
    let systemImage: String
}

struct LabOption: Identifiable, Hashable {
    let id: String
    let title: String
    let detail: String
}

struct LabChallenge: Identifiable, Hashable {
    let id: String
    let kind: LabChallengeKind
    let title: String
    let prompt: String
    let hint: String
    let options: [LabOption]
    let correctAnswerIDs: [String]
    let explanation: String

    func randomized() -> LabChallenge {
        LabChallenge(
            id: id,
            kind: kind,
            title: title,
            prompt: prompt,
            hint: hint,
            options: options.shuffled(),
            correctAnswerIDs: correctAnswerIDs,
            explanation: explanation
        )
    }
}

struct InteractiveLabDefinition: Identifiable, Hashable {
    let id: String
    let examID: String
    let domainID: String
    let title: String
    let category: String
    let scenario: String
    let role: String
    let estimatedMinutes: Int
    let systemImage: String
    let theme: LabTheme
    let evidence: [LabEvidence]
    let challenges: [LabChallenge]
}

struct LabChallengeEvaluation: Identifiable, Hashable {
    let id: String
    let isCorrect: Bool
}

struct LabSessionResult: Hashable {
    let score: Int
    let correctCount: Int
    let totalCount: Int
    let elapsedSeconds: Int
    let evaluations: [LabChallengeEvaluation]

    var didPass: Bool { score >= 75 }
}

enum InteractiveLabCatalog {
    static func labs(for examID: String) -> [InteractiveLabDefinition] {
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

    private static let core1Labs: [InteractiveLabDefinition] = [
        InteractiveLabDefinition(
            id: "lab-1201-dns-floor2",
            examID: ExamCatalog.aPlusCore1.id,
            domainID: "1201-networking",
            title: "Floor 2 Name Resolution",
            category: "Network ticket",
            scenario: "A relocated workstation reaches the default gateway and public IP addresses, but websites fail when users enter hostnames. Other desks work normally.",
            role: "Field technician",
            estimatedMinutes: 8,
            systemImage: "network",
            theme: .cyan,
            evidence: [
                LabEvidence(id: "address", title: "Address", value: "10.20.8.44 /24", systemImage: "number"),
                LabEvidence(id: "gateway", title: "Gateway", value: "10.20.8.1 reachable", systemImage: "arrow.triangle.branch"),
                LabEvidence(id: "dns", title: "DNS", value: "10.20.80.53", systemImage: "server.rack"),
                LabEvidence(id: "test", title: "Test", value: "203.0.113.18 replies", systemImage: "checkmark.circle")
            ],
            challenges: [
                LabChallenge(
                    id: "diagnosis",
                    kind: .single,
                    title: "Classify the fault",
                    prompt: "Which subsystem should you investigate first?",
                    hint: "Separate IP reachability from hostname resolution.",
                    options: [
                        LabOption(id: "dns", title: "DNS configuration", detail: "The workstation may be using an unreachable or incorrect resolver."),
                        LabOption(id: "dhcp", title: "DHCP scope exhaustion", detail: "A scope problem would normally prevent a valid lease."),
                        LabOption(id: "switch", title: "Switch port failure", detail: "A failed port would prevent gateway and public IP replies."),
                        LabOption(id: "display", title: "Display driver", detail: "A display driver does not control name resolution.")
                    ],
                    correctAnswerIDs: ["dns"],
                    explanation: "Successful IP tests with failed hostname access point to DNS before DHCP, switching, or application repair."
                ),
                LabChallenge(
                    id: "evidence",
                    kind: .multiple,
                    title: "Collect evidence",
                    prompt: "Select the TWO lowest-risk checks that best confirm the diagnosis.",
                    hint: "Choose tests that compare resolver configuration and resolution behavior.",
                    options: [
                        LabOption(id: "lookup", title: "Query a hostname with nslookup", detail: "Shows which resolver responds and whether it returns an address."),
                        LabOption(id: "compare", title: "Compare DNS settings with a working desk", detail: "Reveals an incorrect server or suffix without changing state."),
                        LabOption(id: "reset", title: "Factory-reset the access point", detail: "Disruptive and unsupported by the current evidence."),
                        LabOption(id: "replace", title: "Replace the workstation NIC", detail: "IP connectivity already demonstrates that the adapter can communicate.")
                    ],
                    correctAnswerIDs: ["lookup", "compare"],
                    explanation: "A direct lookup and known-good comparison confirm the resolver path while preserving the original evidence."
                ),
                LabChallenge(
                    id: "resolver",
                    kind: .single,
                    title: "Apply the repair",
                    prompt: "The working desks use 10.20.8.53. Choose the best corrective action.",
                    hint: "Correct only the setting proven wrong.",
                    options: [
                        LabOption(id: "correct", title: "Change DNS to 10.20.8.53", detail: "Use the approved resolver for this subnet."),
                        LabOption(id: "public", title: "Use an unapproved public resolver", detail: "May bypass policy and internal name resolution."),
                        LabOption(id: "static", title: "Replace the entire lease with arbitrary static values", detail: "Changes unrelated settings and may create conflicts."),
                        LabOption(id: "disable", title: "Disable IPv4", detail: "Would remove the currently working path.")
                    ],
                    correctAnswerIDs: ["correct"],
                    explanation: "The resolver address is the isolated difference, so correcting that one setting is the least disruptive repair."
                ),
                LabChallenge(
                    id: "verify",
                    kind: .sequence,
                    title: "Verify and close",
                    prompt: "Put the final actions in the best order.",
                    hint: "Test the repaired function, test the user workflow, then document.",
                    options: [
                        LabOption(id: "resolve", title: "Resolve an approved hostname", detail: "Confirm the DNS response first."),
                        LabOption(id: "browse", title: "Open the user's required site", detail: "Verify the original workflow."),
                        LabOption(id: "record", title: "Record cause, change, and results", detail: "Close the ticket with reproducible notes.")
                    ],
                    correctAnswerIDs: ["resolve", "browse", "record"],
                    explanation: "Technical verification should precede user-workflow verification and final documentation."
                )
            ]
        ),
        InteractiveLabDefinition(
            id: "lab-1201-laser-fuser",
            examID: ExamCatalog.aPlusCore1.id,
            domainID: "1201-hardware",
            title: "Loose Toner Service Call",
            category: "Hardware bench",
            scenario: "A laser printer produces complete pages, but text smears when touched. The correct toner cartridge is installed and no paper jam is present.",
            role: "Depot technician",
            estimatedMinutes: 7,
            systemImage: "printer",
            theme: .orange,
            evidence: [
                LabEvidence(id: "output", title: "Output", value: "Complete but smears", systemImage: "doc.text"),
                LabEvidence(id: "media", title: "Media", value: "Approved 20 lb paper", systemImage: "doc"),
                LabEvidence(id: "toner", title: "Toner", value: "Correct cartridge", systemImage: "shippingbox"),
                LabEvidence(id: "status", title: "Status", value: "No error code", systemImage: "info.circle")
            ],
            challenges: [
                LabChallenge(
                    id: "stage",
                    kind: .single,
                    title: "Identify the failed stage",
                    prompt: "Which laser-printing stage is most closely associated with this symptom?",
                    hint: "The image is present, but it is not permanently bonded to the page.",
                    options: [
                        LabOption(id: "fusing", title: "Fusing", detail: "Heat and pressure bond toner to the media."),
                        LabOption(id: "processing", title: "Processing", detail: "Creates the page image before mechanical printing."),
                        LabOption(id: "exposing", title: "Exposing", detail: "Writes the latent image to the drum."),
                        LabOption(id: "cleaning", title: "Cleaning", detail: "Removes residual toner after transfer.")
                    ],
                    correctAnswerIDs: ["fusing"],
                    explanation: "Toner that reaches the page but rubs off was not bonded correctly during fusing."
                ),
                LabChallenge(
                    id: "checks",
                    kind: .multiple,
                    title: "Inspect safely",
                    prompt: "Select the TWO best checks before replacing a part.",
                    hint: "Confirm media compatibility and the component associated with heat and pressure.",
                    options: [
                        LabOption(id: "media", title: "Verify media type in the tray and driver", detail: "Heavy or specialty media can require different fuser temperature and speed."),
                        LabOption(id: "fuser", title: "Inspect the fuser for damage after cooling", detail: "A worn or failed fuser can leave toner loose."),
                        LabOption(id: "pickup", title: "Replace every pickup roller", detail: "Pickup rollers affect feeding, not toner bonding."),
                        LabOption(id: "network", title: "Reconfigure the printer IP address", detail: "Networking does not cause loose toner.")
                    ],
                    correctAnswerIDs: ["media", "fuser"],
                    explanation: "Media configuration and fuser condition are targeted, low-risk checks for incomplete toner bonding."
                ),
                LabChallenge(
                    id: "safety",
                    kind: .single,
                    title: "Control the hazard",
                    prompt: "What should happen before physically inspecting the fuser?",
                    hint: "This assembly operates at high temperature.",
                    options: [
                        LabOption(id: "cool", title: "Power down and allow cooling", detail: "Follow the service procedure before touching the assembly."),
                        LabOption(id: "touch", title: "Touch it immediately to test temperature", detail: "Creates a burn hazard."),
                        LabOption(id: "water", title: "Cool it with water", detail: "Can damage the printer and create electrical hazards."),
                        LabOption(id: "live", title: "Keep printing during inspection", detail: "Exposes the technician to moving and hot parts.")
                    ],
                    correctAnswerIDs: ["cool"],
                    explanation: "The printer must be powered down and the fuser allowed to cool according to the service procedure."
                ),
                LabChallenge(
                    id: "close",
                    kind: .sequence,
                    title: "Return to service",
                    prompt: "Arrange the final workflow.",
                    hint: "Repair, test, then document.",
                    options: [
                        LabOption(id: "repair", title: "Correct media settings or replace the failed fuser", detail: "Apply the supported repair."),
                        LabOption(id: "test", title: "Print and rub-test several approved pages", detail: "Confirm toner bonds consistently."),
                        LabOption(id: "document", title: "Record parts, settings, and test results", detail: "Complete the maintenance history.")
                    ],
                    correctAnswerIDs: ["repair", "test", "document"],
                    explanation: "A supported repair must be followed by repeatable output testing and maintenance documentation."
                )
            ]
        )
    ]

    private static let core2Labs: [InteractiveLabDefinition] = [
        InteractiveLabDefinition(
            id: "lab-1202-service-startup",
            examID: ExamCatalog.aPlusCore2.id,
            domainID: "1202-troubleshooting",
            title: "Service Fails After Reboot",
            category: "Virtual desktop",
            scenario: "A required inventory agent runs when started manually but remains stopped after every reboot. Event history shows a normal shutdown and no malware indicators.",
            role: "Desktop support technician",
            estimatedMinutes: 8,
            systemImage: "desktopcomputer",
            theme: .indigo,
            evidence: [
                LabEvidence(id: "manual", title: "Manual start", value: "Successful", systemImage: "play.circle"),
                LabEvidence(id: "startup", title: "Startup type", value: "Manual", systemImage: "gearshape"),
                LabEvidence(id: "account", title: "Service account", value: "Valid", systemImage: "person.badge.key"),
                LabEvidence(id: "event", title: "Event log", value: "No crash recorded", systemImage: "list.bullet.rectangle")
            ],
            challenges: [
                LabChallenge(
                    id: "cause",
                    kind: .single,
                    title: "Find the cause",
                    prompt: "Which configuration most directly explains the symptom?",
                    hint: "The service works, but Windows is not instructed to launch it during startup.",
                    options: [
                        LabOption(id: "manual", title: "Startup type is Manual", detail: "The service waits for an explicit start request."),
                        LabOption(id: "dns", title: "DNS cache is stale", detail: "Does not explain a consistently stopped local service."),
                        LabOption(id: "disk", title: "Disk requires formatting", detail: "The operating system and service both run."),
                        LabOption(id: "profile", title: "User wallpaper is corrupt", detail: "Unrelated to service control.")
                    ],
                    correctAnswerIDs: ["manual"],
                    explanation: "A service that starts successfully by hand but not at boot points first to its startup configuration."
                ),
                LabChallenge(
                    id: "evidence",
                    kind: .multiple,
                    title: "Confirm before change",
                    prompt: "Select the TWO records that should be captured before modifying the service.",
                    hint: "Preserve the original configuration and the relevant event evidence.",
                    options: [
                        LabOption(id: "properties", title: "Current service properties", detail: "Preserves startup type, account, and dependencies."),
                        LabOption(id: "events", title: "Relevant service-control events", detail: "Provides a before-change evidence trail."),
                        LabOption(id: "photos", title: "The user's vacation photos", detail: "Not relevant to the incident."),
                        LabOption(id: "printer", title: "Printer toner level", detail: "Not related to service startup.")
                    ],
                    correctAnswerIDs: ["properties", "events"],
                    explanation: "Capture the current service configuration and related event records before making a reversible change."
                ),
                LabChallenge(
                    id: "change",
                    kind: .single,
                    title: "Apply the least disruptive fix",
                    prompt: "Policy requires this agent at startup. Which change is appropriate?",
                    hint: "Use the service's supported startup control.",
                    options: [
                        LabOption(id: "automatic", title: "Set startup type to Automatic", detail: "Starts the required service during normal boot."),
                        LabOption(id: "reinstall", title: "Reinstall Windows immediately", detail: "Disproportionate to a confirmed configuration issue."),
                        LabOption(id: "admin", title: "Make every user a local administrator", detail: "Creates unnecessary security exposure."),
                        LabOption(id: "firewall", title: "Disable the firewall", detail: "Does not control whether the service starts.")
                    ],
                    correctAnswerIDs: ["automatic"],
                    explanation: "Changing the approved service to Automatic addresses the proven cause without broad system changes."
                ),
                LabChallenge(
                    id: "verify",
                    kind: .sequence,
                    title: "Verify persistence",
                    prompt: "Arrange the validation steps.",
                    hint: "Test the actual failure condition before closing the ticket.",
                    options: [
                        LabOption(id: "restart", title: "Restart the workstation", detail: "Reproduce the condition that previously failed."),
                        LabOption(id: "status", title: "Confirm the service is running", detail: "Verify startup behavior."),
                        LabOption(id: "function", title: "Confirm the inventory agent reports normally", detail: "Test the business function."),
                        LabOption(id: "notes", title: "Document the change and rollback", detail: "Close with complete support notes.")
                    ],
                    correctAnswerIDs: ["restart", "status", "function", "notes"],
                    explanation: "A reboot, service check, functional check, and documented rollback prove the repair is persistent and supportable."
                )
            ]
        ),
        InteractiveLabDefinition(
            id: "lab-1202-malware-flow",
            examID: ExamCatalog.aPlusCore2.id,
            domainID: "1202-security",
            title: "Redirecting Browser Ticket",
            category: "Incident workflow",
            scenario: "A user reports repeated browser redirects and an unfamiliar startup item. The workstation contains business data and is connected to the corporate network.",
            role: "Support and security liaison",
            estimatedMinutes: 9,
            systemImage: "shield.lefthalf.filled",
            theme: .red,
            evidence: [
                LabEvidence(id: "browser", title: "Browser", value: "Unexpected redirects", systemImage: "safari"),
                LabEvidence(id: "startup", title: "Startup", value: "Unknown updater", systemImage: "bolt"),
                LabEvidence(id: "network", title: "Network", value: "Connected", systemImage: "wifi"),
                LabEvidence(id: "edr", title: "Protection", value: "Definitions outdated", systemImage: "exclamationmark.shield")
            ],
            challenges: [
                LabChallenge(
                    id: "first",
                    kind: .single,
                    title: "Choose the first response",
                    prompt: "What is the best immediate action after recording the symptoms?",
                    hint: "Limit spread and command-and-control traffic while preserving the system for analysis.",
                    options: [
                        LabOption(id: "isolate", title: "Isolate the workstation from the network", detail: "Contains likely malicious communication without wiping evidence."),
                        LabOption(id: "wipe", title: "Erase the drive immediately", detail: "Destroys evidence and user data before scope is known."),
                        LabOption(id: "ignore", title: "Tell the user to keep working", detail: "Allows possible compromise to continue."),
                        LabOption(id: "share", title: "Copy the unknown program to coworkers", detail: "Expands exposure.")
                    ],
                    correctAnswerIDs: ["isolate"],
                    explanation: "Isolation is the appropriate containment step after documenting symptoms when active compromise is plausible."
                ),
                LabChallenge(
                    id: "preserve",
                    kind: .multiple,
                    title: "Preserve useful evidence",
                    prompt: "Select the THREE useful evidence sources to capture.",
                    hint: "Focus on execution, persistence, and network indicators.",
                    options: [
                        LabOption(id: "process", title: "Running processes and startup entries", detail: "Shows current execution and persistence."),
                        LabOption(id: "alerts", title: "Security alerts and scan history", detail: "Provides detection context."),
                        LabOption(id: "connections", title: "Recent network destinations", detail: "May identify command-and-control indicators."),
                        LabOption(id: "theme", title: "Desktop theme color", detail: "Does not support this investigation."),
                        LabOption(id: "mouse", title: "Mouse pointer speed", detail: "Unrelated to compromise.")
                    ],
                    correctAnswerIDs: ["process", "alerts", "connections"],
                    explanation: "Processes, persistence locations, security alerts, and network indicators establish what ran and where it communicated."
                ),
                LabChallenge(
                    id: "remediate",
                    kind: .single,
                    title: "Choose remediation",
                    prompt: "After evidence is captured, what is the best supported next step?",
                    hint: "Use approved, current security tooling before returning the device to service.",
                    options: [
                        LabOption(id: "scan", title: "Update approved tools and perform remediation scans", detail: "Uses current signatures and supported cleanup procedures."),
                        LabOption(id: "disable", title: "Permanently disable all security tools", detail: "Removes protection and visibility."),
                        LabOption(id: "restore", title: "Restore connectivity before scanning", detail: "May allow malicious traffic to resume."),
                        LabOption(id: "rename", title: "Rename the suspicious file only", detail: "Does not address persistence or related artifacts.")
                    ],
                    correctAnswerIDs: ["scan"],
                    explanation: "Approved tools should be updated and used to remediate the isolated system after evidence collection."
                ),
                LabChallenge(
                    id: "return",
                    kind: .sequence,
                    title: "Return safely",
                    prompt: "Arrange the closing workflow.",
                    hint: "Verify, patch, reconnect, and monitor.",
                    options: [
                        LabOption(id: "verify", title: "Verify scans are clean and symptoms are gone", detail: "Confirm remediation first."),
                        LabOption(id: "patch", title: "Apply required operating-system and application updates", detail: "Close known exposure."),
                        LabOption(id: "connect", title: "Reconnect through the approved process", detail: "Restore controlled network access."),
                        LabOption(id: "monitor", title: "Monitor and document follow-up indicators", detail: "Watch for recurrence and complete the ticket.")
                    ],
                    correctAnswerIDs: ["verify", "patch", "connect", "monitor"],
                    explanation: "A clean verification and patching should precede reconnection, monitoring, and final documentation."
                )
            ]
        )
    ]

    private static let securityLabs: [InteractiveLabDefinition] = [
        InteractiveLabDefinition(
            id: "lab-701-firewall-admin",
            examID: ExamCatalog.securityPlus.id,
            domainID: "701-architecture",
            title: "Exposed Admin Interface",
            category: "Firewall configuration",
            scenario: "A branch firewall permits inbound HTTPS administration from any internet address. Administrators connect only through VPN address space 10.90.0.0/24.",
            role: "Security analyst",
            estimatedMinutes: 9,
            systemImage: "firewall",
            theme: .teal,
            evidence: [
                LabEvidence(id: "source", title: "Current source", value: "0.0.0.0/0", systemImage: "globe"),
                LabEvidence(id: "service", title: "Service", value: "TCP 443 admin", systemImage: "lock"),
                LabEvidence(id: "vpn", title: "Admin VPN", value: "10.90.0.0/24", systemImage: "network.badge.shield.half.filled"),
                LabEvidence(id: "logging", title: "Deny logging", value: "Disabled", systemImage: "doc.text")
            ],
            challenges: [
                LabChallenge(
                    id: "risk",
                    kind: .single,
                    title: "Identify the primary risk",
                    prompt: "What is the most important weakness in the current rule?",
                    hint: "Compare the allowed source with the actual administrative path.",
                    options: [
                        LabOption(id: "broad", title: "The source includes the entire internet", detail: "Any internet host can reach the management service."),
                        LabOption(id: "https", title: "The rule uses encrypted HTTPS", detail: "Encryption is appropriate but does not justify broad exposure."),
                        LabOption(id: "vpn", title: "Administrators have VPN addresses", detail: "The VPN range enables a narrower rule."),
                        LabOption(id: "branch", title: "The firewall is at a branch", detail: "Location alone is not the weakness.")
                    ],
                    correctAnswerIDs: ["broad"],
                    explanation: "The management plane is exposed to 0.0.0.0/0 even though legitimate administration comes from one VPN range."
                ),
                LabChallenge(
                    id: "rule",
                    kind: .single,
                    title: "Build the replacement rule",
                    prompt: "Which source and destination service apply least privilege?",
                    hint: "Allow only the documented administrator network to the required management port.",
                    options: [
                        LabOption(id: "vpn443", title: "10.90.0.0/24 to firewall TCP 443", detail: "Limits management access to approved VPN clients."),
                        LabOption(id: "all443", title: "0.0.0.0/0 to firewall TCP 443", detail: "Preserves the original exposure."),
                        LabOption(id: "vpnall", title: "10.90.0.0/24 to every internal port", detail: "Allows far more access than required."),
                        LabOption(id: "denyall", title: "Deny all traffic without an admin exception", detail: "Would prevent required administration.")
                    ],
                    correctAnswerIDs: ["vpn443"],
                    explanation: "Restricting TCP 443 management to the documented VPN subnet satisfies the requirement with the narrowest access."
                ),
                LabChallenge(
                    id: "controls",
                    kind: .multiple,
                    title: "Add supporting controls",
                    prompt: "Select the TWO controls that best improve detection and recovery.",
                    hint: "Choose one visibility control and one safe-change control.",
                    options: [
                        LabOption(id: "denylog", title: "Log denied management attempts", detail: "Creates evidence of scanning or unauthorized access."),
                        LabOption(id: "rollback", title: "Save a tested rollback path", detail: "Supports recovery if approved access is interrupted."),
                        LabOption(id: "share", title: "Share the admin password broadly", detail: "Weakens accountability and access control."),
                        LabOption(id: "disablevpn", title: "Disable the approved VPN", detail: "Removes the intended secure path.")
                    ],
                    correctAnswerIDs: ["denylog", "rollback"],
                    explanation: "Deny logging improves visibility, while a tested rollback path controls operational risk during the change."
                ),
                LabChallenge(
                    id: "deploy",
                    kind: .sequence,
                    title: "Deploy safely",
                    prompt: "Arrange the change workflow.",
                    hint: "Preserve recovery, add the new path, test it, then remove the old exposure.",
                    options: [
                        LabOption(id: "backup", title: "Back up the current configuration", detail: "Create a recoverable starting point."),
                        LabOption(id: "add", title: "Add the restricted VPN rule", detail: "Establish the approved path."),
                        LabOption(id: "test", title: "Test approved and unapproved sources", detail: "Confirm allow and deny behavior."),
                        LabOption(id: "remove", title: "Remove the broad internet rule", detail: "Close the exposure after validation."),
                        LabOption(id: "monitor", title: "Monitor logs and document the change", detail: "Verify production behavior.")
                    ],
                    correctAnswerIDs: ["backup", "add", "test", "remove", "monitor"],
                    explanation: "A recoverable, tested transition prevents lockout while ensuring the broad rule is removed and monitored."
                )
            ]
        ),
        InteractiveLabDefinition(
            id: "lab-701-impossible-travel",
            examID: ExamCatalog.securityPlus.id,
            domainID: "701-operations",
            title: "Impossible Travel Investigation",
            category: "Log investigation",
            scenario: "An employee signs in from New York and twelve minutes later from an overseas address. MFA was accepted for the second session, followed by a new mailbox forwarding rule.",
            role: "SOC analyst",
            estimatedMinutes: 10,
            systemImage: "doc.text.magnifyingglass",
            theme: .red,
            evidence: [
                LabEvidence(id: "first", title: "09:14", value: "New York, managed device", systemImage: "laptopcomputer"),
                LabEvidence(id: "second", title: "09:26", value: "Overseas, unknown device", systemImage: "globe"),
                LabEvidence(id: "mfa", title: "MFA", value: "Push accepted", systemImage: "checkmark.shield"),
                LabEvidence(id: "mail", title: "09:31", value: "Forwarding rule created", systemImage: "envelope.badge.shield.half.filled")
            ],
            challenges: [
                LabChallenge(
                    id: "classification",
                    kind: .single,
                    title: "Classify the alert",
                    prompt: "Which interpretation is best supported by the combined evidence?",
                    hint: "MFA acceptance alone does not prove the user intended the session.",
                    options: [
                        LabOption(id: "likely", title: "Likely account compromise", detail: "Impossible travel, unknown device, and mailbox change form a coherent attack pattern."),
                        LabOption(id: "benign", title: "Definitely benign travel", detail: "The time interval and post-login action require investigation."),
                        LabOption(id: "hardware", title: "Local hard-drive failure", detail: "Does not explain identity and mailbox events."),
                        LabOption(id: "printer", title: "Printer configuration error", detail: "Unrelated to the evidence.")
                    ],
                    correctAnswerIDs: ["likely"],
                    explanation: "The location anomaly, unknown device, accepted prompt, and forwarding rule collectively support likely account compromise."
                ),
                LabChallenge(
                    id: "scope",
                    kind: .multiple,
                    title: "Determine scope",
                    prompt: "Select the THREE highest-value evidence sources for immediate review.",
                    hint: "Trace authentication, session activity, and changes made after access.",
                    options: [
                        LabOption(id: "signin", title: "Identity-provider sign-in and MFA logs", detail: "Shows device, method, IP, and authentication sequence."),
                        LabOption(id: "audit", title: "Mailbox and cloud audit logs", detail: "Shows rules, messages, downloads, and privileged actions."),
                        LabOption(id: "endpoint", title: "Managed endpoint telemetry", detail: "Helps validate the legitimate session and user activity."),
                        LabOption(id: "cafeteria", title: "Cafeteria menu", detail: "Does not establish account scope."),
                        LabOption(id: "weather", title: "Local weather report", detail: "Does not validate authentication or cloud activity.")
                    ],
                    correctAnswerIDs: ["signin", "audit", "endpoint"],
                    explanation: "Identity, cloud audit, and endpoint telemetry establish how access occurred, what changed, and which session was legitimate."
                ),
                LabChallenge(
                    id: "contain",
                    kind: .multiple,
                    title: "Contain the account",
                    prompt: "Select the THREE appropriate immediate containment actions.",
                    hint: "Stop active access, remove persistence, and restore trustworthy authentication.",
                    options: [
                        LabOption(id: "revoke", title: "Revoke active sessions and tokens", detail: "Terminates current authenticated access."),
                        LabOption(id: "disable", title: "Temporarily disable or lock the account", detail: "Prevents new sign-ins during investigation."),
                        LabOption(id: "reset", title: "Reset credentials and MFA through verification", detail: "Re-establishes trusted authentication."),
                        LabOption(id: "announce", title: "Post the password in the team chat", detail: "Creates another compromise."),
                        LabOption(id: "ignore", title: "Wait for another alert", detail: "Allows the attacker to continue.")
                    ],
                    correctAnswerIDs: ["revoke", "disable", "reset"],
                    explanation: "Session revocation, temporary lockout, and verified credential/MFA reset contain access and restore account control."
                ),
                LabChallenge(
                    id: "response",
                    kind: .sequence,
                    title: "Complete the response",
                    prompt: "Arrange the remaining response steps.",
                    hint: "Preserve, contain, remove unauthorized changes, then monitor and close.",
                    options: [
                        LabOption(id: "preserve", title: "Preserve relevant identity and cloud evidence", detail: "Maintain the investigation record."),
                        LabOption(id: "contain", title: "Execute approved account containment", detail: "Stop active misuse."),
                        LabOption(id: "remove", title: "Remove the forwarding rule and other persistence", detail: "Reverse unauthorized changes."),
                        LabOption(id: "hunt", title: "Hunt for related users, IPs, and indicators", detail: "Determine broader scope."),
                        LabOption(id: "monitor", title: "Monitor, notify, and document lessons learned", detail: "Complete recovery and improvement.")
                    ],
                    correctAnswerIDs: ["preserve", "contain", "remove", "hunt", "monitor"],
                    explanation: "Evidence preservation supports defensible containment, cleanup, wider threat hunting, and documented recovery."
                )
            ]
        )
    ]
}

struct HandsOnLabsList: View {
    @EnvironmentObject private var store: StudyBuddyStore
    @State private var mode: LabInteractionMode = .guided

    private var labs: [InteractiveLabDefinition] {
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
                        InteractiveLabSessionView(lab: lab, mode: mode)
                    } label: {
                        InteractiveLabRow(
                            lab: lab,
                            bestScore: store.labBestScores[lab.id]
                        )
                    }
                }
            } header: {
                Text("\(store.displayExamCode) labs")
            } footer: {
                Text("Original StudyBuddy simulations mapped to the selected exam. These are not official CompTIA labs or live exam items.")
            }
        }
        .listStyle(.insetGrouped)
    }
}

private struct InteractiveLabRow: View {
    let lab: InteractiveLabDefinition
    let bestScore: Int?

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: lab.systemImage)
                .font(.title3.weight(.semibold))
                .foregroundStyle(lab.theme.color)
                .frame(width: 34, height: 34)
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

                Text(lab.category)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(lab.theme.color)

                Text(lab.scenario)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)

                Label("\(lab.estimatedMinutes) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 5)
    }
}

struct InteractiveLabSessionView: View {
    @EnvironmentObject private var store: StudyBuddyStore

    let lab: InteractiveLabDefinition
    let mode: LabInteractionMode

    @State private var challenges: [LabChallenge]
    @State private var currentIndex = 0
    @State private var singleSelections: [String: String] = [:]
    @State private var multipleSelections: [String: Set<String>] = [:]
    @State private var sequenceSelections: [String: [String]] = [:]
    @State private var evaluations: [String: LabChallengeEvaluation] = [:]
    @State private var visibleHintID: String?
    @State private var result: LabSessionResult?
    @State private var startedAt = Date.now
    @State private var feedbackTrigger = 0
    @State private var showingResetConfirmation = false

    init(lab: InteractiveLabDefinition, mode: LabInteractionMode) {
        self.lab = lab
        self.mode = mode
        _challenges = State(initialValue: lab.challenges.map { $0.randomized() })
    }

    private var currentChallenge: LabChallenge {
        challenges[currentIndex]
    }

    private var currentEvaluation: LabChallengeEvaluation? {
        evaluations[currentChallenge.id]
    }

    private var isCurrentAnswered: Bool {
        switch currentChallenge.kind {
        case .single:
            singleSelections[currentChallenge.id] != nil
        case .multiple:
            multipleSelections[currentChallenge.id, default: []].count == currentChallenge.correctAnswerIDs.count
        case .sequence:
            sequenceSelections[currentChallenge.id, default: []].count == currentChallenge.correctAnswerIDs.count
        }
    }

    var body: some View {
        Group {
            if let result {
                LabResultScreen(
                    lab: lab,
                    mode: mode,
                    challenges: challenges,
                    result: result,
                    restart: resetSession
                )
            } else {
                sessionContent
            }
        }
        .navigationTitle(lab.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if result == nil {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingResetConfirmation = true
                    } label: {
                        Label("Reset lab", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
        .confirmationDialog(
            "Reset this lab session?",
            isPresented: $showingResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset Lab", role: .destructive, action: resetSession)
            Button("Cancel", role: .cancel) {}
        }
        .sensoryFeedback(.success, trigger: feedbackTrigger)
    }

    private var sessionContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                sessionHeader
                Divider()
                evidenceSection
                Divider()
                challengeSection
            }
        }
        .background(Color(.systemGroupedBackground))
        .safeAreaInset(edge: .bottom) {
            sessionControls
        }
    }

    private var sessionHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label(mode.rawValue, systemImage: mode.systemImage)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(lab.theme.color)
                Spacer()
                Text("\(currentIndex + 1) of \(challenges.count)")
                    .font(.caption.monospacedDigit().weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: Double(currentIndex + 1), total: Double(challenges.count))
                .tint(lab.theme.color)

            Text(lab.scenario)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)

            Label("Role: \(lab.role)", systemImage: "person.text.rectangle")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(lab.theme.color.opacity(0.08))
    }

    private var evidenceSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Evidence")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(lab.evidence) { item in
                        VStack(alignment: .leading, spacing: 7) {
                            Label(item.title, systemImage: item.systemImage)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(lab.theme.color)
                            Text(item.value)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(width: 174, height: 86, alignment: .topLeading)
                        .padding(12)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }

    private var challengeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 7) {
                Text(currentChallenge.title)
                    .font(.title3.weight(.bold))
                Text(currentChallenge.prompt)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            challengeInput

            if mode == .guided {
                guidedSupport
            }
        }
        .padding()
        .animation(.easeInOut(duration: 0.2), value: currentIndex)
    }

    @ViewBuilder
    private var challengeInput: some View {
        switch currentChallenge.kind {
        case .single:
            singleChoiceInput
        case .multiple:
            multipleChoiceInput
        case .sequence:
            sequenceInput
        }
    }

    private var singleChoiceInput: some View {
        VStack(spacing: 10) {
            ForEach(currentChallenge.options) { option in
                LabOptionButton(
                    option: option,
                    selectionState: singleSelections[currentChallenge.id] == option.id ? .selected : .unselected,
                    isEnabled: currentEvaluation == nil
                ) {
                    singleSelections[currentChallenge.id] = option.id
                }
            }
        }
    }

    private var multipleChoiceInput: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Select all that apply")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            ForEach(currentChallenge.options) { option in
                let selected = multipleSelections[currentChallenge.id, default: []].contains(option.id)
                LabOptionButton(
                    option: option,
                    selectionState: selected ? .selected : .unselected,
                    isEnabled: currentEvaluation == nil
                ) {
                    var values = multipleSelections[currentChallenge.id, default: []]
                    if selected {
                        values.remove(option.id)
                    } else {
                        values.insert(option.id)
                    }
                    multipleSelections[currentChallenge.id] = values
                }
            }
        }
    }

    private var sequenceInput: some View {
        let selectedIDs = sequenceSelections[currentChallenge.id, default: []]
        let selectedOptions = selectedIDs.compactMap { id in
            currentChallenge.options.first { $0.id == id }
        }
        let availableOptions = currentChallenge.options.filter { !selectedIDs.contains($0.id) }

        return VStack(alignment: .leading, spacing: 16) {
            Text("Your sequence")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            if selectedOptions.isEmpty {
                Text("Tap the actions below to build the response order.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
                    .padding(.horizontal, 12)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
            } else {
                ForEach(Array(selectedOptions.enumerated()), id: \.element.id) { index, option in
                    HStack(spacing: 10) {
                        Text("\(index + 1)")
                            .font(.caption.monospacedDigit().weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 26, height: 26)
                            .background(lab.theme.color, in: Circle())

                        Text(option.title)
                            .font(.subheadline.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Button {
                            moveSequenceItem(from: index, offset: -1)
                        } label: {
                            Label("Move up", systemImage: "chevron.up")
                        }
                        .disabled(index == 0 || currentEvaluation != nil)

                        Button {
                            moveSequenceItem(from: index, offset: 1)
                        } label: {
                            Label("Move down", systemImage: "chevron.down")
                        }
                        .disabled(index == selectedOptions.count - 1 || currentEvaluation != nil)

                        Button(role: .destructive) {
                            removeSequenceItem(option.id)
                        } label: {
                            Label("Remove", systemImage: "xmark")
                        }
                        .disabled(currentEvaluation != nil)
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderless)
                    .padding(10)
                    .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                }
            }

            if !availableOptions.isEmpty {
                Text("Available actions")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                ForEach(availableOptions) { option in
                    Button {
                        sequenceSelections[currentChallenge.id, default: []].append(option.id)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundStyle(lab.theme.color)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(option.title)
                                    .font(.subheadline.weight(.semibold))
                                Text(option.detail)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                    .disabled(currentEvaluation != nil)
                }
            }
        }
    }

    @ViewBuilder
    private var guidedSupport: some View {
        if let currentEvaluation {
            VStack(alignment: .leading, spacing: 8) {
                Label(
                    currentEvaluation.isCorrect ? "Correct decision" : "Review this decision",
                    systemImage: currentEvaluation.isCorrect ? "checkmark.circle.fill" : "exclamationmark.triangle.fill"
                )
                .font(.headline)
                .foregroundStyle(currentEvaluation.isCorrect ? .green : .orange)

                Text(currentChallenge.explanation)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                (currentEvaluation.isCorrect ? Color.green : Color.orange).opacity(0.1),
                in: RoundedRectangle(cornerRadius: 8)
            )
        } else {
            Button {
                withAnimation(.easeInOut) {
                    visibleHintID = visibleHintID == currentChallenge.id ? nil : currentChallenge.id
                }
            } label: {
                Label(
                    visibleHintID == currentChallenge.id ? "Hide coaching" : "Show coaching",
                    systemImage: "lightbulb"
                )
            }
            .buttonStyle(.bordered)

            if visibleHintID == currentChallenge.id {
                Text(currentChallenge.hint)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.yellow.opacity(0.12), in: RoundedRectangle(cornerRadius: 8))
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    private var sessionControls: some View {
        HStack(spacing: 12) {
            Button {
                currentIndex = max(0, currentIndex - 1)
                visibleHintID = nil
            } label: {
                Label("Back", systemImage: "chevron.left")
            }
            .buttonStyle(.bordered)
            .disabled(currentIndex == 0)

            Spacer()

            Button(action: primaryAction) {
                Label(primaryButtonTitle, systemImage: primaryButtonIcon)
                    .frame(minWidth: 120)
            }
            .buttonStyle(.borderedProminent)
            .tint(lab.theme.color)
            .disabled(!isCurrentAnswered)
        }
        .padding()
        .background(.bar)
    }

    private var primaryButtonTitle: String {
        if mode == .guided && currentEvaluation == nil {
            return "Check"
        }
        return currentIndex == challenges.count - 1 ? "Finish Lab" : "Next"
    }

    private var primaryButtonIcon: String {
        if mode == .guided && currentEvaluation == nil {
            return "checkmark.circle"
        }
        return currentIndex == challenges.count - 1 ? "flag.checkered" : "chevron.right"
    }

    private func primaryAction() {
        if mode == .guided && currentEvaluation == nil {
            let evaluation = evaluate(currentChallenge)
            evaluations[currentChallenge.id] = evaluation
            if evaluation.isCorrect {
                feedbackTrigger += 1
            }
            return
        }

        if currentIndex == challenges.count - 1 {
            finishSession()
        } else {
            currentIndex += 1
            visibleHintID = nil
        }
    }

    private func evaluate(_ challenge: LabChallenge) -> LabChallengeEvaluation {
        let isCorrect: Bool
        switch challenge.kind {
        case .single:
            isCorrect = singleSelections[challenge.id].map { [$0] == challenge.correctAnswerIDs } ?? false
        case .multiple:
            isCorrect = multipleSelections[challenge.id, default: []] == Set(challenge.correctAnswerIDs)
        case .sequence:
            isCorrect = sequenceSelections[challenge.id, default: []] == challenge.correctAnswerIDs
        }
        return LabChallengeEvaluation(id: challenge.id, isCorrect: isCorrect)
    }

    private func finishSession() {
        let finalEvaluations = challenges.map(evaluate)
        let correctCount = finalEvaluations.filter(\.isCorrect).count
        let score = Int((Double(correctCount) / Double(max(challenges.count, 1)) * 100).rounded())
        let elapsed = max(1, Int(Date.now.timeIntervalSince(startedAt)))
        let sessionResult = LabSessionResult(
            score: score,
            correctCount: correctCount,
            totalCount: challenges.count,
            elapsedSeconds: elapsed,
            evaluations: finalEvaluations
        )
        evaluations = Dictionary(uniqueKeysWithValues: finalEvaluations.map { ($0.id, $0) })
        result = sessionResult
        store.recordLabResult(labID: lab.id, score: score)
        if sessionResult.didPass {
            feedbackTrigger += 1
        }
    }

    private func moveSequenceItem(from index: Int, offset: Int) {
        var values = sequenceSelections[currentChallenge.id, default: []]
        let destination = index + offset
        guard values.indices.contains(index), values.indices.contains(destination) else { return }
        values.swapAt(index, destination)
        sequenceSelections[currentChallenge.id] = values
    }

    private func removeSequenceItem(_ id: String) {
        sequenceSelections[currentChallenge.id, default: []].removeAll { $0 == id }
    }

    private func resetSession() {
        challenges = lab.challenges.map { $0.randomized() }
        currentIndex = 0
        singleSelections = [:]
        multipleSelections = [:]
        sequenceSelections = [:]
        evaluations = [:]
        visibleHintID = nil
        result = nil
        startedAt = .now
    }
}

private enum LabOptionSelectionState {
    case unselected
    case selected
}

private struct LabOptionButton: View {
    let option: LabOption
    let selectionState: LabOptionSelectionState
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: selectionState == .selected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(selectionState == .selected ? Color.accentColor : Color.secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(option.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)
                    Text(option.detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .background(
                selectionState == .selected
                    ? Color.accentColor.opacity(0.12)
                    : Color(.secondarySystemGroupedBackground),
                in: RoundedRectangle(cornerRadius: 8)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        selectionState == .selected ? Color.accentColor.opacity(0.65) : Color.clear,
                        lineWidth: 1.5
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

private struct LabResultScreen: View {
    let lab: InteractiveLabDefinition
    let mode: LabInteractionMode
    let challenges: [LabChallenge]
    let result: LabSessionResult
    let restart: () -> Void

    private var elapsedLabel: String {
        let minutes = result.elapsedSeconds / 60
        let seconds = result.elapsedSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    Image(systemName: result.didPass ? "checkmark.seal.fill" : "target")
                        .font(.system(size: 48, weight: .semibold))
                        .foregroundStyle(result.didPass ? .green : .orange)

                    Text(result.didPass ? "Lab Complete" : "Keep Training")
                        .font(.title.bold())

                    Text("\(result.score)%")
                        .font(.system(size: 46, weight: .bold, design: .rounded))
                        .monospacedDigit()

                    Text(
                        result.didPass
                            ? "You met the 75% completion standard."
                            : "Review the missed decisions and run a fresh variation."
                    )
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                    HStack(spacing: 22) {
                        Label("\(result.correctCount)/\(result.totalCount)", systemImage: "checkmark.circle")
                        Label(elapsedLabel, systemImage: "clock")
                        Label(mode.rawValue, systemImage: mode.systemImage)
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background((result.didPass ? Color.green : Color.orange).opacity(0.09))

                VStack(alignment: .leading, spacing: 18) {
                    Text("Decision Review")
                        .font(.title3.bold())

                    ForEach(challenges) { challenge in
                        let evaluation = result.evaluations.first { $0.id == challenge.id }
                        VStack(alignment: .leading, spacing: 8) {
                            Label(
                                challenge.title,
                                systemImage: evaluation?.isCorrect == true ? "checkmark.circle.fill" : "xmark.circle.fill"
                            )
                            .font(.headline)
                            .foregroundStyle(evaluation?.isCorrect == true ? .green : .red)

                            Text(challenge.explanation)
                                .font(.callout)
                                .foregroundStyle(.secondary)

                            Text("Best response: \(correctAnswerText(for: challenge))")
                                .font(.caption.weight(.semibold))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if challenge.id != challenges.last?.id {
                            Divider()
                        }
                    }

                    Button(action: restart) {
                        Label("Start Fresh Variation", systemImage: "shuffle")
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

    private func correctAnswerText(for challenge: LabChallenge) -> String {
        challenge.correctAnswerIDs.compactMap { id in
            challenge.options.first { $0.id == id }?.title
        }
        .joined(separator: challenge.kind == .sequence ? " -> " : ", ")
    }
}
