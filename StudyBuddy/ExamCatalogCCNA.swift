import Foundation

// Cisco CCNA 200-301 (v1.1) study catalog.
// Domain weights verified against the 2026 200-301 v1.1 blueprint on 2026-09-28:
// Network Fundamentals 20, Network Access 20, IP Connectivity 25,
// IP Services 10, Security Fundamentals 15, Automation and Programmability 10.
// Cisco does not publish a fixed official passing score; the simulation below
// uses a 300-1000 scale with a practice threshold and says so in its description.
enum ExamCatalogCCNA {
    private static let ciscoDisclaimer = "PrepNexus is independent study software. It is not affiliated with, endorsed by, or sponsored by Cisco. Cisco and CCNA are trademarks of Cisco Systems, Inc. Practice questions are original study prompts, not real exam questions."

    static let ccna = ExamProfile(
        id: "cisco-ccna-200-301",
        name: "Cisco CCNA",
        code: "200-301",
        summary: "Study guidance for the Cisco CCNA 200-301 (v1.1) exam: network fundamentals, network access, IP connectivity, IP services, security fundamentals, and automation and programmability. Content is original study material and should be checked against the official Cisco exam topics before submission.",
        domains: [
            ExamDomain(
                id: "200-301-fundamentals",
                title: "Network Fundamentals",
                weight: 20,
                focus: "Addressing, subnetting, interfaces, topologies, virtualization, and wireless principles.",
                objectives: [
                    "Explain the roles of routers, Layer 2 and Layer 3 switches, controllers, endpoints, and servers.",
                    "Compare two-tier, three-tier, spine-leaf, WAN, SOHO, and on-premises versus cloud topologies.",
                    "Perform IPv4 addressing and subnetting, including VLSM, to meet host requirements with least waste.",
                    "Describe IPv6 address types, prefix lengths, and basic IPv6 addressing concepts.",
                    "Compare TCP and UDP, common port numbers, and typical application behavior.",
                    "Explain switching concepts: MAC learning and aging, frame flooding, and the MAC table.",
                    "Describe wireless principles: RF behavior, bands, channels, SSIDs, and basic WLAN concepts.",
                    "Describe virtualization and cloud concepts relevant to network fundamentals."
                ]
            ),
            ExamDomain(
                id: "200-301-access",
                title: "Network Access",
                weight: 20,
                focus: "VLANs, trunks, CDP/LLDP, LACP, Rapid PVST+, and wireless access.",
                objectives: [
                    "Configure and verify VLANs, access ports, and trunk ports, including allowed VLANs and native VLAN.",
                    "Explain and verify interswitch connectivity using trunking.",
                    "Configure and verify Layer 2 discovery protocols: Cisco Discovery Protocol and LLDP.",
                    "Configure and verify EtherChannel using LACP.",
                    "Describe Rapid PVST+ operation: root bridge selection, port roles, and port states.",
                    "Describe WLAN deployment concepts: AP modes, WLC roles, and wireless access configuration."
                ]
            ),
            ExamDomain(
                id: "200-301-connectivity",
                title: "IP Connectivity",
                weight: 25,
                focus: "Routing-table decisions, IPv4/IPv6 static routes, single-area OSPFv2, and FHRP purpose.",
                objectives: [
                    "Interpret routing tables to predict forwarding: longest prefix match, administrative distance, and metric.",
                    "Configure and verify IPv4 and IPv6 static routing, default routes, and floating static routes.",
                    "Configure and verify single-area OSPFv2: neighbor adjacency, router ID, passive interfaces, and cost.",
                    "Describe the purpose of first-hop redundancy protocols and how they provide gateway resiliency.",
                    "Compare routing protocol characteristics at a conceptual level."
                ]
            ),
            ExamDomain(
                id: "200-301-services",
                title: "IP Services",
                weight: 10,
                focus: "NAT, NTP, DHCP/DNS, SNMP, syslog, QoS, SSH, and file transfer.",
                objectives: [
                    "Configure and verify NAT: inside static, inside dynamic, and PAT overload.",
                    "Explain DHCP client and server operation, and configure a basic DHCP server on a router.",
                    "Describe the roles of DNS, NTP, SNMP, syslog, and QoS in network operations.",
                    "Configure SSH for secure device management and describe TFTP/FTP use for image and config transfer."
                ]
            ),
            ExamDomain(
                id: "200-301-security",
                title: "Security Fundamentals",
                weight: 15,
                focus: "Access control, Layer 2 protections, VPN concepts, AAA, and WLAN security.",
                objectives: [
                    "Configure and verify standard and extended IPv4 access control lists.",
                    "Explain Layer 2 security: port security, DHCP snooping, and dynamic ARP inspection concepts.",
                    "Describe VPN concepts: site-to-site, remote access, and the basic purpose of IPsec.",
                    "Explain AAA concepts: authentication, authorization, accounting, and local versus server-based AAA.",
                    "Describe WLAN security: WPA2, WPA3, and basic wireless threat awareness.",
                    "Apply device hardening basics: strong credentials, banners, and disabling unused services."
                ]
            ),
            ExamDomain(
                id: "200-301-automation",
                title: "Automation and Programmability",
                weight: 10,
                focus: "Controller-based networking, APIs, JSON, configuration management, and AI/ML concepts.",
                objectives: [
                    "Compare traditional, controller-based, and software-defined networking architectures.",
                    "Explain REST API concepts, HTTP verbs, and data formats including JSON.",
                    "Interpret basic JSON data returned by network APIs.",
                    "Describe configuration management tools and concepts: Ansible, Puppet, and Chef at a conceptual level.",
                    "Describe how AI and ML concepts apply to modern network operations."
                ]
            )
        ],
        studyTasks: [
            StudyTask(id: "200-301-fund-1", domainID: "200-301-fundamentals", title: "Subnetting speed drill", detail: "Practice 20 subnetting problems: given a host requirement, pick the least-waste prefix, then compute network, broadcast, and usable range. Target under 60 seconds each.", minutes: 45),
            StudyTask(id: "200-301-fund-2", domainID: "200-301-fundamentals", title: "VLSM design lab", detail: "Design a VLSM scheme for a small company with four LANs of different sizes plus WAN links. Allocate from one block, largest requirement first, and document each subnet.", minutes: 45),
            StudyTask(id: "200-301-fund-3", domainID: "200-301-fundamentals", title: "TCP/UDP and ports map", detail: "List common ports 20/21, 22, 23, 25, 53, 67/68, 69, 80, 110, 143, 161, 443, 3389 and write the service plus TCP or UDP behavior for each.", minutes: 35),
            StudyTask(id: "200-301-fund-4", domainID: "200-301-fundamentals", title: "Topology sketch", detail: "Draw two-tier, three-tier, and spine-leaf topologies. Label where routers, Layer 3 switches, and controllers sit, and note the failure domains.", minutes: 30),
            StudyTask(id: "200-301-access-1", domainID: "200-301-access", title: "VLAN and trunk lab", detail: "On paper or in Packet Tracer, create three VLANs, assign access ports, build a trunk with a native VLAN, and verify with show commands. Then break the native VLAN and observe the symptom.", minutes: 45),
            StudyTask(id: "200-301-access-2", domainID: "200-301-access", title: "STP root election drill", detail: "Given bridge priorities and MAC addresses for three switches, predict the root bridge, root ports, and designated ports. Then change one priority and re-predict.", minutes: 35),
            StudyTask(id: "200-301-access-3", domainID: "200-301-access", title: "EtherChannel build", detail: "Configure an LACP EtherChannel between two switches. Verify with show etherchannel summary, then shut one member link and confirm the bundle stays up.", minutes: 40),
            StudyTask(id: "200-301-access-4", domainID: "200-301-access", title: "Discovery protocol sweep", detail: "Enable CDP and LLDP in a lab, map neighbors with show cdp neighbors and show lldp neighbors, then disable CDP on an edge port facing users and explain why.", minutes: 30),
            StudyTask(id: "200-301-conn-1", domainID: "200-301-connectivity", title: "Routing table reading", detail: "Take a sample show ip route output with static, connected, and OSPF routes. For six destination addresses, predict the chosen route and explain longest prefix match and administrative distance.", minutes: 40),
            StudyTask(id: "200-301-conn-2", domainID: "200-301-connectivity", title: "Static route lab", detail: "Build a three-router chain. Configure static routes both directions, add a default route, then create a floating static route with a higher administrative distance as backup.", minutes: 45),
            StudyTask(id: "200-301-conn-3", domainID: "200-301-connectivity", title: "OSPF adjacency lab", detail: "Configure single-area OSPFv2 on three routers. Verify neighbors, then break adjacency on purpose: mismatched area, mismatched hello timer, and a passive interface. Record the symptom of each.", minutes: 45),
            StudyTask(id: "200-301-conn-4", domainID: "200-301-connectivity", title: "FHRP concept map", detail: "Explain what happens to hosts when their default gateway router fails, then describe how a first-hop redundancy protocol fixes it. Contrast active/standby with load-sharing behavior.", minutes: 30),
            StudyTask(id: "200-301-svc-1", domainID: "200-301-services", title: "NAT overload lab", detail: "Configure PAT overload on an edge router so a private LAN reaches the internet. Verify translations, then add one inside static NAT entry for a server and test inbound reachability.", minutes: 40),
            StudyTask(id: "200-301-svc-2", domainID: "200-301-services", title: "DHCP server build", detail: "Configure a router as a DHCP server with an excluded range, DNS server, and default router. Release and renew a client, then verify the lease on both sides.", minutes: 35),
            StudyTask(id: "200-301-svc-3", domainID: "200-301-services", title: "Services matrix", detail: "Make a card for each: NTP, SNMP, syslog, QoS, SSH, TFTP/FTP. For each, write its purpose, one key port or behavior, and one misconfiguration symptom.", minutes: 35),
            StudyTask(id: "200-301-svc-4", domainID: "200-301-services", title: "Management hardening pass", detail: "On a lab device, configure SSH with a domain name and RSA keys, disable Telnet, set an MOTD banner, and verify only SSH is reachable for management.", minutes: 30),
            StudyTask(id: "200-301-sec-1", domainID: "200-301-security", title: "ACL lab", detail: "Write a standard ACL limiting VTY access to one management subnet, and an extended ACL blocking a host from a server while permitting everything else. Apply, test, and then fix the implicit deny surprise.", minutes: 45),
            StudyTask(id: "200-301-sec-2", domainID: "200-301-security", title: "Port security drill", detail: "Configure port security with sticky MAC learning and a violation shutdown on an access port. Trigger a violation with a second device, then recover the port and document the steps.", minutes: 35),
            StudyTask(id: "200-301-sec-3", domainID: "200-301-security", title: "AAA concept map", detail: "Diagram authentication, authorization, and accounting for an admin logging into a router via TACACS+. Mark what each A proves and where the decision is made.", minutes: 30),
            StudyTask(id: "200-301-sec-4", domainID: "200-301-security", title: "VPN comparison", detail: "Compare site-to-site and remote-access VPNs: who initiates, what traffic is protected, and where each is used. Add one sentence on what IPsec provides.", minutes: 30),
            StudyTask(id: "200-301-auto-1", domainID: "200-301-automation", title: "Architecture compare", detail: "Draw the control plane in three designs: traditional distributed, controller-based SDN, and Cisco DNA Center style. Mark where forwarding decisions are made in each.", minutes: 35),
            StudyTask(id: "200-301-auto-2", domainID: "200-301-automation", title: "REST and JSON drill", detail: "Given a sample JSON response from a network controller, identify objects, arrays, and key-value pairs. Then match GET, POST, PUT, DELETE to retrieve, create, update, and remove.", minutes: 35),
            StudyTask(id: "200-301-auto-3", domainID: "200-301-automation", title: "Config management cards", detail: "Make cards for Ansible, Puppet, and Chef: agent or agentless, push or pull, and the language used to describe desired state. Note which one the blueprint emphasizes conceptually.", minutes: 30),
            StudyTask(id: "200-301-auto-4", domainID: "200-301-automation", title: "AI in NetOps brief", detail: "Write a half-page brief on where AI/ML shows up in modern network operations: anomaly detection, predictive maintenance, and intent-based networking. Keep it conceptual, not vendor-specific.", minutes: 30)
        ],
        flashcards: [
            Flashcard(id: "200-301-fc-001", domainID: "200-301-fundamentals", front: "How many usable hosts does a /26 provide?", back: "62 usable hosts: 2^6 minus network and broadcast, 64 total minus 2."),
            Flashcard(id: "200-301-fc-002", domainID: "200-301-fundamentals", front: "What is the difference between TCP and UDP?", back: "TCP is connection-oriented with sequencing, acknowledgments, and retransmission. UDP is connectionless with minimal overhead and no delivery guarantee."),
            Flashcard(id: "200-301-fc-003", domainID: "200-301-fundamentals", front: "What does a switch do when it receives a frame for an unknown destination MAC?", back: "It floods the frame out all ports except the receiving port, then learns the source MAC from the reply."),
            Flashcard(id: "200-301-fc-004", domainID: "200-301-access", front: "What is the purpose of the native VLAN on a trunk?", back: "It carries untagged traffic across the trunk. Both ends must agree or traffic can leak between VLANs."),
            Flashcard(id: "200-301-fc-005", domainID: "200-301-access", front: "How is the STP root bridge elected?", back: "Lowest bridge ID wins: lowest priority first, then lowest MAC address as the tiebreaker."),
            Flashcard(id: "200-301-fc-006", domainID: "200-301-access", front: "What does LACP do?", back: "Link Aggregation Control Protocol negotiates bundling multiple physical links into one logical EtherChannel, adding bandwidth and redundancy."),
            Flashcard(id: "200-301-fc-007", domainID: "200-301-connectivity", front: "What is longest prefix match?", back: "When multiple routes match a destination, the router forwards using the route with the longest (most specific) prefix."),
            Flashcard(id: "200-301-fc-008", domainID: "200-301-connectivity", front: "What is administrative distance?", back: "A trustworthiness rating for route sources. Lower wins: connected 0, static 1, OSPF 110. Used to choose between different sources for the same prefix."),
            Flashcard(id: "200-301-fc-009", domainID: "200-301-connectivity", front: "What must match for two routers to become OSPF neighbors?", back: "Same area, same hello and dead timers, same authentication settings, matching MTU, and unique router IDs, among other parameters."),
            Flashcard(id: "200-301-fc-010", domainID: "200-301-services", front: "What is PAT overload?", back: "Port Address Translation maps many private inside addresses to one public address using unique source ports, the common way a LAN shares one public IP."),
            Flashcard(id: "200-301-fc-011", domainID: "200-301-services", front: "What four things does a DHCP server typically provide?", back: "IP address, subnet mask, default gateway, and DNS server addresses, plus a lease time."),
            Flashcard(id: "200-301-fc-012", domainID: "200-301-services", front: "Why use SSH instead of Telnet for device management?", back: "SSH encrypts the session including credentials. Telnet sends everything, including passwords, in clear text."),
            Flashcard(id: "200-301-fc-013", domainID: "200-301-security", front: "What is the implicit rule at the end of every ACL?", back: "An implicit deny: anything not explicitly permitted is denied. Forgetting this is the classic ACL surprise."),
            Flashcard(id: "200-301-fc-014", domainID: "200-301-security", front: "What does DHCP snooping protect against?", back: "Rogue DHCP servers: it classifies ports as trusted or untrusted and drops DHCP server messages arriving on untrusted ports."),
            Flashcard(id: "200-301-fc-015", domainID: "200-301-security", front: "What do the three As in AAA stand for?", back: "Authentication (who are you), authorization (what can you do), accounting (what did you do)."),
            Flashcard(id: "200-301-fc-016", domainID: "200-301-automation", front: "In controller-based networking, where does the control plane live?", back: "Centralized in the controller, which programs forwarding behavior down to the network devices instead of each device deciding alone."),
            Flashcard(id: "200-301-fc-017", domainID: "200-301-automation", front: "What do the HTTP verbs GET, POST, PUT, DELETE do?", back: "GET retrieves, POST creates, PUT updates or replaces, DELETE removes. These are the basic verbs for REST API interaction."),
            Flashcard(id: "200-301-fc-018", domainID: "200-301-automation", front: "What is JSON?", back: "JavaScript Object Notation: a lightweight text format of key-value pairs and arrays that REST APIs commonly use to exchange data.")
        ],
        practiceQuestions: [
            PracticeQuestion(id: "200-301-pq-001", domainID: "200-301-fundamentals", prompt: "A host needs 30 usable addresses. Which subnet mask wastes the fewest addresses?", choices: ["255.255.255.224 (/27)", "255.255.255.192 (/26)", "255.255.255.128 (/25)", "255.255.255.0 (/24)"], answerIndex: 0, explanation: "A /27 provides 32 addresses total — 30 usable — which fits the requirement with zero waste. A /26 provides 62 usable (32 wasted); larger masks waste even more."),
            PracticeQuestion(id: "200-301-pq-002", domainID: "200-301-fundamentals", prompt: "Which address is a valid IPv6 global unicast address?", choices: ["2001:db8::1", "169.254.10.5", "224.0.0.5", "fe80::1"], answerIndex: 0, explanation: "2001:db8::/32 is the documentation global unicast range. 169.254.x.x is IPv4 link-local, 224.0.0.5 is IPv4 multicast, fe80::/10 is IPv6 link-local."),
            PracticeQuestion(id: "200-301-pq-003", domainID: "200-301-access", prompt: "A trunk link carries VLANs 10, 20, and 30 with native VLAN 99. A frame from VLAN 10 crosses the trunk. How is it tagged?", choices: ["Tagged with VLAN 10", "Untagged, because VLAN 10 is the native VLAN", "Tagged with VLAN 99", "Dropped, because only the native VLAN crosses"], answerIndex: 0, explanation: "Only native VLAN traffic goes untagged. VLAN 10 is not native here, so its frames cross tagged with VLAN 10."),
            PracticeQuestion(id: "200-301-pq-004", domainID: "200-301-access", prompt: "Two switches have bridge priorities 32768 and 16384, all else equal. Which becomes the STP root?", choices: ["The switch with priority 16384", "The switch with priority 32768", "The switch with the highest MAC address", "Neither; an election tie disables STP"], answerIndex: 0, explanation: "Lowest bridge ID wins, and priority is compared before MAC address. 16384 beats 32768."),
            PracticeQuestion(id: "200-301-pq-005", domainID: "200-301-connectivity", prompt: "A router knows 10.0.0.0/8 via OSPF and 10.1.0.0/16 via a static route. A packet arrives for 10.1.5.5. Which route is used?", choices: ["The static 10.1.0.0/16 route", "The OSPF 10.0.0.0/8 route", "Both, with load balancing", "Neither; the packet is dropped"], answerIndex: 0, explanation: "Longest prefix match decides first: /16 is more specific than /8, so the static route wins regardless of administrative distance."),
            PracticeQuestion(id: "200-301-pq-006", domainID: "200-301-connectivity", prompt: "Two routers will not form an OSPF adjacency. Which mismatch is a likely cause?", choices: ["Different OSPF area numbers", "Different hostnames", "Different interface descriptions", "Different enable secrets"], answerIndex: 0, explanation: "Area numbers must match for adjacency. Hostnames, descriptions, and enable secrets do not affect OSPF neighbor formation."),
            PracticeQuestion(id: "200-301-pq-007", domainID: "200-301-services", prompt: "An office LAN uses 192.168.1.0/24 internally and one public IP. Which NAT design fits?", choices: ["PAT overload on the edge router", "One-to-one static NAT for every host", "No NAT; private addresses route on the internet", "Dynamic NAT with a pool of one address and no overload"], answerIndex: 0, explanation: "PAT overload maps many private addresses to one public IP using unique source ports. Static NAT per host wastes addresses, and private addresses are not internet-routable."),
            PracticeQuestion(id: "200-301-pq-008", domainID: "200-301-security", prompt: "An extended ACL ends with no explicit permit. A permitted service stops working after the ACL is applied. What is the most likely cause?", choices: ["The implicit deny blocked the remaining traffic", "ACLs only filter outbound by default", "Extended ACLs cannot filter TCP", "The ACL needs a reload to take effect"], answerIndex: 0, explanation: "Every ACL ends with an implicit deny. Traffic not explicitly permitted is dropped, which surprises anyone expecting a default permit."),
            PracticeQuestion(id: "200-301-pq-009", domainID: "200-301-security", prompt: "Which wireless security standard should a new enterprise deployment choose?", choices: ["WPA3", "WPA", "WEP", "Open authentication"], answerIndex: 0, explanation: "WPA3 is the current enterprise standard. WPA is deprecated, WEP is broken, and open authentication provides no encryption."),
            PracticeQuestion(id: "200-301-pq-010", domainID: "200-301-automation", prompt: "A script needs to read the current interface status from a network controller. Which HTTP verb fits?", choices: ["GET", "POST", "PUT", "DELETE"], answerIndex: 0, explanation: "GET retrieves data. POST creates, PUT updates, DELETE removes.")
        ],
        quickTips: [
            "Cisco does not publish a fixed official passing score for 200-301, and third-party numbers like 825/1000 are practice conventions, not Cisco policy. Train for mastery of the blueprint, not a number.",
            "CCNA v2.0 arrives February 3, 2027 and restructures the domains. If you test before February 2, 2027, study v1.1; after that date, confirm the current blueprint before scheduling.",
            "Read the verb before planning the lab. Describe and compare need recognition and explanation; configure and verify needs hands-on practice with real or simulated devices.",
            "Subnetting speed is a force multiplier: aim for under 60 seconds per calculation. VLSM design questions punish slow arithmetic more than any other topic.",
            "IP Connectivity is the heaviest domain at 25 percent. Routing-table reading, static routes, and single-area OSPFv2 deserve the most lab time.",
            "Do not skip Automation and Programmability because it is only 10 percent. Controller concepts, REST verbs, and JSON interpretation are straightforward points if you drill them."
        ],
        disclaimer: ciscoDisclaimer
    )

