package com.example.sessionsignage.shared

import java.text.SimpleDateFormat
import java.util.Locale
import java.util.TimeZone

actual class Platform actual constructor() {
    companion object {
        private val iso8601Format = SimpleDateFormat("yyyy-MM-dd'T'HH:mmXXX", Locale.US).apply {
            timeZone = TimeZone.getTimeZone("UTC")
        }
        private val timeFormat = SimpleDateFormat("h:mma", Locale.US)
        private val dateFormat = SimpleDateFormat("E. MMMM d", Locale.US)
    }
    actual val platform: String = "Android ${android.os.Build.VERSION.SDK_INT}"
    actual fun formatSessionTime(startTime: String, endTime: String): String {
        val startDate = requireNotNull(iso8601Format.parse(startTime))
        val endDate = requireNotNull(iso8601Format.parse(endTime))

        return String.format(
            "%s, %s - %s",
            dateFormat.format(startDate),
            timeFormat.format(startDate).toLowerCase(),
            timeFormat.format(endDate).toLowerCase()
        )
    }

    actual fun formatDay(time: String): String {
        return String.format("%s", dateFormat.format(requireNotNull(iso8601Format.parse(time))))
    }
    actual fun formatTime(time: String): String {
        return String.format("%s", timeFormat.format(requireNotNull(iso8601Format.parse(time))).toLowerCase())
    }
}