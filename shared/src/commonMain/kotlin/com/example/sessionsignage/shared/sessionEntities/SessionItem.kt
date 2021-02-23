package com.example.sessionsignage.shared.sessionEntities

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SessionItem(
    @SerialName("id")
    val id: String,
    @SerialName("bannerUrl")
    val bannerUrl: String,
    @SerialName("date")
    val date: String,
    @SerialName("description")
    val description: String,
    @SerialName("endTime")
    val endTime: String,
    @SerialName("isRecorded")
    val isRecorded: Boolean,
    @SerialName("location")
    val location: String,
    @SerialName("name")
    val name: String,
    @SerialName("startTime")
    val startTime: String,
    @SerialName("speakers")
    val speakers: List<Speaker>,
    @SerialName("seatingInfo")
    val seatingInfo: SeatingInfo,
    @SerialName("tags")
    val tags: List<Tag>
)
