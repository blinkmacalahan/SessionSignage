package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.SessionSignageSDK
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class CurrentSessionFragment: Fragment() {

    private val platform = Platform()
    private lateinit var sdk: SessionSignageSDK

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.current_session_fragment, container, false)
        updateView(view)
        return view
    }

    private fun updateView(view: View) {
        val title: TextView = view.findViewById(R.id.session_title)
        val date: TextView = view.findViewById(R.id.current_session_date)
        val time: TextView = view.findViewById(R.id.current_session_time)
        val desc: TextView = view.findViewById(R.id.session_desc)
        lifecycleScope.launchWhenCreated {
            sdk = SessionSignageSDK(DatabaseDriverFactory(this@CurrentSessionFragment.requireContext()))
            val sessions = sdk.getSessionOverviews()
            val currentSession = sessions[0]
            title.text = currentSession.name
            date.text = platform.formatDay(currentSession.startTime)
            time.text = platform.formatTime(currentSession.startTime)
            desc.text = currentSession.desc
        }
    }

    fun sessions() {
        lifecycleScope.launchWhenCreated {
            sdk = SessionSignageSDK(DatabaseDriverFactory(this@CurrentSessionFragment.requireContext()))
            val sessions = sdk.getSessionOverviews()
            val currentSession = sessions[0]
            val builder = StringBuilder()
            for (session in sessions) {
                builder.append(session.name)
                builder.append(": ")
                builder.append(platform.formatSessionTime(session.startTime, session.endTime))
                builder.append("\n")
            }
            withContext(Dispatchers.Main) {
                //title.text = builder.toString().trim()
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

    companion object {
        fun newInstance(): CurrentSessionFragment {
            return CurrentSessionFragment()
        }
    }
}