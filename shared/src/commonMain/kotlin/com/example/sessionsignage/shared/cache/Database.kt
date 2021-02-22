package com.example.sessionsignage.shared.cache

import com.example.sessionsignage.shared.db.SpeakersAdapter
import com.example.sessionsignage.shared.sessionEntities.SessionItem
import com.example.sessionsignage.shared.sessionEntities.Speaker

internal class Database(databaseDriverFactory: DatabaseDriverFactory) {
    private val database = AppDatabase(databaseDriverFactory.createDriver(), Session.Adapter(SpeakersAdapter()))
    private val dbQuery = database.appDatabaseQueries

    internal fun clearDatabase() {
        dbQuery.transaction {
            dbQuery.removeAllSessions()
        }
    }

    internal fun getAllSessions(): List<SessionItem> {
        return dbQuery.selectAllSessions(::mapSession).executeAsList()
    }

    private fun mapSession(
        name: String,
        startTime: String,
        endTime: String,
        description: String,
        location: String,
        isRecorded: Boolean,
        bannerUrl: String,
        seatingId: Long,
        speakers: List<Speaker>
    ): SessionItem {
        return SessionItem(
            name = name,
            startTime = startTime,
            endTime = endTime,
            description = description,
            location = location,
            isRecorded = isRecorded,
            bannerUrl = bannerUrl,
            speakers = speakers
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
            seatingId = 0,
            speakers = session.speakers
        )
    }

//    private fun mapLaunchSelecting(
//        flightNumber: Long,
//        missionName: String,
//        launchYear: Int,
//        rocketId: String,
//        details: String?,
//        launchSuccess: Boolean?,
//        launchDateUTC: String,
//        missionPatchUrl: String?,
//        articleUrl: String?,
//        rocket_id: String?,
//        name: String?,
//        type: String?
//    ): RocketLaunch {
//        return RocketLaunch(
//            flightNumber = flightNumber.toInt(),
//            missionName = missionName,
//            launchYear = launchYear,
//            details = details,
//            launchDateUTC = launchDateUTC,
//            launchSuccess = launchSuccess,
//            rocket = Rocket(
//                id = rocketId,
//                name = name!!,
//                type = type!!
//            ),
//            links = Links(
//                missionPatchUrl = missionPatchUrl,
//                articleUrl = articleUrl
//            )
//        )
//    }
}