import Foundation

enum ExamCatalog {
    private static let comptiaDisclaimer = "StudyBuddy is independent study software. It is not affiliated with, endorsed by, or sponsored by CompTIA. CompTIA, A+, and Security+ are trademarks of CompTIA, Inc. Practice questions are original study prompts, not real exam questions."

    static let aPlusCore1 = ExamProfile(
        id: "comptia-a-plus-core-1-220-1201",
        name: "CompTIA A+ Core 1",
        code: "220-1201",
        summary: "Study guidance for mobile devices, networking, hardware, virtualization, cloud computing, and hardware or network troubleshooting. Content is original study material and should be checked against the official objectives before submission.",
        domains: [
            ExamDomain(
                id: "1201-mobile",
                title: "Mobile Devices",
                weight: 13,
                focus: "Support laptops, mobile hardware, accessories, displays, power, connectivity, and mobile device configuration.",
                objectives: [
                    "Compare laptop components such as batteries, keyboards, storage, memory, wireless cards, displays, and docking stations.",
                    "Connect mobile devices using Bluetooth, NFC, USB, cellular, tethering, and hotspot features.",
                    "Configure email, synchronization, MFA prompts, location services, screen locks, and app permissions.",
                    "Recognize mobile display, charging, battery, overheating, touch, and connectivity symptoms.",
                    "Choose appropriate accessories such as styluses, headsets, card readers, docking stations, and privacy screens.",
                    "Apply safe support habits before opening small devices or handling glued, sealed, or high-density components."
                ]
            ),
            ExamDomain(
                id: "1201-networking",
                title: "Networking",
                weight: 23,
                focus: "Understand ports, protocols, network hardware, IP addressing, wireless standards, and basic network services.",
                objectives: [
                    "Memorize common ports and protocols for web, email, file transfer, remote access, directory, DNS, DHCP, and SMB services.",
                    "Compare routers, switches, access points, modems, firewalls, patch panels, and PoE injectors.",
                    "Explain IPv4, IPv6, subnet masks, gateways, DNS, DHCP, APIPA, NAT, VPNs, and VLAN basics.",
                    "Compare wireless standards, encryption types, channels, bands, SSIDs, interference, and roaming behavior.",
                    "Use network tools such as ping, ipconfig, tracert, nslookup, netstat, and cable testers.",
                    "Recognize when cloud, wired, wireless, or cellular networking is the best fit for a scenario."
                ]
            ),
            ExamDomain(
                id: "1201-hardware",
                title: "Hardware",
                weight: 25,
                focus: "Install, identify, and support PC components, storage, printers, cables, connectors, and peripheral devices.",
                objectives: [
                    "Identify motherboard form factors, CPU sockets, RAM types, expansion slots, firmware, TPM, and power connectors.",
                    "Compare storage types including HDD, SATA SSD, NVMe, optical media, flash media, RAID, and external drives.",
                    "Select power supplies, cooling, thermal paste, fans, UPS units, surge protectors, and power protection.",
                    "Install printers and understand laser, inkjet, thermal, impact, and 3D printer maintenance needs.",
                    "Identify cables and connectors such as USB, Thunderbolt, HDMI, DisplayPort, RJ45, fiber, SATA, and power connectors.",
                    "Match components to use cases such as gaming, virtualization, office work, NAS, video editing, and small-form-factor builds."
                ]
            ),
            ExamDomain(
                id: "1201-cloud",
                title: "Virtualization and Cloud",
                weight: 11,
                focus: "Explain client-side virtualization, cloud concepts, resource requirements, and service models.",
                objectives: [
                    "Compare IaaS, PaaS, SaaS, public, private, hybrid, community, and metered cloud models.",
                    "Explain rapid elasticity, high availability, shared resources, file synchronization, and cloud-hosted applications.",
                    "Prepare a client for virtualization with CPU support, RAM, storage, networking, and security requirements.",
                    "Understand snapshots, virtual networks, sandboxing, virtual desktops, and test environments.",
                    "Recognize resource contention, internet dependency, licensing, and data location concerns.",
                    "Choose cloud or local resources based on cost, availability, performance, and manageability."
                ]
            ),
            ExamDomain(
                id: "1201-troubleshooting",
                title: "Hardware and Network Troubleshooting",
                weight: 28,
                focus: "Diagnose PC hardware, mobile, printer, and network symptoms using a repeatable troubleshooting process.",
                objectives: [
                    "Use the six-step troubleshooting method before replacing parts or changing configuration.",
                    "Troubleshoot no power, POST errors, boot failures, overheating, shutdowns, noise, and intermittent hardware faults.",
                    "Resolve storage, RAID, display, peripheral, printer, and mobile device hardware symptoms.",
                    "Diagnose wired and wireless symptoms such as limited connectivity, no DHCP address, interference, DNS failure, and slow speeds.",
                    "Use logs, diagnostic lights, beep codes, vendor tools, loopback plugs, cable testers, and known-good parts.",
                    "Verify full functionality, document the fix, and explain prevention steps."
                ]
            )
        ],
        studyTasks: [
            StudyTask(id: "1201-mobile-1", domainID: "1201-mobile", title: "Laptop part map", detail: "Sketch a laptop and label storage, RAM, battery, Wi-Fi, keyboard, display, webcam, speakers, and docking options.", minutes: 35),
            StudyTask(id: "1201-mobile-2", domainID: "1201-mobile", title: "Mobile connection drill", detail: "Compare Bluetooth, NFC, USB, cellular, hotspot, and tethering by use case and failure symptom.", minutes: 35),
            StudyTask(id: "1201-mobile-3", domainID: "1201-mobile", title: "Mobile config checklist", detail: "Review email setup, app permissions, location services, screen locks, MFA, and backup or sync settings.", minutes: 40),
            StudyTask(id: "1201-mobile-4", domainID: "1201-mobile", title: "Battery and display symptoms", detail: "List likely causes for swelling, overheating, dim display, flicker, bad touch input, and charging failure.", minutes: 30),
            StudyTask(id: "1201-networking-1", domainID: "1201-networking", title: "Ports and protocols", detail: "Memorize common port numbers and write the technician clue that points to each service.", minutes: 45),
            StudyTask(id: "1201-networking-2", domainID: "1201-networking", title: "Network device roles", detail: "Compare modem, router, switch, access point, firewall, patch panel, hub, bridge, and PoE injector.", minutes: 35),
            StudyTask(id: "1201-networking-3", domainID: "1201-networking", title: "IP addressing basics", detail: "Practice DHCP, static IP, APIPA, gateway, subnet mask, DNS, NAT, IPv6, and VPN scenarios.", minutes: 45),
            StudyTask(id: "1201-networking-4", domainID: "1201-networking", title: "Wireless diagnosis", detail: "Review SSID, bands, channels, encryption, interference, antenna placement, and roaming behavior.", minutes: 40),
            StudyTask(id: "1201-hardware-1", domainID: "1201-hardware", title: "Motherboard tour", detail: "Identify CPU, RAM, PCIe, M.2, SATA, TPM, BIOS or UEFI, fan headers, and power connectors.", minutes: 45),
            StudyTask(id: "1201-hardware-2", domainID: "1201-hardware", title: "Storage and RAID", detail: "Compare HDD, SATA SSD, NVMe, flash, optical, external drives, RAID 0, RAID 1, and RAID 5.", minutes: 45),
            StudyTask(id: "1201-hardware-3", domainID: "1201-hardware", title: "Printer flow", detail: "Review laser imaging steps, inkjet maintenance, thermal use cases, impact printers, and 3D printer basics.", minutes: 40),
            StudyTask(id: "1201-hardware-4", domainID: "1201-hardware", title: "Cable match game", detail: "Match USB, Thunderbolt, HDMI, DisplayPort, RJ45, fiber, SATA, and power connectors to scenarios.", minutes: 35),
            StudyTask(id: "1201-cloud-1", domainID: "1201-cloud", title: "Cloud model cards", detail: "Make cards for IaaS, PaaS, SaaS, public, private, hybrid, and metered cloud services.", minutes: 35),
            StudyTask(id: "1201-cloud-2", domainID: "1201-cloud", title: "Virtual machine requirements", detail: "Write the minimum host resources and settings needed for a stable client-side VM.", minutes: 35),
            StudyTask(id: "1201-cloud-3", domainID: "1201-cloud", title: "Snapshot scenarios", detail: "Practice when snapshots, sandboxes, test VMs, and virtual networks are helpful or risky.", minutes: 30),
            StudyTask(id: "1201-cloud-4", domainID: "1201-cloud", title: "Cloud tradeoffs", detail: "Compare local and cloud choices for cost, availability, internet dependency, security, and performance.", minutes: 35),
            StudyTask(id: "1201-troubleshooting-1", domainID: "1201-troubleshooting", title: "POST and power symptoms", detail: "Practice scenarios for no power, beep codes, shutdowns, overheating, fan noise, and boot loops.", minutes: 45),
            StudyTask(id: "1201-troubleshooting-2", domainID: "1201-troubleshooting", title: "Storage failures", detail: "Match symptoms to loose cables, failed drives, corrupt file systems, RAID issues, and firmware settings.", minutes: 40),
            StudyTask(id: "1201-troubleshooting-3", domainID: "1201-troubleshooting", title: "Network symptom lab", detail: "Diagnose APIPA, bad DNS, wrong gateway, weak signal, interference, duplicate IP, and bad cable symptoms.", minutes: 45),
            StudyTask(id: "1201-troubleshooting-4", domainID: "1201-troubleshooting", title: "Printer and mobile triage", detail: "Review paper jams, image defects, calibration, stuck print queues, charging issues, and swollen batteries.", minutes: 40)
        ],
        flashcards: [
            Flashcard(id: "1201-fc-001", domainID: "1201-mobile", front: "What does a swollen mobile battery require?", back: "Stop using the device, avoid puncturing the battery, follow safe handling rules, and replace through an approved process."),
            Flashcard(id: "1201-fc-002", domainID: "1201-mobile", front: "What is tethering?", back: "Sharing a mobile device's cellular data connection with another device over USB, Bluetooth, or Wi-Fi hotspot."),
            Flashcard(id: "1201-fc-003", domainID: "1201-mobile", front: "What does NFC usually support?", back: "Very short-range communication for payments, pairing, access badges, and quick data exchange."),
            Flashcard(id: "1201-fc-004", domainID: "1201-networking", front: "What does DHCP provide?", back: "Automatic IP configuration such as IP address, subnet mask, gateway, DNS, and lease information."),
            Flashcard(id: "1201-fc-005", domainID: "1201-networking", front: "What does APIPA indicate?", back: "A Windows device self-assigned a 169.254.x.x address because it did not receive DHCP configuration."),
            Flashcard(id: "1201-fc-006", domainID: "1201-networking", front: "What port is DNS commonly associated with?", back: "Port 53, usually UDP for queries and TCP for zone transfers or large responses."),
            Flashcard(id: "1201-fc-007", domainID: "1201-networking", front: "What does NAT do?", back: "It translates private internal addresses to public addresses for internet communication."),
            Flashcard(id: "1201-fc-008", domainID: "1201-hardware", front: "What is NVMe?", back: "A high-performance storage protocol commonly used by PCIe-based solid-state drives."),
            Flashcard(id: "1201-fc-009", domainID: "1201-hardware", front: "What does TPM support?", back: "Hardware-backed security features such as measured boot, key protection, and disk encryption support."),
            Flashcard(id: "1201-fc-010", domainID: "1201-hardware", front: "What does RAID 1 provide?", back: "Mirroring across drives for redundancy, not a replacement for backups."),
            Flashcard(id: "1201-fc-011", domainID: "1201-hardware", front: "What is the first laser printer imaging step?", back: "Processing, followed by charging, exposing, developing, transferring, fusing, and cleaning."),
            Flashcard(id: "1201-fc-012", domainID: "1201-cloud", front: "What is IaaS?", back: "Cloud-hosted infrastructure such as virtual machines, storage, and networks that the customer configures."),
            Flashcard(id: "1201-fc-013", domainID: "1201-cloud", front: "What is SaaS?", back: "A complete cloud-hosted application delivered to users, such as webmail or collaboration software."),
            Flashcard(id: "1201-fc-014", domainID: "1201-cloud", front: "Why use a VM snapshot?", back: "To capture a VM state before a risky change so it can be rolled back quickly."),
            Flashcard(id: "1201-fc-015", domainID: "1201-troubleshooting", front: "What does a 169.254.x.x address suggest?", back: "DHCP failure, disconnected network, bad cable, failed AP, or missing DHCP server response."),
            Flashcard(id: "1201-fc-016", domainID: "1201-troubleshooting", front: "What does intermittent shutdown often suggest?", back: "Overheating, power supply problems, bad battery, short circuits, or failing components."),
            Flashcard(id: "1201-fc-017", domainID: "1201-troubleshooting", front: "What tool checks Ethernet cable wiring?", back: "A cable tester or certifier, depending on the depth of testing required."),
            Flashcard(id: "1201-fc-018", domainID: "1201-troubleshooting", front: "What causes ghosted laser prints?", back: "Often a failing drum, fuser issue, wrong media, or toner problem."),
            Flashcard(id: "1201-fc-019", domainID: "1201-hardware", front: "What does a UPS provide?", back: "Temporary battery power and power conditioning so systems can ride through or shut down safely."),
            Flashcard(id: "1201-fc-020", domainID: "1201-networking", front: "What is PoE?", back: "Power over Ethernet, which supplies electrical power and data over compatible network cabling.")
        ],
        practiceQuestions: [
            PracticeQuestion(id: "1201-pq-001", domainID: "1201-mobile", prompt: "A laptop battery is bulging and the touchpad no longer sits flat. What should the technician do first?", choices: ["Press the case back into shape", "Stop using the laptop and follow safe battery handling procedures", "Update the touchpad driver", "Run disk cleanup"], answerIndex: 1, explanation: "A swollen battery is a safety issue. Stop use and handle it through approved replacement or disposal procedures."),
            PracticeQuestion(id: "1201-pq-002", domainID: "1201-networking", prompt: "A Windows PC has address 169.254.20.15 and cannot reach the internet. What is the most likely issue?", choices: ["DNS cache is too large", "DHCP did not provide an address", "The monitor cable is loose", "The CPU is overheating"], answerIndex: 1, explanation: "169.254.x.x is an APIPA address, commonly seen when DHCP fails."),
            PracticeQuestion(id: "1201-pq-003", domainID: "1201-networking", prompt: "Which device usually forwards traffic between a home network and the internet?", choices: ["Router", "Patch panel", "Display adapter", "KVM switch"], answerIndex: 0, explanation: "A router connects networks and typically handles NAT, routing, DHCP, and firewall functions in a SOHO network."),
            PracticeQuestion(id: "1201-pq-004", domainID: "1201-hardware", prompt: "A user needs the fastest internal consumer storage option for a workstation. Which choice best fits?", choices: ["DVD-RW", "NVMe SSD", "USB 2.0 flash drive", "7200 RPM external HDD"], answerIndex: 1, explanation: "NVMe SSDs use PCIe and are typically much faster than SATA, optical, USB 2.0, or spinning disk options."),
            PracticeQuestion(id: "1201-pq-005", domainID: "1201-hardware", prompt: "A laser printer output rubs off the page after printing. Which part is most suspect?", choices: ["Fuser", "Pickup roller", "Paper tray", "Network card"], answerIndex: 0, explanation: "The fuser bonds toner to paper. Loose toner often points to fuser or media problems."),
            PracticeQuestion(id: "1201-pq-006", domainID: "1201-cloud", prompt: "A technician wants to test a risky software install and quickly revert if it fails. What VM feature helps most?", choices: ["Snapshot", "MAC filtering", "Port forwarding", "Thermal throttling"], answerIndex: 0, explanation: "Snapshots capture VM state and make quick rollback practical."),
            PracticeQuestion(id: "1201-pq-007", domainID: "1201-cloud", prompt: "Which cloud model gives the customer virtual machines and storage while the provider manages the physical data center?", choices: ["IaaS", "SaaS", "Bluetooth", "NFC"], answerIndex: 0, explanation: "Infrastructure as a Service provides virtual infrastructure while the provider handles physical facilities and hardware."),
            PracticeQuestion(id: "1201-pq-008", domainID: "1201-troubleshooting", prompt: "A desktop powers off after ten minutes under load. What should be checked early?", choices: ["Keyboard language", "Thermal conditions and power supply", "Wallpaper size", "Printer toner level"], answerIndex: 1, explanation: "Shutdowns under load often relate to heat, failing power, cooling problems, or component faults."),
            PracticeQuestion(id: "1201-pq-009", domainID: "1201-troubleshooting", prompt: "A user reports slow Wi-Fi only in one corner of the office. Which cause is most likely?", choices: ["Weak signal or interference", "Wrong printer driver", "Bad CMOS battery", "Full recycle bin"], answerIndex: 0, explanation: "Location-specific wireless issues often involve distance, interference, attenuation, or AP placement."),
            PracticeQuestion(id: "1201-pq-010", domainID: "1201-hardware", prompt: "Which RAID level mirrors data across two drives?", choices: ["RAID 0", "RAID 1", "RAID 5", "JBOD"], answerIndex: 1, explanation: "RAID 1 mirrors data for redundancy. It does not replace a real backup strategy."),
            PracticeQuestion(id: "1201-pq-011", domainID: "1201-networking", prompt: "Which protocol resolves hostnames such as example.com to IP addresses?", choices: ["DNS", "DHCP", "SMTP", "RDP"], answerIndex: 0, explanation: "DNS maps names to IP addresses and other records."),
            PracticeQuestion(id: "1201-pq-012", domainID: "1201-mobile", prompt: "A phone will not pair with a headset. Which setting should be checked first?", choices: ["Bluetooth", "Print spooler", "Disk partition style", "RAID mode"], answerIndex: 0, explanation: "Bluetooth pairing requires Bluetooth to be enabled and both devices to be discoverable or in pairing mode.")
        ],
        quickTips: [
            "For Core 1, build mental maps: parts, ports, cables, symptoms, and first tools.",
            "Memorize ports by service clue, not only by number.",
            "When a question mentions 169.254.x.x, think DHCP path first.",
            "For printer questions, identify the printer type before choosing a part.",
            "Core 1 loves best next step scenarios. Slow down and rule out the simple physical layer first.",
            "Before App Store release, compare every topic against the current official CompTIA objectives PDF."
        ],
        disclaimer: comptiaDisclaimer
    )

