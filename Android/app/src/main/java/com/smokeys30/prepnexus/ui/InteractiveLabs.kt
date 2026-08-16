package com.smokeys30.prepnexus.ui

import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.background
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.navigationBarsPadding
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.rememberScrollState
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.Send
import androidx.compose.material.icons.outlined.CheckCircle
import androidx.compose.material.icons.outlined.Refresh
import androidx.compose.material.icons.outlined.Terminal
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.SuggestionChip
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.ImeAction
import androidx.compose.ui.unit.dp
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import com.smokeys30.prepnexus.data.PrepNexusStore

private data class LabMission(
    val id: String,
    val title: String,
    val briefing: String,
    val commands: List<String>,
    val required: Set<String>,
    val responses: Map<String, String>
)

@Composable
fun InteractiveLabScreen(store: PrepNexusStore, twoPane: Boolean) {
    val mission = remember(store.selectedExamId) { missionFor(store.exam.code) }
    val history = remember(store.selectedExamId) {
        mutableStateListOf("PrepNexus isolated lab ready.", mission.briefing, "Type help to view supported commands.")
    }
    val completedCommands = remember(store.selectedExamId) { mutableStateListOf<String>() }
    var input by remember(store.selectedExamId) { mutableStateOf("") }

    fun execute(raw: String) {
        val command = raw.trim().lowercase()
        if (command.isEmpty()) return
        if (command == "clear") {
            history.clear()
            input = ""
            return
        }
        history += "> $command"
        history += when (command) {
            "help" -> "Available: ${mission.commands.joinToString(", ")}"
            else -> mission.responses[command] ?: "Command not available in this isolated simulation. Type help."
        }
        if (command in mission.required && command !in completedCommands) completedCommands += command
        input = ""
    }

    val complete = mission.required.all(completedCommands::contains)
    val brief: @Composable (Modifier) -> Unit = { modifier ->
        Column(modifier.padding(20.dp), verticalArrangement = Arrangement.spacedBy(14.dp)) {
            Text(mission.title, style = MaterialTheme.typography.titleLarge, fontWeight = FontWeight.Bold)
            Text(mission.briefing, color = MaterialTheme.colorScheme.onSurfaceVariant)
            HorizontalDivider()
            Text("Mission checks", style = MaterialTheme.typography.titleMedium, fontWeight = FontWeight.Bold)
            mission.required.forEach { command ->
                Row(horizontalArrangement = Arrangement.spacedBy(9.dp)) {
                    Icon(
                        Icons.Outlined.CheckCircle,
                        contentDescription = null,
                        tint = if (command in completedCommands) MaterialTheme.colorScheme.primary else MaterialTheme.colorScheme.outline
                    )
                    Text(command, fontFamily = FontFamily.Monospace)
                }
            }
            if (complete) {
                Card(border = BorderStroke(1.dp, MaterialTheme.colorScheme.primary)) {
                    Text(
                        "Lab complete. You gathered the required evidence without changing a real device or network.",
                        modifier = Modifier.padding(14.dp),
                        color = MaterialTheme.colorScheme.primary
                    )
                }
            }
        }
    }
    val console: @Composable (Modifier) -> Unit = { modifier ->
        Column(modifier.background(Color(0xFF101817)).navigationBarsPadding().padding(14.dp)) {
            Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Icon(Icons.Outlined.Terminal, contentDescription = null, tint = Color(0xFF89D8C7))
                    Text("PREPNEXUS LAB", color = Color(0xFF89D8C7), fontFamily = FontFamily.Monospace, fontWeight = FontWeight.Bold)
                }
                IconButton(onClick = { history.clear(); completedCommands.clear() }) {
                    Icon(Icons.Outlined.Refresh, contentDescription = "Reset lab", tint = Color.White)
                }
            }
            LazyColumn(Modifier.weight(1f).fillMaxWidth(), verticalArrangement = Arrangement.spacedBy(6.dp)) {
                items(history) { line ->
                    Text(line, color = Color(0xFFE1F4EF), fontFamily = FontFamily.Monospace, style = MaterialTheme.typography.bodySmall)
                }
            }
            Row(Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()), horizontalArrangement = Arrangement.spacedBy(7.dp)) {
                mission.commands.filterNot { it == "clear" }.take(5).forEach { command ->
                    SuggestionChip(onClick = { execute(command) }, label = { Text(command) })
                }
            }
            Spacer(Modifier.height(8.dp))
            OutlinedTextField(
                value = input,
                onValueChange = { input = it },
                modifier = Modifier.fillMaxWidth(),
                placeholder = { Text("Enter a command") },
                singleLine = true,
                keyboardOptions = KeyboardOptions(imeAction = ImeAction.Send),
                keyboardActions = KeyboardActions(onSend = { execute(input) }),
                trailingIcon = {
                    IconButton(onClick = { execute(input) }) {
                        Icon(Icons.AutoMirrored.Outlined.Send, contentDescription = "Run command")
                    }
                }
            )
        }
    }

    if (twoPane) {
        Row(Modifier.fillMaxSize().padding(top = 12.dp)) {
            brief(Modifier.weight(0.8f).fillMaxHeight())
            console(Modifier.weight(1.2f).fillMaxHeight())
        }
    } else {
        Column(Modifier.fillMaxSize().padding(top = 12.dp)) {
            brief(Modifier.fillMaxWidth().weight(0.8f))
            console(Modifier.fillMaxWidth().weight(1.2f))
        }
    }
}

