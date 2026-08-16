package com.smokeys30.prepnexus

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.produceState
import androidx.window.layout.FoldingFeature
import androidx.window.layout.WindowInfoTracker
import com.smokeys30.prepnexus.data.FoldPosture
import com.smokeys30.prepnexus.ui.PrepNexusRoot
import com.smokeys30.prepnexus.ui.PrepNexusTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            PrepNexusTheme {
                PrepNexusRoot(foldPosture = rememberFoldPosture(this))
            }
        }
    }
}

@Composable
private fun rememberFoldPosture(activity: ComponentActivity): FoldPosture {
    val posture by produceState(initialValue = FoldPosture.FLAT, activity) {
        WindowInfoTracker.getOrCreate(activity).windowLayoutInfo(activity).collect { info ->
            val feature = info.displayFeatures.filterIsInstance<FoldingFeature>().firstOrNull()
            value = when {
                feature?.state != FoldingFeature.State.HALF_OPENED -> FoldPosture.FLAT
                feature.orientation == FoldingFeature.Orientation.VERTICAL -> FoldPosture.BOOK
                else -> FoldPosture.TABLETOP
            }
        }
    }
    return posture
}
