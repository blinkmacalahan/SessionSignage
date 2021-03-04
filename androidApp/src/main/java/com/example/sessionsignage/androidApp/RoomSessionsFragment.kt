package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.TextureView
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.TextView
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.cache.Session

class RoomSessionsFragment(private val room: String, private val sessions: List<Session>): Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.room_sessions_fragment, container, false)
        updateView(view)
        return view
    }

    private fun updateView(view: View) {
        val title: TextView = view.findViewById(R.id.room_title)
        val empty: TextView = view.findViewById(R.id.room_sessions_empty)
        val roomsContainer: LinearLayout = view.findViewById(R.id.room_sessions_container)
        val roomRecyclerView: RecyclerView = view.findViewById(R.id.room_sessions_rv)
        val layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
        val adapter = RoomSessionsAdapter(sessions, object : StatsAdapter.OnItemClickListener {
            override fun onItemClick(session: Session) {
                activity?.supportFragmentManager?.beginTransaction()?.replace(
                    R.id.display_root,
                    CurrentSessionFragment.newInstance(session),
                    CurrentSessionFragment.TAG
                )?.commit()
            }
        })

        title.text = room
        roomRecyclerView.layoutManager = layoutManager
        roomRecyclerView.adapter = adapter

        if (sessions.isEmpty()) {
            empty.visibility = View.VISIBLE
            roomsContainer.visibility = View.INVISIBLE
        }
    }

    companion object {
        const val TAG = "room_sessions_tag"

        fun newInstance(room: String, sessions: List<Session>): RoomSessionsFragment {
            return RoomSessionsFragment(room, sessions)
        }
    }
}