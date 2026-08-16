package com.smokeys30.prepnexus.data

import android.content.Context
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableLongStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.core.content.edit
import org.json.JSONArray
import org.json.JSONObject
import java.time.Instant
import java.time.LocalDate
import java.time.ZoneId
import java.time.temporal.ChronoUnit
import java.util.UUID

class PrepNexusStore(context: Context, val catalog: CatalogData) {
    private val preferences = context.getSharedPreferences("prepnexus.progress", Context.MODE_PRIVATE)
    private val defaultExamId = catalog.exams.firstOrNull { it.code == "220-1202" }?.id
        ?: catalog.exams.first().id

    var selectedExamId by mutableStateOf(
        preferences.getString("selectedExamId", defaultExamId)
            ?.takeIf { candidate -> catalog.exams.any { it.id == candidate } }
            ?: defaultExamId
    )
        private set

    var difficulty by mutableStateOf(Difficulty.fromKey(preferences.getString("difficulty", null)))
        private set

    var completedTaskIds by mutableStateOf(loadScopedSet("completedTasks"))
        private set

    var masteredCardIds by mutableStateOf(loadScopedSet("masteredCards"))
        private set

    var answeredQuestionIds by mutableStateOf(loadScopedSet("answeredQuestions"))
        private set

    var attempts by mutableStateOf(loadAttempts())
        private set

    var examDateMillis by mutableLongStateOf(
        preferences.getLong("examDateMillis", System.currentTimeMillis() + 30L * 24L * 60L * 60L * 1000L)
    )
        private set

    var dailyMinutes by mutableIntStateOf(preferences.getInt("dailyMinutes", 45))
        private set

    var aiHealth by mutableStateOf(AiHealth(AiServerState.CHECKING, "Checking AI study service..."))

    var resetGeneration by mutableIntStateOf(0)
        private set

    var practiceInProgress by mutableStateOf(false)
        private set

    private var appOpenDates by mutableStateOf(loadSet("appOpenDates"))

    init {
        markAppOpened()
    }

    val exam: ExamProfile
        get() = catalog.exams.firstOrNull { it.id == selectedExamId } ?: catalog.exams.first()

    val examAttempts: List<AttemptRecord>
        get() = attempts.filter { it.examId == selectedExamId }.sortedByDescending { it.completedAtMillis }

    val hasStartedStudying: Boolean
        get() = completedTaskIds.isNotEmpty() || masteredCardIds.isNotEmpty() ||
            answeredQuestionIds.isNotEmpty() || examAttempts.isNotEmpty()

    val taskProgress: Double
        get() = ratio(completedTaskIds.size, exam.studyTasks.size)

    val flashcardProgress: Double
        get() = ratio(masteredCardIds.size, exam.flashcards.size)

    val questionsAnswered: Int
        get() = examAttempts.sumOf { it.total }.coerceAtLeast(answeredQuestionIds.size)

    val readiness: Double
        get() {
            val scores = examAttempts.take(5).map { it.percent }
            if (scores.isEmpty()) return 0.0
            val scoreSignal = scores.average()
            val coverageSignal = (taskProgress * 0.6) + (flashcardProgress * 0.4)
            return (scoreSignal * 0.8 + coverageSignal * 0.2).coerceIn(0.0, 0.99)
        }

    val daysUntilExam: Long
        get() {
            val target = Instant.ofEpochMilli(examDateMillis).atZone(ZoneId.systemDefault()).toLocalDate()
            return ChronoUnit.DAYS.between(LocalDate.now(), target).coerceAtLeast(0)
        }

    val streakDays: Int
        get() {
            var day = LocalDate.now()
            var count = 0
            while (appOpenDates.contains(day.toString())) {
                count += 1
                day = day.minusDays(1)
            }
            return count
        }

    fun selectExam(examId: String) {
        if (examId == selectedExamId || catalog.exams.none { it.id == examId }) return
        selectedExamId = examId
        preferences.edit { putString("selectedExamId", examId) }
        completedTaskIds = loadScopedSet("completedTasks")
        masteredCardIds = loadScopedSet("masteredCards")
        answeredQuestionIds = loadScopedSet("answeredQuestions")
    }

    fun updateDifficulty(value: Difficulty) {
        difficulty = value
        preferences.edit { putString("difficulty", value.key) }
    }

    fun toggleTask(taskId: String) {
        completedTaskIds = completedTaskIds.toggle(taskId)
        saveScopedSet("completedTasks", completedTaskIds)
        markStudyActivity()
    }

    fun markCard(cardId: String, mastered: Boolean) {
        masteredCardIds = if (mastered) masteredCardIds + cardId else masteredCardIds - cardId
        saveScopedSet("masteredCards", masteredCardIds)
        markStudyActivity()
    }

    fun questionBank(value: Difficulty = difficulty): List<PracticeQuestion> {
        val examBanks = catalog.questionBanks[selectedExamId].orEmpty()
        val primary = examBanks[value].orEmpty().ifEmpty { exam.practiceQuestions }
        val seen = primary.mapTo(mutableSetOf()) { it.prompt.normalizedPrompt() }
        val topUp = examBanks.values.flatten().filter { seen.add(it.prompt.normalizedPrompt()) }
        return primary + topUp
    }

    fun simulations(): List<ExamSimulation> = catalog.simulations[selectedExamId].orEmpty()