private fun missionFor(code: String): LabMission = when (code) {
    "220-1201" -> LabMission(
        id = "core1-network",
        title = "Network Triage Terminal",
        briefing = "A workstation has a 169.254 address and cannot resolve the internal portal. Prove the fault domain before recommending a fix.",
        commands = listOf("ipconfig /all", "ping 10.0.20.1", "nslookup portal.local", "test cable", "help", "clear"),
        required = setOf("ipconfig /all", "ping 10.0.20.1", "nslookup portal.local", "test cable"),
        responses = mapOf(
            "ipconfig /all" to "IPv4: 169.254.41.22  Mask: 255.255.0.0\nDHCP Enabled: Yes  Gateway: none  DNS: none",
            "ping 10.0.20.1" to "Destination host unreachable. 4 sent, 0 received.",
            "nslookup portal.local" to "DNS request timed out. No DNS server configured.",
            "test cable" to "Pairs 1-2: pass | 3-6: open at 14 m | 4-5: pass | 7-8: pass"
        )
    )
    "SY0-701" -> LabMission(
        id = "security-soc",
        title = "SOC Investigation Console",
        briefing = "EDR detected an encoded command on FIN-042. Validate the alert, collect context, and contain the endpoint.",
        commands = listOf("show alerts", "inspect process", "query dns", "isolate host", "help", "clear"),
        required = setOf("show alerts", "inspect process", "query dns", "isolate host"),
        responses = mapOf(
            "show alerts" to "HIGH FIN-042 powershell.exe encoded command; parent WINWORD.EXE; user e.baker",
            "inspect process" to "WINWORD.EXE -> powershell.exe -enc ... -> rundll32.exe | unsigned child module",
            "query dns" to "FIN-042 queried cdn-update-check.example 37 times; first seen 09:14Z",
            "isolate host" to "FIN-042 isolated from production network. EDR management channel remains active."
        )
    )
    else -> LabMission(
        id = "core2-windows",
        title = "Windows Support Console",
        briefing = "A user can sign in but policy and an internal share fail after a VPN update. Gather identity, network, and service evidence.",
        commands = listOf("whoami", "ipconfig /all", "gpresult /r", "sc query", "help", "clear"),
        required = setOf("whoami", "ipconfig /all", "gpresult /r", "sc query"),
        responses = mapOf(
            "whoami" to "PREPNEXUS\\ebloomfield",
            "ipconfig /all" to "VPN IPv4: 10.90.18.24  DNS: 1.1.1.1  Gateway: on-link\nDNS suffix: none",
            "gpresult /r" to "INFO: The user does not have RSoP data. Domain controller unavailable.",
            "sc query" to "LanmanWorkstation RUNNING\nDnscache RUNNING\nPolicyAgent RUNNING"
        )
    )
}