    static let aPlusCore2 = ExamProfile(
        id: "comptia-a-plus-core-2-220-1202",
        name: "CompTIA A+ Core 2",
        code: "220-1202",
        summary: "Study guidance for operating systems, security, software troubleshooting, and operational procedures. Content is original study material and should be checked against the official exam objectives before submission.",
        domains: [
            ExamDomain(id: "1202-os", title: "Operating Systems", weight: 28, focus: "Install, configure, and support Windows, macOS, Linux, ChromeOS, Android, and iOS in technician scenarios.", objectives: [
                "Compare Windows editions, upgrade paths, feature limits, and common installation methods.",
                "Use command-line tools such as ipconfig, ping, netstat, nslookup, chkdsk, sfc, gpupdate, and diskpart.",
                "Manage local users, groups, permissions, services, startup apps, updates, and recovery options.",
                "Recognize file systems, boot methods, partitioning, system requirements, and driver issues.",
                "Support basic macOS and Linux tasks including shell commands, package updates, permissions, and backups.",
                "Apply mobile OS setup and troubleshooting for Android and iOS without assuming every setting is in the same place."
            ]),
            ExamDomain(id: "1202-security", title: "Security", weight: 28, focus: "Protect users, endpoints, SOHO networks, and data while recognizing common threats and response steps.", objectives: [
                "Explain malware types, social engineering tactics, phishing, shoulder surfing, tailgating, and impersonation.",
                "Harden accounts with least privilege, MFA, lockout policies, password managers, and secure recovery methods.",
                "Secure wireless routers using WPA3 or WPA2, strong passphrases, firmware updates, guest networks, and disabled WPS.",
                "Follow malware removal steps: identify symptoms, quarantine, disable restore points when needed, remediate, update, scan, and educate.",
                "Protect mobile devices with screen locks, remote wipe, app permissions, OS updates, and trusted app stores.",
                "Handle data with backups, encryption, secure disposal, and privacy-aware support practices."
            ]),
            ExamDomain(id: "1202-troubleshooting", title: "Software Troubleshooting", weight: 23, focus: "Diagnose operating system, application, security, and mobile software issues using repeatable troubleshooting steps.", objectives: [
                "Use the six-step troubleshooting method before changing settings or replacing components.",
                "Resolve boot errors, slow performance, blue screens, service failures, update loops, and application crashes.",
                "Identify malware symptoms such as pop-ups, redirects, disabled tools, unusual processes, and changed browser settings.",
                "Troubleshoot mobile symptoms including app crashes, poor battery life, overheating, connectivity issues, and sync failures.",
                "Collect useful evidence from event logs, reliability history, device manager, safe mode, and recovery tools.",
                "Document the fix, verify full system functionality, and leave the user with clear prevention advice."
            ]),
            ExamDomain(id: "1202-operations", title: "Operational Procedures", weight: 21, focus: "Work safely and professionally using documentation, change control, ticketing, communication, and compliance practices.", objectives: [
                "Use tickets, asset records, knowledge base notes, and change approvals to make support work repeatable.",
                "Communicate with empathy, avoid jargon when possible, set expectations, and escalate at the right time.",
                "Follow electrical, fire, ESD, lifting, cable, and environmental safety practices.",
                "Apply backup concepts, recovery testing, retention, versioning, and secure storage.",
                "Use remote access responsibly with consent, session logging, least privilege, and clear handoff.",
                "Respect privacy, licensing, regulated data, acceptable use, and chain-of-custody requirements."
            ])
        ],
        studyTasks: [
            StudyTask(id: "1202-os-1", domainID: "1202-os", title: "Map Windows tools", detail: "Make a one-page map of Settings, Control Panel, Task Manager, Computer Management, Event Viewer, and Device Manager.", minutes: 35),
            StudyTask(id: "1202-os-2", domainID: "1202-os", title: "Command-line reps", detail: "Practice ten support commands and write what each one proves or rules out.", minutes: 45),
            StudyTask(id: "1202-os-3", domainID: "1202-os", title: "Install and recovery flow", detail: "Review clean install, upgrade, repair, safe mode, reset, restore point, and image recovery paths.", minutes: 40),
            StudyTask(id: "1202-os-4", domainID: "1202-os", title: "Non-Windows essentials", detail: "Review macOS, Linux, ChromeOS, Android, and iOS admin basics and backup tools.", minutes: 45),
            StudyTask(id: "1202-security-1", domainID: "1202-security", title: "Threat recognition drill", detail: "Write symptoms and first actions for phishing, malware, ransomware, impersonation, and rogue antivirus.", minutes: 35),
            StudyTask(id: "1202-security-2", domainID: "1202-security", title: "SOHO hardening pass", detail: "Build a checklist for router login, Wi-Fi security, firmware, guest access, DNS, and physical placement.", minutes: 40),
            StudyTask(id: "1202-security-3", domainID: "1202-security", title: "Malware removal sequence", detail: "Memorize and rehearse the removal process without skipping quarantine, updates, scans, and education.", minutes: 30),
            StudyTask(id: "1202-security-4", domainID: "1202-security", title: "Data protection basics", detail: "Compare encryption, backup, remote wipe, secure disposal, permissions, and least privilege.", minutes: 40),
            StudyTask(id: "1202-troubleshooting-1", domainID: "1202-troubleshooting", title: "Troubleshooting method", detail: "Practice the six-step method on three fake incidents: slow boot, browser redirects, and failed updates.", minutes: 45),
            StudyTask(id: "1202-troubleshooting-2", domainID: "1202-troubleshooting", title: "Windows symptoms", detail: "Match common symptoms to evidence sources: logs, safe mode, services, startup, drivers, and recovery.", minutes: 45),
            StudyTask(id: "1202-troubleshooting-3", domainID: "1202-troubleshooting", title: "Mobile app symptoms", detail: "Review crashes, permissions, sync, battery, storage, OS updates, and network reset workflows.", minutes: 35),
            StudyTask(id: "1202-troubleshooting-4", domainID: "1202-troubleshooting", title: "Verification habit", detail: "For every fix, write how you would verify functionality and prevent recurrence.", minutes: 25),
            StudyTask(id: "1202-operations-1", domainID: "1202-operations", title: "Ticket notes practice", detail: "Write a sample ticket with problem, impact, steps tried, root cause, resolution, and follow-up.", minutes: 30),
            StudyTask(id: "1202-operations-2", domainID: "1202-operations", title: "Safety sweep", detail: "Review ESD, electrical safety, fire classes, lifting, cable management, disposal, and battery handling.", minutes: 35),
            StudyTask(id: "1202-operations-3", domainID: "1202-operations", title: "Change and backups", detail: "Connect change control, rollback planning, backup testing, retention, and recovery objectives.", minutes: 45),
            StudyTask(id: "1202-operations-4", domainID: "1202-operations", title: "Professional scenarios", detail: "Practice scripts for unclear users, angry users, privacy-sensitive data, and escalation handoffs.", minutes: 30)
        ],
        flashcards: [
            Flashcard(id: "1202-fc-001", domainID: "1202-os", front: "What does sfc /scannow check?", back: "It verifies protected Windows system files and attempts to repair corrupted versions."),
            Flashcard(id: "1202-fc-002", domainID: "1202-os", front: "When would you use gpupdate?", back: "To refresh Group Policy settings on a Windows computer, often after a policy change."),
            Flashcard(id: "1202-fc-003", domainID: "1202-os", front: "What does diskpart manage?", back: "Disks, partitions, volumes, drive letters, and related storage configuration."),
            Flashcard(id: "1202-fc-004", domainID: "1202-os", front: "What is Safe Mode useful for?", back: "Starting Windows with minimal drivers and services so you can isolate startup, driver, or software issues."),
            Flashcard(id: "1202-fc-005", domainID: "1202-security", front: "What is least privilege?", back: "Giving users and services only the access they need to do their work, no more."),
            Flashcard(id: "1202-fc-006", domainID: "1202-security", front: "Why disable WPS on a router?", back: "WPS can weaken Wi-Fi security because PIN-based setup is easier to attack than a strong passphrase."),
            Flashcard(id: "1202-fc-007", domainID: "1202-security", front: "What is shoulder surfing?", back: "Watching someone enter or view sensitive information without permission."),
            Flashcard(id: "1202-fc-008", domainID: "1202-security", front: "What should happen after malware removal?", back: "Update protections, run scans, verify functionality, and educate the user to reduce repeat infection."),
            Flashcard(id: "1202-fc-009", domainID: "1202-troubleshooting", front: "First step in troubleshooting?", back: "Identify the problem by gathering information, questioning the user, and checking for recent changes."),
            Flashcard(id: "1202-fc-010", domainID: "1202-troubleshooting", front: "Why check Event Viewer?", back: "It can reveal application, security, setup, and system events that point to root cause."),
            Flashcard(id: "1202-fc-011", domainID: "1202-troubleshooting", front: "What does a browser redirect suggest?", back: "Possible malware, malicious extension, DNS change, proxy setting, or compromised browser settings."),
            Flashcard(id: "1202-fc-012", domainID: "1202-troubleshooting", front: "Why document a fix?", back: "It helps future technicians, supports compliance, and proves what changed."),
            Flashcard(id: "1202-fc-013", domainID: "1202-operations", front: "What is change control?", back: "A process for requesting, approving, scheduling, implementing, and reviewing changes."),
            Flashcard(id: "1202-fc-014", domainID: "1202-operations", front: "What does ESD protection prevent?", back: "Damage to sensitive components from electrostatic discharge."),
            Flashcard(id: "1202-fc-015", domainID: "1202-operations", front: "What is chain of custody?", back: "A documented trail showing who handled evidence, when, where, and why."),
            Flashcard(id: "1202-fc-016", domainID: "1202-operations", front: "Why test backups?", back: "A backup is only useful if it can be restored within the required time and data-loss limits.")
        ],
        practiceQuestions: [
            PracticeQuestion(id: "1202-pq-001", domainID: "1202-os", prompt: "A user reports that Windows starts normally but a required service fails after every reboot. Where should you look first to confirm the service status and startup type?", choices: ["Device Manager", "Services console", "Disk Management", "Windows Defender Firewall"], answerIndex: 1, explanation: "The Services console shows status, startup type, dependencies, and recovery options for Windows services."),
            PracticeQuestion(id: "1202-pq-002", domainID: "1202-os", prompt: "Which command is best for quickly viewing a Windows computer's IP address, DNS servers, and default gateway?", choices: ["sfc /scannow", "gpupdate /force", "ipconfig /all", "chkdsk /f"], answerIndex: 2, explanation: "ipconfig /all reports detailed TCP/IP configuration, including DNS servers, gateway, MAC address, and DHCP details."),
            PracticeQuestion(id: "1202-pq-003", domainID: "1202-security", prompt: "A home office router still uses the default admin password. What is the best first hardening step?", choices: ["Disable all wireless networks", "Change the administrator password", "Turn off DHCP", "Lower the transmit power"], answerIndex: 1, explanation: "Changing default administrator credentials is an immediate high-value step because default passwords are widely known."),
            PracticeQuestion(id: "1202-pq-004", domainID: "1202-security", prompt: "A caller pressures a help desk technician to reset an executive's password immediately and refuses identity verification. What threat does this most closely match?", choices: ["Tailgating", "Impersonation", "Shoulder surfing", "Dumpster diving"], answerIndex: 1, explanation: "The caller is pretending to be someone with authority or urgency. Verification procedures protect against impersonation."),
            PracticeQuestion(id: "1202-pq-005", domainID: "1202-security", prompt: "During malware response, why might a technician quarantine a system before cleaning it?", choices: ["To improve Wi-Fi signal", "To prevent spread or command-and-control traffic", "To erase logs automatically", "To bypass user permissions"], answerIndex: 1, explanation: "Quarantine limits further spread, data exposure, and attacker communication while investigation and remediation continue."),
            PracticeQuestion(id: "1202-pq-006", domainID: "1202-troubleshooting", prompt: "After installing an application update, a user's computer becomes unstable. Which troubleshooting question is most useful first?", choices: ["What changed right before the issue began?", "Can you replace the power supply?", "Do you want a new monitor?", "Can the printer print in color?"], answerIndex: 0, explanation: "Recent changes are often the fastest clue when identifying the problem and forming a theory."),
            PracticeQuestion(id: "1202-pq-007", domainID: "1202-troubleshooting", prompt: "A phone app crashes after an OS update. Which action is a reasonable early step?", choices: ["Replace the battery immediately", "Clear app cache or update the app", "Disable the screen lock", "Factory reset without backup"], answerIndex: 1, explanation: "App updates, cache clearing, and permission checks are lower-risk steps before destructive recovery options."),
            PracticeQuestion(id: "1202-pq-008", domainID: "1202-operations", prompt: "A technician is about to modify a production workstation used for billing. What should they check before making the change?", choices: ["Wallpaper preference", "Change approval and rollback plan", "Keyboard color", "Monitor brightness"], answerIndex: 1, explanation: "Change control and rollback planning reduce business risk and make recovery possible if the change fails."),
            PracticeQuestion(id: "1202-pq-009", domainID: "1202-operations", prompt: "Which ticket note is most useful after resolving a support issue?", choices: ["Fixed it", "User was upset", "Updated network driver, rebooted, verified VPN connection, and advised user to report recurrence", "Computer is blue"], answerIndex: 2, explanation: "Good notes include actions taken, verification, and follow-up guidance."),
            PracticeQuestion(id: "1202-pq-010", domainID: "1202-operations", prompt: "Which practice helps prevent component damage when replacing RAM?", choices: ["ESD strap or grounded mat", "More thermal paste", "Higher screen brightness", "Disabling Bluetooth"], answerIndex: 0, explanation: "ESD controls reduce the chance of electrostatic discharge damaging sensitive electronic parts.")
        ],
        quickTips: [
            "Do short daily sessions. A consistent 35 minutes beats one exhausted four-hour cram.",
            "For command-line tools, memorize what each tool proves. The exam rewards choosing the right next step.",
            "When a scenario mentions urgency, authority, fear, or secrecy, pause and think social engineering.",
            "Say the troubleshooting steps out loud until they feel automatic.",
            "Keep your study notes in symptom -> evidence -> fix -> verification format.",
            "Before App Store release, compare every topic against the current official CompTIA objectives PDF."
        ],
        disclaimer: comptiaDisclaimer
    )

