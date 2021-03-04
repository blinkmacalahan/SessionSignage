package com.example.sessionsignage.androidApp

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.sessionsignage.shared.SessionSignageSDK
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import com.example.sessionsignage.shared.cache.Session
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class DisplayActivity : AppCompatActivity() {

    private lateinit var sdk: SessionSignageSDK

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display)

        val displayOption = intent.extras?.getInt(DISPLAY_OPTION)
        val room: String = intent.extras?.getString(SELECTED_ROOM) ?: ""

        lifecycleScope.launchWhenCreated {
            sdk = SessionSignageSDK(DatabaseDriverFactory(this@DisplayActivity))
            val sessionsForRoom = sdk.getSessionsForLocation(room)
            val allSessions = sdk.getSessions()
            val sessionsList = if (room.isNotEmpty() && sessionsForRoom.isNotEmpty()) {
                sessionsForRoom
            } else {
                allSessions
            }
            withContext(Dispatchers.Main) {
                when(displayOption) {
                    1 -> {
                        supportFragmentManager.beginTransaction().replace(
                            R.id.display_root,
                            CurrentSessionFragment.newInstance(sessionsList[0]),
                            CurrentSessionFragment.TAG
                        ).commit()
                    }
                    2 -> {
                        supportFragmentManager.beginTransaction().replace(
                            R.id.display_root,
                            RoomSessionsFragment.newInstance(sessionsList),
                            RoomSessionsFragment.TAG
                        ).commit()
                    }
                    3 -> {
                        supportFragmentManager.beginTransaction().replace(
                            R.id.display_root,
                            EventStatsFragment.newInstance(allSessions),
                            EventStatsFragment.TAG
                        ).commit()
                    }
                }
            }
        }
    }

    fun sessions() {
//        lifecycleScope.launchWhenCreated {
//            sdk = SessionSignageSDK(DatabaseDriverFactory(this@CurrentSessionFragment.requireContext()))
//            val sessions = sdk.getSessionOverviews()
//            val currentSession = sessions[0]
//            val builder = StringBuilder()
//            for (session in sessions) {
//                builder.append(session.name)
//                builder.append(": ")
//                builder.append(platform.formatSessionTime(session.startTime, session.endTime))
//                builder.append("\n")
//            }
//            withContext(Dispatchers.Main) {
//                //title.text = builder.toString().trim()
//            }

//            // Listen for updates to a particular session
//            launch {
//                sdk.getObservableSessionWithId("a8ca402e-c376-4daa-93df-6b5cf28b5537").watch {
//                    Log.d("CRR", "session $it")
//                }
//            }
//            // Code to update the session
//            delay(2000)
//            sdk.updateSession("a8ca402e-c376-4daa-93df-6b5cf28b5537")
//            delay(2000)
//            sdk.updateSession("a8ca402e-c376-4daa-93df-6b5cf28b5537")
    // }
    }

    companion object {
        const val DISPLAY_OPTION = "display_option"
        const val SELECTED_ROOM = "selected_room"
    }

}