package com.smokeys30.prepnexus.data

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.net.HttpURLConnection
import java.net.URL

class AiServiceClient(
    private val baseUrl: String = "https://studybuddy-ai-server-m5zi.onrender.com"
) {
    suspend fun health(): AiHealth = withContext(Dispatchers.IO) {
        runCatching {
            val connection = (URL("${baseUrl.trimEnd('/')}/health").openConnection() as HttpURLConnection).apply {
                requestMethod = "GET"
                connectTimeout = 12_000
                readTimeout = 12_000
                setRequestProperty("Accept", "application/json")
            }
            try {
                val body = connection.inputStream.bufferedReader().use { it.readText() }
                val json = JSONObject(body)
                val attest = json.optJSONObject("appAttest")
                if (connection.responseCode in 200..299 && json.optBoolean("ok")) {
                    AiHealth(
                        state = AiServerState.ONLINE,
                        message = "Study service is online. Android AI tutoring unlocks after Play Integrity setup.",
                        model = json.optString("model", "--"),
                        appAttestMode = attest?.optString("mode", "unknown") ?: "unknown"
                    )
                } else {
                    AiHealth(AiServerState.OFFLINE, "AI study service returned an unhealthy response.")
                }
            } finally {
                connection.disconnect()
            }
        }.getOrElse {
            AiHealth(AiServerState.OFFLINE, "AI study service is unavailable. Offline study still works.")
        }
    }

    suspend fun monitor(onUpdate: (AiHealth) -> Unit) {
        repeat(3) { attempt ->
            val health = health()
            onUpdate(health)
            if (health.state == AiServerState.ONLINE) return
            delay((attempt + 1) * 4_000L)
            onUpdate(AiHealth(AiServerState.CHECKING, "Retrying AI study service..."))
        }
    }
}
