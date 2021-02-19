package com.example.sessionsignage.shared.sessionEntities

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class Tag(
    @SerialName("color")
    val color: String?,
    @SerialName("name")
    val name: String
)