    static let securityPlus = ExamProfile(
        id: "comptia-security-plus-sy0-701",
        name: "CompTIA Security+",
        code: "SY0-701",
        summary: "Study guidance for security concepts, threats, architecture, operations, governance, risk, and compliance. Content is original study material and should be checked against the official objectives before submission.",
        domains: [
            ExamDomain(id: "701-concepts", title: "General Security Concepts", weight: 12, focus: "Build vocabulary around security controls, principles, cryptography, identity, and risk fundamentals.", objectives: [
                "Compare control categories and types, including technical, managerial, operational, preventive, detective, corrective, and compensating controls.",
                "Explain CIA, non-repudiation, authentication, authorization, accounting, least privilege, and zero trust principles.",
                "Identify cryptographic use cases for hashing, encryption, key exchange, certificates, PKI, digital signatures, and salting.",
                "Compare identity concepts such as federation, SSO, MFA, passwordless authentication, and privileged access.",
                "Recognize physical, logical, administrative, and procedural controls in scenario questions."
            ]),
            ExamDomain(id: "701-threats", title: "Threats, Vulnerabilities, and Mitigations", weight: 22, focus: "Recognize attacks, threat actors, vulnerabilities, malware, social engineering, and mitigation choices.", objectives: [
                "Compare malware, ransomware, rootkits, trojans, worms, spyware, logic bombs, and fileless malware.",
                "Identify phishing, smishing, vishing, pretexting, impersonation, business email compromise, and watering hole attacks.",
                "Recognize application and web attacks such as injection, XSS, CSRF, directory traversal, buffer overflow, and insecure design.",
                "Assess vulnerabilities from misconfiguration, unsupported systems, weak passwords, open ports, and unpatched software.",
                "Choose mitigations such as patching, segmentation, hardening, allow lists, EDR, secure coding, and user training."
            ]),
            ExamDomain(id: "701-architecture", title: "Security Architecture", weight: 18, focus: "Design and secure infrastructure, cloud, network, identity, data, resilience, and endpoint architecture.", objectives: [
                "Compare network security tools such as firewalls, IDS, IPS, proxies, load balancers, NAC, VPNs, and secure gateways.",
                "Explain segmentation, DMZs, zero trust, SASE, SD-WAN, microsegmentation, and secure access patterns.",
                "Secure cloud and virtualization with shared responsibility, CASB, container controls, secrets management, and IAM.",
                "Protect data with classification, encryption, tokenization, masking, DLP, retention, and secure disposal.",
                "Plan resilience with redundancy, backups, snapshots, replication, failover, disaster recovery, and high availability."
            ]),
            ExamDomain(id: "701-operations", title: "Security Operations", weight: 28, focus: "Monitor, detect, investigate, respond, and recover using tools, processes, logging, and automation.", objectives: [
                "Use SIEM, SOAR, EDR, vulnerability scanners, packet capture, logs, and threat intelligence during investigations.",
                "Follow incident response phases from preparation through lessons learned.",
                "Interpret alerts, logs, indicators of compromise, baselines, anomalies, and escalation criteria.",
                "Perform vulnerability management with scanning, prioritization, remediation, validation, and exception handling.",
                "Apply automation, scripting, playbooks, secure configuration, change management, and continuous monitoring."
            ]),
            ExamDomain(id: "701-program", title: "Security Program Management", weight: 20, focus: "Understand governance, risk, compliance, audits, policies, awareness, third parties, and business continuity.", objectives: [
                "Compare policies, standards, procedures, guidelines, baselines, and exceptions.",
                "Explain risk identification, analysis, likelihood, impact, appetite, acceptance, transfer, mitigation, and avoidance.",
                "Recognize compliance drivers, audits, evidence collection, privacy, data handling, and legal holds.",
                "Manage third-party risk with contracts, SLAs, assessments, right-to-audit, and supply chain controls.",
                "Support business continuity with BIA, RTO, RPO, tabletop exercises, disaster recovery plans, and communication plans."
            ])
        ],
        studyTasks: [
            StudyTask(id: "701-concepts-1", domainID: "701-concepts", title: "Control type matrix", detail: "Build a matrix for preventive, detective, corrective, deterrent, compensating, technical, operational, and managerial controls.", minutes: 40),
            StudyTask(id: "701-concepts-2", domainID: "701-concepts", title: "CIA and AAA scenarios", detail: "Practice identifying confidentiality, integrity, availability, authentication, authorization, and accounting in short scenarios.", minutes: 35),
            StudyTask(id: "701-concepts-3", domainID: "701-concepts", title: "Crypto purpose drill", detail: "Match hashing, encryption, signatures, certificates, salting, key exchange, and PKI to their real purpose.", minutes: 45),
            StudyTask(id: "701-concepts-4", domainID: "701-concepts", title: "Identity review", detail: "Compare SSO, federation, MFA, passwordless login, privileged access, and access reviews.", minutes: 35),
            StudyTask(id: "701-threats-1", domainID: "701-threats", title: "Malware symptoms", detail: "Write signs and first response actions for ransomware, trojans, worms, rootkits, spyware, and fileless malware.", minutes: 45),
            StudyTask(id: "701-threats-2", domainID: "701-threats", title: "Social engineering signals", detail: "Practice recognizing pressure, urgency, secrecy, authority, fear, gift offers, and business email compromise.", minutes: 35),
            StudyTask(id: "701-threats-3", domainID: "701-threats", title: "Web attack map", detail: "Compare injection, XSS, CSRF, traversal, insecure design, and buffer overflow by input, impact, and mitigation.", minutes: 45),
            StudyTask(id: "701-threats-4", domainID: "701-threats", title: "Mitigation picks", detail: "Choose between patching, segmentation, hardening, EDR, allow lists, WAF, and training for scenario prompts.", minutes: 40),
            StudyTask(id: "701-architecture-1", domainID: "701-architecture", title: "Network security tools", detail: "Map firewalls, IDS, IPS, proxies, VPNs, NAC, load balancers, and secure gateways to traffic flow.", minutes: 45),
            StudyTask(id: "701-architecture-2", domainID: "701-architecture", title: "Cloud responsibility", detail: "Compare what the provider and customer secure across SaaS, PaaS, IaaS, containers, and serverless.", minutes: 40),
            StudyTask(id: "701-architecture-3", domainID: "701-architecture", title: "Data protection ladder", detail: "Review classification, encryption, tokenization, masking, DLP, retention, deletion, and secure disposal.", minutes: 40),
            StudyTask(id: "701-architecture-4", domainID: "701-architecture", title: "Resilience planning", detail: "Compare backups, replication, snapshots, clustering, failover, HA, DR, RTO, and RPO.", minutes: 45),
            StudyTask(id: "701-operations-1", domainID: "701-operations", title: "Incident response flow", detail: "Memorize preparation, detection, analysis, containment, eradication, recovery, and lessons learned.", minutes: 45),
            StudyTask(id: "701-operations-2", domainID: "701-operations", title: "Log source map", detail: "Map authentication, firewall, endpoint, DNS, proxy, cloud, and application logs to investigation clues.", minutes: 45),
            StudyTask(id: "701-operations-3", domainID: "701-operations", title: "Vulnerability management", detail: "Practice scanning, prioritizing, remediating, validating, documenting exceptions, and retesting.", minutes: 40),
            StudyTask(id: "701-operations-4", domainID: "701-operations", title: "Automation and playbooks", detail: "Write simple if-this-then-that playbooks for phishing, malware, impossible travel, and exposed ports.", minutes: 35),
            StudyTask(id: "701-program-1", domainID: "701-program", title: "Policy hierarchy", detail: "Compare policies, standards, procedures, baselines, guidelines, and exceptions using workplace examples.", minutes: 35),
            StudyTask(id: "701-program-2", domainID: "701-program", title: "Risk response choices", detail: "Practice risk acceptance, avoidance, transfer, mitigation, likelihood, impact, residual risk, and risk appetite.", minutes: 45),
            StudyTask(id: "701-program-3", domainID: "701-program", title: "Third-party risk", detail: "Review vendor assessment, contracts, SLAs, right-to-audit, supply chain risk, and data handling terms.", minutes: 40),
            StudyTask(id: "701-program-4", domainID: "701-program", title: "Business continuity", detail: "Connect BIA, RTO, RPO, tabletop exercises, DR plans, backups, and communications.", minutes: 45)
        ],
        flashcards: [
            Flashcard(id: "701-fc-001", domainID: "701-concepts", front: "What does CIA stand for?", back: "Confidentiality, integrity, and availability."),
            Flashcard(id: "701-fc-002", domainID: "701-concepts", front: "What is non-repudiation?", back: "Assurance that a party cannot reasonably deny an action, often supported by digital signatures and logging."),
            Flashcard(id: "701-fc-003", domainID: "701-concepts", front: "What does hashing provide?", back: "A fixed-length digest used for integrity checks and password verification when properly salted."),
            Flashcard(id: "701-fc-004", domainID: "701-concepts", front: "What is least privilege?", back: "Granting only the access needed for a task or role."),
            Flashcard(id: "701-fc-005", domainID: "701-threats", front: "What is vishing?", back: "Voice-based phishing, often using phone calls or voicemail."),
            Flashcard(id: "701-fc-006", domainID: "701-threats", front: "What is fileless malware?", back: "Malware that primarily uses legitimate tools or memory-resident techniques instead of obvious malicious files."),
            Flashcard(id: "701-fc-007", domainID: "701-threats", front: "What is SQL injection?", back: "An attack that manipulates database queries through unsanitized input."),
            Flashcard(id: "701-fc-008", domainID: "701-threats", front: "What is a watering hole attack?", back: "Compromising a site likely to be visited by a target group."),
            Flashcard(id: "701-fc-009", domainID: "701-architecture", front: "What is network segmentation?", back: "Dividing networks to limit traffic, reduce blast radius, and enforce security boundaries."),
            Flashcard(id: "701-fc-010", domainID: "701-architecture", front: "What is a CASB?", back: "A cloud access security broker that helps enforce security policy for cloud service use."),
            Flashcard(id: "701-fc-011", domainID: "701-architecture", front: "What is tokenization?", back: "Replacing sensitive data with non-sensitive tokens that map back through a protected system."),
            Flashcard(id: "701-fc-012", domainID: "701-architecture", front: "What is RPO?", back: "Recovery point objective: the maximum acceptable amount of data loss measured in time."),
            Flashcard(id: "701-fc-013", domainID: "701-operations", front: "What does SIEM do?", back: "Collects, correlates, searches, and alerts on security events from many sources."),
            Flashcard(id: "701-fc-014", domainID: "701-operations", front: "What does EDR focus on?", back: "Endpoint detection, investigation, response, and containment."),
            Flashcard(id: "701-fc-015", domainID: "701-operations", front: "What comes after containment in incident response?", back: "Eradication and recovery, followed by lessons learned."),
            Flashcard(id: "701-fc-016", domainID: "701-operations", front: "What is an IOC?", back: "An indicator of compromise, such as a suspicious IP, hash, domain, process, or behavior."),
            Flashcard(id: "701-fc-017", domainID: "701-program", front: "What is risk transfer?", back: "Shifting some risk impact to another party, commonly through insurance or contracts."),
            Flashcard(id: "701-fc-018", domainID: "701-program", front: "What is a BIA?", back: "Business impact analysis, which identifies critical processes and impact over time."),
            Flashcard(id: "701-fc-019", domainID: "701-program", front: "What is an SLA?", back: "A service-level agreement defining expected service performance or response commitments."),
            Flashcard(id: "701-fc-020", domainID: "701-program", front: "What is residual risk?", back: "Risk that remains after controls or treatments are applied.")
        ],
        practiceQuestions: [
            PracticeQuestion(id: "701-pq-001", domainID: "701-concepts", prompt: "Which security objective is most directly protected by hashing a downloaded file and comparing the digest?", choices: ["Availability", "Integrity", "Tailgating", "Federation"], answerIndex: 1, explanation: "Hash comparison helps verify that data has not changed, which supports integrity."),
            PracticeQuestion(id: "701-pq-002", domainID: "701-concepts", prompt: "A user signs in once and accesses several trusted applications without separate passwords. What concept is this?", choices: ["SSO", "DLP", "RTO", "NAT"], answerIndex: 0, explanation: "Single sign-on lets a user authenticate once and access multiple trusted services."),
            PracticeQuestion(id: "701-pq-003", domainID: "701-threats", prompt: "An email claims to be from the CEO and pressures accounting to wire money secretly. What attack is most likely?", choices: ["Business email compromise", "Bluejacking", "DNSSEC", "RAID"], answerIndex: 0, explanation: "BEC uses impersonation and business process abuse to trick users into payments or data disclosure."),
            PracticeQuestion(id: "701-pq-004", domainID: "701-threats", prompt: "A web form lets an attacker alter a database query by entering crafted input. What attack is this?", choices: ["SQL injection", "Smishing", "Evil twin", "Tokenization"], answerIndex: 0, explanation: "SQL injection manipulates database queries through unsanitized input."),
            PracticeQuestion(id: "701-pq-005", domainID: "701-architecture", prompt: "A company wants to limit lateral movement after a workstation compromise. What architecture choice helps most?", choices: ["Network segmentation", "Longer passwords only", "Single flat VLAN", "Public file shares"], answerIndex: 0, explanation: "Segmentation limits traffic paths and reduces the blast radius of compromise."),
            PracticeQuestion(id: "701-pq-006", domainID: "701-architecture", prompt: "Which value describes the maximum acceptable data loss after an outage?", choices: ["RPO", "RTO", "MTTR", "CVSS"], answerIndex: 0, explanation: "RPO is about how much data loss is acceptable, measured in time."),
            PracticeQuestion(id: "701-pq-007", domainID: "701-operations", prompt: "A security team needs to correlate endpoint, firewall, identity, and cloud logs. Which tool category fits best?", choices: ["SIEM", "UPS", "KVM", "Thermal printer"], answerIndex: 0, explanation: "A SIEM centralizes and correlates security events from many sources."),
            PracticeQuestion(id: "701-pq-008", domainID: "701-operations", prompt: "After containing ransomware, what should responders focus on before normal operations resume?", choices: ["Eradication and recovery", "Removing all documentation", "Skipping user communication", "Disabling all logs"], answerIndex: 0, explanation: "After containment, teams remove the threat, restore systems, validate recovery, and then conduct lessons learned."),
            PracticeQuestion(id: "701-pq-009", domainID: "701-program", prompt: "An organization buys cyber insurance to reduce financial impact from a specific event. What risk response is this?", choices: ["Transfer", "Avoidance", "Acceptance", "Exploitation"], answerIndex: 0, explanation: "Insurance transfers some financial impact to a third party."),
            PracticeQuestion(id: "701-pq-010", domainID: "701-program", prompt: "Which document type usually gives step-by-step instructions for performing a task?", choices: ["Procedure", "Policy", "Guideline", "Risk appetite"], answerIndex: 0, explanation: "Procedures are detailed steps. Policies state intent, standards define requirements, and guidelines give recommendations."),
            PracticeQuestion(id: "701-pq-011", domainID: "701-threats", prompt: "A phone text asks a user to click a fake delivery link and enter credentials. What is this?", choices: ["Smishing", "Vishing", "Whaling", "Shadow IT"], answerIndex: 0, explanation: "Smishing is phishing over SMS or text messages."),
            PracticeQuestion(id: "701-pq-012", domainID: "701-operations", prompt: "What is the best reason to run a tabletop exercise?", choices: ["Practice response roles and decisions before a real incident", "Encrypt every hard drive instantly", "Replace all technical controls", "Avoid documenting incidents"], answerIndex: 0, explanation: "Tabletops let teams rehearse response plans, communication, decisions, and gaps in a low-risk setting.")
        ],
        quickTips: [
            "Security+ rewards concept matching. Ask what control, threat, or process the scenario is really testing.",
            "Do not memorize acronyms alone. Tie each acronym to a use case and a clue phrase.",
            "For risk questions, separate likelihood, impact, response, and residual risk.",
            "For incident response, pick actions that preserve evidence, reduce harm, and support recovery.",
            "Cloud questions often turn on shared responsibility. Ask who owns the layer being discussed.",
            "Before App Store release, compare every topic against the current official CompTIA objectives PDF."
        ],
        disclaimer: comptiaDisclaimer
    )

