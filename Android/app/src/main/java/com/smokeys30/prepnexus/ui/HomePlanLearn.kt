package com.smokeys30.prepnexus.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.outlined.Bolt
import androidx.compose.material.icons.outlined.CalendarMonth
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.LocalFireDepartment
import androidx.compose.material.icons.outlined.Psychology
import androidx.compose.material.icons.outlined.Quiz
import androidx.compose.material3.AssistChip
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.Checkbox
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.LinearProgressIndicator
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.VerticalDivider
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import com.smokeys30.prepnexus.data.AiServerState
import com.smokeys30.prepnexus.data.ExamDomain
import com.smokeys30.prepnexus.data.Flashcard
import com.smokeys30.prepnexus.data.FoldPosture
import com.smokeys30.prepnexus.data.PrepNexusStore
import com.smokeys30.prepnexus.data.StudyTask
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

@Composable
fun TodayScreen(store: PrepNexusStore, twoPane: Boolean, foldPosture: FoldPosture) {
    val main: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(
            modifier = modifier.fillMaxHeight().padding(horizontal = 20.dp),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(top = 22.dp, bottom = 28.dp),
            verticalArrangement = Arrangement.spacedBy(18.dp)
        ) {
            item {
                ScreenHeader(
                    title = "Today",
                    subtitle = "${store.exam.name} ${store.exam.code}",
                    trailing = {
                        ExamSelector(store.catalog.exams, store.selectedExamId, store::selectExam)
                    }
                )
            }
            item {
                val ready = store.hasStartedStudying
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        MetricCard(
                            "Readiness",
                            if (ready) store.readiness.asPercent() else "0%",
                            Icons.Outlined.Psychology,
                            Modifier.weight(1f),
                            dimmed = !ready
                        )
                        MetricCard("Questions", store.questionsAnswered.toString(), Icons.Outlined.Quiz, Modifier.weight(1f), dimmed = !ready)
                    }
                    Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                        MetricCard(
                            "Day streak",
                            if (ready) store.streakDays.toString() else "0",
                            Icons.Outlined.LocalFireDepartment,
                            Modifier.weight(1f),
                            dimmed = !ready
                        )
                        MetricCard("Days to exam", store.daysUntilExam.toString(), Icons.Outlined.CalendarMonth, Modifier.weight(1f))
                    }
                }
            }
            item {
                Surface(color = MaterialTheme.colorScheme.primaryContainer, shape = MaterialTheme.shapes.medium) {
                    Column(Modifier.padding(16.dp)) {
                        Text(
                            if (store.hasStartedStudying) "Recommended target" else "Start with a baseline",
                            style = MaterialTheme.typography.titleMedium,
                            fontWeight = FontWeight.Bold
                        )
                        Spacer(Modifier.height(6.dp))
                        Text(
                            if (store.hasStartedStudying)
                                "Study ${store.dailyMinutes} minutes today. Focus first on the weakest objective from your latest attempt."
                            else
                                "Take a 10-question Quick Practice set. PrepNexus will unlock useful readiness signals after your first result."
                        )
                    }
                }
            }
            item {
                SectionTitle("Daily focus", "Complete a task to start objective progress")
            }
            items(store.exam.studyTasks.filterNot { store.completedTaskIds.contains(it.id) }.take(4), key = { it.id }) { task ->
                TaskLine(task, false) { store.toggleTask(task.id) }
            }
            if (store.exam.studyTasks.all { store.completedTaskIds.contains(it.id) }) {
                item { Text("All current study tasks are complete.", color = MaterialTheme.colorScheme.primary) }
            }
        }
    }

    if (twoPane) {
        Row(Modifier.fillMaxSize()) {
            main(Modifier.weight(1.45f))
            VerticalDivider(Modifier.fillMaxHeight())
            TodayInsightPane(store, foldPosture, Modifier.weight(0.9f))
        }
    } else {
        main(Modifier.fillMaxSize())
    }
}

