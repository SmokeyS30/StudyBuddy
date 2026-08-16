package com.smokeys30.prepnexus.data

enum class Difficulty(val key: String, val title: String, val target: Double) {
    BEGINNER("beginner", "Beginner", 0.65),
    CERTIFICATION_READY("certificationReady", "Certification Ready", 0.78),
    REAL_EXAM("realExam", "Real Exam", 0.84),
    NIGHTMARE("nightmareMode", "Nightmare Mode", 0.90);

    companion object {
        fun fromKey(key: String?): Difficulty = entries.firstOrNull { it.key == key } ?: REAL_EXAM
    }
}

data class ExamDomain(
    val id: String,
    val title: String,
    val weight: Int,
    val focus: String,
    val objectives: List<String>
)

data class StudyTask(
    val id: String,
    val domainId: String,
    val title: String,
    val detail: String,
    val minutes: Int
)

data class Flashcard(
    val id: String,
    val domainId: String,
    val front: String,
    val back: String
)

data class PracticeQuestion(
    val id: String,
    val domainId: String,
    val prompt: String,
    val choices: List<String>,
    val answerIndex: Int,
    val explanation: String
) {
    fun shuffled(): PracticeQuestion {
        val indexed = choices.mapIndexed { index, choice -> index to choice }.shuffled()
        val newAnswer = indexed.indexOfFirst { it.first == answerIndex }.coerceAtLeast(0)
        return copy(
            id = "$id-${System.nanoTime()}",
            choices = indexed.map { it.second },
            answerIndex = newAnswer
        )
    }
}

enum class ExamItemKind(val key: String) {
    SINGLE_CHOICE("singleChoice"),
    MULTIPLE_SELECT("multipleSelect"),
    MATCHING("matching"),
    ORDERING("ordering");

    companion object {
        fun fromKey(key: String): ExamItemKind = entries.firstOrNull { it.key == key } ?: SINGLE_CHOICE
    }
}

data class ExamItem(
    val id: String,
    val domainId: String,
    val kind: ExamItemKind,
    val prompt: String,
    val choices: List<String>,
    val correctChoiceIndexes: List<Int>,
    val matchingPrompts: List<String>,
    val matchingAnswers: List<String>,
    val correctMatches: List<Int>,
    val correctOrder: List<String>,
    val explanation: String,
    val points: Int,
    val isPerformanceBased: Boolean
)

data class ExamSimulation(
    val id: String,
    val title: String,
    val description: String,
    val timeLimitMinutes: Int,
    val targetQuestionCount: Int,
    val minimumScaledScore: Int,
    val maximumScaledScore: Int,
    val passingScaledScore: Int,
    val performanceItems: List<ExamItem>
)

data class ExamProfile(
    val id: String,
    val name: String,
    val code: String,
    val summary: String,
    val domains: List<ExamDomain>,
    val studyTasks: List<StudyTask>,
    val flashcards: List<Flashcard>,
    val practiceQuestions: List<PracticeQuestion>,
    val quickTips: List<String>,
    val disclaimer: String
) {
    fun domainTitle(domainId: String): String = domains.firstOrNull { it.id == domainId }?.title ?: "General"
}

data class CatalogData(
    val schemaVersion: Int,
    val generatedAt: String,
    val exams: List<ExamProfile>,
    val simulations: Map<String, List<ExamSimulation>>,
    val questionBanks: Map<String, Map<Difficulty, List<PracticeQuestion>>>
)

data class AttemptRecord(
    val id: String,
    val examId: String,
    val title: String,
    val difficulty: Difficulty,
    val correct: Int,
    val total: Int,
    val scaledScore: Int,
    val passingScore: Int,
    val durationSeconds: Int,
    val completedAtMillis: Long,
    val domainPercents: Map<String, Double>
) {
    val percent: Double get() = if (total == 0) 0.0 else correct.toDouble() / total
    val passed: Boolean get() = scaledScore >= passingScore
}

enum class AiServerState { CHECKING, ONLINE, OFFLINE }

data class AiHealth(
    val state: AiServerState,
    val message: String,
    val model: String = "--",
    val appAttestMode: String = "unknown"
)

enum class FoldPosture(val label: String) {
    FLAT("Flat"),
    BOOK("Book posture"),
    TABLETOP("Tabletop posture")
}
