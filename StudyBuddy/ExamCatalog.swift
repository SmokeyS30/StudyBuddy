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

    static func practiceQuestions(
        for examID: String,
        difficulty: StudyBuddyDifficultyLevel,
        minimumCount: Int = 120
    ) -> [PracticeQuestion] {
        let base = baseExam(for: examID)
        let challenge = challengeQuestions(for: examID)
        let supplemental = supplementalChallengeQuestions(for: examID)
        let generated = generatedScenarioQuestions(for: base, difficulty: difficulty, minimumCount: minimumCount)

        let source: [PracticeQuestion]
        switch difficulty {
        case .beginner:
            source = base.practiceQuestions + Array(generated.prefix(minimumCount))
        case .certificationReady:
            source = base.practiceQuestions + Array(challenge.prefix(max(20, minimumCount / 3))) + supplemental + generated
        case .realExam:
            source = challenge + supplemental + generated + base.practiceQuestions
        case .nightmareMode:
            source = supplemental + generated + challenge
        }

        let examDomainIDs = Set(base.domains.map(\.id))
        let examOnly = source.filter { examDomainIDs.contains($0.domainID) }

        return uniqueQuestions(examOnly.isEmpty ? base.practiceQuestions : examOnly)
            .map { $0.withMinimumChoices() }
            .shuffled()
    }

    static func quickTips(for examID: String) -> [String] {
        switch examID {
        case aPlusCore1.id:
            return aPlusCore1ReadinessTips
        case securityPlus.id:
            return securityPlusReadinessTips
        default:
            return aPlusCore2ReadinessTips
        }
    }

    static let exams: [ExamProfile] = [
        challengeRefresh(
            aPlusCore1,
            extraFlashcards: aPlusCore1ChallengeFlashcards,
            extraQuestions: aPlusCore1ChallengeQuestions
        ),
        challengeRefresh(
            aPlusCore2,
            extraFlashcards: aPlusCore2ChallengeFlashcards,
            extraQuestions: aPlusCore2ChallengeQuestions
        ),
        challengeRefresh(
            securityPlus,
            extraFlashcards: securityPlusChallengeFlashcards,
            extraQuestions: securityPlusChallengeQuestions
        )
    ]

    static func simulations(for examID: String) -> [ExamSimulation] {
        switch examID {
        case aPlusCore1.id:
            let simulation = challengeSimulation(aPlusCore1Simulation, performanceItems: aPlusCore1HardPerformanceItems)
            return [shortSimulation(from: simulation, id: "1201-short-10", title: "Core 1 Hard Short Practice Test"), simulation]
        case securityPlus.id:
            let simulation = challengeSimulation(securityPlusSimulation, performanceItems: securityPlusHardPerformanceItems)
            return [shortSimulation(from: simulation, id: "701-short-10", title: "Security+ Hard Short Practice Test"), simulation]
        default:
            let simulation = challengeSimulation(aPlusCore2Simulation, performanceItems: aPlusCore2HardPerformanceItems)
            return [shortSimulation(from: simulation, id: "1202-short-10", title: "Core 2 Hard Short Practice Test"), simulation]
        }
    }

    private static func shortSimulation(from simulation: ExamSimulation, id: String, title: String) -> ExamSimulation {
        ExamSimulation(
            id: id,
            title: title,
            description: "A 10-question hard-mode practice test with original scenario questions, tough distractors, and PBQ-style items.",
            timeLimitMinutes: 15,
            targetQuestionCount: 10,
            minimumScaledScore: simulation.minimumScaledScore,
            maximumScaledScore: simulation.maximumScaledScore,
            passingScaledScore: simulation.passingScaledScore,
            performanceItems: simulation.performanceItems
        )
    }

    private static func challengeSimulation(_ simulation: ExamSimulation, performanceItems: [ExamItem]) -> ExamSimulation {
        ExamSimulation(
            id: simulation.id,
            title: simulation.title.replacingOccurrences(of: "Exam-Day", with: "Hard Exam-Day"),
            description: "A hard-mode randomized simulation with original scenario questions, tougher distractors, and more demanding PBQ-style workflows.",
            timeLimitMinutes: simulation.timeLimitMinutes,
            targetQuestionCount: simulation.targetQuestionCount,
            minimumScaledScore: simulation.minimumScaledScore,
            maximumScaledScore: simulation.maximumScaledScore,
            passingScaledScore: simulation.passingScaledScore,
            performanceItems: performanceItems
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

private extension ExamCatalog {
    static func baseExam(for examID: String) -> ExamProfile {
        switch examID {
        case aPlusCore1.id:
            return aPlusCore1
        case securityPlus.id:
            return securityPlus
        default:
            return aPlusCore2
        }
    }

    static func challengeQuestions(for examID: String) -> [PracticeQuestion] {
        switch examID {
        case aPlusCore1.id:
            return aPlusCore1ChallengeQuestions
        case securityPlus.id:
            return securityPlusChallengeQuestions
        default:
            return aPlusCore2ChallengeQuestions
        }
    }

    static func uniqueQuestions(_ questions: [PracticeQuestion]) -> [PracticeQuestion] {
        var seen = Set<String>()
        var unique: [PracticeQuestion] = []

        for question in questions {
            let key = question.prompt.lowercased()
                .components(separatedBy: CharacterSet.alphanumerics.inverted)
                .filter { !$0.isEmpty }
                .joined(separator: " ")
            guard !seen.contains(key) else { continue }
            seen.insert(key)
            unique.append(question)
        }

        return unique
    }

    static func generatedScenarioQuestions(
        for exam: ExamProfile,
        difficulty: StudyBuddyDifficultyLevel,
        minimumCount: Int
    ) -> [PracticeQuestion] {
        var generated: [PracticeQuestion] = []
        var sequence = 0
        let templates = generatedPromptTemplates(for: difficulty)

        while generated.count < minimumCount {
            for domain in exam.domains {
                for objectiveIndex in domain.objectives.indices {
                    let objective = domain.objectives[objectiveIndex]
                    let answer = bestAction(for: domain.id, objectiveIndex: objectiveIndex + sequence)
                    let template = templates[(objectiveIndex + sequence) % templates.count]
                    let id = "\(exam.code)-\(difficulty.rawValue)-generated-\(sequence)-\(domain.id)-\(objectiveIndex)"
                    let prompt = template
                        .replacingOccurrences(of: "{exam}", with: "\(exam.name) \(exam.code)")
                        .replacingOccurrences(of: "{domain}", with: domain.title)
                        .replacingOccurrences(of: "{objective}", with: objective)
                    let distractors = generatedDistractors(
                        for: domain.id,
                        answer: answer,
                        id: id,
                        difficulty: difficulty
                    )
                    generated.append(
                        q(
                            id,
                            domain.id,
                            prompt,
                            answer,
                            distractors,
                            generatedExplanation(for: domain.title, objective: objective, answer: answer, difficulty: difficulty)
                        )
                    )

                    if generated.count >= minimumCount { break }
                }
                if generated.count >= minimumCount { break }
            }
            sequence += 1
        }

        return generated
    }

    static func generatedPromptTemplates(for difficulty: StudyBuddyDifficultyLevel) -> [String] {
        switch difficulty {
        case .beginner:
            return [
                "{exam} beginner check: A study item maps to {domain}. {objective} Which action best matches this objective?",
                "A new technician is reviewing {domain}. The objective says: {objective} Which answer is the safest first habit?",
                "Basic readiness drill for {exam}: {objective} What should the student recognize first?"
            ]
        case .certificationReady:
            return [
                "A ticket tests {domain}: {objective} Which response best balances evidence gathering and a low-risk fix?",
                "A technician sees a scenario tied to {domain}. {objective} What answer is most defensible before escalation?",
                "Certification-ready scenario: {objective} Which choice best fits the timing, scope, and verification needed?"
            ]
        case .realExam:
            return [
                "A scenario gives partial evidence for {domain}. {objective} Which action is the best next step, not just a generally true statement?",
                "Real Exam Mode: A user report maps to {domain}. {objective} What should the technician or analyst do first?",
                "A question stem includes extra details around {domain}. {objective} Which response best follows exam-day process?"
            ]
        case .nightmareMode:
            return [
                "Nightmare Mode: Conflicting clues point toward {domain}. {objective} Which choice best preserves evidence, reduces risk, and avoids premature remediation?",
                "A long scenario hides the deciding clue inside {domain}. {objective} Which answer is strongest when more than one option sounds plausible?",
                "Harder-than-exam drill: {objective} Which action fits the objective while respecting scope, timing, and verification?"
            ]
        }
    }

    static func bestAction(for domainID: String, objectiveIndex: Int) -> String {
        let actions = bestActionBank[domainID] ?? bestActionBank["generic"] ?? questionSafeFallbacks
        return actions[objectiveIndex % actions.count]
    }

    static func generatedDistractors(
        for domainID: String,
        answer: String,
        id: String,
        difficulty: StudyBuddyDifficultyLevel
    ) -> [String] {
        switch difficulty {
        case .beginner:
            return Array(questionSafeFallbacks.filter { $0 != answer }.prefix(3))
        case .certificationReady, .realExam, .nightmareMode:
            return toughDistractors(for: domainID, answer: answer, prompt: "", id: id)
        }
    }

    static func generatedExplanation(
        for domainTitle: String,
        objective: String,
        answer: String,
        difficulty: StudyBuddyDifficultyLevel
    ) -> String {
        "\(difficulty.title) questions should be answered by matching the scenario clue to the objective. For \(domainTitle), this item maps to: \(objective). The best action is: \(answer)."
    }

    static func challengeRefresh(_ exam: ExamProfile, extraFlashcards: [Flashcard], extraQuestions: [PracticeQuestion]) -> ExamProfile {
        ExamProfile(
            id: exam.id,
            name: exam.name,
            code: exam.code,
            summary: exam.summary,
            domains: exam.domains,
            studyTasks: exam.studyTasks,
            flashcards: exam.flashcards + extraFlashcards,
            practiceQuestions: harden(extraQuestions + supplementalChallengeQuestions(for: exam.id)),
            quickTips: quickTips(for: exam.id) + exam.quickTips,
            disclaimer: exam.disclaimer
        )
    }

    static func harden(_ questions: [PracticeQuestion]) -> [PracticeQuestion] {
        questions.map { question in
            let answer = question.choices.indices.contains(question.answerIndex) ? question.choices[question.answerIndex] : question.choices.first ?? ""
            let distractors = toughDistractors(for: question.domainID, answer: answer, prompt: question.prompt, id: question.id)

            return PracticeQuestion(
                id: question.id,
                domainID: question.domainID,
                prompt: question.prompt,
                choices: [answer] + distractors,
                answerIndex: 0,
                explanation: question.explanation
            )
        }
    }

    static func toughDistractors(for domainID: String, answer: String, prompt: String, id: String) -> [String] {
        let bank = toughDistractorBank[domainID] ?? toughDistractorBank["generic"] ?? []
        let normalizedAnswer = answer.lowercased()
            .replacingOccurrences(of: "/", with: " ")
            .replacingOccurrences(of: "-", with: " ")

        let filtered = bank.filter { option in
            let normalizedOption = option.lowercased()
                .replacingOccurrences(of: "/", with: " ")
                .replacingOccurrences(of: "-", with: " ")
            return option != answer
                && !normalizedOption.contains(normalizedAnswer)
                && !normalizedAnswer.contains(normalizedOption)
        }

        let source = filtered.count >= 3 ? filtered : bank.filter { $0 != answer }
        guard !source.isEmpty else { return Array(questionSafeFallbacks.prefix(3)) }

        let start = abs(id.unicodeScalars.reduce(0) { ($0 &* 31) &+ Int($1.value) }) % source.count
        let rotated = Array(source[start...]) + Array(source[..<start])
        let selected = Array(rotated.prefix(3))

        if selected.count == 3 {
            return selected
        }

        return selected + questionSafeFallbacks.filter { $0 != answer && !selected.contains($0) }.prefix(3 - selected.count)
    }

    static func q(_ id: String, _ domainID: String, _ prompt: String, _ answer: String, _ distractors: [String], _ explanation: String) -> PracticeQuestion {
        PracticeQuestion(
            id: id,
            domainID: domainID,
            prompt: prompt,
            choices: [answer] + distractors,
            answerIndex: 0,
            explanation: explanation
        )
    }

    static let questionSafeFallbacks = [
        "Escalate only after collecting evidence, confirming scope, and documenting impact",
        "Apply the lowest-risk reversible change first, then verify the user's original workflow",
        "Use policy-approved tooling, preserve useful logs, and avoid destructive recovery until data is protected"
    ]

    static let aPlusCore1ReadinessTips = [
        "220-1201 readiness starts with recognition speed: ports, connectors, printer types, storage types, wireless bands, and mobile symptoms should feel automatic before full exams.",
        "For Core 1 troubleshooting, always separate symptom scope first: one device, one user, one location, one network segment, or everyone. Scope usually exposes the best next step.",
        "Printer questions become easier when you identify the print technology before choosing a part. Laser, inkjet, thermal, impact, and 3D printers fail in different ways.",
        "For networking, do not memorize only port numbers. Memorize the clue: name resolution points to DNS, auto-addressing points to DHCP, secure web points to HTTPS, remote GUI points to RDP.",
        "For hardware, protect data before destructive actions. Check power, cable seating, firmware visibility, known-good parts, and diagnostics before replacing expensive components.",
        "For mobile and laptops, small symptoms can be physical: lid angle, cable routing, swollen batteries, dock firmware, privacy permissions, and antenna placement matter.",
        "Spend extra time on Hardware and Troubleshooting because they carry the largest Core 1 weight and drive many scenario questions.",
        "Before exam day, practice explaining why three wrong answers are wrong. That skill is what makes tough distractors less tempting."
    ]

    static let aPlusCore2ReadinessTips = [
        "220-1202 readiness depends on process order. For every support scenario, name the evidence source, the least disruptive action, the verification step, and the documentation note.",
        "Command-line questions are not about memorizing commands alone. Know what each command proves: ipconfig proves IP configuration, sfc checks protected system files, gpupdate refreshes policy.",
        "For malware questions, do not jump straight to cleanup. Identify symptoms, contain or quarantine, protect data and logs, remediate, update, scan, verify, and educate.",
        "For security, watch for social engineering language: urgency, authority, secrecy, payment pressure, password resets, and refusal to verify identity.",
        "For OS issues, decide whether the failure is user-specific, device-specific, app-specific, network-specific, or service-wide before choosing the fix.",
        "For operational procedures, choose the answer that protects privacy, follows change control, documents useful evidence, and escalates only when scope requires it.",
        "If you miss a question you thought you knew, mark it as guessed. Lucky answers should come back sooner in review.",
        "Build a pre-exam checklist for Windows tools, malware order, backup/change control, remote access consent, ticket notes, and privacy handling."
    ]

    static let securityPlusReadinessTips = [
        "SY0-701 is scenario-heavy. First decide whether the question is asking for an attack type, a control, a process step, an architecture choice, or a risk decision.",
        "Spend the most time on Security Operations and Threats/Vulnerabilities because together they cover a large part of the exam and feed many PBQ-style scenarios.",
        "For incident response, do not skip containment and evidence. The strongest answer usually reduces harm while preserving the ability to investigate.",
        "For architecture questions, map the control to the enforcement point: endpoint, identity provider, network edge, cloud control plane, data layer, or monitoring system.",
        "For cryptography, separate confidentiality, integrity, authentication, non-repudiation, and key management. Hashing, encryption, signatures, and certificates solve different problems.",
        "For risk questions, identify asset value, exposure, likelihood, impact, residual risk, and ownership before selecting accept, avoid, transfer, or mitigate.",
        "For governance, memorize the difference between policy, standard, procedure, guideline, baseline, exception, and audit evidence.",
        "Before exam day, drill logs and alerts: process tree, failed sign-ins, suspicious DNS, impossible travel, firewall denies, and phishing indicators."
    ]

    static let bestActionBank: [String: [String]] = [
        "1201-mobile": [
            "Inspect physical condition, battery safety, cable path, radio state, permissions, and sync settings before replacing parts",
            "Compare the failure against a known-good charger, cable, dock, accessory, or network",
            "Check mobile OS permissions, account sync state, MDM restrictions, screen lock, and backup status",
            "Treat swollen batteries, overheating, liquid exposure, and damaged ports as safety or handling issues first"
        ],
        "1201-networking": [
            "Confirm link, DHCP, DNS, gateway, VLAN, and wireless signal evidence before changing infrastructure",
            "Use the tool that proves the suspected layer with the least disruption",
            "Match the protocol, port, or network service to the symptom instead of guessing by acronym",
            "Compare one affected device against a known-good device on the same network path"
        ],
        "1201-hardware": [
            "Protect data, check firmware visibility, reseat components, and test with known-good parts before replacement",
            "Identify the component role, connector type, compatibility limit, and power or thermal requirement",
            "Match printer symptom to printer technology before choosing a maintenance part",
            "Verify full functionality after hardware changes and document what was replaced or reseated"
        ],
        "1201-cloud": [
            "Map responsibility between provider and customer before choosing a cloud or virtualization fix",
            "Check resource allocation, networking, snapshots, licensing, and data location before moving workloads",
            "Use snapshots for short rollback windows and backups for independent recovery",
            "Choose cloud service models based on who manages the application, platform, and infrastructure"
        ],
        "1201-troubleshooting": [
            "Use the troubleshooting process: identify, theorize, test, plan, verify, and document",
            "Scope the symptom by user, device, location, network, service, and timing before replacing hardware",
            "Start with low-risk checks such as power, cables, link lights, recent changes, logs, and known-good parts",
            "Verify the original user workflow after the technical symptom appears resolved"
        ],
        "1202-os": [
            "Use logs, service state, recent changes, permissions, startup items, and recovery tools before reinstalling",
            "Choose the command or console that proves the suspected Windows, macOS, Linux, or mobile OS issue",
            "Preserve user data and profile state before rollback, reset, reimage, or profile recreation",
            "Separate account, device, app, network, and service scope before choosing a fix"
        ],
        "1202-security": [
            "Verify identity, enforce least privilege, protect sessions, and preserve auditability",
            "Treat unexpected MFA prompts, forwarding rules, browser redirects, and disabled tools as compromise signals",
            "Harden SOHO and endpoint settings with MFA, WPA2 or WPA3, disabled WPS, updates, guest isolation, and backups",
            "Follow malware response order before destructive cleanup"
        ],
        "1202-troubleshooting": [
            "Gather recent-change evidence, logs, safe-mode behavior, permissions, and resource usage before destructive recovery",
            "Check app cache, profile state, permissions, updates, and network restrictions for user-specific failures",
            "Use a reversible fix first, then verify the user's original workflow",
            "Document evidence, action, result, root cause if known, and prevention guidance"
        ],
        "1202-operations": [
            "Use change approval, rollback planning, communication, documentation, and verification before production changes",
            "Protect privacy and regulated data by minimizing exposure and using approved systems",
            "Escalate when permissions, compliance, evidence, or business impact exceeds the technician role",
            "Apply ESD, electrical, lifting, disposal, cable, and battery safety before hands-on work"
        ],
        "701-concepts": [
            "Map the control to confidentiality, integrity, availability, authentication, authorization, accounting, or non-repudiation",
            "Separate preventive, detective, corrective, deterrent, compensating, managerial, technical, and operational controls",
            "Use hashing for integrity, encryption for confidentiality, signatures for authenticity, and certificates for trust binding",
            "Apply zero trust by evaluating identity, device posture, risk, and requested resource"
        ],
        "701-threats": [
            "Classify the attack by delivery method, exploit path, actor motive, indicator, and mitigation",
            "Correlate user reports, URLs, headers, process behavior, persistence, and network indicators before declaring root cause",
            "Prioritize mitigations by exploitability, exposed attack surface, asset criticality, and compensating controls",
            "Treat urgency, payment changes, credential prompts, and secrecy as social engineering evidence"
        ],
        "701-architecture": [
            "Choose the control based on where enforcement belongs: identity, endpoint, network, cloud, data, or monitoring",
            "Use segmentation, microsegmentation, zero trust, secure gateways, and least privilege to limit lateral movement",
            "Protect secrets with vaulting, scoped identity access, rotation, and removal from source code",
            "Design resilience around business impact, RTO, RPO, backup integrity, replication, and failover"
        ],
        "701-operations": [
            "Contain affected systems, preserve evidence, scope impact, and activate the incident response process",
            "Correlate SIEM, EDR, identity, DNS, firewall, proxy, cloud, and application logs before remediation",
            "Prioritize vulnerabilities by risk, exploitability, asset criticality, exposure, and validation",
            "Verify recovery by checking integrity, persistence removal, functionality, and recurrence indicators"
        ],
        "701-program": [
            "Document risk ownership, residual risk, approval, review date, and compensating controls",
            "Tie third-party access to contracts, SLAs, right-to-audit, data handling, and offboarding requirements",
            "Use BIA results to drive RTO, RPO, tabletop exercises, communications, and recovery priorities",
            "Measure awareness by behavior outcomes such as report rate, repeat click rate, and response time"
        ],
        "generic": [
            "Confirm scope and evidence before selecting a disruptive remediation path",
            "Choose the control that fits timing, risk, and responsibility rather than a generally true statement",
            "Verify the original user or business workflow after the technical symptom changes",
            "Preserve data and logs before making irreversible changes"
        ]
    ]

    static let toughDistractorBank: [String: [String]] = [
        "1201-mobile": [
            "Recreate the saved wireless or Bluetooth profile after confirming radio state and permissions",
            "Validate display mode, adapter capability, dock firmware, and external monitor input before replacing hardware",
            "Inspect battery health, charging path, thermal state, and vendor diagnostics before ordering parts",
            "Confirm app permission scope, sync account state, storage availability, and OS update status",
            "Test with known-good cable, charger, port orientation, and accessory before replacing the system board",
            "Check MDM restrictions, screen lock policy, biometric enrollment, and remote wipe state"
        ],
        "1201-networking": [
            "Check DHCP lease negotiation, VLAN assignment, gateway, and address conflict evidence",
            "Validate DNS resolver, search suffix, cache behavior, and split-tunnel name resolution",
            "Test cable pair integrity, switch port negotiation, patch path, and link-state changes",
            "Review SSID band steering, channel overlap, AP placement, attenuation, and roaming thresholds",
            "Confirm firewall profile, ACL behavior, captive portal state, and VPN tunnel restrictions",
            "Compare local subnet reachability with off-subnet routing before replacing network hardware"
        ],
        "1201-hardware": [
            "Verify firmware support, slot population rules, bus compatibility, and power connector seating",
            "Check thermal transfer, cooler mounting pressure, fan header, airflow path, and load behavior",
            "Validate storage protocol, partition style, boot mode, controller settings, and data cable path",
            "Inspect rotating printer components, media path, maintenance kit status, and consumable compatibility",
            "Confirm PSU capacity, transient load behavior, UPS condition, and surge protection path",
            "Preserve user data before stress testing suspected storage or rebuilding arrays"
        ],
        "1201-cloud": [
            "Confirm shared responsibility boundaries, identity controls, data location, and internet dependency",
            "Validate host CPU virtualization support, RAM allocation, storage IOPS, and network adapter mode",
            "Use snapshots for short rollback windows while maintaining independent backups and retention",
            "Compare SaaS operational convenience with IaaS configuration control and customer responsibility",
            "Check metered cost, elasticity limits, service availability, and offline access requirements",
            "Separate sandbox isolation from production trust and data handling requirements"
        ],
        "1201-troubleshooting": [
            "Identify the symptom scope, recent changes, environmental triggers, and physical-layer evidence first",
            "Verify the simple reversible path before replacing parts or reimaging the device",
            "Protect data, collect diagnostic evidence, and test with known-good components when hardware is suspected",
            "Compare user-specific, device-specific, network-specific, and service-wide failure patterns",
            "Confirm full functionality in the user's original workflow before documenting closure",
            "Use logs, diagnostic indicators, vendor tools, and recurrence timing to test the theory"
        ],
        "1202-os": [
            "Use Event Viewer, Reliability Monitor, service state, and recent-change evidence before reinstalling",
            "Validate account context, local group membership, file permissions, and application install scope",
            "Check DNS, VPN routing, cached credentials, and domain controller reachability for sign-in or share failures",
            "Use Safe Mode or recovery tools to disable suspect startup items, drivers, or services",
            "Confirm architecture, edition support, update state, and vendor compatibility before changing software",
            "Preserve profile data before recreating profiles, rolling back updates, or resetting the OS"
        ],
        "1202-security": [
            "Follow identity verification policy, deny suspicious requests, and preserve auditability",
            "Isolate suspected compromise, preserve logs, reset affected credentials, and educate the user",
            "Apply least privilege with time-limited elevation, MFA, account review, and screen lock controls",
            "Use approved remote access, consent, session logging, and clear handoff steps",
            "Harden SOHO wireless with WPA2 or WPA3, disabled WPS, firmware updates, and guest isolation",
            "Handle sensitive data with approved storage, minimal exposure, secure disposal, and privacy policy"
        ],
        "1202-troubleshooting": [
            "Scope whether the failure is user-specific, app-specific, device-specific, or service-wide",
            "Use recent changes, logs, safe mode, and resource monitors before destructive recovery",
            "Refresh saved credentials, tokens, app permissions, and profile settings when authentication changed",
            "Check browser extensions, notifications, cached data, proxy settings, and profile corruption",
            "Verify update rollback, vendor workaround, or configuration repair with the user's real workflow",
            "Use trusted recovery media or safe environment when local security tools may be compromised"
        ],
        "1202-operations": [
            "Obtain approval, schedule impact, communicate expectations, and confirm rollback before production changes",
            "Document symptoms, evidence, actions, verification, user confirmation, and prevention guidance",
            "Escalate when permissions, scope, compliance, or evidence handling exceeds the technician role",
            "Use ESD, electrical safety, lifting, disposal, and battery handling procedures before hands-on work",
            "Protect privacy by minimizing exposure and storing sensitive information only in approved systems",
            "Verify backup restoration capability before assuming recovery objectives can be met"
        ],
        "701-concepts": [
            "Use cryptographic signing and logging to support non-repudiation rather than confidentiality alone",
            "Apply hashing for integrity or password verification, not reversible data confidentiality",
            "Evaluate authentication, authorization, accounting, federation, and privileged access as separate controls",
            "Map control function to preventive, detective, corrective, deterrent, compensating, managerial, technical, or operational",
            "Use certificates and PKI to bind identities to public keys and manage trust",
            "Apply zero trust by evaluating identity, device posture, location, risk, and requested resource"
        ],
        "701-threats": [
            "Treat urgency, payment change requests, and out-of-band secrecy as business email compromise indicators",
            "Prioritize exploitability, exposed attack surface, asset criticality, and compensating controls",
            "Identify whether the prompt is testing attack vector, vulnerability class, threat actor motive, or mitigation",
            "Correlate user reports, headers, URLs, process behavior, persistence, and network indicators",
            "Mitigate web input flaws with validation, encoding, parameterized queries, and secure design review",
            "Separate phishing delivery channel from impersonation, credential theft, and process abuse"
        ],
        "701-architecture": [
            "Use segmentation or microsegmentation to limit east-west movement and enforce trust boundaries",
            "Map cloud responsibility to customer configuration, identity, data protection, and provider-managed layers",
            "Protect secrets with vaulting, rotation, scoped access, and removal from source code",
            "Apply DLP, classification, tokenization, encryption, retention, and disposal controls by data sensitivity",
            "Use WAF, NAC, CASB, SASE, ZTNA, or secure gateways based on traffic flow and enforcement point",
            "Design HA, backup, replication, RTO, and RPO around business impact rather than tool preference"
        ],
        "701-operations": [
            "Contain affected systems, preserve evidence, scope impact, and activate the incident response process",
            "Correlate SIEM, EDR, identity, firewall, DNS, proxy, cloud, and application logs before declaring root cause",
            "Prioritize vulnerabilities by exploitability, asset criticality, exposure, compensating controls, and validation",
            "Use playbooks for repeatable triage while keeping analyst review for risky containment actions",
            "Validate recovery by checking integrity, persistence removal, functionality, and recurrence indicators",
            "Tune noisy detections only after measuring coverage impact and documenting the exception"
        ],
        "701-program": [
            "Document risk acceptance with owner approval, residual risk, review date, and compensating controls",
            "Tie third-party access to contracts, SLAs, right-to-audit, data handling, and offboarding requirements",
            "Use BIA results to drive RTO, RPO, communications, tabletop exercises, and recovery priorities",
            "Separate policies, standards, procedures, guidelines, baselines, and exceptions by authority and detail",
            "Measure awareness with behavior outcomes such as report rate, repeat click rate, and response time",
            "Classify data to choose handling, retention, encryption, sharing, and disposal requirements"
        ],
        "generic": [
            "Confirm scope and evidence before selecting a disruptive remediation path",
            "Choose the control that fits timing, risk, and responsibility rather than a generally true statement",
            "Verify the original user or business workflow after the technical symptom changes",
            "Preserve data and logs before making irreversible changes"
        ]
    ]

    static func supplementalChallengeQuestions(for examID: String) -> [PracticeQuestion] {
        switch examID {
        case aPlusCore1.id:
            return [
                q("1201-ultra-001", "1201-mobile", "A laptop intermittently loses Wi-Fi only when the lid is moved. Other devices remain connected. Which area should be inspected first?", "Antenna lead routing through the hinge and wireless card seating", [], "Movement-related wireless loss on one laptop points to antenna/cable routing or adapter seating before infrastructure changes."),
                q("1201-ultra-002", "1201-networking", "A workstation can reach internal IP addresses but fails when using hostnames after connecting to VPN. What is the best first theory?", "Split-DNS or VPN-provided DNS configuration is wrong", [], "IP reachability with hostname failure after VPN connection points to DNS behavior across the tunnel."),
                q("1201-ultra-003", "1201-hardware", "A new NVMe drive is physically installed, but firmware lists only SATA devices and the motherboard manual says the slot shares lanes with SATA ports. What should be checked?", "M.2 lane sharing, slot mode, and disabled SATA port rules", [], "M.2 detection issues often depend on PCIe/SATA mode and lane-sharing rules."),
                q("1201-ultra-004", "1201-troubleshooting", "A desktop passes a short memory test but crashes after 30 minutes under load. What evidence should be gathered next?", "Thermal and power behavior during sustained load", [], "Time/load-dependent crashes require checking heat, power stability, and sustained stress behavior."),
                q("1201-ultra-005", "1201-cloud", "A synced cloud file opens on a laptop at the office but is unavailable on a plane. What should have been configured?", "Offline availability for the file or folder before travel", [], "Cloud sync does not guarantee offline availability unless the file is stored locally."),
                q("1201-ultra-006", "1201-hardware", "A laser printer has ghosted images that repeat faintly after the original text. Which cause is most likely?", "Drum or fuser-related image transfer issue", [], "Ghosting commonly points to drum, fuser, toner, or media behavior in the imaging path."),
                q("1201-ultra-007", "1201-networking", "A device gets the correct IP, mask, DNS, and gateway but cannot reach one server subnet. Others can. What should be compared?", "Local firewall rules, route table, and server-side access control for that device", [], "Correct basic IP settings do not rule out local firewall, route, or access-control differences."),
                q("1201-ultra-008", "1201-mobile", "A user's authenticator prompts stopped after restoring a phone backup to a new device. What is the best explanation?", "The authenticator or push approval enrollment must be re-registered", [], "Restoring a phone does not always migrate MFA device registration."),
                q("1201-ultra-009", "1201-troubleshooting", "A PC fails only at the user's desk but works at the repair bench. Which test is most important?", "Recreate the desk environment including power, peripherals, cable path, and network drop", [], "Location-specific failures require testing the original environment, not only the isolated device."),
                q("1201-ultra-010", "1201-hardware", "After replacing a motherboard, Windows asks for a recovery key before booting. What component or feature most likely triggered it?", "TPM or secure boot state changed", [], "Hardware/firmware changes can affect TPM-measured boot and trigger recovery for encrypted drives.")
            ]
        case securityPlus.id:
            return [
                q("701-ultra-001", "701-concepts", "A system encrypts a message and signs the hash of the message. What does the signature primarily provide?", "Integrity, authentication, and non-repudiation support", [], "Digital signatures prove the signer key and detect message changes; encryption separately protects confidentiality."),
                q("701-ultra-002", "701-threats", "A login endpoint shows normal volume but many usernames each receive one password attempt from distributed IPs. What attack fits best?", "Password spraying", [], "Password spraying uses common passwords across many accounts to avoid lockouts."),
                q("701-ultra-003", "701-architecture", "A SaaS admin accidentally allows public sharing links for confidential documents. Which control would most directly reduce future exposure?", "DLP and sharing policy enforcement through SaaS or CASB controls", [], "The risk is cloud data sharing; DLP/CASB or SaaS policy enforcement addresses it directly."),
                q("701-ultra-004", "701-operations", "An EDR alert shows a signed system tool spawning a suspicious encoded command. What should be reviewed first?", "Process tree, command line, user context, and parent process", [], "Living-off-the-land activity requires process lineage and command context."),
                q("701-ultra-005", "701-program", "A business unit accepts a medium risk for six months while a compensating control is built. What is required?", "Documented risk acceptance with owner, expiration, and review date", [], "Risk acceptance should be explicit, time-bound, owned, and reviewed."),
                q("701-ultra-006", "701-threats", "A user browses a trusted industry site and receives a malicious script from a compromised third-party ad. What is the best classification?", "Watering hole or supply-chain style web compromise", [], "The target is reached through a trusted site or dependency in the browsing path."),
                q("701-ultra-007", "701-architecture", "A developer wants production database credentials available to an app without exposing them in source control. Which design is best?", "Managed secrets vault with scoped identity access and rotation", [], "Secrets should be centrally managed, scoped, audited, and rotated."),
                q("701-ultra-008", "701-operations", "A vulnerability is critical but exists only on an isolated lab host with no sensitive data. Another high vulnerability is internet-facing on an identity server. What should drive priority?", "Business context, exposure, exploitability, and asset criticality", [], "Severity alone is not enough; exposure and asset value change remediation priority."),
                q("701-ultra-009", "701-program", "A vendor contract lacks breach notification timelines. Which risk area is most directly affected?", "Third-party incident response and legal/compliance obligations", [], "Contracts should define notification, responsibilities, evidence, data handling, and audit rights."),
                q("701-ultra-010", "701-concepts", "A user is authorized for an app but attempts to read records outside their department. Which control failed if the request succeeds?", "Authorization or object-level access control", [], "Authentication proves identity; authorization controls what records the identity can access.")
            ]
        default:
            return [
                q("1202-ultra-001", "1202-os", "A domain user can sign in with cached credentials but cannot access new file shares after a VPN client update. What should be checked first?", "VPN routing, DNS to domain resources, and domain controller reachability", [], "Cached sign-in can succeed while live domain resources fail because the device cannot reach internal services."),
                q("1202-ultra-002", "1202-security", "A user approved an MFA prompt they did not initiate and then reports mailbox rules they did not create. What is the best response?", "Treat it as account compromise, revoke sessions, reset credentials, and review mailbox rules", [], "Unexpected MFA approval plus mailbox changes is a compromise signal that needs containment and review."),
                q("1202-ultra-003", "1202-troubleshooting", "An application crashes only for one Windows profile, while the same app works for another user on the same PC. What is the best scope?", "User profile, app cache, permissions, or per-user configuration", [], "Same machine and app working for another user points to profile-specific state."),
                q("1202-ultra-004", "1202-operations", "A support fix requires disabling a security control temporarily on a production workstation. What should happen first?", "Obtain approval, document risk, set a rollback time, and verify compensating controls", [], "Operational procedure requires approval and risk control before weakening security."),
                q("1202-ultra-005", "1202-security", "A remote caller knows the user's manager, asset tag, and ticket number but wants a password reset sent to a personal email. What is the best action?", "Refuse until identity is verified through the approved process", [], "Context details can be gathered; policy-based identity verification is still required."),
                q("1202-ultra-006", "1202-troubleshooting", "A mobile app syncs on Wi-Fi but fails on cellular after a privacy update. What is the best first area to inspect?", "Cellular data permission, background app refresh, VPN, and app-specific network settings", [], "Network-specific mobile failures often come from permissions, background restrictions, VPN, or app network settings.")
            ]
        }
    }

    static let aPlusCore1ChallengeFlashcards: [Flashcard] = [
        Flashcard(id: "1201-hard-fc-001", domainID: "1201-mobile", front: "What makes laptop display questions tricky?", back: "Symptoms can point to panel, backlight, inverter on older systems, cable, GPU, brightness settings, or external display configuration."),
        Flashcard(id: "1201-hard-fc-002", domainID: "1201-mobile", front: "Why is a swollen battery not a normal troubleshooting part swap?", back: "It is a safety issue. Stop use, avoid pressure or puncture, and follow approved replacement and disposal procedures."),
        Flashcard(id: "1201-hard-fc-003", domainID: "1201-networking", front: "What should APIPA make you check first?", back: "DHCP path, link status, VLAN or Wi-Fi connectivity, adapter configuration, and whether a DHCP server or scope is available."),
        Flashcard(id: "1201-hard-fc-004", domainID: "1201-networking", front: "Why can DNS be broken when internet connectivity still exists?", back: "A device may reach IP addresses while failing hostname resolution because DNS server, suffix, cache, or filtering settings are wrong."),
        Flashcard(id: "1201-hard-fc-005", domainID: "1201-hardware", front: "What is the difference between M.2 and NVMe?", back: "M.2 is a physical form factor. NVMe is a high-performance protocol commonly used over PCIe."),
        Flashcard(id: "1201-hard-fc-006", domainID: "1201-hardware", front: "Why is RAID not a backup?", back: "RAID can improve availability or performance, but it does not protect against deletion, corruption, ransomware, theft, or site loss."),
        Flashcard(id: "1201-hard-fc-007", domainID: "1201-hardware", front: "What does loose toner usually suggest on a laser printer?", back: "The toner is not being fused properly, often due to fuser, media, or temperature-related problems."),
        Flashcard(id: "1201-hard-fc-008", domainID: "1201-cloud", front: "What is the key difference between IaaS and SaaS?", back: "IaaS gives configurable infrastructure like VMs and networks. SaaS delivers a complete application managed by the provider."),
        Flashcard(id: "1201-hard-fc-009", domainID: "1201-cloud", front: "Why are snapshots not long-term backups?", back: "Snapshots depend on the underlying storage and are meant for rollback points, not independent recovery or retention."),
        Flashcard(id: "1201-hard-fc-010", domainID: "1201-troubleshooting", front: "What should 'intermittent' symptoms make you consider?", back: "Heat, power, loose connections, wireless interference, failing components, load, timing, and environmental factors."),
        Flashcard(id: "1201-hard-fc-011", domainID: "1201-troubleshooting", front: "Why is the physical layer often checked early?", back: "Loose cables, wrong ports, power, link lights, and damaged media are common, fast to verify, and low risk to correct."),
        Flashcard(id: "1201-hard-fc-012", domainID: "1201-troubleshooting", front: "What does a good troubleshooting answer include?", back: "The best next step, not just a true statement. It should match the symptom, risk, timing, and available evidence.")
    ]

    static let aPlusCore1ChallengeQuestions: [PracticeQuestion] = [
        q("1201-hard-001", "1201-mobile", "A laptop display is very dim, but an external monitor works and the built-in panel image is faintly visible under a flashlight. What is the best first hardware area to suspect?", "Backlight or display power path", ["GPU failure", "DHCP failure", "Bad keyboard ribbon"], "A faint image suggests the panel is receiving video but illumination is failing."),
        q("1201-hard-002", "1201-mobile", "A user says a phone charges only when the cable is held at an angle. Other devices charge normally with the same charger. What should be checked first?", "Charging port debris or damage on the phone", ["DNS server settings", "Printer fuser temperature", "RAID controller cache"], "The charger works elsewhere, so the phone port, cable seating, or port damage is the best next check."),
        q("1201-hard-003", "1201-mobile", "A tablet battery swells and the screen begins separating from the case. What is the best response?", "Stop use and follow approved battery handling and replacement procedures", ["Press the screen back into place", "Run calibration until it drains", "Place it under heavy books overnight"], "A swollen battery is a safety issue and should not be compressed, punctured, or kept in service."),
        q("1201-hard-004", "1201-mobile", "A laptop on a docking station has network and keyboard access but no external display. The monitor works with another laptop. What should be checked first?", "Dock display connection, input selection, and display settings", ["DHCP lease duration", "Laser printer imaging drum", "NFC pairing settings"], "The issue is scoped to display through the dock, so cabling, input, dock port, and OS display mode are the most relevant checks."),
        q("1201-hard-005", "1201-mobile", "A user cannot pair Bluetooth earbuds after they were paired with another phone nearby. What is the best next step?", "Put the earbuds in pairing mode and forget old pairings if needed", ["Replace the SSD", "Change the router default gateway", "Run diskpart"], "Bluetooth devices often need explicit pairing mode and may auto-connect to a previous host."),
        q("1201-hard-006", "1201-mobile", "A smartphone can use cellular data but cannot join the office Wi-Fi. Other phones join the Wi-Fi successfully. What should be checked first?", "Saved Wi-Fi profile, password, and device-specific network settings", ["The ISP modem only", "The office printer driver", "The desktop power supply"], "Because other phones work, focus on the affected phone's saved profile and local Wi-Fi settings."),
        q("1201-hard-007", "1201-mobile", "A laptop touchpad stops working only when a mouse is connected. What setting is most likely involved?", "Touchpad disabled while external mouse is connected", ["APIPA addressing", "RAID 5 parity", "Printer duplex mode"], "Many laptops can disable the touchpad automatically when an external pointing device is present."),
        q("1201-hard-008", "1201-mobile", "A user's phone storage is full, backups fail, and app updates cannot install. What is the best first action?", "Free local storage and verify cloud backup/sync settings", ["Replace the access point", "Change the laptop RAM speed", "Disable WPA3"], "Storage shortage directly affects backup, updates, and app behavior."),
        q("1201-hard-009", "1201-mobile", "A laptop keyboard has several nonresponsive keys after a spill. What should the technician do first?", "Power off, disconnect power, and follow liquid-damage procedure", ["Keep typing until it dries", "Run a DNS flush", "Update the printer driver"], "Liquids and powered electronics create risk. Power down and handle safely before testing."),
        q("1201-hard-010", "1201-mobile", "A phone's NFC payment fails after a thick metal-backed case is installed. What is the best theory?", "The case is interfering with short-range NFC communication", ["DHCP scope exhaustion", "A failing desktop PSU", "SATA cable damage"], "NFC is very short range and can be affected by cases, metal, or placement."),
        q("1201-hard-011", "1201-mobile", "A laptop camera works in one meeting app but not another. What is the best first check?", "App permission and selected camera settings", ["Replace the display panel", "Change the subnet mask", "Rebuild the RAID array"], "App-specific camera failure points to permissions or app device selection."),
        q("1201-hard-012", "1201-mobile", "A laptop battery drains quickly only when the dedicated GPU is active. Which change is most targeted?", "Adjust graphics performance profile or app GPU assignment", ["Clear DNS cache", "Replace the Ethernet switch", "Clean the laser printer pickup roller"], "GPU workload can heavily affect battery life; tune graphics behavior before unrelated fixes."),
        q("1201-hard-013", "1201-networking", "A PC shows 169.254.44.10 and cannot reach internal resources. Link lights are on. What should be checked next?", "DHCP availability, VLAN, or client IP configuration", ["Printer toner level", "Monitor orientation", "CPU virtualization support"], "APIPA indicates the client did not receive DHCP configuration despite a physical link."),
        q("1201-hard-014", "1201-networking", "A workstation can ping 8.8.8.8 but cannot browse to example.com. Which service should be investigated first?", "DNS", ["DHCP only", "RDP", "SMB signing"], "IP connectivity works, but hostname resolution fails, pointing to DNS."),
        q("1201-hard-015", "1201-networking", "Users on one side of an office report weak Wi-Fi after a microwave was moved near the access point. What is the best first theory?", "RF interference in the affected area", ["DHCP relay failure", "Bad laser fuser", "Wrong printer paper size"], "Location-specific wireless degradation after device movement points to interference or attenuation."),
        q("1201-hard-016", "1201-networking", "A conference room AP supports 2.4 GHz and 5 GHz. Users farthest away only see the 2.4 GHz SSID. Why?", "2.4 GHz generally has better range and wall penetration", ["5 GHz has unlimited range", "DNS blocks 5 GHz", "PoE changes the SSID"], "2.4 GHz usually travels farther, while 5 GHz commonly offers more throughput at shorter range."),
        q("1201-hard-017", "1201-networking", "A printer has a static IP that matches a DHCP client's address. What problem does this create?", "IP address conflict", ["DNS zone transfer", "RAID parity mismatch", "Bluetooth pairing conflict"], "Duplicate IP addresses cause intermittent or failed network communication."),
        q("1201-hard-018", "1201-networking", "A technician needs to test whether an Ethernet wall jack is connected to the expected switch port. Which tool is best?", "Toner/probe or cable tester depending on the task", ["Loopback plug for video", "ESD strap", "Thermal paste"], "Cable tracing and testing tools verify cable path and wiring."),
        q("1201-hard-019", "1201-networking", "A small office wants to power ceiling access points without local outlets. Which technology is most appropriate?", "PoE", ["NFC", "RAID 0", "SaaS"], "Power over Ethernet can provide data and power to compatible network devices."),
        q("1201-hard-020", "1201-networking", "A user can reach local shares but not websites. The default gateway is blank. What does this explain?", "Local subnet access works, but off-subnet routing fails", ["The monitor is unplugged", "The printer is out of toner", "The RAM is incompatible"], "A missing gateway prevents traffic from leaving the local subnet."),
        q("1201-hard-021", "1201-networking", "A web server is reachable over HTTP but not HTTPS. Which port or service should be checked?", "TCP 443", ["UDP 67", "TCP 3389", "UDP 161"], "HTTPS commonly uses TCP 443."),
        q("1201-hard-022", "1201-networking", "A technician sees intermittent packet loss only on a long copper run near fluorescent fixtures. What should be suspected?", "Cable quality, length, or EMI", ["Wrong screen resolution", "Low toner", "Expired cloud subscription"], "Long or poorly routed copper cables can suffer from interference or signal quality problems."),
        q("1201-hard-023", "1201-networking", "A user cannot connect to a corporate VPN from a hotel network, but tethering works. What is a plausible cause?", "Hotel network filtering or captive portal behavior", ["Failed desktop PSU", "Bad laptop hinge", "Printer drum wear"], "Public networks may block VPN traffic, require captive portal login, or interfere with tunneling."),
        q("1201-hard-024", "1201-networking", "A network uses private IPv4 addresses internally and one public address externally. Which function is likely involved?", "NAT", ["APIPA", "RAID 1", "TPM"], "NAT translates private internal addresses to public addresses for internet communication."),
        q("1201-hard-025", "1201-networking", "A technician wants to verify DNS records for a hostname without relying on a browser. Which tool fits?", "nslookup", ["diskpart", "sfc", "dxdiag"], "nslookup queries DNS records and helps isolate name-resolution problems."),
        q("1201-hard-026", "1201-networking", "A PC can reach websites by name but file sharing to a server name fails after a subnet move. What should be checked?", "Name resolution path and firewall/file-sharing reachability", ["Screen brightness", "Printer paper type", "CMOS battery first"], "Different services and name-resolution paths can fail separately after network moves."),
        q("1201-hard-027", "1201-networking", "A technician connects two switches with an old cable and gets no link at 1 Gbps. What should be checked?", "Cable category, pinout, and port negotiation", ["Laptop battery cycle count", "Fuser temperature", "App permissions"], "Gigabit Ethernet requires proper cabling and negotiation; bad or wrong cable wiring can prevent link."),
        q("1201-hard-028", "1201-networking", "A user says Wi-Fi drops only while walking between AP coverage areas. What feature or design issue is most relevant?", "Roaming behavior and AP placement", ["NVMe queue depth", "Printer cleaning cycle", "Local user groups"], "Mobility between APs depends on roaming support, signal overlap, and AP design."),
        q("1201-hard-029", "1201-hardware", "A motherboard has an M.2 slot, but the new SSD is not detected. What compatibility detail should be checked?", "Whether the slot supports the drive's SATA or NVMe/PCIe type", ["Whether DNS is enabled", "Whether the mouse uses Bluetooth", "Whether the printer has toner"], "M.2 slots may support SATA, PCIe/NVMe, or both; form factor alone is not enough."),
        q("1201-hard-030", "1201-hardware", "A desktop powers on, fans spin, but there is no video after a RAM upgrade. What should be checked early?", "RAM seating, compatibility, and slot population rules", ["DHCP server options", "Cloud metering", "WPA3 passphrase"], "No video after RAM changes often points to memory seating or compatibility."),
        q("1201-hard-031", "1201-hardware", "A PC shuts down during gaming but not while idle. Temperatures spike under load. What is the best first area?", "Cooling system, airflow, and thermal interface", ["DNS records", "Printer spooler", "Bluetooth pairing"], "Load-related shutdowns with high temperatures point to cooling and thermal issues."),
        q("1201-hard-032", "1201-hardware", "A user needs redundancy for one drive failure in a two-drive workstation. Which RAID level best fits?", "RAID 1", ["RAID 0", "JBOD", "Single disk"], "RAID 1 mirrors data across drives and can tolerate one drive failure in a two-drive mirror."),
        q("1201-hard-033", "1201-hardware", "A workstation needs maximum scratch-disk performance and data is backed up elsewhere. Which RAID choice fits performance over redundancy?", "RAID 0", ["RAID 1", "RAID 5 with two disks", "Optical media"], "RAID 0 stripes for performance but provides no redundancy."),
        q("1201-hard-034", "1201-hardware", "A laser printer produces repeating marks at regular intervals down the page. Which component is most suspect?", "Drum or roller with a defect", ["DNS resolver", "DHCP scope", "Laptop touchpad"], "Repeating defects often match a rotating component circumference, such as a drum or roller."),
        q("1201-hard-035", "1201-hardware", "Fresh toner rubs off pages from a laser printer. What is the most likely starting point?", "Fuser or media compatibility", ["Wi-Fi channel overlap", "NVMe namespace", "CMOS battery"], "Unfused toner points to fuser heat/pressure or wrong media."),
        q("1201-hard-036", "1201-hardware", "An inkjet printer has missing lines after sitting unused. What maintenance should be tried first?", "Run cleaning/alignment and check ink", ["Replace the fuser", "Change the DHCP scope", "Rebuild RAID 5"], "Inkjet missing lines commonly come from clogged nozzles or ink problems."),
        q("1201-hard-037", "1201-hardware", "A computer loses time and BIOS settings after being unplugged. What is most likely failing?", "CMOS/RTC battery", ["DNS server", "Printer fuser", "Access point antenna"], "A failing CMOS/RTC battery can cause time and firmware setting loss."),
        q("1201-hard-038", "1201-hardware", "A user wants to connect two 4K monitors to a laptop through one cable. What should be verified?", "USB-C/Thunderbolt display capability and dock bandwidth", ["Printer duplex support", "DHCP lease duration", "NFC tag format"], "Not all USB-C ports support display output or enough bandwidth for multiple high-resolution monitors."),
        q("1201-hard-039", "1201-hardware", "A desktop randomly restarts after a GPU upgrade. The issue happens under graphics load. What should be checked?", "Power supply capacity and GPU power connectors", ["DNS suffix", "Printer drum", "Phone app permissions"], "A new GPU may exceed PSU capacity or require additional power connectors."),
        q("1201-hard-040", "1201-hardware", "A new CPU is installed, but the system will not POST. The socket matches. What else should be checked?", "BIOS/UEFI CPU support version", ["DHCP relay", "Printer queue", "Wi-Fi password"], "A motherboard may need firmware support for a newer compatible-socket CPU."),
        q("1201-hard-041", "1201-hardware", "A user needs a scanner, copier, printer, and fax in a small office with limited space. Which device type fits?", "Multifunction printer", ["KVM switch", "Patch panel", "NAS only"], "A multifunction printer combines print, scan, copy, and sometimes fax functions."),
        q("1201-hard-042", "1201-hardware", "A technician installs a large air cooler and the system overheats immediately. What should be checked?", "Protective film, thermal paste, mounting pressure, and fan header", ["DNS records", "SSID broadcast", "Printer toner level"], "Cooler installation details directly affect CPU heat transfer and fan operation."),
        q("1201-hard-043", "1201-hardware", "A PC beeps after startup and shows no display after moving offices. What should be checked first?", "Reseat internal components and cables disturbed during the move", ["Change cloud provider", "Run gpupdate", "Replace all printers"], "Movement can loosen RAM, GPU, power cables, or other components."),
        q("1201-hard-044", "1201-hardware", "A user needs fast external storage for video editing. Which connection is most appropriate?", "Thunderbolt or high-speed USB-C storage", ["USB 2.0 flash drive", "NFC", "10 Mbps hub"], "Video editing benefits from high-throughput external interfaces."),
        q("1201-hard-045", "1201-hardware", "A NAS is needed for shared files and drive fault tolerance. Which feature should be considered?", "RAID or storage pool redundancy plus backups", ["Display brightness", "NFC pairing", "Laptop keyboard backlight"], "NAS planning should include redundancy and backup strategy."),
        q("1201-hard-046", "1201-hardware", "A system cannot see a SATA drive after installation. Power is connected. What else should be checked?", "SATA data cable and enabled motherboard port", ["DNS suffix", "WPS status", "Printer cleaning page"], "SATA drives need both power and a data path to an enabled controller port."),
        q("1201-hard-047", "1201-cloud", "A company wants email available through a browser with the provider managing the app and infrastructure. Which model is this?", "SaaS", ["IaaS", "On-prem RAID", "NFC"], "SaaS delivers a complete application managed by the provider."),
        q("1201-hard-048", "1201-cloud", "A developer needs virtual machines, virtual networks, and storage they can configure. Which cloud model fits?", "IaaS", ["SaaS", "Bluetooth", "Inkjet"], "IaaS provides configurable infrastructure resources."),
        q("1201-hard-049", "1201-cloud", "A business uses both a private data center and public cloud resources for workloads. What model is this?", "Hybrid cloud", ["Community-only cloud", "Local-only storage", "PAN"], "Hybrid cloud combines private and public cloud resources."),
        q("1201-hard-050", "1201-cloud", "A VM test environment must be rolled back after software experiments. What feature helps?", "Snapshot", ["NAT loopback only", "Thermal paste", "WPS"], "Snapshots capture VM state for rollback after testing."),
        q("1201-hard-051", "1201-cloud", "A host will run three client VMs at once. What is the most important planning concern?", "CPU, RAM, storage, and virtualization support resources", ["Printer page yield", "Monitor color temperature", "NFC range"], "Multiple VMs need enough compute, memory, storage, and virtualization support."),
        q("1201-hard-052", "1201-cloud", "A user expects a cloud file to be available offline on a laptop during travel. What should be configured?", "Offline sync or local availability for the file", ["RAID 0", "WPS", "Printer sharing only"], "Cloud files may require explicit offline sync before losing internet access."),
        q("1201-hard-053", "1201-cloud", "A company wants cloud costs to scale with actual usage. Which cloud characteristic is most relevant?", "Metered utilization", ["CMOS reset", "RJ11 cabling", "Impact printing"], "Metered service charges based on measured usage."),
        q("1201-hard-054", "1201-cloud", "A VM is slow because the host is out of memory. What is the most direct issue?", "Resource contention", ["DNS poisoning", "Printer calibration", "Cable pinout"], "VMs share host resources; insufficient memory causes contention and performance problems."),
        q("1201-hard-055", "1201-cloud", "A company wants a cloud app to increase capacity during seasonal demand and reduce it afterward. Which concept fits?", "Rapid elasticity", ["Static IP only", "Thermal throttling", "RAID mirroring"], "Elasticity allows resources to scale up and down with demand."),
        q("1201-hard-056", "1201-cloud", "A technician uses a VM to open suspicious files away from the host system. What concept is most relevant?", "Sandboxing or isolated test environment", ["PoE", "WPS", "Fuser assembly"], "A VM can provide isolation for testing when used with appropriate controls."),
        q("1201-hard-057", "1201-troubleshooting", "A desktop has no power after being moved. What should be checked first?", "Outlet, power cable, PSU switch, and power strip", ["Operating system reinstall", "Cloud sync status", "Printer driver"], "Basic power path checks are fast, low risk, and directly tied to no-power symptoms."),
        q("1201-hard-058", "1201-troubleshooting", "A laptop overheats after a fan replacement. What should be checked?", "Fan connection, airflow direction, thermal paste, and dust blockage", ["DNS suffix", "SMB version", "WPA3 mode"], "Heat after fan work points to cooling installation and airflow."),
        q("1201-hard-059", "1201-troubleshooting", "A workstation boots slowly and makes clicking sounds from a spinning drive. What should happen first?", "Back up data and test the drive", ["Defragment repeatedly", "Disable MFA", "Change Wi-Fi channels"], "Clicking from an HDD suggests possible failure. Protect data before stress testing."),
        q("1201-hard-060", "1201-troubleshooting", "A user reports intermittent network disconnects. The cable clip is broken and link drops when touched. What is the best fix?", "Replace the patch cable", ["Change DNS provider first", "Reinstall Windows", "Replace the CPU"], "A physically unreliable cable should be replaced."),
        q("1201-hard-061", "1201-troubleshooting", "A printer jams only from tray 2. Tray 1 works. What should be checked?", "Tray 2 guides, rollers, media, and pickup path", ["DNS cache", "GPU driver", "Cloud region"], "Tray-specific jams point to that tray's media path and feed components."),
        q("1201-hard-062", "1201-troubleshooting", "A PC shows artifacts only under 3D load. Temperatures are normal. What should be checked next?", "GPU driver, power, or failing graphics hardware", ["Printer fuser", "DHCP scope", "Phone NFC"], "Graphics artifacts under load point to GPU software, power, or hardware."),
        q("1201-hard-063", "1201-troubleshooting", "A user says web pages load slowly but speed tests are normal. DNS lookups pause before pages open. What is likely?", "DNS resolution delay", ["Bad toner", "Wrong RAM slot", "Laptop hinge failure"], "Delayed hostname lookup with normal throughput suggests DNS latency or resolver issues."),
        q("1201-hard-064", "1201-troubleshooting", "A laptop will not display on a projector, but the projector works with another device. What should be checked?", "Display mode, adapter compatibility, and output port", ["DHCP lease", "Printer drum", "RAID parity"], "External display issues depend on output mode, adapter, cable, input, and port capability."),
        q("1201-hard-065", "1201-troubleshooting", "A mobile device cannot send email after a password change, but webmail works. What should be updated?", "Saved mail account credentials or app authentication", ["Display refresh rate", "Printer tray size", "CPU socket"], "Mail apps may retain old credentials after password changes."),
        q("1201-hard-066", "1201-troubleshooting", "A wireless device connects near the AP but drops in a warehouse aisle with metal shelving. What should be assessed?", "Signal attenuation, interference, and AP placement", ["Laser printer fuser", "M.2 keying", "CMOS battery"], "Metal shelving and distance affect wireless coverage."),
        q("1201-hard-067", "1201-troubleshooting", "A system powers on for one second and shuts off after a CPU cooler replacement. What should be checked?", "CPU fan header, cooler mounting, and thermal protection", ["DHCP settings", "Printer toner", "NFC pairing"], "Immediate shutdown after cooler work can be thermal protection or fan/cooler installation."),
        q("1201-hard-068", "1201-troubleshooting", "A technician replaced a failed drive in a RAID 1 mirror. What should be verified?", "Array rebuild status and data accessibility", ["Screen saver timing", "Wi-Fi SSID name", "Keyboard layout"], "After replacing a mirror drive, confirm rebuild and data availability."),
        q("1201-hard-069", "1201-troubleshooting", "A user cannot scan to a network folder after the folder password changed. Printing still works. What should be checked?", "Stored scan-to-folder credentials", ["Fuser heat", "Monitor cable", "CPU cache"], "Scanning to a share uses stored credentials separate from printing."),
        q("1201-hard-070", "1201-troubleshooting", "A PC reports no bootable device after a BIOS update. The drive is visible in firmware. What setting may have changed?", "Boot mode/order such as UEFI versus legacy", ["DNS search suffix", "Printer duplex", "Bluetooth name"], "Firmware updates may alter boot order or boot mode."),
        q("1201-hard-071", "1201-troubleshooting", "An impact printer prints faint multipart forms. What should be checked?", "Ribbon condition and printhead impact settings", ["Fuser assembly", "DNS cache", "NVMe driver"], "Impact printers rely on ribbon and printhead impact for multipart forms."),
        q("1201-hard-072", "1201-troubleshooting", "A thermal receipt printer produces blank labels after a roll change. What should be checked?", "Thermal media orientation and type", ["Toner cartridge", "DHCP server", "GPU temperature"], "Thermal printers require correct heat-sensitive media orientation/type."),
        q("1201-hard-073", "1201-troubleshooting", "A newly built PC repeatedly fails POST with a high-power GPU installed, but works with integrated graphics. What should be checked?", "PCIe power connectors and PSU capacity", ["Cloud sync", "Printer queue", "DNS TTL"], "High-power GPUs need adequate PSU capacity and proper power cables."),
        q("1201-hard-074", "1201-troubleshooting", "A laptop's Wi-Fi works until the display lid is moved. What is a likely hardware area?", "Antenna cable routing or hinge-area cable damage", ["DHCP reservation only", "Fuser roller", "Cloud licensing"], "Laptop antennas and display cables often route through hinge areas and can fail intermittently."),
        q("1201-hard-075", "1201-troubleshooting", "A PC works at the technician bench but fails at the user's desk. What should be checked at the desk?", "Power, cabling, peripherals, network drop, and environmental conditions", ["The bench keyboard only", "The app store region", "The toner cartridge"], "Location-specific symptoms require checking the user's environment and connected devices."),
        q("1201-hard-076", "1201-troubleshooting", "After resolving a network printer issue, what final step best completes troubleshooting?", "Verify printing from the user's workflow and document the fix", ["Leave without testing", "Delete unrelated drivers", "Disable DHCP"], "Troubleshooting ends with verification and documentation.")
    ]

    static let aPlusCore2ChallengeFlashcards: [Flashcard] = [
        Flashcard(id: "1202-hard-fc-001", domainID: "1202-os", front: "A command is useful only if it answers the right question. What does ipconfig /all prove?", back: "It shows the current TCP/IP configuration, including DHCP status, DNS servers, gateway, adapter details, and lease information."),
        Flashcard(id: "1202-hard-fc-002", domainID: "1202-os", front: "Why is Safe Mode a strong troubleshooting step after a boot or crash problem?", back: "It limits startup drivers and services, helping isolate whether the issue is caused by normal startup components."),
        Flashcard(id: "1202-hard-fc-003", domainID: "1202-os", front: "When is sfc /scannow a better fit than chkdsk?", back: "Use sfc for protected Windows system file integrity. Use chkdsk for file system or disk structure issues."),
        Flashcard(id: "1202-hard-fc-004", domainID: "1202-os", front: "What is the risk of using System Restore without checking user data and recent changes?", back: "It may roll back system configuration and applications but does not replace a backup plan or solve every data issue."),
        Flashcard(id: "1202-hard-fc-005", domainID: "1202-security", front: "What makes a security answer the best answer, not just a true answer?", back: "It addresses the specific risk with the least unnecessary disruption and follows policy, verification, and least privilege."),
        Flashcard(id: "1202-hard-fc-006", domainID: "1202-security", front: "Why is MFA not a replacement for least privilege?", back: "MFA strengthens authentication, while least privilege limits what an authenticated user or service can access."),
        Flashcard(id: "1202-hard-fc-007", domainID: "1202-security", front: "Why should WPS usually be disabled on a SOHO router?", back: "PIN-based WPS weakens wireless security and can undermine an otherwise strong passphrase."),
        Flashcard(id: "1202-hard-fc-008", domainID: "1202-security", front: "What separates phishing from impersonation in a scenario?", back: "Phishing is the delivery tactic, while impersonation is pretending to be a trusted person, role, or organization."),
        Flashcard(id: "1202-hard-fc-009", domainID: "1202-troubleshooting", front: "What makes 'recent change' questions tricky?", back: "The recent change is a clue, but the best next step still has to be low-risk, evidence-based, and reversible when possible."),
        Flashcard(id: "1202-hard-fc-010", domainID: "1202-troubleshooting", front: "Why verify full functionality before closing a ticket?", back: "A symptom may be gone while the original workflow, network access, or user need is still broken."),
        Flashcard(id: "1202-hard-fc-011", domainID: "1202-operations", front: "What should good ticket notes include?", back: "Impact, symptoms, recent changes, actions taken, results, root cause if known, verification, and user guidance."),
        Flashcard(id: "1202-hard-fc-012", domainID: "1202-operations", front: "Why is a rollback plan part of change control?", back: "It gives the technician a documented path to restore service if the change fails or causes unexpected impact.")
    ]

    static let aPlusCore2ChallengeQuestions: [PracticeQuestion] = [
        q("1202-hard-001", "1202-os", "A Windows laptop connects to Wi-Fi but cannot reach internal file shares. It can browse public websites. Which command gives the best first evidence about DNS suffixes, DNS servers, DHCP, and gateway configuration?", "ipconfig /all", ["net user", "sfc /scannow", "diskpart"], "The symptom is network name-resolution or IP configuration related. ipconfig /all provides the most relevant adapter, DHCP, gateway, and DNS details."),
        q("1202-hard-002", "1202-os", "A user reports that Group Policy settings should have changed after moving the computer to a new OU, but the setting is not applied yet. Which command should be tried before reinstalling software?", "gpupdate /force", ["chkdsk /r", "format", "netstat -ano"], "gpupdate /force refreshes Group Policy and is a low-risk step before more disruptive actions."),
        q("1202-hard-003", "1202-os", "After a power loss, Windows starts but built-in utilities fail with missing-file errors. Which command is the best fit to repair protected operating system files?", "sfc /scannow", ["ipconfig /release", "gpresult /r", "net use"], "sfc /scannow verifies and repairs protected Windows system files. The other commands do not repair OS file integrity."),
        q("1202-hard-004", "1202-os", "A workstation receives an IP address but cannot resolve hostnames. Other users on the same VLAN are working. What should the technician check first?", "The workstation's DNS server settings", ["The monitor refresh rate", "The Windows edition license channel", "The keyboard layout"], "An IP address with hostname failures points to DNS configuration or DNS reachability before unrelated settings."),
        q("1202-hard-005", "1202-os", "A user can sign in locally, but a mapped drive script fails only when they work from home. What should the technician verify before editing the script?", "VPN connection and name resolution to internal resources", ["Printer duplex settings", "BitLocker recovery key escrow only", "Whether the user has a touchscreen"], "Mapped internal resources usually require VPN routing and internal DNS/name resolution when offsite."),
        q("1202-hard-006", "1202-os", "A Windows PC repeatedly boots to recovery after a driver update. Which approach best isolates whether normal startup drivers are involved?", "Start in Safe Mode and roll back or remove the suspect driver", ["Immediately replace the motherboard", "Disable the firewall from the router", "Delete all user profiles"], "Safe Mode is designed to start with limited drivers and services so the technician can remove or roll back the suspect driver."),
        q("1202-hard-007", "1202-os", "A user says an application works for administrators but not for standard users. What is the best interpretation?", "The app may require permissions or file/registry access not granted to standard users", ["The display cable is loose", "DHCP has failed", "The CPU does not support virtualization"], "Admin-only success points toward permissions, installation context, or application design rather than unrelated hardware or DHCP issues."),
        q("1202-hard-008", "1202-os", "A disk shows as online but has no drive letter after a migration. Which Windows tool is the best fit to assign a letter without reformatting?", "Disk Management", ["Event Viewer only", "Windows Defender Firewall", "Device Encryption settings"], "Disk Management can assign drive letters and inspect partitions. Reformatting would risk data loss."),
        q("1202-hard-009", "1202-os", "A user cannot install a required application because Windows reports the app is not compatible with this processor architecture. What should be checked?", "Whether the installer matches the system architecture", ["Whether the mouse is paired", "Whether the screen saver is enabled", "Whether the subnet mask is classful"], "Architecture mismatch means the installer may be ARM/x64/x86 incompatible with the device."),
        q("1202-hard-010", "1202-os", "A technician needs to confirm whether a remote host is reachable and see where packets stop along the path. Which tool best fits?", "tracert", ["diskpart", "gpupdate", "winver"], "tracert helps identify the route and where connectivity may fail between source and destination."),
        q("1202-hard-011", "1202-os", "A user reports that Windows search and indexing are slow after a major update, but CPU and disk usage are temporarily high. What is the best first response?", "Explain that post-update indexing may be running, monitor briefly, and verify the process settles", ["Reinstall Windows immediately", "Disable all Windows services", "Replace the display adapter"], "Some post-update background tasks are normal. The best first step is to confirm the cause and avoid unnecessary disruption."),
        q("1202-hard-012", "1202-os", "A workstation is joined to a domain, but cached sign-in works while new domain authentication fails. Which evidence is most relevant?", "Network path and DNS reachability to domain controllers", ["Local wallpaper policy", "The number of USB ports", "The audio driver version"], "Cached sign-in can work without contacting a domain controller; new domain authentication requires network and DNS access to domain services."),
        q("1202-hard-013", "1202-os", "A user enabled a startup app yesterday, and now sign-in takes several minutes. What is the best next step?", "Disable the suspected startup item and test sign-in again", ["Clear browser history", "Change the default printer", "Replace the CMOS battery first"], "Recent startup changes should be tested with a reversible action before unrelated fixes."),
        q("1202-hard-014", "1202-os", "A macOS user cannot install a trusted app because the system blocks it from opening. Which area should be checked first?", "Privacy and Security settings for app approval", ["Windows Services console", "NTFS compression", "Group Policy refresh"], "macOS app approval and Gatekeeper behavior are managed through Privacy and Security settings."),
        q("1202-hard-015", "1202-os", "A Linux workstation reports permission denied when a user runs a script in their home folder. The file exists and the path is correct. What should be checked?", "Execute permission on the script", ["DHCP lease time", "Windows activation state", "Printer spooler service"], "Linux requires execute permission to run a script directly."),
        q("1202-hard-016", "1202-os", "A browser-based business app works in a private window but fails in the normal profile. What is the best next area to check?", "Browser cache, cookies, extensions, and profile settings", ["Power supply wattage", "Laser printer fuser", "BIOS boot order"], "Private-window success suggests cached data, cookies, extensions, or profile-specific settings."),
        q("1202-hard-017", "1202-os", "A user can print from one Windows profile but not another on the same PC. What is the most likely scope?", "User-specific printer mapping or profile configuration", ["The printer has no toner", "The router has no default route", "The display is set to duplicate"], "Profile-specific behavior points to user mapping, permissions, or profile settings."),
        q("1202-hard-018", "1202-os", "A technician needs to confirm whether a Windows feature exists on a user's edition before planning an upgrade. Which check is most appropriate?", "Review the Windows edition and feature support", ["Run a cable toner", "Change Wi-Fi channels", "Replace the RAM"], "Feature availability varies by Windows edition; verify edition before choosing an upgrade or workaround."),
        q("1202-hard-019", "1202-os", "After a failed update, Windows repeatedly rolls back during restart. Which recovery action best preserves user data while targeting the update issue first?", "Use Windows recovery options to uninstall the latest quality or feature update", ["Format the drive", "Disable MFA", "Replace the keyboard"], "Removing the problematic update is targeted and lower risk than wiping the device."),
        q("1202-hard-020", "1202-os", "A technician must collect useful evidence for intermittent application crashes. Which built-in source is most relevant?", "Event Viewer or Reliability Monitor", ["Disk Cleanup only", "Display color calibration", "Mouse pointer settings"], "Event Viewer and Reliability Monitor can show crash events, faulting modules, and timelines."),
        q("1202-hard-021", "1202-os", "A user reports that only one website fails with certificate warnings, while other HTTPS sites work. What should be checked before changing system-wide network settings?", "The site's certificate details and the device date/time", ["The keyboard driver", "The printer queue", "The RAM speed profile"], "Certificate warnings can come from site certificate problems or incorrect local time. Network-wide changes are premature."),
        q("1202-hard-022", "1202-os", "A Windows tablet rotates incorrectly after a driver update. Which corrective step is most targeted?", "Roll back or update the sensor/display driver", ["Clear DNS cache", "Disable the router firewall", "Replace the SSD"], "Rotation issues after a driver change point to sensor or display driver behavior."),
        q("1202-hard-023", "1202-os", "A technician wants to verify local group membership for a user who can run tools they should not access. Which area is most relevant?", "Local Users and Groups or account permissions", ["Subnet mask length", "Screen resolution", "Printer paper type"], "Unexpected tool access often comes from local group membership or permissions."),
        q("1202-hard-024", "1202-os", "A device is stuck in a boot loop immediately after enabling a new startup service. Which approach best tests the theory?", "Boot with recovery or Safe Mode and disable the service", ["Change DNS providers", "Re-seat the monitor cable", "Delete all backups"], "The symptom is tied to startup. Safe Mode/recovery allows disabling the suspected service."),
        q("1202-hard-025", "1202-security", "A help desk caller knows an employee ID and manager name but refuses the required identity checks. What should the technician do?", "Follow verification policy and deny the reset until identity is verified", ["Reset the password because the caller knows internal details", "Ask the caller to email a personal address", "Disable logging to speed up the request"], "Internal details can be gathered by attackers. Password resets require verification and policy compliance."),
        q("1202-hard-026", "1202-security", "A SOHO router uses WPA2-Personal with a strong passphrase but still has WPS enabled. What is the best hardening step?", "Disable WPS", ["Switch to WEP for compatibility", "Publish the SSID password in the lobby", "Disable all firmware updates"], "WPS can weaken wireless security even when the passphrase itself is strong."),
        q("1202-hard-027", "1202-security", "A shared workstation is used by several employees to access customer records. Which control best improves accountability?", "Unique named accounts with least privilege", ["One shared administrator account", "A sticky note with the password", "Disabling screen locks"], "Named accounts support accountability, auditing, and least privilege."),
        q("1202-hard-028", "1202-security", "A user receives repeated MFA prompts they did not initiate. What is the best advice?", "Deny the prompts and report possible credential compromise", ["Approve one prompt to make them stop", "Disable MFA permanently", "Share the code with the help desk caller"], "Unexpected MFA prompts can indicate password compromise or prompt bombing."),
        q("1202-hard-029", "1202-security", "A browser begins redirecting searches and opening pop-ups after a free utility was installed. What should the technician suspect first?", "Potentially unwanted software or malicious browser extension", ["Bad RAM timing only", "A depleted CMOS battery", "A failed fuser"], "Search redirects and pop-ups commonly point to unwanted software, malicious extensions, or browser setting changes."),
        q("1202-hard-030", "1202-security", "A user reports ransomware-like file extensions on a shared drive. What should happen before attempting cleanup?", "Isolate affected systems and escalate through incident response", ["Run disk defrag on the share", "Rename files manually", "Tell users to keep working from the share"], "Potential ransomware requires containment and escalation to limit spread and preserve evidence."),
        q("1202-hard-031", "1202-security", "A technician is disposing of an old laptop that contained customer records. Which action best protects the data?", "Follow approved secure wipe or destruction procedures", ["Delete the desktop shortcuts", "Remove browser bookmarks only", "Change the wallpaper"], "Sensitive data requires secure sanitization or destruction, not simple deletion of visible items."),
        q("1202-hard-032", "1202-security", "A mobile device used for work is lost. It had email and saved business files. Which action should be prioritized?", "Remote lock or wipe according to policy", ["Wait for the battery to die", "Post the user's password in chat", "Disable all company backups"], "Lost managed devices should be locked or wiped under policy to protect data."),
        q("1202-hard-033", "1202-security", "A user installed an app from outside the official app store, and now the phone shows permission prompts for contacts, SMS, and location. What is the best response?", "Remove the untrusted app and review permissions/security settings", ["Enable every requested permission", "Disable screen lock", "Share the phone hotspot password"], "Untrusted sideloaded apps and excessive permissions are mobile security risks."),
        q("1202-hard-034", "1202-security", "An executive receives a message that appears to be from a vendor asking to change payment routing. What is the best next step?", "Verify the request using an approved out-of-band contact method", ["Reply to the same message with bank details", "Forward the message to all employees", "Disable email filtering"], "Payment changes are high-risk and should be verified through a known trusted channel."),
        q("1202-hard-035", "1202-security", "A PC shows antivirus alerts but also has signs of active network communication to suspicious domains. Which action is most appropriate early?", "Disconnect from the network or quarantine the host", ["Keep browsing to collect more ads", "Delete all logs first", "Upgrade the monitor"], "Quarantine limits spread and attacker communication while preserving response options."),
        q("1202-hard-036", "1202-security", "A technician must grant temporary admin access for a maintenance window. Which practice best follows least privilege?", "Grant time-limited access and remove it after the task is verified", ["Make the user a permanent local administrator", "Share the domain admin password", "Disable auditing"], "Temporary, scoped access reduces risk while allowing the work to happen."),
        q("1202-hard-037", "1202-security", "A user's laptop is encrypted and asks for a recovery key after firmware settings changed. What should the technician do?", "Retrieve the recovery key through the approved escrow or management process", ["Guess the key", "Format immediately", "Publish the key in the ticket comments"], "Encrypted devices need recovery through approved key escrow or management systems."),
        q("1202-hard-038", "1202-security", "A customer sends screenshots that include full Social Security numbers. What should the technician do?", "Handle and store the information according to privacy and data handling policy", ["Forward it to a personal email", "Paste it into a public knowledge base", "Ask for more screenshots with passwords"], "Regulated or sensitive data must be handled under policy with minimum exposure."),
        q("1202-hard-039", "1202-security", "A new employee needs access to one billing application but not payroll reports. Which principle controls the request?", "Least privilege", ["Full disk encryption", "Open authentication", "Port forwarding"], "Least privilege grants only the access needed for the role or task."),
        q("1202-hard-040", "1202-security", "A user says a support person called and requested their MFA code to fix email. What should the technician identify?", "Social engineering attempt", ["Normal password rotation", "Safe remote access practice", "Required DNS verification"], "Legitimate support should not ask users to disclose MFA codes."),
        q("1202-hard-041", "1202-security", "A browser warns that a download is uncommon and unsigned. The user needs the software for work. What should happen next?", "Verify the source and software approval before installation", ["Install it because the user asked", "Disable all browser protections", "Rename the file extension"], "Software should be trusted and approved before installation, especially when warnings appear."),
        q("1202-hard-042", "1202-security", "A technician finds a workstation unlocked in a public reception area with customer records visible. Which control directly reduces this risk?", "Short inactivity lock with user reauthentication", ["Higher screen brightness", "Open guest Wi-Fi", "Longer DHCP leases"], "Screen lock timeouts reduce exposure when workstations are unattended."),
        q("1202-hard-043", "1202-security", "A malware cleanup appears successful, but the user continues using the same weak password that was captured. What step is missing?", "Credential reset and user education", ["Monitor color calibration", "Printer maintenance", "Disk partition resizing"], "Remediation should include password changes and education when credentials may be compromised."),
        q("1202-hard-044", "1202-security", "A technician must connect remotely to a user's PC. Which practice is best?", "Get user consent and use approved remote access tooling", ["Connect without notice because IT owns the device", "Ask the user to disable all security tools", "Use a personal remote desktop account"], "Remote access should follow consent, authorization, logging, and approved tooling practices."),
        q("1202-hard-045", "1202-security", "A small office wants guests to use Wi-Fi without seeing internal printers or file shares. What should be configured?", "Separate guest network or VLAN isolation", ["Shared administrator password", "WPS enrollment", "A single flat network"], "Guest isolation protects internal resources from untrusted devices."),
        q("1202-hard-046", "1202-security", "A technician receives a suspicious USB drive in the parking lot. What is the safest action?", "Do not plug it in; follow security reporting or disposal policy", ["Open it on a production workstation", "Copy files to the file server", "Disable endpoint protection first"], "Unknown removable media can carry malware and should be handled under policy."),
        q("1202-hard-047", "1202-security", "A user's account locks repeatedly overnight, but they are not working. What is a plausible first investigation?", "Stored credentials or a scheduled task using an old password", ["Printer out of paper", "Screen resolution mismatch", "Bad thermal paste"], "Repeated lockouts often come from stale saved credentials, services, mapped drives, or scheduled tasks."),
        q("1202-hard-048", "1202-security", "A workstation needs to run one approved kiosk app for visitors. Which configuration best reduces misuse?", "Kiosk mode or assigned access with restricted account permissions", ["Local admin rights for visitors", "Shared email credentials", "Unrestricted browser access"], "Kiosk/assigned access limits the user to the intended app and reduces exposure."),
        q("1202-hard-049", "1202-troubleshooting", "A user says the PC became slow after installing a toolbar. CPU is normal, but browser pages redirect. What is the best first theory?", "Browser hijacker or unwanted extension", ["Failed power supply", "Expired toner", "Wrong keyboard language"], "The symptom centers on browser behavior after an add-on install, making unwanted extension or hijacker likely."),
        q("1202-hard-050", "1202-troubleshooting", "A Windows update fails repeatedly with low free disk space warnings. What should be tried first?", "Free disk space and retry the update", ["Replace the router", "Disable user accounts", "Change the printer tray"], "The error points directly to storage capacity, so free space before deeper repair."),
        q("1202-hard-051", "1202-troubleshooting", "A user cannot open one application. Other apps and the network work normally. What is the best scoping conclusion?", "The issue is likely application-specific rather than system-wide", ["The entire LAN is down", "The monitor failed", "The DHCP server is offline"], "Scoping separates one-app issues from broader OS or network failures."),
        q("1202-hard-052", "1202-troubleshooting", "A mobile app drains battery only after location permission was allowed. What should be checked first?", "App permission and background activity settings", ["Desktop BIOS password", "Laser printer maintenance kit", "Windows file sharing"], "Battery drain tied to permission changes points to mobile app permissions/background use."),
        q("1202-hard-053", "1202-troubleshooting", "A user says email sync stopped after a password change. Webmail works. What is the best next step?", "Update saved credentials or reauthenticate the mail app", ["Replace the display", "Clear the print queue", "Change the router SSID"], "App sync failures after a password change commonly require credential refresh or reauthentication."),
        q("1202-hard-054", "1202-troubleshooting", "A PC crashes only when a specific USB device is connected. What should the technician test?", "Device driver, cable/port, and the device on another system", ["The office wallpaper", "The user's calendar permissions", "The toner cartridge"], "The trigger is a connected device, so test driver, port/cable, and the device itself."),
        q("1202-hard-055", "1202-troubleshooting", "A user reports no sound after joining a video call. System sound works elsewhere. What is the best first area?", "Application audio input/output settings", ["Disk partition table", "Group Policy replication", "DHCP reservations"], "If sound works elsewhere, app-specific input/output selection is a strong first check."),
        q("1202-hard-056", "1202-troubleshooting", "A computer is slow only during the first ten minutes after sign-in. What evidence helps most?", "Startup apps and Task Manager resource usage during sign-in", ["Printer page count", "Mouse DPI", "Monitor refresh rate"], "Startup impact and resource usage reveal what is consuming CPU, memory, disk, or network at sign-in."),
        q("1202-hard-057", "1202-troubleshooting", "A user's profile loads a temporary desktop after sign-in. What should be protected before repair attempts?", "User data from the affected profile", ["The monitor stand", "The guest Wi-Fi password only", "The DHCP lease duration"], "Profile repair can risk user data. Preserve data before changing or recreating profiles."),
        q("1202-hard-058", "1202-troubleshooting", "A printer appears offline for one user, but others can print. What is the best scope?", "User workstation, mapping, or profile-specific print configuration", ["Printer hardware failure", "Building-wide power loss", "Internet outage"], "If others can print, the issue is likely local to the user, profile, queue, or mapping."),
        q("1202-hard-059", "1202-troubleshooting", "A business app fails after a certificate renewal on the server. Clients show trust warnings. What should be checked?", "Certificate chain, hostname, and trust store", ["Keyboard layout", "Local disk compression", "Screen orientation"], "Certificate trust problems depend on chain, hostname, date/time, and trusted roots/intermediates."),
        q("1202-hard-060", "1202-troubleshooting", "A phone overheats and battery drops rapidly after a new app install. Which step is most targeted?", "Review app battery usage and uninstall or restrict the suspect app", ["Replace the office switch", "Run chkdsk on a desktop", "Clear printer calibration"], "The timing and mobile symptoms point to app activity and battery usage."),
        q("1202-hard-061", "1202-troubleshooting", "A user receives 'access denied' opening one shared folder but can access another share on the same server. What should be checked?", "Share and NTFS permissions for that folder", ["The user's monitor cable", "DHCP relay settings only", "The keyboard battery"], "Access to one share but not another points to folder/share permissions."),
        q("1202-hard-062", "1202-troubleshooting", "An app crashes after an update, but the previous version worked. The vendor has a known issue notice. What is the best next step?", "Apply the vendor workaround or roll back according to policy", ["Disable all endpoint protection permanently", "Replace all RAM immediately", "Ignore the notice"], "Known vendor issues should be handled with approved workaround, patch, or rollback procedures."),
        q("1202-hard-063", "1202-troubleshooting", "A user's browser works on cellular hotspot but not office Wi-Fi. Other users on office Wi-Fi work. What should be checked?", "Device-specific proxy, DNS, or Wi-Fi profile settings", ["The ISP for the entire office", "The building power supply", "The printer toner"], "Because office Wi-Fi works for others, focus on the affected device's network/profile settings."),
        q("1202-hard-064", "1202-troubleshooting", "A technician suspects malware but the installed antivirus will not launch. What is the best next approach?", "Boot to a trusted recovery or safe environment and scan with updated tools", ["Assume the system is clean", "Disable all logs", "Tell the user to keep using it"], "Malware may disable security tools. Use trusted recovery or safe-mode approaches and updated scanners."),
        q("1202-hard-065", "1202-troubleshooting", "A user cannot authenticate to a SaaS app after getting a new phone. Password is correct. What is most likely?", "MFA device registration or recovery process is needed", ["Fuser failure", "DisplayPort version mismatch", "APIPA address"], "A new phone often affects authenticator app, push approvals, or MFA registration."),
        q("1202-hard-066", "1202-troubleshooting", "A workstation is slow and disk usage is 100%. Which step gathers useful evidence before replacing hardware?", "Check Task Manager/Resource Monitor for the process causing disk activity", ["Change the mouse", "Disable the monitor", "Erase event logs"], "Identify the process and workload before assuming a hardware failure."),
        q("1202-hard-067", "1202-troubleshooting", "A user reports pop-ups only in one browser. Another browser is clean. What is the best first repair?", "Disable suspicious extensions and reset that browser's settings", ["Replace the power supply", "Reset the office firewall", "Remove all printers"], "Browser-specific pop-ups point to extensions, notifications, or browser configuration."),
        q("1202-hard-068", "1202-troubleshooting", "A laptop cannot connect to corporate Wi-Fi after a password change, but other networks work. What should the technician try?", "Forget and recreate the corporate Wi-Fi profile with updated credentials", ["Replace the SSD", "Run disk cleanup only", "Change the screen brightness"], "Saved Wi-Fi profiles can retain old credentials or policy settings."),
        q("1202-hard-069", "1202-operations", "A technician is asked to install unapproved remote access software for convenience. What should they do?", "Use only approved remote access tools and follow policy", ["Install it because it is faster", "Share personal credentials", "Disable endpoint controls"], "Operational procedures require approved tools, consent, and security controls."),
        q("1202-hard-070", "1202-operations", "A change will affect payroll workstations during business hours. What should happen before implementation?", "Obtain approval, communicate impact, and confirm rollback plan", ["Make the change silently", "Skip documentation", "Remove backups"], "Change control reduces business risk through approval, scheduling, communication, and rollback."),
        q("1202-hard-071", "1202-operations", "A technician resolved a VPN issue by reinstalling a client and verifying access. Which ticket note is best?", "Reinstalled VPN client, confirmed successful MFA sign-in and file share access, user verified workflow", ["Fixed", "User was annoyed", "Network did something weird"], "Useful ticket notes document actions, verification, and user impact clearly."),
        q("1202-hard-072", "1202-operations", "A user is frustrated and keeps interrupting troubleshooting. What communication approach is best?", "Acknowledge the impact, set expectations, and explain the next step briefly", ["Use jargon to end the call", "Blame the user", "Ignore consent for remote control"], "Professional communication includes empathy, clear expectations, and respectful next steps."),
        q("1202-hard-073", "1202-operations", "A technician finds possible evidence of policy misuse on a company laptop. What should they avoid?", "Changing or deleting evidence without following escalation procedures", ["Documenting the observation", "Escalating according to policy", "Preserving chain of custody when required"], "Potential evidence must be handled carefully and escalated through policy."),
        q("1202-hard-074", "1202-operations", "A workstation repair requires opening the case. Which safety action is most appropriate?", "Power down, unplug, and use ESD protection", ["Leave power connected for speed", "Work on carpet without grounding", "Spray cleaner into the power supply"], "Hardware work requires electrical safety and ESD protection."),
        q("1202-hard-075", "1202-operations", "A backup job reports success, but no one has tested restoration. What is the real risk?", "The organization may not be able to recover usable data when needed", ["The monitor may dim", "The printer may run out of paper", "The keyboard layout may change"], "Backup success is not enough; recovery must be tested."),
        q("1202-hard-076", "1202-operations", "A support call involves a user's medical document open on screen. What should the technician do?", "Limit exposure and handle the data according to privacy policy", ["Read the document out loud", "Save a copy locally for notes", "Paste details into chat"], "Privacy-aware support minimizes unnecessary exposure and follows data handling policy."),
        q("1202-hard-077", "1202-operations", "A technician cannot finish a repair because admin rights are required. What is the best action?", "Escalate to the correct support tier or request approved temporary access", ["Ask the user for their password", "Bypass policy", "Abandon the ticket without notes"], "Escalation protects security and keeps the workflow documented."),
        q("1202-hard-078", "1202-operations", "A user asks when service will be restored, but the root cause is still unknown. What should the technician say?", "Provide a realistic next update time and explain what is being checked", ["Promise an exact fix time without evidence", "Say nothing until it is fixed", "Blame another team"], "Good communication sets expectations without making unsupported promises."),
        q("1202-hard-079", "1202-operations", "A repair requires deleting and recreating a user's mail profile. What should happen first?", "Confirm data sync/backup state and explain expected impact", ["Delete it immediately", "Disable MFA", "Clear unrelated browser data"], "Profile recreation can affect local data/cache. Confirm protection and communicate impact first."),
        q("1202-hard-080", "1202-operations", "A technician uses a known workaround repeatedly but never updates the knowledge base. What is the downside?", "The team loses repeatable documentation and future technicians waste time", ["The mouse becomes slower", "Wi-Fi encryption changes", "The display cable fails"], "Operational maturity depends on reusable documentation and knowledge sharing."),
        q("1202-hard-081", "1202-operations", "A user wants the technician to install personally licensed software on a company computer. What should be checked?", "Software licensing and company acceptable use policy", ["Monitor refresh rate", "Printer page count", "Bluetooth discoverability"], "Licensing and acceptable use determine whether software can be installed."),
        q("1202-hard-082", "1202-operations", "A remote session is complete. Which final step is most professional?", "Verify the user can perform the original task and close the session clearly", ["Leave the session open", "Browse unrelated files", "Change settings without explaining"], "Verification and clear handoff complete the support interaction safely."),
        q("1202-hard-083", "1202-operations", "A technician sees liquid near a powered workstation. What is the safest first action?", "Power down safely if possible and follow electrical safety procedures", ["Keep typing to save time", "Use a wet cloth on the power supply", "Ignore it if the screen is on"], "Liquid and powered electronics create safety risks; follow electrical safety procedures."),
        q("1202-hard-084", "1202-operations", "A user asks for admin credentials so they can 'fix it next time.' What should the technician do?", "Decline and explain that access must follow least privilege and approved support process", ["Share the password verbally", "Write the password on a note", "Disable auditing for the user"], "Credential sharing violates security practice. Access should be role-based and approved.")
    ]

    static let securityPlusChallengeFlashcards: [Flashcard] = [
        Flashcard(id: "701-hard-fc-001", domainID: "701-concepts", front: "What makes a security control answer best?", back: "It matches the objective, risk, control type, and implementation layer without creating unnecessary exposure."),
        Flashcard(id: "701-hard-fc-002", domainID: "701-concepts", front: "Why is hashing not encryption?", back: "Hashing is one-way integrity verification. Encryption is reversible confidentiality protection with a key."),
        Flashcard(id: "701-hard-fc-003", domainID: "701-threats", front: "What does a good threat question usually hide?", back: "Whether the scenario is testing attack type, threat actor motive, vulnerability, indicator, or mitigation."),
        Flashcard(id: "701-hard-fc-004", domainID: "701-threats", front: "Why are BEC scenarios tricky?", back: "They often combine phishing, impersonation, urgency, payment process abuse, and weak verification."),
        Flashcard(id: "701-hard-fc-005", domainID: "701-architecture", front: "What is segmentation trying to reduce?", back: "Unauthorized reachability and lateral movement after compromise."),
        Flashcard(id: "701-hard-fc-006", domainID: "701-architecture", front: "What does shared responsibility mean in cloud?", back: "The provider and customer protect different layers depending on SaaS, PaaS, IaaS, and configuration choices."),
        Flashcard(id: "701-hard-fc-007", domainID: "701-operations", front: "Why is containment not the same as eradication?", back: "Containment limits spread or impact. Eradication removes the root cause or threat from affected systems."),
        Flashcard(id: "701-hard-fc-008", domainID: "701-operations", front: "What makes SIEM useful?", back: "It centralizes and correlates events from multiple sources so analysts can detect patterns and investigate faster."),
        Flashcard(id: "701-hard-fc-009", domainID: "701-program", front: "What is residual risk?", back: "The risk that remains after controls or treatments are applied."),
        Flashcard(id: "701-hard-fc-010", domainID: "701-program", front: "What is the difference between RTO and RPO?", back: "RTO is maximum acceptable recovery time. RPO is maximum acceptable data loss measured in time."),
        Flashcard(id: "701-hard-fc-011", domainID: "701-program", front: "Why are policies different from procedures?", back: "Policies state intent or rules. Procedures give step-by-step instructions for carrying out work."),
        Flashcard(id: "701-hard-fc-012", domainID: "701-operations", front: "What is the value of lessons learned?", back: "It turns incident findings into control improvements, process changes, training, and measurable follow-up.")
    ]

    static let securityPlusChallengeQuestions: [PracticeQuestion] = [
        q("701-hard-001", "701-concepts", "A developer stores salted password hashes instead of encrypted passwords. Which objective is most directly supported?", "Password verification without storing reversible secrets", ["High availability clustering", "Network segmentation", "Physical deterrence"], "Salted hashes let systems verify passwords without keeping plaintext or reversible encrypted passwords."),
        q("701-hard-002", "701-concepts", "A file transfer must prove the sender cannot reasonably deny sending it. Which concept is most relevant?", "Non-repudiation", ["Obfuscation", "Availability", "Tailgating"], "Non-repudiation is supported by mechanisms such as digital signatures and logging."),
        q("701-hard-003", "701-concepts", "A company wants users to sign in with a corporate identity provider to several SaaS apps. Which concept fits best?", "Federation or SSO", ["Data masking", "RAID parity", "Air gapping"], "Federation and SSO allow trusted identity across applications."),
        q("701-hard-004", "701-concepts", "A security team adds badge access, camera monitoring, and locked server racks. Which control area is most represented?", "Physical controls", ["Cryptographic controls only", "Secure coding controls", "Tokenization"], "Badges, cameras, and locked racks protect physical access."),
        q("701-hard-005", "701-concepts", "A database stores only the last four digits of card numbers for support screens. What control is this?", "Data masking", ["Load balancing", "Key stretching", "Geofencing"], "Masking hides part of sensitive data while allowing limited business use."),
        q("701-hard-006", "701-concepts", "An organization requires privileged users to request elevation only when needed and records the session. What concept is this?", "Privileged access management", ["Open authentication", "Data deduplication", "DNS filtering"], "PAM limits and monitors privileged access."),
        q("701-hard-007", "701-concepts", "A control does not stop an attack but alerts analysts when it happens. What control function is this?", "Detective", ["Preventive", "Directive only", "Recovery only"], "Detective controls identify or alert on events."),
        q("701-hard-008", "701-concepts", "A system uses encryption for data at rest and TLS for data in transit. Which objective is most directly supported?", "Confidentiality", ["Availability only", "Non-repudiation only", "Safety"], "Encryption helps prevent unauthorized reading of data."),
        q("701-hard-009", "701-concepts", "A security architect wants every access request evaluated based on identity, device posture, location, and risk. What model fits?", "Zero trust", ["Flat trust network", "Single shared account", "Implicit perimeter trust"], "Zero trust evaluates each access request rather than assuming internal trust."),
        q("701-hard-010", "701-concepts", "A message digest changes when one byte of a file changes. What property is being used?", "Integrity verification", ["Metered billing", "Identity federation", "Physical access control"], "Hashes are commonly used to detect changes to data."),
        q("701-hard-011", "701-concepts", "A user authenticates with a password and a hardware token. What is this?", "Multifactor authentication", ["Single-factor authentication", "Data tokenization", "VLAN tagging"], "MFA uses factors from different categories, such as something known and something possessed."),
        q("701-hard-012", "701-concepts", "A company uses certificates to bind public keys to identities. Which infrastructure supports this?", "PKI", ["NAT", "RAID", "DHCP"], "Public key infrastructure manages certificates and trust relationships."),
        q("701-hard-013", "701-threats", "An email thread appears legitimate, but an attacker inserts new wire instructions after compromising a vendor mailbox. What attack is most likely?", "Business email compromise", ["DNS sinkhole", "Bluejacking", "Shoulder surfing"], "BEC abuses trusted business communication and payment processes."),
        q("701-hard-014", "701-threats", "A web application includes unsanitized user input directly in database queries. Which attack is most relevant?", "SQL injection", ["Vishing", "Evil twin", "RFID cloning"], "SQL injection manipulates database queries through untrusted input."),
        q("701-hard-015", "701-threats", "An attacker hosts a fake Wi-Fi network named like the company's guest SSID to capture logins. What is this?", "Evil twin", ["Logic bomb", "Rootkit", "Watering hole"], "An evil twin impersonates a trusted wireless network."),
        q("701-hard-016", "701-threats", "A user receives a text with a fake shipping link that asks for credentials. What attack type fits?", "Smishing", ["Vishing", "Pharming", "Tailgating"], "Smishing is phishing through SMS or text messages."),
        q("701-hard-017", "701-threats", "Malware encrypts shared files and leaves payment instructions. What is the threat?", "Ransomware", ["Spyware only", "Adware only", "Replay attack"], "Ransomware encrypts or denies access to data for payment."),
        q("701-hard-018", "701-threats", "An attacker places malicious code in memory using legitimate administration tools and leaves few files on disk. What does this suggest?", "Fileless malware", ["Impact printer abuse", "RAID failure", "Data masking"], "Fileless malware abuses legitimate tools or memory-resident behavior."),
        q("701-hard-019", "701-threats", "A user is pressured by phone to reveal a one-time passcode. What tactic is most central?", "Social engineering", ["Patch management", "Network segmentation", "Data classification"], "The attacker manipulates human trust and urgency rather than exploiting a technical vulnerability directly."),
        q("701-hard-020", "701-threats", "A site frequently visited by a target industry is compromised to infect visitors. What is this?", "Watering hole attack", ["Bluejacking", "DNSSEC", "Key stretching"], "Watering hole attacks compromise sites likely to be used by a target group."),
        q("701-hard-021", "701-threats", "A web page stores user input and later executes it in another user's browser. What attack is most likely?", "Stored XSS", ["CSRF", "Vishing", "On-path routing"], "Stored cross-site scripting persists malicious script that later runs for other users."),
        q("701-hard-022", "701-threats", "A malicious link causes a logged-in user browser to submit an unwanted account change. Which attack fits best?", "CSRF", ["SQL injection", "Smishing", "Logic bomb"], "CSRF abuses a user's authenticated browser session to submit actions."),
        q("701-hard-023", "701-threats", "A scanner finds an internet-facing service with a known critical CVE and public exploit code. What is the best mitigation priority?", "Patch, disable exposure, or apply compensating controls quickly", ["Delay until annual review", "Ignore because it is only a scanner result", "Publish the service banner"], "Known critical exposure with exploitability should be prioritized for remediation or compensating controls."),
        q("701-hard-024", "701-threats", "A user receives a QR code flyer that leads to a fake login page. What term fits this phishing variation?", "Quishing", ["Vishing", "Bluejacking", "Salting"], "QR-code phishing uses QR codes to send users to malicious destinations."),
        q("701-hard-025", "701-threats", "A server uses default credentials exposed to the internet. What weakness is most relevant?", "Misconfiguration", ["Secure baseline", "Strong authentication", "Data minimization"], "Default credentials on exposed services are a dangerous configuration failure."),
        q("701-hard-026", "701-threats", "An attacker sends many requests until a web process crashes due to poor memory bounds checking. What vulnerability type is suggested?", "Buffer overflow", ["Tailgating", "Data masking", "Risk transfer"], "Buffer overflows occur when software mishandles memory boundaries."),
        q("701-hard-027", "701-threats", "A login page reveals whether usernames exist through different error messages. What issue is this?", "Information disclosure or user enumeration", ["High availability", "Tokenization", "Data sovereignty"], "Different responses can disclose valid accounts and help attackers."),
        q("701-hard-028", "701-threats", "A software library used by an application is found to be vulnerable. What program activity addresses this?", "Dependency and vulnerability management", ["Clean desk policy only", "Printer hardening", "Cable management"], "Third-party dependency risk is managed through inventory, scanning, patching, and replacement."),
        q("701-hard-029", "701-architecture", "A company wants public web servers reachable from the internet but isolated from internal databases. What design is most appropriate?", "DMZ with segmented access", ["Single flat network", "Shared admin workstation", "Unrestricted east-west traffic"], "A DMZ and segmentation expose public services while limiting access to internal systems."),
        q("701-hard-030", "701-architecture", "A breached workstation should not be able to directly reach every server subnet. What architecture control helps most?", "Network segmentation or microsegmentation", ["Longer usernames", "More local printers", "Single shared VLAN"], "Segmentation restricts lateral movement after compromise."),
        q("701-hard-031", "701-architecture", "A cloud storage bucket contains sensitive data and is accidentally public. Which responsibility is usually on the customer?", "Secure configuration and access policy", ["Physical data center guards", "Hypervisor hardware repair", "Cloud provider staff hiring"], "In cloud shared responsibility, customers commonly own data configuration and access controls."),
        q("701-hard-032", "701-architecture", "An application needs secrets without embedding passwords in code. What should be used?", "Secrets manager or secure vault", ["Plaintext environment notes", "Hard-coded credentials", "Shared spreadsheet"], "Secrets should be stored and rotated through controlled secret management."),
        q("701-hard-033", "701-architecture", "A company wants to inspect and control SaaS usage across users. Which tool category fits?", "CASB", ["UPS", "KVM", "Thermal printer"], "A cloud access security broker helps enforce policy for cloud service use."),
        q("701-hard-034", "701-architecture", "A data set should be useful for analytics without exposing actual account numbers. Which control is best?", "Tokenization", ["Open shares", "Static routing", "WPS"], "Tokenization replaces sensitive data with tokens mapped in a protected system."),
        q("701-hard-035", "701-architecture", "A web app needs protection from common HTTP attacks such as injection attempts. Which control is most relevant?", "WAF", ["NAC only", "UPS only", "Badge reader"], "A web application firewall can help inspect and block malicious web requests."),
        q("701-hard-036", "701-architecture", "A company requires device health checks before allowing network access. Which control fits?", "NAC", ["RAID", "NTP", "OLED"], "Network access control can evaluate device posture before granting access."),
        q("701-hard-037", "701-architecture", "A remote worker should access only approved private applications without full network VPN access. Which architecture concept aligns?", "ZTNA", ["Flat VPN for all subnets", "Shared local admin", "Open guest network"], "Zero trust network access grants application-specific access based on identity and posture."),
        q("701-hard-038", "701-architecture", "A system must continue operating if one server fails. Which design principle is central?", "High availability and redundancy", ["Obfuscation only", "Manual password sharing", "Single point of failure"], "Availability is improved by redundant components and failover design."),
        q("701-hard-039", "701-architecture", "A backup plan allows losing at most 15 minutes of data. Which metric states this?", "RPO", ["RTO", "MTTR", "MTBF"], "Recovery point objective defines acceptable data loss measured in time."),
        q("701-hard-040", "701-architecture", "A service must be restored within four hours after an outage. Which metric states this?", "RTO", ["RPO", "ALE", "SLE"], "Recovery time objective defines acceptable restoration time."),
        q("701-hard-041", "701-architecture", "A company wants encrypted DNS lookups to improve privacy from local observers. Which option may help?", "DNS over HTTPS or DNS over TLS", ["Telnet", "FTP", "WEP"], "DoH and DoT encrypt DNS transport."),
        q("701-hard-042", "701-architecture", "A container image should be checked before deployment. Which control is most relevant?", "Image scanning and trusted registries", ["Printer calibration", "Badge color", "RAID stripe size"], "Container security includes scanning images and using trusted sources."),
        q("701-hard-043", "701-architecture", "A company wants to prevent confidential files from being emailed externally. What control category fits?", "DLP", ["NTP", "DHCP", "VLAN trunking only"], "Data loss prevention can detect and block sensitive data movement."),
        q("701-hard-044", "701-architecture", "A branch office uses cloud security inspection and software-defined networking for remote access. Which concept is most relevant?", "SASE", ["POTS", "Impact printing", "Local-only trust"], "Secure Access Service Edge combines network and security functions through cloud-delivered architecture."),
        q("701-hard-045", "701-operations", "A SIEM alert shows impossible travel for a user and successful MFA shortly after. What should analysts do first?", "Investigate account compromise indicators and validate user activity", ["Delete the user immediately without review", "Ignore because MFA succeeded", "Disable all logging"], "Impossible travel plus successful login may indicate compromise or token/MFA abuse and needs validation."),
        q("701-hard-046", "701-operations", "A ransomware alert fires on one endpoint. What is the best immediate operational priority?", "Contain the endpoint and preserve evidence", ["Patch all printers first", "Publish the ransom note", "Disable the SIEM"], "Containment limits spread while evidence preservation supports investigation."),
        q("701-hard-047", "701-operations", "A vulnerability scan finds many issues. What should drive remediation order?", "Risk, exploitability, asset criticality, and exposure", ["Alphabetical plugin name", "Scanner color theme", "Oldest ticket only"], "Vulnerability management prioritizes based on risk and business context."),
        q("701-hard-048", "701-operations", "An EDR tool blocks a suspicious PowerShell command. What should analysts collect?", "Process tree, command line, user, host, and related indicators", ["Monitor brightness", "Printer tray", "Badge photo size"], "Endpoint evidence helps determine scope and intent."),
        q("701-hard-049", "701-operations", "A phishing report includes headers, URLs, and an attachment hash. What should happen?", "Analyze indicators, search for other recipients, and contain malicious artifacts", ["Delete the report only", "Forward the email to everyone", "Disable email filtering"], "Phishing response includes analysis, scoping, containment, and user protection."),
        q("701-hard-050", "701-operations", "A firewall log shows repeated denied connections from one external IP. What is the best interpretation?", "Potential scanning or probing that should be correlated with other events", ["Guaranteed compromise", "Successful data loss", "Printer failure"], "Denied probes may be scanning, but correlation is needed before declaring compromise."),
        q("701-hard-051", "701-operations", "A security team builds a repeatable workflow for phishing triage in SOAR. What is this called?", "Playbook or runbook automation", ["Data masking only", "Physical access control", "Hash collision"], "SOAR often uses playbooks to automate repeatable response tasks."),
        q("701-hard-052", "701-operations", "A log source stops sending events to the SIEM. What is the risk?", "Reduced detection and investigation visibility", ["Higher screen resolution", "Better segmentation", "Guaranteed patching"], "Missing logs create blind spots for detection and response."),
        q("701-hard-053", "701-operations", "After containment, responders remove persistence mechanisms and malicious files. Which phase is this?", "Eradication", ["Preparation", "Lessons learned", "Risk transfer"], "Eradication removes the threat from affected systems."),
        q("701-hard-054", "701-operations", "A system is restored from backup after malware removal. What must be verified?", "Backup integrity and absence of reinfection indicators", ["Wallpaper", "Mouse speed", "Printer toner"], "Recovery must ensure systems are functional and not restored to an infected state."),
        q("701-hard-055", "701-operations", "A team wants to baseline normal authentication behavior to detect anomalies. What is most relevant?", "User and entity behavior analytics", ["WPS", "RAID 0", "Thermal printing"], "Behavior analytics compares activity to baselines to detect anomalies."),
        q("701-hard-056", "701-operations", "A packet capture is needed to inspect suspected cleartext credentials. Which tool type fits?", "Protocol analyzer", ["Badge printer", "Disk shredder", "Load balancer only"], "Protocol analyzers capture and inspect network traffic."),
        q("701-hard-057", "701-operations", "A patch caused outages in a pilot group. What should the team do before broad deployment?", "Pause rollout, investigate, and use change/rollback procedures", ["Deploy everywhere immediately", "Disable all backups", "Ignore pilot feedback"], "Pilot failures should stop broad rollout until risk is understood."),
        q("701-hard-058", "701-operations", "A scanner reports a critical vulnerability on an asset that no longer exists. What should be improved?", "Asset inventory and scan validation", ["Printer cleaning", "Screen lock image", "Keyboard layout"], "Accurate vulnerability management depends on accurate asset inventory and validation."),
        q("701-hard-059", "701-operations", "A response team needs to prove who handled a forensic image and when. What is required?", "Chain of custody", ["Round-robin DNS", "RAID mirroring", "Guest Wi-Fi"], "Chain of custody documents evidence handling."),
        q("701-hard-060", "701-operations", "A web server has repeated login attempts from many IPs using common usernames. What is likely?", "Password spraying or brute-force activity", ["Data tokenization", "Secure wipe", "Business impact analysis"], "Distributed login attempts against common usernames are consistent with password attacks."),
        q("701-hard-061", "701-operations", "An incident was resolved, but the same gap remains in procedures. What meeting should identify improvements?", "Lessons learned", ["Daily standup only", "Procurement review only", "Printer maintenance"], "Lessons learned captures improvements after incident response."),
        q("701-hard-062", "701-operations", "A security analyst suppresses a noisy alert permanently without review. What is the risk?", "True positives may be hidden and detection coverage reduced", ["Encryption becomes stronger", "Backups run faster", "MFA improves automatically"], "Alert tuning should be reviewed so coverage is not lost."),
        q("701-hard-063", "701-program", "A policy says sensitive data must be encrypted, while a procedure explains how to enable encryption. Which statement is true?", "Policy states the rule; procedure gives steps", ["Procedure outranks law", "Policy is always optional", "Guidelines are mandatory laws"], "Policies define requirements; procedures provide step-by-step implementation."),
        q("701-hard-064", "701-program", "A risk is accepted because mitigation costs exceed expected impact. What must still happen?", "Document approval and residual risk", ["Hide the decision", "Disable audits", "Delete the risk register"], "Risk acceptance should be documented and approved."),
        q("701-hard-065", "701-program", "A vendor will process customer data. What should be reviewed?", "Contract terms, data handling, security requirements, and right-to-audit", ["Monitor size", "Printer model", "Cable color"], "Third-party risk includes legal, security, privacy, and audit requirements."),
        q("701-hard-066", "701-program", "A business impact analysis identifies that billing can tolerate only two hours of downtime. What planning does this support?", "Business continuity and disaster recovery requirements", ["Social media branding", "Desk layout", "Printer consumables"], "BIA findings drive continuity and recovery targets."),
        q("701-hard-067", "701-program", "An organization buys cyber insurance for ransomware recovery costs. What risk response is this?", "Transfer", ["Avoid", "Exploit", "Ignore"], "Insurance transfers some financial impact to a third party."),
        q("701-hard-068", "701-program", "A company removes a risky unsupported application entirely. What risk response is this?", "Avoidance", ["Acceptance", "Transfer", "Deterrence only"], "Eliminating the activity or asset can avoid the risk."),
        q("701-hard-069", "701-program", "A new control reduces likelihood but does not eliminate risk. What remains?", "Residual risk", ["Zero risk", "No risk register", "Guaranteed compliance"], "Residual risk remains after treatment."),
        q("701-hard-070", "701-program", "An auditor asks for proof that privileged access reviews occurred. What should be provided?", "Review records and evidence of approval/remediation", ["Screensaver images", "Printer logs only", "Weather reports"], "Audits require evidence that controls operated as intended."),
        q("701-hard-071", "701-program", "A company must retain logs for one year due to regulation. Which document should define this?", "Retention policy or standard", ["Lunch menu", "Cable map only", "Personal notes"], "Retention requirements should be documented in policy or standards."),
        q("701-hard-072", "701-program", "A tabletop exercise reveals nobody knows who contacts legal during an incident. What should be updated?", "Incident response plan roles and communication procedures", ["Printer driver", "Monitor resolution", "Keyboard firmware"], "Exercises identify gaps in roles, communication, and decision-making."),
        q("701-hard-073", "701-program", "A team classifies data as public, internal, confidential, and restricted. What does this enable?", "Appropriate handling and control selection", ["Faster keyboard input", "Automatic cloud billing", "Printer duplexing"], "Classification guides protection requirements."),
        q("701-hard-074", "701-program", "A supplier provides critical authentication services. What risk should be considered?", "Third-party dependency and service availability", ["Only local printer speed", "Only desk placement", "Only screen size"], "Critical vendors can create operational and security dependency risk."),
        q("701-hard-075", "701-program", "A security awareness campaign targets employees approving MFA prompts they did not initiate. What risk is being reduced?", "MFA fatigue or prompt bombing success", ["Disk fragmentation", "Printer jams", "Cable attenuation"], "Training can reduce social engineering success against MFA prompts."),
        q("701-hard-076", "701-program", "A company wants to measure whether phishing training improved behavior. What should be used?", "Metrics from simulations, reporting rates, and repeat click rates", ["Only number of posters printed", "Router uptime only", "Keyboard inventory"], "Awareness programs should be measured with behavior-focused metrics.")
    ]

    static let aPlusCore1HardPerformanceItems: [ExamItem] = [
        ExamItem(
            id: "1201-hard-pbq-wifi-roaming",
            domainID: "1201-networking",
            kind: .matching,
            prompt: "PBQ: Users lose voice calls while walking between two office wings. Match each observation to the most likely tuning area.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["Calls drop exactly between AP coverage areas", "2.4 GHz works but is slow near break room", "Only one user's laptop drops when lid angle changes", "Clients cling to a distant AP with weak signal", "Guest devices can see internal printers"],
            matchingAnswers: ["Roaming threshold or AP overlap", "RF interference and channel plan", "Laptop antenna path or adapter seating", "Band steering or minimum RSSI behavior", "Guest network isolation"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "The clues separate RF design, roaming, device-specific hardware, and segmentation issues.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1201-hard-pbq-no-boot",
            domainID: "1201-troubleshooting",
            kind: .ordering,
            prompt: "PBQ: A PC reports no bootable device after an NVMe migration. Put the safest troubleshooting flow in order.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Confirm the drive is detected in firmware", "Check boot order and UEFI or legacy mode", "Verify storage controller or NVMe support settings", "Boot recovery media and inspect partitions", "Repair boot records only after data is protected", "Verify OS boot and document the change"],
            explanation: "The order protects data and checks firmware, boot mode, and partition state before repair actions.",
            points: 6,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1201-hard-pbq-printer-defects",
            domainID: "1201-hardware",
            kind: .matching,
            prompt: "PBQ: Match each printer symptom to the best first investigation.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["Loose toner wipes off the page", "Repeating marks at a regular interval", "Inkjet output has missing lines", "Thermal labels print blank after roll change", "Only tray 2 jams"],
            matchingAnswers: ["Fuser or wrong media", "Drum or roller defect", "Nozzle cleaning, ink, or alignment", "Thermal media orientation/type", "Tray guides, pickup roller, and media path"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "Printer PBQs usually hinge on printer type and symptom scope before choosing a part.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1201-hard-pbq-storage",
            domainID: "1201-hardware",
            kind: .multipleSelect,
            prompt: "PBQ: A new M.2 SSD is not detected. The motherboard has two M.2 slots and shared SATA lanes. Select the checks that should happen before replacing the drive.",
            choices: ["Verify whether the slot supports SATA, PCIe, or both", "Check whether installing the drive disables specific SATA ports", "Confirm BIOS or UEFI storage settings and firmware support", "Reseat the drive and standoff correctly", "Format the old data drive without backup", "Replace the monitor cable"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "M.2 troubleshooting requires checking protocol support, lane sharing, firmware settings, and physical seating before destructive actions.",
            points: 4,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1201-hard-pbq-cloud-vm",
            domainID: "1201-cloud",
            kind: .ordering,
            prompt: "PBQ: Put the safest VM testing workflow in order before installing untrusted software.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Confirm isolation and no production data exposure", "Patch the guest and update security tools", "Take a snapshot", "Run the test", "Review behavior and logs", "Revert or preserve evidence according to policy"],
            explanation: "A VM can help isolate testing, but the workflow still needs patching, snapshotting, review, and policy-aware cleanup.",
            points: 6,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1201-hard-pbq-mobile-loss",
            domainID: "1201-mobile",
            kind: .multipleSelect,
            prompt: "PBQ: A company phone with email and local files is lost at an airport. Select the best immediate actions.",
            choices: ["Use MDM to lock or wipe according to policy", "Revoke active sessions or tokens if available", "Document the incident and notify the appropriate owner", "Ask the user whether sensitive data was stored locally", "Wait several days to see if it appears", "Post the user's password in the ticket"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Lost managed devices require containment, session protection, documentation, and data-impact assessment.",
            points: 4,
            isPerformanceBased: true
        )
    ]

    static let aPlusCore2HardPerformanceItems: [ExamItem] = [
        ExamItem(
            id: "1202-hard-pbq-account-compromise",
            domainID: "1202-security",
            kind: .multipleSelect,
            prompt: "PBQ: A user approved an unexpected MFA prompt. Mailbox forwarding rules appeared shortly after. Select the best response actions.",
            choices: ["Revoke active sessions or tokens", "Reset the password through the approved process", "Review mailbox rules and sign-in logs", "Preserve evidence and escalate if required", "Tell the user to approve prompts until they stop", "Delete logs to reduce noise"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Unexpected MFA approval plus mailbox changes should be treated as account compromise.",
            points: 4,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1202-hard-pbq-windows-evidence",
            domainID: "1202-os",
            kind: .matching,
            prompt: "PBQ: Match each Windows symptom to the best first evidence source or tool.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["Intermittent app crash timeline", "Service fails after every reboot", "Group Policy not applying after OU move", "Disk online but no drive letter", "Slow sign-in after new startup app"],
            matchingAnswers: ["Reliability Monitor or Event Viewer", "Services console and dependencies", "gpupdate/gpresult path", "Disk Management", "Task Manager startup impact"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "Hard OS questions reward choosing the evidence source that fits the exact symptom.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1202-hard-pbq-malware",
            domainID: "1202-security",
            kind: .ordering,
            prompt: "PBQ: Put the defensible malware response flow in order for a workstation showing command-and-control traffic.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Identify symptoms and scope", "Isolate the host from the network", "Preserve useful logs or evidence", "Remediate with updated trusted tools", "Reset affected credentials if needed", "Verify functionality and no recurring indicators", "Educate the user and document closure"],
            explanation: "Containment and evidence come before cleanup; verification and user education complete the workflow.",
            points: 7,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1202-hard-pbq-profile-scope",
            domainID: "1202-troubleshooting",
            kind: .matching,
            prompt: "PBQ: Match the symptom pattern to the most likely troubleshooting scope.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["App fails for one Windows profile only", "Website certificate warning on every device", "Printer offline for one user only", "Browser redirects in one browser only", "VPN share fails only offsite"],
            matchingAnswers: ["User profile or per-user configuration", "Service/site certificate or time trust issue", "Local mapping, queue, or profile setting", "Extension, notification, cache, or browser profile", "VPN routing and internal DNS"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "Scope matters: one user, one app, one browser, every device, and offsite-only failures point to different causes.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1202-hard-pbq-change-control",
            domainID: "1202-operations",
            kind: .ordering,
            prompt: "PBQ: Put the production workstation change workflow in the best order.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Define impact and reason for change", "Confirm approval and maintenance window", "Verify backup or rollback path", "Communicate expected user impact", "Perform the change", "Validate the original business workflow", "Document result and follow-up"],
            explanation: "Production changes require approval, rollback planning, communication, validation, and documentation.",
            points: 7,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "1202-hard-pbq-mobile-policy",
            domainID: "1202-security",
            kind: .multipleSelect,
            prompt: "PBQ: A user's phone was restored to a replacement device, and corporate mail works but MFA push and a line-of-business app fail. Select likely checks.",
            choices: ["Re-enroll the authenticator or MFA device", "Confirm MDM compliance and app configuration", "Review app permissions and managed account state", "Check whether tokens or certificates need reissue", "Disable MFA for the user permanently", "Factory reset without checking backup or enrollment"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Replacement mobile devices often need MFA, MDM, tokens, certificates, and managed app state refreshed.",
            points: 4,
            isPerformanceBased: true
        )
    ]

    static let securityPlusHardPerformanceItems: [ExamItem] = [
        ExamItem(
            id: "701-hard-pbq-ir-flow",
            domainID: "701-operations",
            kind: .ordering,
            prompt: "PBQ: Put the incident response actions in the best order after EDR detects suspicious encoded commands on a finance workstation.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Validate alert and collect initial context", "Contain the endpoint", "Preserve volatile and relevant log evidence", "Scope related hosts, users, and indicators", "Eradicate persistence and malicious artifacts", "Recover and monitor for recurrence", "Document lessons learned and control improvements"],
            explanation: "The order emphasizes validation, containment, evidence, scoping, eradication, recovery, and improvement.",
            points: 7,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "701-hard-pbq-cloud-responsibility",
            domainID: "701-architecture",
            kind: .matching,
            prompt: "PBQ: Match each cloud security task to the party usually responsible in an IaaS deployment.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["Physical server replacement", "Guest OS patching", "Identity and access policy", "Storage bucket access configuration", "Hypervisor maintenance"],
            matchingAnswers: ["Cloud provider", "Customer", "Customer", "Customer", "Cloud provider"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "In IaaS, the provider handles physical and hypervisor layers while the customer owns guest OS, IAM, data, and configuration.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "701-hard-pbq-bec",
            domainID: "701-threats",
            kind: .multipleSelect,
            prompt: "PBQ: A vendor email thread requests an urgent bank routing change. Select the best risk-reducing actions.",
            choices: ["Verify through a known out-of-band contact method", "Inspect sender, reply-to, headers, and message history", "Follow payment change approval workflow", "Report the message to security or finance control owner", "Reply with current banking details to confirm", "Bypass approval because the thread is existing"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "BEC defense requires out-of-band verification, header/context review, workflow controls, and reporting.",
            points: 4,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "701-hard-pbq-control-map",
            domainID: "701-concepts",
            kind: .matching,
            prompt: "PBQ: Match each control to the best control function or category.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["EDR alert on suspicious script", "Firewall denies inbound management traffic", "Restore clean backup after malware", "Change advisory board approval", "Security awareness simulation"],
            matchingAnswers: ["Detective technical", "Preventive technical", "Corrective operational", "Managerial", "Operational"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "The best label depends on whether the control detects, prevents, corrects, governs, or operates a process.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "701-hard-pbq-vuln-mgmt",
            domainID: "701-operations",
            kind: .ordering,
            prompt: "PBQ: Put the vulnerability management flow in order after a critical internet-facing finding appears.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Validate the finding and affected asset", "Assess exposure, exploitability, and business criticality", "Choose patch, mitigation, or compensating control", "Schedule or execute remediation through change process", "Rescan or otherwise verify remediation", "Document exception or closure"],
            explanation: "Vulnerability work needs validation, prioritization, remediation, verification, and documentation.",
            points: 6,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "701-hard-pbq-data-protection",
            domainID: "701-program",
            kind: .multipleSelect,
            prompt: "PBQ: A vendor will process confidential customer records in a SaaS platform. Select required risk checks.",
            choices: ["Data handling and retention terms", "Right-to-audit or assurance evidence", "Breach notification timeline", "Access control and offboarding process", "Vendor logo color", "Whether users like the interface"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Third-party risk must address data handling, assurance, notification, access, and lifecycle controls.",
            points: 4,
            isPerformanceBased: true
        )
    ]
}
