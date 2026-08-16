package com.smokeys30.prepnexus.ui

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.outlined.MenuBook
import androidx.compose.material.icons.outlined.BarChart
import androidx.compose.material.icons.outlined.CalendarMonth
import androidx.compose.material.icons.outlined.Home
import androidx.compose.material.icons.outlined.Quiz
import androidx.compose.material.icons.outlined.Settings
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.NavigationRail
import androidx.compose.material3.NavigationRailItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import com.smokeys30.prepnexus.data.AiServiceClient
import com.smokeys30.prepnexus.data.CatalogRepository
import com.smokeys30.prepnexus.data.FoldPosture
import com.smokeys30.prepnexus.data.PrepNexusStore
import kotlinx.coroutines.delay

enum class AppDestination(val label: String, val icon: ImageVector) {
    TODAY("Today", Icons.Outlined.Home),
    PLAN("Plan", Icons.Outlined.CalendarMonth),
    LEARN("Learn", Icons.AutoMirrored.Outlined.MenuBook),
    PRACTICE("Practice", Icons.Outlined.Quiz),
    RESULTS("Results", Icons.Outlined.BarChart),
    SETTINGS("Settings", Icons.Outlined.Settings)
}

@Composable
fun PrepNexusRoot(foldPosture: FoldPosture) {
    val context = LocalContext.current
    val catalog = remember { CatalogRepository(context).load() }
    val store = remember { PrepNexusStore(context, catalog) }
    var showWelcome by remember { mutableStateOf(true) }

    LaunchedEffect(Unit) {
        AiServiceClient().monitor { store.aiHealth = it }
    }
    LaunchedEffect(Unit) {
        delay(5_000)
        showWelcome = false
    }

    Box(Modifier.fillMaxSize()) {
        AppScaffold(store = store, foldPosture = foldPosture)
        AnimatedVisibility(
            visible = showWelcome,
            enter = fadeIn(),
            exit = fadeOut(animationSpec = tween(700))
        ) {
            WelcomeScreen(store.exam.code)
        }
    }
}

@Composable
private fun WelcomeScreen(examCode: String) {
    Box(
        Modifier.fillMaxSize().background(MaterialTheme.colorScheme.primary),
        contentAlignment = Alignment.Center
    ) {
        Column(horizontalAlignment = Alignment.CenterHorizontally) {
            Icon(
                Icons.AutoMirrored.Outlined.MenuBook,
                contentDescription = null,
                modifier = Modifier.size(64.dp),
                tint = MaterialTheme.colorScheme.onPrimary
            )
            Spacer(Modifier.height(24.dp))
            Text("Welcome to", color = MaterialTheme.colorScheme.onPrimary, style = MaterialTheme.typography.titleMedium)
            Text(
                "PrepNexus: IT Certs",
                color = MaterialTheme.colorScheme.onPrimary,
                style = MaterialTheme.typography.headlineMedium,
                fontWeight = FontWeight.Bold
            )
            Spacer(Modifier.height(10.dp))
            Text(examCode, color = MaterialTheme.colorScheme.primaryContainer, style = MaterialTheme.typography.titleSmall)
        }
    }
}

@Composable
private fun AppScaffold(store: PrepNexusStore, foldPosture: FoldPosture) {
    var destination by remember { mutableStateOf(AppDestination.TODAY) }
    LaunchedEffect(store.resetGeneration) { destination = AppDestination.TODAY }

    BoxWithConstraints(Modifier.fillMaxSize()) {
        val useRail = maxWidth >= 600.dp
        val twoPane = maxWidth >= 700.dp && maxHeight >= 480.dp

        if (useRail) {
            Row(Modifier.fillMaxSize()) {
                AnimatedVisibility(visible = !store.practiceInProgress) {
                    NavigationRail {
                        Spacer(Modifier.height(12.dp))
                        AppDestination.entries.forEach { item ->
                            NavigationRailItem(
                                selected = destination == item,
                                onClick = { destination = item },
                                icon = { Icon(item.icon, contentDescription = item.label) },
                                label = { Text(item.label) }
                            )
                        }
                    }
                }
                DestinationContent(destination, store, twoPane, foldPosture, Modifier.weight(1f))
            }
        } else {
            Scaffold(
                bottomBar = {
                    AnimatedVisibility(visible = !store.practiceInProgress) {
                        NavigationBar {
                            AppDestination.entries.forEach { item ->
                                NavigationBarItem(
                                    selected = destination == item,
                                    onClick = { destination = item },
                                    icon = { Icon(item.icon, contentDescription = item.label) },
                                    label = { Text(item.label) }
                                )
                            }
                        }
                    }
                }
            ) { padding ->
                DestinationContent(destination, store, false, foldPosture, Modifier.padding(padding))
            }
        }
    }
}

@Composable
private fun DestinationContent(
    destination: AppDestination,
    store: PrepNexusStore,
    twoPane: Boolean,
    foldPosture: FoldPosture,
    modifier: Modifier
) {
    AnimatedContent(targetState = destination, label = "destination", modifier = modifier.fillMaxSize()) { target ->
        when (target) {
            AppDestination.TODAY -> TodayScreen(store, twoPane, foldPosture)
            AppDestination.PLAN -> PlanScreen(store, twoPane)
            AppDestination.LEARN -> LearnScreen(store, twoPane)
            AppDestination.PRACTICE -> PracticeScreen(store, twoPane)
            AppDestination.RESULTS -> ResultsScreen(store, twoPane)
            AppDestination.SETTINGS -> SettingsScreen(store, foldPosture)
        }
    }
}
