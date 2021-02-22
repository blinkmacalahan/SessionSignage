package com.example.sessionsignage.shared.db

import com.example.sessionsignage.shared.sessionEntities.SeatingInfo
import com.squareup.sqldelight.ColumnAdapter
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class SeatingInfoAdapter: ColumnAdapter<SeatingInfo, String> {

    override fun decode(databaseValue: String): SeatingInfo {
        return Json.decodeFromString(databaseValue)
    }

    override fun encode(value: SeatingInfo): String {
        return Json.encodeToString(value)
    }
}