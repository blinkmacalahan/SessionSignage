package com.example.sessionsignage.shared

import platform.Foundation.NSDateFormatter
import platform.Foundation.NSLocale
import platform.UIKit.UIDevice

actual class Platform actual constructor() {
    companion object {

        private val iso8601Format = NSDateFormatter().apply {
            dateFormat = "yyyy-MM-dd'T'HH:mmXXX"
            locale = NSLocale("en_US_POSIX")
        }
        private val timeFormat = NSDateFormatter().apply {
            dateFormat = "h:mma"
            locale = NSLocale("en_US_POSIX")
        }

        private val dateFormat = NSDateFormatter().apply {
            dateFormat = "E. MMMM d"
            locale = NSLocale("en_US_POSIX")
        }
    }

    actual val platform: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
    actual fun formatSessionTime(startTime: String, endTime: String): String {
        val startDate = requireNotNull(iso8601Format.dateFromString(startTime))
        val endDate = requireNotNull(iso8601Format.dateFromString(endTime))
        return "${dateFormat.stringFromDate(startDate)}, ${timeFormat.stringFromDate(startDate)} - ${timeFormat.stringFromDate(endDate)}"
    }
    actual fun formatDay(time: String): String {
        val date = requireNotNull(iso8601Format.dateFromString(time))
        return "${dateFormat.stringFromDate(date)}"
    }
    actual fun formatTime(time: String): String {
        val date = requireNotNull(iso8601Format.dateFromString(time))
        return "${timeFormat.stringFromDate(date)}"
    }
}