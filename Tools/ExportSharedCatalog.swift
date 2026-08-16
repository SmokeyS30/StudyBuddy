import Foundation

private struct SharedCatalog: Codable {
    let schemaVersion: Int
    let generatedAt: String
    let exams: [ExamProfile]
    let simulations: [String: [ExamSimulation]]
    let questionBanks: [String: [String: [PracticeQuestion]]]
}

@main
private enum ExportSharedCatalog {
    static func main() throws {
        let outputPath = CommandLine.arguments.dropFirst().first
            ?? "Android/app/src/main/assets/exam_catalog.json"
        let exams = ExamCatalog.exams
        let payload = SharedCatalog(
            schemaVersion: 1,
            generatedAt: ISO8601DateFormatter().string(from: Date()),
            exams: exams,
            simulations: Dictionary(uniqueKeysWithValues: exams.map { exam in
                (exam.id, ExamCatalog.simulations(for: exam.id))
            }),
            questionBanks: Dictionary(uniqueKeysWithValues: exams.map { exam in
                let banks = Dictionary(uniqueKeysWithValues: StudyBuddyDifficultyLevel.allCases.map { difficulty in
                    (difficulty.rawValue, ExamCatalog.practiceQuestions(
                        for: exam.id,
                        difficulty: difficulty,
                        minimumCount: 180
                    ))
                })
                return (exam.id, banks)
            })
        )
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys, .withoutEscapingSlashes]
        let data = try encoder.encode(payload)
        let outputURL = URL(fileURLWithPath: outputPath)
        try FileManager.default.createDirectory(
            at: outputURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try data.write(to: outputURL, options: .atomic)
        print("Exported \(exams.count) exams to \(outputURL.path)")
    }
}
