package com.example.sessionsignage.shared

import com.example.sessionsignage.shared.cache.Database
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import com.example.sessionsignage.shared.network.GoogleIOApi
import com.example.sessionsignage.shared.sessionEntities.SessionItem
import com.example.sessionsignage.shared.sessionEntities.SessionOverviewItem

class SessionSignageSDK(databaseDriverFactory: DatabaseDriverFactory) {
    private val database = Database(databaseDriverFactory)
    private val api = GoogleIOApi()

    @Throws(Exception::class) suspend fun getSessions(forceReload: Boolean = false): List<SessionItem> {
        val cachedSessions = database.getAllSessions()
        return if (cachedSessions.isNotEmpty() && !forceReload) {
            cachedSessions
        } else {
            syncSessions(api, database)
        }
    }

    @Throws(Exception::class) suspend fun getSessionOverviews(forceReload: Boolean = false): List<SessionOverviewItem> {
        val cachedSessionOverviews = database.getSessionOverviews()
        return if (cachedSessionOverviews.isNotEmpty() && !forceReload) {
            cachedSessionOverviews
        } else {
            syncSessions(api, database).map {
                SessionOverviewItem(it.name, it.description, it.startTime, it.endTime)
            }
        }
    }

    private suspend fun syncSessions(api: GoogleIOApi, database: Database): List<SessionItem> {
        return api.getAllSessions().also { sessions ->
            database.clearDatabase()
            database.createEvent(sessions)
        }
    }
}