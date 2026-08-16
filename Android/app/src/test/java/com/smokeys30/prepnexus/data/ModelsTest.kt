package com.smokeys30.prepnexus.data

import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class ModelsTest {
    @Test
    fun shuffledQuestionKeepsCorrectAnswerAndAllChoices() {
        val question = PracticeQuestion(
            id = "q1",
            domainId = "networking",
            prompt = "Choose the best answer.",
            choices = listOf("A", "B", "C", "D"),
            answerIndex = 2,
            explanation = "C is correct."
        )

        repeat(50) {
            val shuffled = question.shuffled()
            assertEquals(question.choices.toSet(), shuffled.choices.toSet())
            assertEquals("C", shuffled.choices[shuffled.answerIndex])
        }
    }

    @Test
    fun difficultyKeysRoundTrip() {
        Difficulty.entries.forEach { difficulty ->
            assertEquals(difficulty, Difficulty.fromKey(difficulty.key))
        }
        assertEquals(Difficulty.REAL_EXAM, Difficulty.fromKey("unknown"))
    }

    @Test
    fun emptyAttemptPercentIsSafe() {
        val attempt = AttemptRecord(
            id = "attempt",
            examId = "exam",
            title = "Empty",
            difficulty = Difficulty.BEGINNER,
            correct = 0,
            total = 0,
            scaledScore = 100,
            passingScore = 700,
            durationSeconds = 0,
            completedAtMillis = 0,
            domainPercents = emptyMap()
        )

        assertEquals(0.0, attempt.percent, 0.0)
        assertTrue(!attempt.passed)
    }
}
