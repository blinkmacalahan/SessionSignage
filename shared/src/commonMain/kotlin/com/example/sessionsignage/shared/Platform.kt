package com.example.sessionsignage.shared

expect class Platform() {
    val platform: String
    fun formatSessionTime(startTime: String, endTime: String): String
    fun formatDay(time: String): String
    fun formatTime(time: String): String
}