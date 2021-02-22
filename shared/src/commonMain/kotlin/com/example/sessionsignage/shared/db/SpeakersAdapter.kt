package com.example.sessionsignage.shared.db

import com.example.sessionsignage.shared.sessionEntities.Speaker
import com.squareup.sqldelight.ColumnAdapter
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class SpeakersAdapter : ColumnAdapter<List<Speaker>, String> {

    override fun decode(databaseValue: String): List<Speaker> {
        return Json.decodeFromString(databaseValue)
    }

    override fun encode(value: List<Speaker>): String {
        return Json.encodeToString(value)
    }
}