    fun recordPractice(
        title: String,
        questions: List<PracticeQuestion>,
        selectedAnswers: Map<Int, Int>,
        elapsedSeconds: Int,
        passingScore: Int
    ): AttemptRecord {
        val correct = questions.indices.count { index -> selectedAnswers[index] == questions[index].answerIndex }
        val domainGroups = questions.indices.groupBy { questions[it].domainId }
        val domainPercents = domainGroups.mapValues { (_, indexes) ->
            indexes.count { selectedAnswers[it] == questions[it].answerIndex }.toDouble() / indexes.size
        }
        val percent = ratio(correct, questions.size)
        return recordSession(
            title = title,
            correct = correct,
            total = questions.size,
            percent = percent,
            elapsedSeconds = elapsedSeconds,
            passingScore = passingScore,
            domainPercents = domainPercents,
            answeredIds = questions.map { it.id }
        )
    }

    fun recordSession(
        title: String,
        correct: Int,
        total: Int,
        percent: Double,
        elapsedSeconds: Int,
        passingScore: Int,
        domainPercents: Map<String, Double>,
        answeredIds: List<String>
    ): AttemptRecord {
        val attempt = AttemptRecord(
            id = UUID.randomUUID().toString(),
            examId = selectedExamId,
            title = title,
            difficulty = difficulty,
            correct = correct,
            total = total,
            scaledScore = 100 + (800 * percent).toInt(),
            passingScore = passingScore,
            durationSeconds = elapsedSeconds,
            completedAtMillis = System.currentTimeMillis(),
            domainPercents = domainPercents
        )
        attempts = listOf(attempt) + attempts
        answeredQuestionIds = answeredQuestionIds + answeredIds
        saveScopedSet("answeredQuestions", answeredQuestionIds)
        saveAttempts()
        markStudyActivity()
        return attempt
    }

    fun setPlan(minutes: Int, targetDateMillis: Long) {
        dailyMinutes = minutes.coerceIn(10, 240)
        examDateMillis = targetDateMillis
        preferences.edit {
            putInt("dailyMinutes", dailyMinutes)
            putLong("examDateMillis", examDateMillis)
        }
    }

    fun updatePracticeState(value: Boolean) {
        practiceInProgress = value
    }

    fun resetAll() {
        preferences.edit { clear() }
        selectedExamId = defaultExamId
        difficulty = Difficulty.REAL_EXAM
        completedTaskIds = emptySet()
        masteredCardIds = emptySet()
        answeredQuestionIds = emptySet()
        attempts = emptyList()
        appOpenDates = emptySet()
        dailyMinutes = 45
        examDateMillis = System.currentTimeMillis() + 30L * 24L * 60L * 60L * 1000L
        markAppOpened()
        resetGeneration += 1
    }

    private fun markAppOpened() {
        appOpenDates = appOpenDates + LocalDate.now().toString()
        saveSet("appOpenDates", appOpenDates)
    }

    private fun markStudyActivity() {
        val values = loadScopedSet("studyActivityDates") + LocalDate.now().toString()
        saveScopedSet("studyActivityDates", values)
    }

    private fun scopedKey(base: String): String = "$base.$selectedExamId"

    private fun loadScopedSet(base: String): Set<String> = loadSet(scopedKey(base))

    private fun saveScopedSet(base: String, values: Set<String>) = saveSet(scopedKey(base), values)

    private fun loadSet(key: String): Set<String> = preferences.getStringSet(key, emptySet()).orEmpty().toSet()

    private fun saveSet(key: String, values: Set<String>) {
        preferences.edit { putStringSet(key, values) }
    }

    private fun loadAttempts(): List<AttemptRecord> = runCatching {
        val array = JSONArray(preferences.getString("attempts", "[]"))
        (0 until array.length()).map { index ->
            val json = array.getJSONObject(index)
            val domains = json.optJSONObject("domains") ?: JSONObject()
            AttemptRecord(
                id = json.getString("id"),
                examId = json.getString("examId"),
                title = json.getString("title"),
                difficulty = Difficulty.fromKey(json.getString("difficulty")),
                correct = json.getInt("correct"),
                total = json.getInt("total"),
                scaledScore = json.getInt("scaledScore"),
                passingScore = json.getInt("passingScore"),
                durationSeconds = json.getInt("durationSeconds"),
                completedAtMillis = json.getLong("completedAtMillis"),
                domainPercents = domains.keys().asSequence().associateWith { domains.getDouble(it) }
            )
        }
    }.getOrDefault(emptyList())

    private fun saveAttempts() {
        val array = JSONArray()
        attempts.forEach { attempt ->
            array.put(JSONObject().apply {
                put("id", attempt.id)
                put("examId", attempt.examId)
                put("title", attempt.title)
                put("difficulty", attempt.difficulty.key)
                put("correct", attempt.correct)
                put("total", attempt.total)
                put("scaledScore", attempt.scaledScore)
                put("passingScore", attempt.passingScore)
                put("durationSeconds", attempt.durationSeconds)
                put("completedAtMillis", attempt.completedAtMillis)
                put("domains", JSONObject(attempt.domainPercents))
            })
        }
        preferences.edit { putString("attempts", array.toString()) }
    }

    private fun Set<String>.toggle(value: String): Set<String> = if (contains(value)) minus(value) else plus(value)

    private fun ratio(value: Int, total: Int): Double = if (total == 0) 0.0 else value.toDouble() / total

    private fun String.normalizedPrompt(): String = lowercase().filter(Char::isLetterOrDigit)
}
