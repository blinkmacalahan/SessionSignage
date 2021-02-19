package com.example.sessionsignage.shared

import com.example.sessionsignage.shared.network.GoogleIOApi
import com.example.sessionsignage.shared.sessionEntities.SessionItem

class SessionSignageSDK {
    private val api = GoogleIOApi()

    @Throws(Exception::class) suspend fun getSessions(): List<SessionItem> {
        return api.getAllSessions()
    }
}