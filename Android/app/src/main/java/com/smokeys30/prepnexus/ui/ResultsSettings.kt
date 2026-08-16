package com.smokeys30.prepnexus.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.clickable
import androidx.compose.foundation.horizontalScroll
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
import androidx.compose.material.icons.outlined.Add
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.CloudDone
import androidx.compose.material.icons.outlined.CloudOff
import androidx.compose.material.icons.outlined.DeleteForever
import androidx.compose.material.icons.outlined.Remove
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.FilterChip
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedButton
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.VerticalDivider
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.smokeys30.prepnexus.data.AiServerState
import com.smokeys30.prepnexus.data.AttemptRecord
import com.smokeys30.prepnexus.data.Difficulty
import com.smokeys30.prepnexus.data.FoldPosture
import com.smokeys30.prepnexus.data.PrepNexusStore
import java.time.Instant
import java.time.ZoneId
import java.time.format.DateTimeFormatter

@Composable
fun ResultsScreen(store: PrepNexusStore, twoPane: Boolean) {
    var selected by remember(store.selectedExamId, store.attempts) { mutableStateOf(store.examAttempts.firstOrNull()) }
    if (store.examAttempts.isEmpty()) {
        Column(
            Modifier.fillMaxSize().padding(24.dp),
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            Icon(Icons.Outlined.CheckCircle, contentDescription = null)
            Spacer(Modifier.height(12.dp))
            Text("No results yet", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text("Complete Quick Practice or Real Exam Mode for ${store.exam.code} to start your progress history.")
        }
        return
    }

    val history: @Composable (Modifier) -> Unit = { modifier ->
        LazyColumn(
            modifier.padding(horizontal = 20.dp),
            contentPadding = androidx.compose.foundation.layout.PaddingValues(top = 22.dp, bottom = 28.dp),
            verticalArrangement = Arrangement.spacedBy(12.dp)
        ) {
            item {
                ScreenHeader("Results", "${store.examAttempts.size} attempts for ${store.exam.code}")
            }
            item {
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                    MetricCard("Readiness", store.readiness.asPercent(), Icons.Outlined.CheckCircle, Modifier.weight(1f))
                    MetricCard("Latest", store.examAttempts.first().scaledScore.toString(), Icons.Outlined.CheckCircle, Modifier.weight(1f))
                }
            }
            items(store.examAttempts, key = { it.id }) { attempt ->
                AttemptRow(attempt, selected?.id == attempt.id) { selected = attempt }
            }
        }
    }
    if (twoPane) {
        Row(Modifier.fillMaxSize()) {
            history(Modifier.weight(0.9f).fillMaxHeight())
            VerticalDivider(Modifier.fillMaxHeight())
            AttemptDetail(store, selected ?: store.examAttempts.first(), Modifier.weight(1.1f))
        }
    } else history(Modifier.fillMaxSize())
}

@Composable
private fun AttemptRow(attempt: AttemptRecord, selected: Boolean, onClick: () -> Unit) {
    Card(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick),
        colors = CardDefaults.cardColors(
            containerColor = if (selected) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.surface
        ),
        border = BorderStroke(1.dp, MaterialTheme.colorScheme.outlineVariant)
    ) {
        Row(
            Modifier.fillMaxWidth().padding(14.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(attempt.title, fontWeight = FontWeight.Bold)
                Text("${attempt.difficulty.title}  |  ${formatAttemptDate(attempt.completedAtMillis)}", style = MaterialTheme.typography.bodySmall)
            }
            Column(horizontalAlignment = Alignment.End) {
                Text(attempt.scaledScore.toString(), style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
                Text(if (attempt.passed) "Target met" else "Keep training", style = MaterialTheme.typography.labelMedium)
            }
        }
    }
}

