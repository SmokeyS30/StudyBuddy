package com.smokeys30.prepnexus.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.ArrowBack
import androidx.compose.material.icons.automirrored.outlined.ArrowForward
import androidx.compose.material.icons.outlined.ArrowDownward
import androidx.compose.material.icons.outlined.ArrowUpward
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.Flag
import androidx.compose.material.icons.outlined.GridView
import androidx.compose.material.icons.outlined.Refresh
import androidx.compose.material.icons.outlined.Timer
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.DropdownMenu
import androidx.compose.material3.DropdownMenuItem
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.RadioButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.VerticalDivider
import androidx.compose.runtime.Composable
import androidx.compose.runtime.DisposableEffect
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateMapOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.smokeys30.prepnexus.data.AttemptRecord
import com.smokeys30.prepnexus.data.Difficulty
import com.smokeys30.prepnexus.data.ExamItem
import com.smokeys30.prepnexus.data.ExamItemKind
import com.smokeys30.prepnexus.data.PracticeQuestion
import com.smokeys30.prepnexus.data.PrepNexusStore
import kotlinx.coroutines.delay
import kotlin.math.roundToInt

private data class SessionItem(
    val id: String,
    val domainId: String,
    val kind: ExamItemKind,
    val prompt: String,
    val choices: List<String>,
    val correctChoices: Set<Int>,
    val matchingPrompts: List<String>,
    val matchingAnswers: List<String>,
    val correctMatches: List<Int>,
    val correctOrder: List<String>,
    val explanation: String,
    val points: Int,
    val isPbq: Boolean
) {
    fun score(answer: SessionAnswer): Int = when (kind) {
        ExamItemKind.SINGLE_CHOICE, ExamItemKind.MULTIPLE_SELECT -> if (answer.selected == correctChoices) points else 0
        ExamItemKind.MATCHING -> {
            if (correctMatches.isEmpty()) 0 else ((correctMatches.indices.count { answer.matches[it] == correctMatches[it] }.toDouble() / correctMatches.size) * points).roundToInt()
        }
        ExamItemKind.ORDERING -> {
            if (correctOrder.isEmpty()) 0 else ((correctOrder.indices.count { answer.order.getOrNull(it) == correctOrder[it] }.toDouble() / correctOrder.size) * points).roundToInt()
        }
    }
}

private data class SessionAnswer(
    val selected: Set<Int> = emptySet(),
    val matches: Map<Int, Int> = emptyMap(),
    val order: List<String> = emptyList()
) {
    val isAnswered: Boolean get() = selected.isNotEmpty() || matches.isNotEmpty() || order.isNotEmpty()
}

private data class PracticeSession(
    val id: Long,
    val title: String,
    val items: List<SessionItem>,
    val timeLimitSeconds: Int,
    val passingScore: Int,
    val difficulty: Difficulty
)

private data class CompletedSession(
    val attempt: AttemptRecord,
    val session: PracticeSession,
    val answers: Map<String, SessionAnswer>
)

@Composable
fun PracticeScreen(store: PrepNexusStore, twoPane: Boolean) {
    var session by remember(store.selectedExamId) { mutableStateOf<PracticeSession?>(null) }
    var completed by remember(store.selectedExamId) { mutableStateOf<CompletedSession?>(null) }

    LaunchedEffect(session, completed) {
        store.updatePracticeState(session != null && completed == null)
    }
    DisposableEffect(Unit) {
        onDispose { store.updatePracticeState(false) }
    }

    when {
        completed != null -> PracticeResult(store, completed!!, twoPane) {
            completed = null
            session = null
        }
        session != null -> ActivePractice(store, session!!, twoPane) { answers, elapsed ->
            completed = finishSession(store, session!!, answers, elapsed)
        }
        else -> PracticeLauncher(store, twoPane) { count -> session = createSession(store, count) }
    }
}

