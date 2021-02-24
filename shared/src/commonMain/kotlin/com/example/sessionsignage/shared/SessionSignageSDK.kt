package com.example.sessionsignage.shared

import com.example.sessionsignage.shared.cache.Database
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import com.example.sessionsignage.shared.cache.Session
import com.example.sessionsignage.shared.network.GoogleIOApi
import com.example.sessionsignage.shared.sessionEntities.SessionOverviewItem
import com.squareup.sqldelight.Query
import kotlinx.coroutines.flow.Flow

class SessionSignageSDK(databaseDriverFactory: DatabaseDriverFactory) {

    private val database = Database(databaseDriverFactory)
    private val api = GoogleIOApi()

    @Throws(Exception::class)
    suspend fun getSessions(forceReload: Boolean = false): List<Session> {
        val cachedSessions = database.getAllSessions()
        return if (cachedSessions.isNotEmpty() && !forceReload) {
            cachedSessions
        } else {
            syncSessions(api, database)
        }
    }

    @Throws(Exception::class)
    suspend fun getSessionOverviews(forceReload: Boolean = false): List<SessionOverviewItem> {
        val cachedSessionOverviews = database.getSessionOverviews()
        return if (cachedSessionOverviews.isNotEmpty() && !forceReload) {
            cachedSessionOverviews
        } else {
            syncSessions(api, database).map {
                SessionOverviewItem(it.id, it.name, it.desc, it.startTime, it.endTime)
            }
        }
    }

    @Throws(Exception::class)
    suspend fun getSessionWithId(sessionId: String): Session? {
        return database.getSessionWithId(sessionId)
    }

    @Throws(Exception::class) suspend fun getSessionOverviewsForLocation(location: String): List<SessionOverviewItem> {
        return database.getSessionOverviewsForLocation(location)
    }

    @Throws(Exception::class) suspend fun updateSession(sessionId: String) {
        database.updateSession(sessionId)
    }


    @Throws(Exception::class) suspend fun getObservableSessionWithId(sessionId: String): CommonFlow<Session> {
        return database.observableSessionWithId(sessionId).asCommonFlow()
    }

    private suspend fun syncSessions(api: GoogleIOApi, database: Database): List<Session> {
        api.getAllSessions().also { sessions ->
            database.clearDatabase()
            database.createEvent(sessions)
        }

        return database.getAllSessions()
    }
}