    static let ccnaChallengeFlashcards: [Flashcard] = [
        Flashcard(id: "200-301-hard-fc-001", domainID: "200-301-fundamentals", front: "A site needs 1,500 usable hosts on one subnet. Which prefix wastes the least?", back: "/21: 2,046 usable (546 wasted). /22 gives only 1,022, too small. /20 gives 4,094, wasting far more."),
        Flashcard(id: "200-301-hard-fc-002", domainID: "200-301-fundamentals", front: "How do you tell an IPv6 global unicast address from a link-local one?", back: "Global unicast starts with 2000::/3 (e.g. 2001:db8::). Link-local starts with fe80::/10 and never leaves the local link."),
        Flashcard(id: "200-301-hard-fc-003", domainID: "200-301-access", front: "What breaks when two ends of a trunk disagree on the native VLAN?", back: "Untagged traffic from one side lands in the wrong VLAN on the other, causing misdelivery and a potential VLAN-hopping risk."),
        Flashcard(id: "200-301-hard-fc-004", domainID: "200-301-access", front: "In Rapid PVST+, what are the port states and which forward traffic?", back: "Discarding, learning, forwarding. Only forwarding ports pass user traffic. Rapid PVST+ converges faster than legacy 802.1D timers."),
        Flashcard(id: "200-301-hard-fc-005", domainID: "200-301-connectivity", front: "What does a floating static route do?", back: "A static route with a higher administrative distance than the dynamic protocol, so it stays dormant until the dynamic route disappears, then takes over as backup."),
        Flashcard(id: "200-301-hard-fc-006", domainID: "200-301-connectivity", front: "In OSPF, what are the DR and BDR for?", back: "On multi-access networks the Designated Router and Backup DR reduce adjacency overhead: other routers form adjacencies only with the DR/BDR instead of full mesh."),
        Flashcard(id: "200-301-hard-fc-007", domainID: "200-301-services", front: "In NAT terminology, what is the difference between inside local and inside global?", back: "Inside local is the private address as seen on the inside network. Inside global is the public address representing it on the outside."),
        Flashcard(id: "200-301-hard-fc-008", domainID: "200-301-services", front: "What is NTP stratum and why does it matter?", back: "Stratum is distance from the reference clock: stratum 1 is directly attached, higher numbers are further downstream. Lower stratum means more authoritative time."),
        Flashcard(id: "200-301-hard-fc-009", domainID: "200-301-security", front: "What are the three port-security violation modes?", back: "Protect (drop, no alert), restrict (drop plus alert and counter), shutdown (error-disable the port until recovery)."),
        Flashcard(id: "200-301-hard-fc-010", domainID: "200-301-security", front: "Why is WPA3 stronger than WPA2 for personal networks?", back: "WPA3-Personal uses SAE instead of the WPA2 4-way handshake, resisting offline dictionary attacks against captured handshakes."),
        Flashcard(id: "200-301-hard-fc-011", domainID: "200-301-automation", front: "What is the difference between northbound and southbound APIs?", back: "Southbound APIs let the controller program network devices. Northbound APIs expose network services and state up to applications and orchestration."),
        Flashcard(id: "200-301-hard-fc-012", domainID: "200-301-automation", front: "Why is Ansible called agentless?", back: "It manages devices over SSH or APIs using playbooks, with no agent software installed on the managed nodes.")
    ]