@Composable
private fun TodayInsightPane(store: PrepNexusStore, foldPosture: FoldPosture, modifier: Modifier) {
    Column(
        modifier.verticalScroll(rememberScrollState()).padding(20.dp),
        verticalArrangement = Arrangement.spacedBy(18.dp)
    ) {
        SectionTitle("Coach notes", "Practical reminders for ${store.exam.code}")
        store.exam.quickTips.take(4).forEachIndexed { index, tip ->
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("${index + 1}", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold)
                Text(tip, style = MaterialTheme.typography.bodyMedium)
            }
        }
        HorizontalDivider()
        SectionTitle("Service", foldPosture.label)
        StatusPill(
            text = store.aiHealth.message,
            positive = store.aiHealth.state == AiServerState.ONLINE
        )
    }
}

@Composable
fun PlanScreen(store: PrepNexusStore, twoPane: Boolean) {
    val taskList: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(
            modifier.fillMaxHeight().padding(horizontal = 20.dp),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(top = 22.dp, bottom = 28.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                ScreenHeader("Plan", "${store.dailyMinutes} minutes daily, ${store.daysUntilExam} days remaining")
            }
            item {
                Surface(color = MaterialTheme.colorScheme.secondaryContainer, shape = MaterialTheme.shapes.medium) {
                    Column(Modifier.padding(16.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                            Icon(Icons.Outlined.Bolt, contentDescription = null, tint = MaterialTheme.colorScheme.secondary)
                            Text("PrepNexus study target", fontWeight = FontWeight.Bold)
                        }
                        Text(
                            if (store.examAttempts.isEmpty())
                                "Your first Quick Practice result will personalize this plan. The starter target is ${store.dailyMinutes} minutes per day."
                            else
                                "Based on recent work, use the first half for your weakest domain, then split the rest between recall and timed questions."
                        )
                        Text(
                            "Target exam date: ${formatDate(store.examDateMillis)}",
                            style = MaterialTheme.typography.labelLarge
                        )
                    }
                }
            }
            store.exam.domains.forEach { domain ->
                item(key = "header-${domain.id}") {
                    val domainTasks = store.exam.studyTasks.filter { it.domainId == domain.id }
                    val completed = domainTasks.count { store.completedTaskIds.contains(it.id) }
                    Column(verticalArrangement = Arrangement.spacedBy(7.dp)) {
                        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                            Text(domain.title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                            Text("$completed/${domainTasks.size}", style = MaterialTheme.typography.labelMedium)
                        }
                        LinearProgressIndicator(
                            progress = { if (domainTasks.isEmpty()) 0f else completed.toFloat() / domainTasks.size },
                            modifier = Modifier.fillMaxWidth().height(7.dp)
                        )
                    }
                }
                items(store.exam.studyTasks.filter { it.domainId == domain.id }, key = { it.id }) { task ->
                    TaskLine(task, store.completedTaskIds.contains(task.id)) { store.toggleTask(task.id) }
                }
            }
        }
    }

    if (twoPane) {
        Row(Modifier.fillMaxSize()) {
            taskList(Modifier.weight(1.45f))
            VerticalDivider(Modifier.fillMaxHeight())
            DomainReadinessPane(store, Modifier.weight(0.85f))
        }
    } else taskList(Modifier.fillMaxSize())
}