@Composable
private fun PracticeLauncher(store: PrepNexusStore, twoPane: Boolean, onStart: (Int) -> Unit) {
    val content: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(
            modifier.padding(horizontal = 20.dp),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(top = 22.dp, bottom = 28.dp),
            verticalArrangement = Arrangement.spacedBy(18.dp)
        ) {
            item { ScreenHeader("Practice", "Randomized sets scoped to ${store.exam.code}") }
            item {
                Text("Difficulty", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                Spacer(Modifier.height(8.dp))
                Row(
                    Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
                    horizontalArrangement = Arrangement.spacedBy(7.dp)
                ) {
                    Difficulty.entries.forEach { difficulty ->
                        FilterChip(
                            selected = store.difficulty == difficulty,
                            onClick = { store.updateDifficulty(difficulty) },
                            label = { Text(difficulty.title, maxLines = 1) }
                        )
                    }
                }
            }
            item {
                PracticeModeCard(
                    title = "Quick Practice",
                    detail = "10 fresh questions, 15 minutes, with a PBQ first at higher difficulty.",
                    action = "Start 10",
                    onStart = { onStart(10) }
                )
            }
            item {
                PracticeModeCard(
                    title = "Real Exam Mode",
                    detail = "90 questions, 90-minute countdown, PBQs first, flagging, review, and explanations after submission.",
                    action = "Start 90",
                    onStart = { onStart(90) }
                )
            }
            item {
                Surface(color = MaterialTheme.colorScheme.tertiaryContainer, shape = MaterialTheme.shapes.medium) {
                    Column(Modifier.padding(15.dp)) {
                        Text("Scoring note", fontWeight = FontWeight.Bold)
                        Text("Scores use a transparent 100-900 study estimate. CompTIA's live item weights and scoring algorithm are proprietary.")
                    }
                }
            }
        }
    }
    if (twoPane) Row(Modifier.fillMaxSize()) {
        content(Modifier.weight(1.25f).fillMaxHeight())
        VerticalDivider(Modifier.fillMaxHeight())
        Column(Modifier.weight(0.75f).padding(24.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("Current exam", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            Text("${store.exam.name}\n${store.exam.code}", style = MaterialTheme.typography.headlineSmall)
            Text("${store.questionBank().size} exam-scoped questions available.")
            Text("The bank is reshuffled and answer positions are randomized every time a session starts.")
        }
    } else content(Modifier.fillMaxSize())
}

@Composable
private fun PracticeModeCard(title: String, detail: String, action: String, onStart: () -> Unit) {
    Card(border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)) {
        Column(Modifier.fillMaxWidth().padding(16.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            Text(title, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text(detail, color = MaterialTheme.colorScheme.onSurfaceVariant)
            Button(onClick = onStart, modifier = Modifier.align(Alignment.End)) { Text(action) }
        }
    }
}

@Composable
private fun ActivePractice(
    store: PrepNexusStore,
    session: PracticeSession,
    twoPane: Boolean,
    onFinish: (Map<String, SessionAnswer>, Int) -> Unit
) {
    val answers = remember(session.id) { mutableStateMapOf<String, SessionAnswer>() }
    val flags = remember(session.id) { mutableStateMapOf<String, Boolean>() }
    val changes = remember(session.id) { mutableStateMapOf<String, Int>() }
    var index by remember(session.id) { mutableIntStateOf(0) }
    var elapsed by remember(session.id) { mutableIntStateOf(0) }
    var questionStartedAt by remember(session.id) { mutableIntStateOf(0) }
    var showReview by remember(session.id) { mutableStateOf(false) }
    var confirmEnd by remember { mutableStateOf(false) }
    val current = session.items[index]
    val remaining = (session.timeLimitSeconds - elapsed).coerceAtLeast(0)

    LaunchedEffect(session.id) {
        while (elapsed < session.timeLimitSeconds) {
            delay(1_000)
            elapsed += 1
        }
        onFinish(answers.toMap(), elapsed)
    }
    LaunchedEffect(index) { questionStartedAt = elapsed }

    if (confirmEnd) {
        AlertDialog(
            onDismissRequest = { confirmEnd = false },
            title = { Text("End this exam?") },
            text = { Text("Unanswered questions will receive no credit. Explanations appear after submission.") },
            confirmButton = { Button(onClick = { confirmEnd = false; onFinish(answers.toMap(), elapsed) }) { Text("End exam") } },
            dismissButton = { OutlinedButton(onClick = { confirmEnd = false }) { Text("Keep working") } }
        )
    }

    Column(Modifier.fillMaxSize()) {
        Row(
            Modifier.fillMaxWidth().statusBarsPadding().padding(horizontal = 18.dp, vertical = 12.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(store.exam.code, style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary)
                Text(session.title, fontWeight = FontWeight.Bold)
            }
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                Icon(Icons.Outlined.Timer, contentDescription = null)
                Text(formatClock(remaining), fontWeight = FontWeight.Bold)
                OutlinedButton(onClick = { confirmEnd = true }) { Text("End") }
            }
        }
        HorizontalDivider()
        if (showReview) {
            ReviewGrid(session, answers, flags, index, onNavigate = { index = it; showReview = false }, onSubmit = { onFinish(answers.toMap(), elapsed) })
        } else if (twoPane) {
            Row(Modifier.weight(1f).fillMaxWidth()) {
                QuestionPane(
                    item = current,
                    answer = answers[current.id] ?: SessionAnswer(),
                    questionNumber = index + 1,
                    total = session.items.size,
                    confidence = inferredConfidence(elapsed - questionStartedAt, changes[current.id] ?: 0, answers[current.id]?.isAnswered == true),
                    onAnswer = { answer -> answers[current.id] = answer; changes[current.id] = (changes[current.id] ?: 0) + 1 },
                    modifier = Modifier.weight(1.35f)
                )
                VerticalDivider(Modifier.fillMaxHeight())
                ExamNavigator(session, answers, flags, index, onNavigate = { index = it }, modifier = Modifier.weight(0.65f))
            }
        } else {
            QuestionPane(
                item = current,
                answer = answers[current.id] ?: SessionAnswer(),
                questionNumber = index + 1,
                total = session.items.size,
                confidence = inferredConfidence(elapsed - questionStartedAt, changes[current.id] ?: 0, answers[current.id]?.isAnswered == true),
                onAnswer = { answer -> answers[current.id] = answer; changes[current.id] = (changes[current.id] ?: 0) + 1 },
                modifier = Modifier.weight(1f)
            )
        }
        Row(
            Modifier.fillMaxWidth().padding(12.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            IconButton(onClick = { flags[current.id] = !(flags[current.id] ?: false) }) {
                Icon(
                    Icons.Outlined.Flag,
                    contentDescription = "Flag for review",
                    tint = if (flags[current.id] == true) MaterialTheme.colorScheme.tertiary else MaterialTheme.colorScheme.onSurface
                )
            }
            Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                OutlinedButton(onClick = { if (index > 0) index -= 1 }, enabled = index > 0) {
                    Icon(Icons.AutoMirrored.Outlined.ArrowBack, contentDescription = null)
                    Text("Back")
                }
                Button(onClick = {
                    if (index + 1 < session.items.size) index += 1 else showReview = true
                }) {
                    Text(if (index + 1 < session.items.size) "Next" else "Review")
                    Icon(if (index + 1 < session.items.size) Icons.AutoMirrored.Outlined.ArrowForward else Icons.Outlined.GridView, contentDescription = null)
                }
            }
        }
    }
}

@Composable
private fun QuestionPane(
    item: SessionItem,
    answer: SessionAnswer,
    questionNumber: Int,
    total: Int,
    confidence: Float,
    onAnswer: (SessionAnswer) -> Unit,
    modifier: Modifier
) {
    Column(modifier.verticalScroll(rememberScrollState()).padding(20.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("Question $questionNumber of $total", style = MaterialTheme.typography.labelLarge)
            if (item.isPbq) StatusPill("PBQ", true)
        }
        ConfidenceSignalBar(confidence)
        Text(item.prompt, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        AnswerEditor(item, answer, onAnswer)
    }
}

@Composable
private fun AnswerEditor(item: SessionItem, answer: SessionAnswer, onAnswer: (SessionAnswer) -> Unit) {
    when (item.kind) {
        ExamItemKind.SINGLE_CHOICE -> item.choices.forEachIndexed { optionIndex, choice ->
            ChoiceRow(choice, answer.selected.contains(optionIndex), false) { onAnswer(answer.copy(selected = setOf(optionIndex))) }
        }
        ExamItemKind.MULTIPLE_SELECT -> {
            Text("Select all that apply.", style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary)
            item.choices.forEachIndexed { optionIndex, choice ->
                ChoiceRow(choice, answer.selected.contains(optionIndex), true) {
                    val selected = if (answer.selected.contains(optionIndex)) answer.selected - optionIndex else answer.selected + optionIndex
                    onAnswer(answer.copy(selected = selected))
                }
            }
        }
        ExamItemKind.MATCHING -> item.matchingPrompts.forEachIndexed { promptIndex, prompt ->
            MatchingRow(prompt, item.matchingAnswers, answer.matches[promptIndex]) { selected ->
                onAnswer(answer.copy(matches = answer.matches + (promptIndex to selected)))
            }
        }
        ExamItemKind.ORDERING -> {
            LaunchedEffect(item.id) {
                if (answer.order.isEmpty()) onAnswer(answer.copy(order = item.correctOrder.shuffled()))
            }
            Text("Move the steps into the best order.", style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary)
            answer.order.forEachIndexed { orderIndex, value ->
                Surface(border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant), shape = MaterialTheme.shapes.small) {
                    Row(Modifier.fillMaxWidth().padding(9.dp), verticalAlignment = Alignment.CenterVertically) {
                        Text("${orderIndex + 1}", fontWeight = FontWeight.Bold, color = MaterialTheme.colorScheme.primary)
                        Text(value, Modifier.weight(1f).padding(horizontal = 10.dp))
                        IconButton(onClick = { if (orderIndex > 0) onAnswer(answer.copy(order = answer.order.move(orderIndex, orderIndex - 1))) }, enabled = orderIndex > 0) {
                            Icon(Icons.Outlined.ArrowUpward, contentDescription = "Move up")
                        }
                        IconButton(onClick = { if (orderIndex + 1 < answer.order.size) onAnswer(answer.copy(order = answer.order.move(orderIndex, orderIndex + 1))) }, enabled = orderIndex + 1 < answer.order.size) {
                            Icon(Icons.Outlined.ArrowDownward, contentDescription = "Move down")
                        }
                    }
                }
            }
        }
    }
}

@Composable
private fun ChoiceRow(text: String, selected: Boolean, multiple: Boolean, onClick: () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        color = if (selected) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface,
        border = BorderStroke(1.dp, if (selected) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.outlineVariant),
        shape = MaterialTheme.shapes.small
    ) {
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.CenterVertically) {
            if (multiple) Checkbox(checked = selected, onCheckedChange = { onClick() })
            else RadioButton(selected = selected, onClick = onClick)
            Text(text, Modifier.padding(start = 8.dp))
        }
    }
}