    static let ccnaChallengeQuestions: [PracticeQuestion] = [
        PracticeQuestion(id: "200-301-hard-001", domainID: "200-301-fundamentals", prompt: "A branch office needs 1,500 usable host addresses on a single subnet. Which prefix wastes the fewest addresses?", choices: ["/21 (2,046 usable)", "/20 (4,094 usable)", "/22 (1,022 usable)", "/23 (510 usable)"], answerIndex: 0, explanation: "/22 and /23 are too small for 1,500 hosts. /21 provides 2,046 usable (546 wasted) versus /20 with 4,094 (2,594 wasted), so /21 is the unique least-waste answer."),
        PracticeQuestion(id: "200-301-hard-002", domainID: "200-301-connectivity", prompt: "Two routers in the same OSPF area will not reach FULL adjacency. Timers, MTU, and area all match. Which mismatch is the next most likely cause?", choices: ["Authentication settings differ", "Hostnames differ", "Interface descriptions differ", "Cable colors differ"], answerIndex: 0, explanation: "OSPF authentication must match for adjacency. Hostnames, descriptions, and cable colors have no effect on neighbor formation."),
        PracticeQuestion(id: "200-301-hard-003", domainID: "200-301-connectivity", prompt: "A router has 172.16.0.0/12 via EIGRP, 172.16.32.0/19 via OSPF, and 172.16.32.128/25 via a static route. A packet for 172.16.32.200 arrives. Which route forwards it?", choices: ["The /25 static route", "The /19 OSPF route", "The /12 EIGRP route", "All three, load-balanced"], answerIndex: 0, explanation: "Longest prefix match wins first: /25 is the most specific match, so the static route forwards the packet regardless of protocol or administrative distance."),
        PracticeQuestion(id: "200-301-hard-004", domainID: "200-301-access", prompt: "Users in VLAN 20 intermittently receive traffic meant for VLAN 30 across a trunk. Both VLANs are allowed on the trunk. What should be checked first?", choices: ["Native VLAN agreement on both ends of the trunk", "The STP root bridge priority", "The OSPF router ID", "The DHCP lease time"], answerIndex: 0, explanation: "Cross-VLAN leakage on a trunk points to a native VLAN mismatch: untagged frames from one side enter the wrong VLAN on the other."),
        PracticeQuestion(id: "200-301-hard-005", domainID: "200-301-services", prompt: "A packet leaves the inside network with source 10.1.1.5 and arrives outside with source 203.0.113.7. In NAT terms, what are these addresses?", choices: ["Inside local and inside global", "Outside local and outside global", "Inside global and inside local", "Both are outside global"], answerIndex: 0, explanation: "10.1.1.5 is the inside local address as seen internally; 203.0.113.7 is the inside global address representing it externally."),
        PracticeQuestion(id: "200-301-hard-006", domainID: "200-301-security", prompt: "DHCP snooping is enabled but clients still receive addresses from a rogue server on an access port. What was missed?", choices: ["The access port was left trusted or snooping is not enforcing on it", "The DHCP pool is too small", "NTP is not synchronized", "The native VLAN is wrong"], answerIndex: 0, explanation: "Snooping only drops server messages on untrusted ports. If the rogue port is trusted or the feature is not active on the VLAN, rogue offers still reach clients."),
        PracticeQuestion(id: "200-301-hard-007", domainID: "200-301-automation", prompt: "A controller returns this JSON: {\"interfaces\": [{\"name\": \"Gig0/0\", \"status\": \"up\"}]}. What is the status of Gig0/0?", choices: ["up", "down", "unknown", "The JSON is malformed"], answerIndex: 0, explanation: "The interfaces array holds one object; its status key has the value up. Reading key-value pairs inside arrays is the core JSON skill."),
        PracticeQuestion(id: "200-301-hard-008", domainID: "200-301-connectivity", prompt: "A LAN uses a first-hop redundancy protocol with one active and one standby gateway. The active router fails. What do the hosts experience?", choices: ["Brief interruption, then the standby takes over the virtual gateway address", "Permanent outage until the router is replaced", "Hosts must be reconfigured with a new gateway", "The standby only works after a manual failover command"], answerIndex: 0, explanation: "FHRP provides a virtual gateway shared by the group. When the active fails, the standby assumes the virtual address and hosts keep their configuration.")
    ]

