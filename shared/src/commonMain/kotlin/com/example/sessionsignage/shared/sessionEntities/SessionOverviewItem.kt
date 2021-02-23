package com.example.sessionsignage.shared.sessionEntities

data class SessionOverviewItem(
    val id: String,
    val name: String,
    val description: String,
    val startTime: String,
    val endTime: String
)