    static let exams: [ExamProfile] = [
        aPlusCore1,
        aPlusCore2,
        securityPlus
    ]

    static func simulations(for examID: String) -> [ExamSimulation] {
        switch examID {
        case aPlusCore1.id:
            return [shortSimulation(from: aPlusCore1Simulation, id: "1201-short-10", title: "Core 1 Short Practice Test"), aPlusCore1Simulation]
        case securityPlus.id:
            return [shortSimulation(from: securityPlusSimulation, id: "701-short-10", title: "Security+ Short Practice Test"), securityPlusSimulation]
        default:
            return [shortSimulation(from: aPlusCore2Simulation, id: "1202-short-10", title: "Core 2 Short Practice Test"), aPlusCore2Simulation]
        }
    }

    private static func shortSimulation(from simulation: ExamSimulation, id: String, title: String) -> ExamSimulation {
        ExamSimulation(
            id: id,
            title: title,
            description: "A 10-question randomized practice test with a fresh mix of original questions and PBQ-style items each time you start.",
            timeLimitMinutes: 15,
            targetQuestionCount: 10,
            minimumScaledScore: simulation.minimumScaledScore,
            maximumScaledScore: simulation.maximumScaledScore,
            passingScaledScore: simulation.passingScaledScore,
            performanceItems: simulation.performanceItems
        )
    }

