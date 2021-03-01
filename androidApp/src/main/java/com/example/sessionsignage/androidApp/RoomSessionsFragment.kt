package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.example.sessionsignage.shared.sessionEntities.SessionOverviewItem

class RoomSessionsFragment(private val sessions: List<SessionOverviewItem>): Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.room_sessions_fragment, container, false)
        updateView(view)
        return view
    }

    private fun updateView(view: View) {}

    companion object {
        const val TAG = "room_sessions_tag"

        fun newInstance(sessions: List<SessionOverviewItem>): RoomSessionsFragment {
            return RoomSessionsFragment(sessions)
        }
    }
}