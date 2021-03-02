package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.cache.Session
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import java.util.Timer
import java.util.TimerTask

class CurrentSessionFragment(private val currentSession: Session): Fragment() {

    private val platform = Platform()
    private lateinit var tagAdapter: TagAdapter
    private lateinit var sessionInfoViews: List<View>
    private var slidePosition = 0

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.current_session_fragment, container, false)
        val tagRecyclerView: RecyclerView = view.findViewById(R.id.current_session_tags_rv)
        val layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
        tagRecyclerView.layoutManager = layoutManager
        tagAdapter = TagAdapter(currentSession.tags)
        tagRecyclerView.adapter = tagAdapter
        sessionInfoViews = getSlideshowViews()
        updateView(view)
        return view
    }

    private fun updateView(view: View) {
        val title: TextView = view.findViewById(R.id.current_session_title)
        val date: TextView = view.findViewById(R.id.current_session_date)
        val time: TextView = view.findViewById(R.id.current_session_time)
        val location: TextView = view.findViewById(R.id.current_session_location)
        val frameLayout: FrameLayout = view.findViewById(R.id.current_session_frame)
        title.text = currentSession.name
        date.text = platform.formatDay(currentSession.startTime)
        time.text = platform.formatTime(currentSession.startTime)
        location.text = currentSession.location

        val timerTask = object : TimerTask() {
            override fun run() {
                runBlocking(Dispatchers.Main) {
                    frameLayout.removeAllViewsInLayout()
                    frameLayout.addView(sessionInfoViews[slidePosition])
                    if (slidePosition < 2) {
                        slidePosition++
                    } else {
                        slidePosition = 0
                    }
                }
            }
        }

        getTimer(timerTask)
    }

    private fun getSlideshowViews(): List<View> {
        val layoutInflater = LayoutInflater.from(context)
        val descriptionView = layoutInflater.inflate(R.layout.session_description, null)
        descriptionView.findViewById<TextView>(R.id.session_desc_text).text = currentSession.desc

        val speakerView = layoutInflater.inflate(R.layout.current_session_speakers, null)
        val speakerRecyclerView: RecyclerView = speakerView.findViewById(R.id.speaker_rv)
        val speakerLayoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
        speakerRecyclerView.layoutManager = speakerLayoutManager
        val speakerAdapter = SpeakerAdapter(currentSession.speakers)
        speakerRecyclerView.adapter = speakerAdapter

        val seatingView = layoutInflater.inflate(R.layout.current_session_seating, null)
        seatingView.findViewById<TextView>(R.id.seating_open_count).text = currentSession.seatingInfo.open.toString()
        seatingView.findViewById<TextView>(R.id.seating_checked_in_count).text = currentSession.seatingInfo.checkedIn.toString()
        seatingView.findViewById<TextView>(R.id.seating_reserved_count).text = currentSession.seatingInfo.reserved.toString()
        return listOf(descriptionView, speakerView, seatingView)
    }

    private fun getTimer(task: TimerTask): Timer {
        val timer = Timer("current_session_timer")
        timer.scheduleAtFixedRate(task, 0, 10000)
        return timer
    }

    companion object {
        const val TAG = "current_session_tag"

        fun newInstance(currentSession: Session): CurrentSessionFragment {
            return CurrentSessionFragment(currentSession)
        }
    }

}