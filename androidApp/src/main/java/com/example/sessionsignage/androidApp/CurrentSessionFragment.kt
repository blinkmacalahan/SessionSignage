package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.cache.Session

class CurrentSessionFragment(private val currentSession: Session?): Fragment() {

    private val platform = Platform()
    private lateinit var tagAdapter: TagAdapter

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.current_session_fragment, container, false)
        val tagRecyclerView: RecyclerView = view.findViewById(R.id.current_session_tags_rv)
        tagAdapter = TagAdapter(currentSession?.tags.orEmpty())
        val layoutManager = LinearLayoutManager(context, LinearLayoutManager.HORIZONTAL, false)
        tagRecyclerView.layoutManager = layoutManager
        tagRecyclerView.adapter = tagAdapter
        updateView(view)
        return view
    }

    private fun updateView(view: View) {
        val title: TextView = view.findViewById(R.id.current_session_title)
        val date: TextView = view.findViewById(R.id.current_session_date)
        val time: TextView = view.findViewById(R.id.current_session_time)
        val location: TextView = view.findViewById(R.id.current_session_location)
        title.text = currentSession?.name
        date.text = platform.formatDay(currentSession?.startTime ?: "")
        time.text = platform.formatTime(currentSession?.startTime ?: "")
        location.text = currentSession?.desc
    }

    companion object {
        const val TAG = "current_session_tag"

        fun newInstance(currentSession: Session?): CurrentSessionFragment {
            return CurrentSessionFragment(currentSession)
        }
    }

}