    private static let aPlusCore1Simulation = ExamSimulation(
        id: "1201-exam-day-1",
        title: "Core 1 Exam-Day Simulation",
        description: "A 90-question randomized A+ Core 1 simulation with original multiple-choice questions, PBQ-style matching, and drag-to-order workflows.",
        timeLimitMinutes: 90,
        targetQuestionCount: 90,
        minimumScaledScore: 100,
        maximumScaledScore: 900,
        passingScaledScore: 675,
        performanceItems: [
            ExamItem(
                id: "1201-pbq-ports",
                domainID: "1201-networking",
                kind: .matching,
                prompt: "PBQ: Match each service to the port clue a technician would expect to see.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: ["DNS name resolution", "Secure web traffic", "Remote Desktop Protocol", "DHCP client/server addressing", "Unencrypted web traffic"],
                matchingAnswers: ["80", "443", "53", "3389", "67/68"],
                correctMatches: [2, 1, 3, 4, 0],
                correctOrder: [],
                explanation: "DNS commonly uses 53, HTTPS 443, RDP 3389, DHCP 67/68, and HTTP 80.",
                points: 5,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1201-pbq-laser-order",
                domainID: "1201-hardware",
                kind: .ordering,
                prompt: "PBQ: Drag the laser printer imaging process into the correct order.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: ["Processing", "Charging", "Exposing", "Developing", "Transferring", "Fusing", "Cleaning"],
                explanation: "Laser printing follows processing, charging, exposing, developing, transferring, fusing, and cleaning.",
                points: 7,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1201-pbq-dhcp",
                domainID: "1201-troubleshooting",
                kind: .multipleSelect,
                prompt: "PBQ: A workstation has a 169.254.x.x address. Select the best checks before replacing hardware.",
                choices: ["Verify link lights and cable seating", "Confirm the DHCP scope or server is available", "Check whether the adapter is set to static IP", "Replace the CPU", "Try a known-good network cable"],
                correctChoiceIndexes: [0, 1, 2, 4],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: [],
                explanation: "APIPA points to failed DHCP configuration. Check physical link, DHCP availability, IP settings, and a known-good cable before unrelated replacement.",
                points: 4,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1201-pbq-hardware-symptoms",
                domainID: "1201-hardware",
                kind: .matching,
                prompt: "PBQ: Match each symptom to the most likely starting point.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: ["Loose toner on laser printout", "Random shutdowns under heavy load", "No video after RAM upgrade", "Clicking from mechanical storage"],
                matchingAnswers: ["Fuser or media problem", "Thermal or power issue", "Reseat memory and check compatibility", "Failing hard drive"],
                correctMatches: [0, 1, 2, 3],
                correctOrder: [],
                explanation: "These pairings point to likely first investigation paths, not guaranteed final causes.",
                points: 4,
                isPerformanceBased: true
            )
        ]
    )