@Composable
private fun MatchingRow(prompt: String, answers: List<String>, selected: Int?, onSelect: (Int) -> Unit) {
    var expanded by remember { mutableStateOf(false) }
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Text(prompt, fontWeight = FontWeight.Bold)
        Box {
            OutlinedButton(onClick = { expanded = true }, modifier = Modifier.fillMaxWidth()) {
                Text(selected?.let { answers.getOrNull(it) } ?: "Choose a match")
            }
            DropdownMenu(expanded = expanded, onDismissRequest = { expanded = false }) {
                answers.forEachIndexed { index, value ->
                    DropdownMenuItem(text = { Text(value) }, onClick = { expanded = false; onSelect(index) })
                }
            }
        }
    }
}

@Composable
private fun ConfidenceSignalBar(confidence: Float) {
    Column(verticalArrangement = Arrangement.spacedBy(6.dp)) {
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("Confidence signal", style = MaterialTheme.typography.labelMedium)
            Text(
                when { confidence >= 0.75f -> "Strong"; confidence >= 0.5f -> "Narrowed"; else -> "Uncertain" },
                style = MaterialTheme.typography.labelMedium,
                fontWeight = FontWeight.Bold
            )
        }
        Canvas(Modifier.fillMaxWidth().height(12.dp)) {
            drawRoundRect(
                brush = Brush.horizontalGradient(listOf(Color(0xFFC94A4A), Color(0xFFF0A742), Color(0xFF2BAA78))),
                cornerRadius = androidx.compose.ui.geometry.CornerRadius(size.height / 2)
            )
            val x = size.width * confidence.coerceIn(0.04f, 0.96f)
            drawCircle(Color.White, radius = size.height * 0.72f, center = Offset(x, size.height / 2))
            drawCircle(Color(0xFF172121), radius = size.height * 0.42f, center = Offset(x, size.height / 2))
        }
    }
}