    static let ccnaSimulation = ExamSimulation(
        id: "200-301-exam-day",
        title: "CCNA Exam-Day Simulation",
        description: "A 100-question randomized CCNA 200-301 (v1.1) practice simulation with original multiple-choice questions, PBQ-style matching, and drag-to-order workflows. Scored on a 300-1000 practice scale; Cisco does not publish a fixed official passing score, so treat the threshold as a study convention.",
        timeLimitMinutes: 120,
        targetQuestionCount: 100,
        minimumScaledScore: 300,
        maximumScaledScore: 1000,
        passingScaledScore: 825,
        performanceItems: []
    )

    static let ccnaHardPerformanceItems: [ExamItem] = [
        ExamItem(
            id: "200-301-hard-pbq-subnet",
            domainID: "200-301-fundamentals",
            kind: .matching,
            prompt: "PBQ: Match each host requirement to the least-waste prefix.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["1,500 hosts", "500 hosts", "60 hosts", "12 hosts", "2 point-to-point hosts"],
            matchingAnswers: ["/21", "/23", "/26", "/28", "/30"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "Pick the smallest block that fits: /21 holds 2,046; /23 holds 510; /26 holds 62; /28 holds 14; /30 holds 2 for point-to-point links.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "200-301-hard-pbq-trunk",
            domainID: "200-301-access",
            kind: .ordering,
            prompt: "PBQ: Put the trunk configuration steps in order on a switch.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Create the VLANs that the trunk must carry", "Set the port to trunk mode", "Set the native VLAN to the agreed value", "Prune the allowed VLAN list to what is needed", "Verify with show interfaces trunk"],
            explanation: "VLANs must exist before they can cross a trunk; mode, native VLAN, and allowed list follow; verification closes the loop.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "200-301-hard-pbq-ospf",
            domainID: "200-301-connectivity",
            kind: .multipleSelect,
            prompt: "PBQ: Two routers will not form an OSPF adjacency. Select the settings that must be verified.",
            choices: ["Area number matches", "Hello and dead timers match", "Authentication settings match", "MTU matches", "Hostnames match", "Interface descriptions match"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Area, timers, authentication, and MTU must agree for adjacency. Hostnames and descriptions are cosmetic.",
            points: 4,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "200-301-hard-pbq-acl",
            domainID: "200-301-security",
            kind: .multipleSelect,
            prompt: "PBQ: An extended ACL will filter traffic to a server farm. Select the correct design practices.",
            choices: ["Place extended ACLs close to the traffic source", "Remember the implicit deny at the end", "Order rules from most specific to most general", "Use the established keyword for return traffic where appropriate", "Assume an implicit permit at the end", "Apply the same ACL inbound and outbound without checking direction"],
            correctChoiceIndexes: [0, 1, 2, 3],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: [],
            explanation: "Extended ACLs belong near the source, rules are top-down so specificity order matters, and the implicit deny must be accounted for. There is no implicit permit.",
            points: 4,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "200-301-hard-pbq-nat",
            domainID: "200-301-services",
            kind: .matching,
            prompt: "PBQ: Match each NAT term to its meaning.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: ["Inside local", "Inside global", "Outside local", "Static NAT", "PAT overload"],
            matchingAnswers: ["Private address as seen on the inside", "Public address representing an inside host outside", "Address of an outside host as seen on the inside", "One-to-one permanent address mapping", "Many private addresses sharing one public IP via ports"],
            correctMatches: [0, 1, 2, 3, 4],
            correctOrder: [],
            explanation: "NAT vocabulary separates the address as seen inside from the address as seen outside, and the mapping style used between them.",
            points: 5,
            isPerformanceBased: true
        ),
        ExamItem(
            id: "200-301-hard-pbq-troubleshoot",
            domainID: "200-301-connectivity",
            kind: .ordering,
            prompt: "PBQ: A user cannot reach a remote subnet. Put the diagnostic steps in order.",
            choices: [],
            correctChoiceIndexes: [],
            matchingPrompts: [],
            matchingAnswers: [],
            correctMatches: [],
            correctOrder: ["Confirm the local IP, mask, gateway, and DNS on the host", "Ping the default gateway, then a remote address by IP", "Check the routing table for a matching route", "Verify the return path and any ACLs in the way", "Test name resolution if IPs work but names fail", "Document the fix and verify full functionality"],
            explanation: "Work from the host outward: local config, gateway, routing, return path and filters, then DNS. Document at the end.",
            points: 6,
            isPerformanceBased: true
        )
    ]
}
