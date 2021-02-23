package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import com.example.sessionsignage.shared.Greeting
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.SessionSignageSDK
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

fun greet(): String {
    return Greeting().greeting()
}

class MainActivity : AppCompatActivity() {

    private val platform = Platform()
    private lateinit var sdk: SessionSignageSDK

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val tv: TextView = findViewById(R.id.text_view)
        tv.text = greet()

        lifecycleScope.launchWhenCreated {
            sdk = SessionSignageSDK(DatabaseDriverFactory(this@MainActivity))
            val sessions = sdk.getSessionOverviews()
            val builder = StringBuilder()
            for (session in sessions) {
                builder.append(session.name)
                builder.append(": ")
                builder.append(platform.formatSessionTime(session.startTime, session.endTime))
                builder.append("\n")
            }
            withContext(Dispatchers.Main) {
                tv.text = builder.toString().trim()
            }
            
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
        }
    }
}
