package com.smokeys30.prepnexus.data

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject

class CatalogRepository(private val context: Context) {
    fun load(): CatalogData {
        val raw = context.assets.open("exam_catalog.json").bufferedReader().use { it.readText() }
        val root = JSONObject(raw)
        val exams = root.array("exams").objects().map(::parseExam)

        val simulations = buildMap {
            val objectValue = root.getJSONObject("simulations")
            objectValue.keys().forEach { examId ->
                put(examId, objectValue.getJSONArray(examId).objects().map(::parseSimulation))
            }
        }

        val questionBanks = buildMap {
            val banksObject = root.getJSONObject("questionBanks")
            banksObject.keys().forEach { examId ->
                val difficultyObject = banksObject.getJSONObject(examId)
                put(examId, buildMap {
                    Difficulty.entries.forEach { difficulty ->
                        val questions = difficultyObject.optJSONArray(difficulty.key)
                            ?.objects()
                            ?.map(::parseQuestion)
                            .orEmpty()
                        put(difficulty, questions)
                    }
                })
            }
        }

        return CatalogData(
            schemaVersion = root.getInt("schemaVersion"),
            generatedAt = root.getString("generatedAt"),
            exams = exams,
            simulations = simulations,
            questionBanks = questionBanks
        )
    }

    private fun parseExam(json: JSONObject) = ExamProfile(
        id = json.getString("id"),
        name = json.getString("name"),
        code = json.getString("code"),
        summary = json.getString("summary"),
        domains = json.array("domains").objects().map { domain ->
            ExamDomain(
                id = domain.getString("id"),
                title = domain.getString("title"),
                weight = domain.getInt("weight"),
                focus = domain.getString("focus"),
                objectives = domain.array("objectives").strings()
            )
        },
        studyTasks = json.array("studyTasks").objects().map { task ->
            StudyTask(
                id = task.getString("id"),
                domainId = task.getString("domainID"),
                title = task.getString("title"),
                detail = task.getString("detail"),
                minutes = task.getInt("minutes")
            )
        },
        flashcards = json.array("flashcards").objects().map { card ->
            Flashcard(
                id = card.getString("id"),
                domainId = card.getString("domainID"),
                front = card.getString("front"),
                back = card.getString("back")
            )
        },
        practiceQuestions = json.array("practiceQuestions").objects().map(::parseQuestion),
        quickTips = json.array("quickTips").strings(),
        disclaimer = json.getString("disclaimer")
    )

    private fun parseQuestion(json: JSONObject) = PracticeQuestion(
        id = json.getString("id"),
        domainId = json.getString("domainID"),
        prompt = json.getString("prompt"),
        choices = json.array("choices").strings(),
        answerIndex = json.getInt("answerIndex"),
        explanation = json.getString("explanation")
    )

    private fun parseSimulation(json: JSONObject) = ExamSimulation(
        id = json.getString("id"),
        title = json.getString("title"),
        description = json.getString("description"),
        timeLimitMinutes = json.getInt("timeLimitMinutes"),
        targetQuestionCount = json.getInt("targetQuestionCount"),
        minimumScaledScore = json.getInt("minimumScaledScore"),
        maximumScaledScore = json.getInt("maximumScaledScore"),
        passingScaledScore = json.getInt("passingScaledScore"),
        performanceItems = json.array("performanceItems").objects().map { item ->
            ExamItem(
                id = item.getString("id"),
                domainId = item.getString("domainID"),
                kind = ExamItemKind.fromKey(item.getString("kind")),
                prompt = item.getString("prompt"),
                choices = item.array("choices").strings(),
                correctChoiceIndexes = item.array("correctChoiceIndexes").ints(),
                matchingPrompts = item.array("matchingPrompts").strings(),
                matchingAnswers = item.array("matchingAnswers").strings(),
                correctMatches = item.array("correctMatches").ints(),
                correctOrder = item.array("correctOrder").strings(),
                explanation = item.getString("explanation"),
                points = item.getInt("points"),
                isPerformanceBased = item.getBoolean("isPerformanceBased")
            )
        }
    )
}

private fun JSONObject.array(key: String): JSONArray = getJSONArray(key)
private fun JSONArray.objects(): List<JSONObject> = (0 until length()).map(::getJSONObject)
private fun JSONArray.strings(): List<String> = (0 until length()).map(::getString)
private fun JSONArray.ints(): List<Int> = (0 until length()).map(::getInt)