@Composable
private fun DomainReadinessPane(store: PrepNexusStore, modifier: Modifier) {
    Column(modifier.verticalScroll(rememberScrollState()).padding(20.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) {
        SectionTitle("Objective tracker", "Weighted by task and exam work")
        store.exam.domains.forEach { domain ->
            val tasks = store.exam.studyTasks.filter { it.domainId == domain.id }
            val completion = if (tasks.isEmpty()) 0.0 else tasks.count { store.completedTaskIds.contains(it.id) }.toDouble() / tasks.size
            ProgressRow(domain.title, completion, "${domain.weight}%")
        }
    }
}

private enum class LearnSection(val title: String) {
    OBJECTIVES("Objectives"), FLASHCARDS("Flashcards"), LABS("Labs"), SHEETS("Sheets")
}

@Composable
fun LearnScreen(store: PrepNexusStore, twoPane: Boolean) {
    var section by remember(store.selectedExamId) { mutableStateOf(LearnSection.OBJECTIVES) }
    Column(Modifier.fillMaxSize()) {
        Column(Modifier.padding(start = 20.dp, end = 20.dp, top = 22.dp)) {
            ScreenHeader("Learn", "Study material for ${store.exam.code}")
            Spacer(Modifier.height(14.dp))
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                LearnSection.entries.forEach { item ->
                    FilterChip(
                        selected = section == item,
                        onClick = { section = item },
                        label = { Text(item.title, maxLines = 1, overflow = TextOverflow.Ellipsis) },
                        modifier = Modifier.weight(1f)
                    )
                }
            }
        }
        when (section) {
            LearnSection.OBJECTIVES -> ObjectivesContent(store, twoPane)
            LearnSection.FLASHCARDS -> FlashcardsContent(store, twoPane)
            LearnSection.LABS -> InteractiveLabScreen(store, twoPane)
            LearnSection.SHEETS -> CheatSheetsContent(store, twoPane)
        }
    }
}

@Composable
private fun ObjectivesContent(store: PrepNexusStore, twoPane: Boolean) {
    var selectedDomain by remember(store.selectedExamId) { mutableStateOf(store.exam.domains.first()) }
    if (twoPane) {
        Row(Modifier.fillMaxSize().padding(top = 12.dp)) {
            LazyColumn(Modifier.weight(0.75f).fillMaxHeight(), contentPadding = androidx.compose.foundation.layout.PaddingValues(20.dp)) {
                items(store.exam.domains, key = { it.id }) { domain ->
                    DomainSelector(domain, selectedDomain.id == domain.id) { selectedDomain = domain }
                }
            }
            VerticalDivider(Modifier.fillMaxHeight())
            DomainDetail(selectedDomain, Modifier.weight(1.25f))
        }
    } else {
        LazyColumn(
            Modifier.fillMaxSize(),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(20.dp),
            verticalArrangement = Arrangement.spacedBy(14.dp)
        ) {
            items(store.exam.domains, key = { it.id }) { domain ->
                Card(border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)) {
                    DomainDetail(domain, Modifier.fillMaxWidth())
                }
            }
        }
    }
}

@Composable
private fun DomainSelector(domain: ExamDomain, selected: Boolean, onClick: () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        color = if (selected) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface,
        shape = MaterialTheme.shapes.small
    ) {
        Column(Modifier.padding(14.dp)) {
            Text(domain.title, fontWeight = FontWeight.Bold)
            Text("${domain.weight}% of objectives", style = MaterialTheme.typography.labelMedium)
        }
    }
}

@Composable
private fun DomainDetail(domain: ExamDomain, modifier: Modifier) {
    Column(modifier.verticalScroll(rememberScrollState()).padding(20.dp), verticalArrangement = Arrangement.spacedBy(14.dp)) {
        Text(domain.title, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        Text(domain.focus, color = MaterialTheme.colorScheme.onSurfaceVariant)
        domain.objectives.forEachIndexed { index, objective ->
            Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Text("${index + 1}.", color = MaterialTheme.colorScheme.primary, fontWeight = FontWeight.Bold)
                Text(objective)
            }
        }
    }
}

