package com.example.sessionsignage.shared.cache

import com.example.sessionsignage.shared.db.SeatingInfoAdapter
import com.example.sessionsignage.shared.db.SpeakersAdapter
import com.example.sessionsignage.shared.db.TagsAdapter
import com.example.sessionsignage.shared.sessionEntities.SeatingInfo
import com.example.sessionsignage.shared.sessionEntities.SessionItem
import com.example.sessionsignage.shared.sessionEntities.SessionOverviewItem
import com.example.sessionsignage.shared.sessionEntities.Speaker
import com.example.sessionsignage.shared.sessionEntities.Tag
import com.squareup.sqldelight.Query
import com.squareup.sqldelight.runtime.coroutines.asFlow
import com.squareup.sqldelight.runtime.coroutines.mapToOneNotNull
import kotlinx.coroutines.flow.Flow

internal class Database(databaseDriverFactory: DatabaseDriverFactory) {

    private val database = AppDatabase(
        databaseDriverFactory.createDriver(),
        Session.Adapter(SpeakersAdapter(), SeatingInfoAdapter(), TagsAdapter())
    )
    private val dbQuery = database.appDatabaseQueries

    internal fun clearDatabase() {
        dbQuery.transaction {
            dbQuery.removeAllSessions()
        }
    }

    internal fun getAllSessions(): List<Session> {
        return dbQuery.selectAllSessions(::mapSession).executeAsList()
    }

    internal fun getSessionOverviews(): List<SessionOverviewItem> {
        return dbQuery.selectAllSessionOverviews(::mapSessionOverview).executeAsList()
    }

    internal fun getSessionWithId(sessionId: String): Session? {
        return dbQuery.session(sessionId).executeAsOneOrNull()
    }

    internal fun getSessionOverviewsForLocation(location: String): List<SessionOverviewItem> {
        return dbQuery.selectSessionOverviewsForLocation(location, ::mapSessionOverview).executeAsList()
    }

    internal fun getSessionsForLocation(location: String): List<Session> {
        return dbQuery.selectSessionsForLocation(location, ::mapSession).executeAsList()
    }

    private fun mapSession(
        id: String,
        name: String,
        startTime: String,
        endTime: String,
        desc: String,
        location: String,
        isRecorded: Boolean,
        bannerUrl: String,
        speakers: List<Speaker>,
        seatingInfo: SeatingInfo,
        tags: List<Tag>
    ): Session {
        return Session(
            id = id,
            name = name,
            startTime = startTime,
            endTime = endTime,
            desc = desc,
            location = location,
            isRecorded = isRecorded,
            bannerUrl = bannerUrl,
            speakers = speakers,
            seatingInfo = seatingInfo,
            tags = tags
        )
    }

    private fun mapSessionOverview(
        id: String,
        name: String,
        startTime: String,
        endTime: String,
        desc: String
    ): SessionOverviewItem {
        return SessionOverviewItem(
            id = id,
            name = name,
            startTime = startTime,
            endTime = endTime,
            desc = desc
        )
    }

    internal fun createEvent(sessions: List<SessionItem>) {
        dbQuery.transaction {
            sessions.forEach { session ->
                insertSession(session)
            }
        }
    }

    private fun insertSession(session: SessionItem) {
        dbQuery.insertSession(
            id = session.id,
            name = session.name,
            startTime = session.startTime,
            endTime = session.endTime,
            desc = session.desc,
            location = session.location,
            isRecorded = session.isRecorded,
            bannerUrl = session.bannerUrl,
            speakers = session.speakers,
            seatingInfo = session.seatingInfo,
            tags = session.tags
        )
    }

    var x = 1
    internal fun updateSession(sessionId: String) {
        dbQuery.updateSession("Chris is ready to rock ${x++}", sessionId)
    }

    internal fun observableSessionWithId(sessionId: String): Flow<Session> {
        return dbQuery.session(sessionId).asFlow().mapToOneNotNull()
    }
}