@Composable
private fun AttemptDetail(store: PrepNexusStore, attempt: AttemptRecord, modifier: Modifier) {
    Column(modifier.verticalScroll(rememberScrollState()).padding(22.dp), verticalArrangement = Arrangement.spacedBy(18.dp)) {
        Text("Attempt breakdown", style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
        Text("${attempt.correct}/${attempt.total} fully correct  |  ${formatDuration(attempt.durationSeconds)}")
        Surface(
            color = if (attempt.passed) MaterialTheme.colorScheme.primaryContainer else MaterialTheme.colorScheme.tertiaryContainer,
            shape = MaterialTheme.shapes.medium
        ) {
            Column(Modifier.fillMaxWidth().padding(18.dp)) {
                Text(attempt.scaledScore.toString(), style = MaterialTheme.typography.displaySmall, fontWeight = FontWeight.Bold)
                Text("Study estimate, target ${attempt.passingScore}")
            }
        }
        store.exam.domains.forEach { domain ->
            val value = attempt.domainPercents[domain.id] ?: 0.0
            ProgressRow(domain.title, value, value.asPercent())
        }
        HorizontalDivider()
        Text("Next step", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        val weakest = store.exam.domains.minByOrNull { attempt.domainPercents[it.id] ?: 0.0 }
        Text("Drill ${weakest?.title ?: "your weakest objective"}, then take a new randomized Quick Practice set at ${attempt.difficulty.title}.")
    }
}

@Composable
fun SettingsScreen(store: PrepNexusStore, foldPosture: FoldPosture) {
    var confirmReset by remember { mutableStateOf(false) }
    if (confirmReset) {
        AlertDialog(
            onDismissRequest = { confirmReset = false },
            title = { Text("Reset all progress?") },
            text = { Text("This clears every exam's tasks, flashcards, attempts, results, streak, and study targets on this Android device.") },
            confirmButton = {
                Button(onClick = { confirmReset = false; store.resetAll() }) {
                    Text("Reset everything")
                }
            },
            dismissButton = { OutlinedButton(onClick = { confirmReset = false }) { Text("Cancel") } }
        )
    }

    Column(
        Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(horizontal = 20.dp, vertical = 22.dp),
        verticalArrangement = Arrangement.spacedBy(22.dp)
    ) {
        ScreenHeader("Settings", "PrepNexus: IT Certs")
        SettingsSection("Active exam") {
            ExamSelector(store.catalog.exams, store.selectedExamId, store::selectExam)
            Text(store.exam.summary, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
        }
        SettingsSection("Default difficulty") {
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
        SettingsSection("Daily study target") {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                IconButton(onClick = { store.setPlan(store.dailyMinutes - 5, store.examDateMillis) }) {
                    Icon(Icons.Outlined.Remove, contentDescription = "Reduce target")
                }
                Text("${store.dailyMinutes} minutes", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
                IconButton(onClick = { store.setPlan(store.dailyMinutes + 5, store.examDateMillis) }) {
                    Icon(Icons.Outlined.Add, contentDescription = "Increase target")
                }
            }
        }
        SettingsSection("AI study service") {
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                Icon(
                    if (store.aiHealth.state == AiServerState.ONLINE) Icons.Outlined.CloudDone else Icons.Outlined.CloudOff,
                    contentDescription = null,
                    tint = if (store.aiHealth.state == AiServerState.ONLINE) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.tertiary
                )
                Column {
                    Text(store.aiHealth.message, fontWeight = FontWeight.Bold)
                    Text("Model ${store.aiHealth.model}", style = MaterialTheme.typography.bodySmall)
                }
            }
        }
        SettingsSection("Device layout") {
            Text("Current posture: ${foldPosture.label}")
            Text("The interface adapts to cover, unfolded, split-screen, tablet, and desktop windows.", style = MaterialTheme.typography.bodySmall)
        }
        SettingsSection("Release") {
            Text("Android version 1.0 (1)")
            Text("Shared catalog schema ${store.catalog.schemaVersion}", style = MaterialTheme.typography.bodySmall)
        }
        HorizontalDivider()
        OutlinedButton(onClick = { confirmReset = true }, modifier = Modifier.fillMaxWidth()) {
            Icon(Icons.Outlined.DeleteForever, contentDescription = null)
            Text("Reset all progress")
        }
        Text(store.exam.disclaimer, style = MaterialTheme.typography.bodySmall, color = MaterialTheme.colorScheme.onSurfaceVariant)
    }
}

@Composable
private fun SettingsSection(title: String, content: @Composable () -> Unit) {
    Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
        Text(title, style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
        content()
    }
}

private fun formatAttemptDate(millis: Long): String = Instant.ofEpochMilli(millis)
    .atZone(ZoneId.systemDefault())
    .format(DateTimeFormatter.ofPattern("MMM d, h:mm a"))

private fun formatDuration(seconds: Int): String = if (seconds >= 60) "${seconds / 60}m ${seconds % 60}s" else "${seconds}s"
