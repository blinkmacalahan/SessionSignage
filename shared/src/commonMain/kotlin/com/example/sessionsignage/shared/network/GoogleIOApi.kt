package com.example.sessionsignage.shared.network

import com.example.sessionsignage.shared.sessionEntities.SessionItem
import io.ktor.client.HttpClient
import io.ktor.client.features.json.JsonFeature
import io.ktor.client.features.json.serializer.KotlinxSerializer
import io.ktor.client.request.get
import kotlinx.serialization.json.Json

class GoogleIOApi {
    companion object {
        private const val SESSIONS_ENDPOINT = "https://blinkmacalahan.github.io/files/google-io-session-info.json"
    }
    private val httpClient = HttpClient {
       install(JsonFeature) {
           val json = Json { ignoreUnknownKeys = true}
           serializer = KotlinxSerializer(json)
       }
    }

    suspend fun getAllSessions(): List<SessionItem> {
        return httpClient.get(SESSIONS_ENDPOINT)
    }
}