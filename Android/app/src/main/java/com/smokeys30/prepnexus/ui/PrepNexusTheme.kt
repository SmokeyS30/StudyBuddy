package com.smokeys30.prepnexus.ui

import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp

private val LightColors = lightColorScheme(
    primary = Color(0xFF086B70),
    onPrimary = Color.White,
    primaryContainer = Color(0xFFB5ECEB),
    onPrimaryContainer = Color(0xFF003739),
    secondary = Color(0xFF3457A5),
    onSecondary = Color.White,
    secondaryContainer = Color(0xFFDCE2FF),
    tertiary = Color(0xFF9A4B13),
    tertiaryContainer = Color(0xFFFFDBC7),
    background = Color(0xFFF7FAFA),
    surface = Color(0xFFFFFFFF),
    surfaceVariant = Color(0xFFE4EAEA),
    onSurface = Color(0xFF162020),
    outline = Color(0xFF6F7979),
    error = Color(0xFFB3261E)
)

private val DarkColors = darkColorScheme(
    primary = Color(0xFF8FD1D0),
    onPrimary = Color(0xFF003738),
    primaryContainer = Color(0xFF005052),
    secondary = Color(0xFFB7C4FF),
    tertiary = Color(0xFFFFB68A),
    background = Color(0xFF101414),
    surface = Color(0xFF171C1C),
    surfaceVariant = Color(0xFF3F4949),
    onSurface = Color(0xFFE1E4E3)
)

@Composable
fun PrepNexusTheme(content: @Composable () -> Unit) {
    val context = LocalContext.current
    val dark = isSystemInDarkTheme()
    val colors = when {
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S && dark -> dynamicDarkColorScheme(context)
        Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> dynamicLightColorScheme(context)
        dark -> DarkColors
        else -> LightColors
    }
    MaterialTheme(
        colorScheme = colors,
        shapes = MaterialTheme.shapes.copy(
            extraSmall = androidx.compose.foundation.shape.RoundedCornerShape(4.dp),
            small = androidx.compose.foundation.shape.RoundedCornerShape(6.dp),
            medium = androidx.compose.foundation.shape.RoundedCornerShape(8.dp),
            large = androidx.compose.foundation.shape.RoundedCornerShape(8.dp),
            extraLarge = androidx.compose.foundation.shape.RoundedCornerShape(8.dp)
        ),
        content = content
    )
}