@Composable
private fun ExamNavigator(
    session: PracticeSession,
    answers: Map<String, SessionAnswer>,
    flags: Map<String, Boolean>,
    current: Int,
    onNavigate: (Int) -> Unit,
    modifier: Modifier
) {
    LazyColumn(modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
        item { Text("Exam navigator", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold) }
        itemsIndexed(session.items) { index, item ->
            Surface(
                modifier = Modifier.fillMaxWidth().clickable { onNavigate(index) },
                color = when {
                    index == current -> MaterialTheme.colorScheme.primaryContainer
                    answers[item.id]?.isAnswered == true -> MaterialTheme.colorScheme.secondaryContainer
                    else -> MaterialTheme.colorScheme.surface
                },
                shape = MaterialTheme.shapes.small
            ) {
                Row(Modifier.padding(10.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                    Text("${index + 1}. ${if (item.isPbq) "PBQ" else "Question"}")
                    if (flags[item.id] == true) Icon(Icons.Outlined.Flag, contentDescription = "Flagged", tint = MaterialTheme.colorScheme.tertiary)
                }
            }
        }
    }
}

@Composable
private fun ReviewGrid(
    session: PracticeSession,
    answers: Map<String, SessionAnswer>,
    flags: Map<String, Boolean>,
    current: Int,
    onNavigate: (Int) -> Unit,
    onSubmit: () -> Unit
) {
    LazyColumn(
        Modifier.fillMaxSize().padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        item {
            ScreenHeader("Review answers", "${answers.values.count { it.isAnswered }} answered, ${flags.values.count { it }} flagged")
        }
        itemsIndexed(session.items) { index, item ->
            Surface(
                modifier = Modifier.fillMaxWidth().clickable { onNavigate(index) },
                border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant),
                shape = MaterialTheme.shapes.small
            ) {
                Row(Modifier.padding(12.dp), horizontalArrangement = Arrangement.SpaceBetween) {
                    Text("${index + 1}. ${if (item.isPbq) "Performance-based question" else "Question"}")
                    Text(
                        when { flags[item.id] == true -> "Flagged"; answers[item.id]?.isAnswered == true -> "Answered"; else -> "Unanswered" },
                        color = if (answers[item.id]?.isAnswered == true) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.tertiary
                    )
                }
            }
        }
        item { Button(onClick = onSubmit, modifier = Modifier.fillMaxWidth()) { Text("Submit exam") } }
    }
}

