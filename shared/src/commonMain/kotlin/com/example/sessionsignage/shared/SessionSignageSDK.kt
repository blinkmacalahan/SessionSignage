package com.example.sessionsignage.shared

import com.example.sessionsignage.shared.cache.Database
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import com.example.sessionsignage.shared.network.GoogleIOApi
import com.example.sessionsignage.shared.sessionEntities.SessionItem

class SessionSignageSDK(databaseDriverFactory: DatabaseDriverFactory) {
    private val database = Database(databaseDriverFactory)
    private val api = GoogleIOApi()

    @Throws(Exception::class) suspend fun getSessions(forceReload: Boolean = false): List<SessionItem> {
        val cachedSessions = database.getAllSessions()
        return if (cachedSessions.isNotEmpty() && !forceReload) {
            cachedSessions
        } else {
            api.getAllSessions().also { sessions ->
                database.clearDatabase()
                database.createEvent(sessions)
            }
        }
    }
}