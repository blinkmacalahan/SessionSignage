package com.example.sessionsignage.shared.sessionEntities

data class SessionOverviewItem(
    val id: Long,
    val name: String,
    val description: String,
    val startTime: String,
    val endTime: String
)