@Composable
private fun PracticeResult(store: PrepNexusStore, completed: CompletedSession, twoPane: Boolean, onDone: () -> Unit) {
    val attempt = completed.attempt
    val summary: @Composable (Modifier) -> Unit = { modifier ->
        Column(modifier.verticalScroll(rememberScrollState()).padding(20.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) {
            ScreenHeader("Exam result", completed.session.title)
            Surface(
                color = if (attempt.passed) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.tertiaryContainer,
                shape = MaterialTheme.shapes.medium
            ) {
                Column(Modifier.fillMaxWidth().padding(22.dp), horizontalAlignment = Alignment.CenterHorizontally) {
                    Icon(Icons.Outlined.CheckCircle, contentDescription = null, modifier = Modifier.size(42.dp))
                    Text(attempt.scaledScore.toString(), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                    Text("Study estimate, passing target ${attempt.passingScore}")
                    Text("${attempt.correct} of ${attempt.total} items fully correct")
                }
            }
            store.exam.domains.forEach { domain ->
                val percent = attempt.domainPercents[domain.id] ?: 0.0
                ProgressRow(domain.title, percent, percent.asPercent())
            }
            Button(onClick = onDone, modifier = Modifier.fillMaxWidth()) {
                Icon(Icons.Outlined.Refresh, contentDescription = null)
                Text("Start a fresh set")
            }
        }
    }
    val review: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(modifier.padding(20.dp), verticalArrangement = Arrangement.spacedBy(12.dp)) {
            item { Text("Answer review", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold) }
            items(completed.session.items) { item ->
                val answer = completed.answers[item.id] ?: SessionAnswer()
                val earned = item.score(answer)
                Card(
                    colors = CardDefaults.cardColors(
                        containerColor = if (earned == item.points) MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.45f)
                        else MaterialTheme.colorScheme.surface
                    ),
                    border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
                ) {
                    Column(Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(7.dp)) {
                        Text(item.prompt, fontWeight = FontWeight.Bold)
                        Text("$earned/${item.points} points", color = if (earned == item.points) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.error)
                        Text(item.explanation, color = MaterialTheme.colorScheme.onSurfaceVariant)
                    }
                }
            }
        }
    }
    if (twoPane) Row(Modifier.fillMaxSize()) {
        summary(Modifier.weight(0.8f).fillMaxHeight())
        VerticalDivider(Modifier.fillMaxHeight())
        review(Modifier.weight(1.2f).fillMaxHeight())
    } else summary(Modifier.fillMaxSize())
}