    private static let aPlusCore2Simulation = ExamSimulation(
        id: "1202-exam-day-1",
        title: "Core 2 Exam-Day Simulation",
        description: "A 90-question randomized A+ Core 2 simulation with original multiple-choice questions, PBQ-style workflows, security scenarios, and troubleshooting order tasks.",
        timeLimitMinutes: 90,
        targetQuestionCount: 90,
        minimumScaledScore: 100,
        maximumScaledScore: 900,
        passingScaledScore: 700,
        performanceItems: [
            ExamItem(
                id: "1202-pbq-malware-order",
                domainID: "1202-security",
                kind: .ordering,
                prompt: "PBQ: Drag the malware response workflow into a defensible order.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: ["Identify symptoms", "Quarantine the system", "Disable restore points if required", "Remediate and remove malware", "Update protection tools", "Run scans", "Verify functionality", "Educate the user"],
                explanation: "The sequence limits spread, removes the threat, verifies recovery, and reduces recurrence.",
                points: 8,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1202-pbq-tools",
                domainID: "1202-os",
                kind: .matching,
                prompt: "PBQ: Match each Windows support task to the best command-line tool.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: ["Refresh Group Policy", "Check protected system files", "Inspect IP configuration", "Manage partitions and volumes", "Trace route to a destination"],
                matchingAnswers: ["sfc /scannow", "tracert", "gpupdate", "diskpart", "ipconfig /all"],
                correctMatches: [2, 0, 4, 3, 1],
                correctOrder: [],
                explanation: "These commands are common Core 2 clues: gpupdate, sfc, ipconfig, diskpart, and tracert each answer a different support question.",
                points: 5,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1202-pbq-account-hardening",
                domainID: "1202-security",
                kind: .multipleSelect,
                prompt: "PBQ: Select the account-hardening actions that best reduce risk for a shared front-desk workstation.",
                choices: ["Use unique named accounts where possible", "Enable MFA for sensitive accounts", "Grant local administrator rights to every user", "Apply screen lock timeout", "Use least privilege"],
                correctChoiceIndexes: [0, 1, 3, 4],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: [],
                explanation: "Unique accounts, MFA, screen locks, and least privilege reduce abuse and improve accountability.",
                points: 4,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "1202-pbq-ticket-flow",
                domainID: "1202-operations",
                kind: .ordering,
                prompt: "PBQ: Drag the support ticket workflow into a professional order.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: ["Greet and identify the user", "Gather symptoms and recent changes", "Document troubleshooting steps", "Escalate when scope or permissions require it", "Verify the fix", "Record resolution and user guidance"],
                explanation: "Good support work combines communication, evidence, escalation boundaries, verification, and documentation.",
                points: 6,
                isPerformanceBased: true
            )
        ]
    )