@Composable
private fun FlashcardsContent(store: PrepNexusStore, twoPane: Boolean) {
    var deck by remember(store.selectedExamId) { mutableStateOf(store.exam.flashcards.shuffled()) }
    var index by remember(store.selectedExamId) { mutableIntStateOf(0) }
    var revealed by remember(store.selectedExamId) { mutableStateOf(false) }
    val card = deck.getOrNull(index)

    Column(
        Modifier.fillMaxSize().padding(20.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center
    ) {
        if (card == null) {
            Text("No flashcards are available for this exam.")
            return@Column
        }
        Text("${index + 1} of ${deck.size}", style = MaterialTheme.typography.labelLarge)
        Spacer(Modifier.height(14.dp))
        Card(
            modifier = Modifier.fillMaxWidth(if (twoPane) 0.72f else 1f).clickable { revealed = true },
            colors = CardDefaults.cardColors(containerColor = MaterialTheme.colorScheme.surface),
            border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
        ) {
            Column(
                Modifier.fillMaxWidth().padding(if (twoPane) 36.dp else 24.dp),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
            ) {
                Text(store.exam.domainTitle(card.domainId), style = MaterialTheme.typography.labelLarge, color = MaterialTheme.colorScheme.primary)
                Spacer(Modifier.height(18.dp))
                Text(card.front, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                Spacer(Modifier.height(24.dp))
                if (revealed) Text(card.back, style = MaterialTheme.typography.bodyLarge)
                else Text("Tap to reveal", color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
        }
        Spacer(Modifier.height(18.dp))
        if (revealed) {
            Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedButton(onClick = { store.markCard(card.id, false); advanceCard(deck, index) { deck = it.first; index = it.second; revealed = false } }) {
                    Text("Review again")
                }
                Button(onClick = { store.markCard(card.id, true); advanceCard(deck, index) { deck = it.first; index = it.second; revealed = false } }) {
                    Text("I know this")
                }
            }
        }
    }
}

private fun advanceCard(deck: List<Flashcard>, index: Int, update: (Pair<List<Flashcard>, Int>) -> Unit) {
    if (index + 1 < deck.size) update(deck to index + 1) else update(deck.shuffled() to 0)
}

@Composable
private fun CheatSheetsContent(store: PrepNexusStore, twoPane: Boolean) {
    var selectedDomain by remember(store.selectedExamId) { mutableStateOf(store.exam.domains.first()) }
    val list: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(modifier, contentPadding = androidx.compose.foundation.layout.PaddingValues(20.dp)) {
            items(store.exam.domains, key = { it.id }) { domain ->
                DomainSelector(domain, selectedDomain.id == domain.id) { selectedDomain = domain }
            }
        }
    }
    val sheet: @Composable (Modifier) -> Unit = { modifier ->
        Column(modifier.verticalScroll(rememberScrollState()).padding(20.dp), verticalArrangement = Arrangement.spacedBy(16.dp)) {
            Text("${selectedDomain.title} Sheet", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text(selectedDomain.focus)
            HorizontalDivider()
            selectedDomain.objectives.forEach { objective ->
                Row(horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    Icon(Icons.Outlined.CheckCircle, contentDescription = null, tint = MaterialTheme.colorScheme.primary)
                    Text(objective)
                }
            }
        }
    }
    if (twoPane) Row(Modifier.fillMaxSize()) {
        list(Modifier.weight(0.75f).fillMaxHeight())
        VerticalDivider(Modifier.fillMaxHeight())
        sheet(Modifier.weight(1.25f))
    } else sheet(Modifier.fillMaxSize())
}

@Composable
private fun TaskLine(task: StudyTask, completed: Boolean, onToggle: () -> Unit) {
    Surface(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onToggle),
        color = if (completed) MaterialTheme.colorScheme.primaryContainer.copy(alpha = 0.55f) else MaterialTheme.colorScheme.surface,
        shape = MaterialTheme.shapes.small,
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
    ) {
        Row(Modifier.padding(12.dp), verticalAlignment = Alignment.Top) {
            Checkbox(checked = completed, onCheckedChange = { onToggle() })
            Column(Modifier.weight(1f).padding(top = 5.dp)) {
                Text(task.title, fontWeight = FontWeight.Bold)
                Text(task.detail, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
            }
            AssistChip(onClick = onToggle, label = { Text("${task.minutes}m") })
        }
    }
}

@Composable
private fun SectionTitle(title: String, subtitle: String) {
    Column {
        Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        Text(subtitle, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

private fun formatDate(millis: Long): String = Instant.ofEpochMilli(millis)
    .atZone(ZoneId.systemDefault())
    .toLocalDate()
    .format(DateTimeFormatter.ofPattern("MMM d, yyyy"))
