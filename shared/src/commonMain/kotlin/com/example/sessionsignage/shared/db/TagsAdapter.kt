package com.example.sessionsignage.shared.db

import com.example.sessionsignage.shared.sessionEntities.Speaker
import com.example.sessionsignage.shared.sessionEntities.Tag
import com.squareup.sqldelight.ColumnAdapter
import kotlinx.serialization.decodeFromString
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class TagsAdapter : ColumnAdapter<List<Tag>, String> {

    override fun decode(databaseValue: String): List<Tag> {
        return Json.decodeFromString(databaseValue)
    }

    override fun encode(value: List<Tag>): String {
        return Json.encodeToString(value)
    }
}