    private static let securityPlusSimulation = ExamSimulation(
        id: "701-exam-day-1",
        title: "Security+ Exam-Day Simulation",
        description: "A 90-question randomized Security+ simulation with original multiple-choice questions, incident-response PBQs, matching scenarios, and drag-to-order security workflows.",
        timeLimitMinutes: 90,
        targetQuestionCount: 90,
        minimumScaledScore: 100,
        maximumScaledScore: 900,
        passingScaledScore: 750,
        performanceItems: [
            ExamItem(
                id: "701-pbq-ir-order",
                domainID: "701-operations",
                kind: .ordering,
                prompt: "PBQ: Drag the incident response phases into the best order.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: ["Preparation", "Detection and analysis", "Containment", "Eradication", "Recovery", "Lessons learned"],
                explanation: "Incident response starts before the incident, then moves through analysis, containment, eradication, recovery, and improvement.",
                points: 6,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "701-pbq-control-types",
                domainID: "701-concepts",
                kind: .matching,
                prompt: "PBQ: Match each control example to the best control type.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: ["Security camera alert", "Firewall blocking inbound traffic", "Restore from backup", "Mandatory approval before production change", "Security awareness training"],
                matchingAnswers: ["Corrective", "Managerial", "Detective", "Preventive", "Operational"],
                correctMatches: [2, 3, 0, 1, 4],
                correctOrder: [],
                explanation: "Cameras detect, firewalls prevent, restores correct, approvals are managerial, and training is operational.",
                points: 5,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "701-pbq-ransomware",
                domainID: "701-operations",
                kind: .multipleSelect,
                prompt: "PBQ: A file server shows ransomware indicators. Select appropriate early response actions.",
                choices: ["Isolate affected systems", "Preserve useful logs and evidence", "Pay immediately without escalation", "Notify the incident response lead", "Begin uncontrolled restoration over infected systems"],
                correctChoiceIndexes: [0, 1, 3],
                matchingPrompts: [],
                matchingAnswers: [],
                correctMatches: [],
                correctOrder: [],
                explanation: "Early response should limit spread, preserve evidence, and activate the response process. Restoration should be controlled and validated.",
                points: 3,
                isPerformanceBased: true
            ),
            ExamItem(
                id: "701-pbq-risk",
                domainID: "701-program",
                kind: .matching,
                prompt: "PBQ: Match each risk action to the correct risk response.",
                choices: [],
                correctChoiceIndexes: [],
                matchingPrompts: ["Buy cyber insurance", "Retire a vulnerable public app", "Patch and segment a risky system", "Accept a low-impact risk by approval"],
                matchingAnswers: ["Avoid", "Mitigate", "Transfer", "Accept"],
                correctMatches: [2, 0, 1, 3],
                correctOrder: [],
                explanation: "Insurance transfers, retiring the exposure avoids, controls mitigate, and documented approval can accept residual risk.",
                points: 4,
                isPerformanceBased: true
            )
        ]
    )
}
