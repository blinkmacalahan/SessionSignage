package com.example.sessionsignage.shared.sessionEntities


import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class SeatingInfo(
    @SerialName("checkedIn")
    val checkedIn: Int,
    @SerialName("open")
    val `open`: Int,
    @SerialName("reserved")
    val reserved: Int
)