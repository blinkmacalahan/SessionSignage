package com.example.sessionsignage.shared.cache

import com.example.sessionsignage.shared.db.SeatingInfoAdapter
import com.example.sessionsignage.shared.db.SpeakersAdapter
import com.example.sessionsignage.shared.db.TagsAdapter
import com.example.sessionsignage.shared.sessionEntities.SeatingInfo
import com.example.sessionsignage.shared.sessionEntities.SessionItem
import com.example.sessionsignage.shared.sessionEntities.SessionOverviewItem
import com.example.sessionsignage.shared.sessionEntities.Speaker
import com.example.sessionsignage.shared.sessionEntities.Tag

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

    internal fun getAllSessions(): List<SessionItem> {
        return dbQuery.selectAllSessions(::mapSession).executeAsList()
    }

    internal fun getSessionOverviews(): List<SessionOverviewItem> {
        return dbQuery.selectAllSessionOverviews(::mapSessionOverview).executeAsList()
    }

    private fun mapSession(
        name: String,
        startTime: String,
        endTime: String,
        description: String,
        location: String,
        isRecorded: Boolean,
        bannerUrl: String,
        speakers: List<Speaker>,
        seatingInfo: SeatingInfo,
        tags: List<Tag>
    ): SessionItem {
        return SessionItem(
            name = name,
            startTime = startTime,
            endTime = endTime,
            description = description,
            location = location,
            isRecorded = isRecorded,
            bannerUrl = bannerUrl,
            speakers = speakers,
            seatingInfo = seatingInfo,
            tags = tags
        )
    }

    private fun mapSessionOverview(
        name: String,
        startTime: String,
        endTime: String,
        description: String
    ): SessionOverviewItem {
        return SessionOverviewItem(
            name = name,
            startTime = startTime,
            endTime = endTime,
            description = description
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
            name = session.name,
            startTime = session.startTime,
            endTime = session.endTime,
            description = session.description,
            location = session.location,
            isRecorded = session.isRecorded,
            bannerUrl = session.bannerUrl,
            speakers = session.speakers,
            seatingInfo = session.seatingInfo,
            tags = session.tags
        )
    }
}