private fun createSession(store: PrepNexusStore, count: Int): PracticeSession {
    val simulation = if (count <= 10) store.simulations().firstOrNull() else store.simulations().lastOrNull()
    val pbqTarget = when (store.difficulty) {
        Difficulty.BEGINNER -> if (count > 10) 1 else 0
        Difficulty.CERTIFICATION_READY -> if (count > 10) 2 else 1
        Difficulty.REAL_EXAM -> if (count > 10) 4 else 1
        Difficulty.NIGHTMARE -> if (count > 10) 6 else 2
    }
    val pbqs = simulation?.performanceItems.orEmpty().shuffled().take(pbqTarget).map(ExamItem::asSessionItem)
    val questions = store.questionBank().shuffled().take((count - pbqs.size).coerceAtLeast(0)).map { it.shuffled().asSessionItem() }
    return PracticeSession(
        id = System.nanoTime(),
        title = if (count <= 10) "Quick Practice" else "Real Exam Mode",
        items = pbqs + questions,
        timeLimitSeconds = (simulation?.timeLimitMinutes ?: if (count <= 10) 15 else 90) * 60,
        passingScore = simulation?.passingScaledScore ?: if (store.exam.code == "SY0-701") 750 else 700,
        difficulty = store.difficulty
    )
}

private fun finishSession(
    store: PrepNexusStore,
    session: PracticeSession,
    answers: Map<String, SessionAnswer>,
    elapsed: Int
): CompletedSession {
    val possible = session.items.sumOf { it.points }.coerceAtLeast(1)
    val earned = session.items.sumOf { it.score(answers[it.id] ?: SessionAnswer()) }
    val fullyCorrect = session.items.count { it.score(answers[it.id] ?: SessionAnswer()) == it.points }
    val domainPercents = session.items.groupBy { it.domainId }.mapValues { (_, items) ->
        val domainPossible = items.sumOf { it.points }.coerceAtLeast(1)
        items.sumOf { it.score(answers[it.id] ?: SessionAnswer()) }.toDouble() / domainPossible
    }
    val attempt = store.recordSession(
        title = session.title,
        correct = fullyCorrect,
        total = session.items.size,
        percent = earned.toDouble() / possible,
        elapsedSeconds = elapsed,
        passingScore = session.passingScore,
        domainPercents = domainPercents,
        answeredIds = session.items.map { it.id }
    )
    return CompletedSession(attempt, session, answers)
}

private fun PracticeQuestion.asSessionItem() = SessionItem(
    id = id,
    domainId = domainId,
    kind = ExamItemKind.SINGLE_CHOICE,
    prompt = prompt,
    choices = choices,
    correctChoices = setOf(answerIndex),
    matchingPrompts = emptyList(),
    matchingAnswers = emptyList(),
    correctMatches = emptyList(),
    correctOrder = emptyList(),
    explanation = explanation,
    points = 1,
    isPbq = false
)

private fun ExamItem.asSessionItem() = SessionItem(
    id = "$id-${System.nanoTime()}",
    domainId = domainId,
    kind = kind,
    prompt = prompt,
    choices = choices,
    correctChoices = correctChoiceIndexes.toSet(),
    matchingPrompts = matchingPrompts,
    matchingAnswers = matchingAnswers,
    correctMatches = correctMatches,
    correctOrder = correctOrder,
    explanation = explanation,
    points = points,
    isPbq = true
)

private fun inferredConfidence(seconds: Int, changes: Int, answered: Boolean): Float = when {
    !answered -> 0.18f
    changes >= 4 -> 0.42f
    seconds <= 22 && changes <= 1 -> 0.88f
    seconds <= 45 && changes <= 2 -> 0.69f
    else -> 0.52f
}

private fun formatClock(seconds: Int): String = "%02d:%02d".format(seconds / 60, seconds % 60)

private fun <T> List<T>.move(from: Int, to: Int): List<T> = toMutableList().apply {
    add(to, removeAt(from))
}
