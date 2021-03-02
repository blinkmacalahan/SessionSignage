package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.cache.Session


class EventStatsFragment(private val sessions: List<Session>): Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.event_stats_fragment, container, false)
        val statsRecyclerView: RecyclerView = view.findViewById(R.id.event_stats_rv)
        val statsLayoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)
        val statsAdapter = StatsAdapter(sessions, object : StatsAdapter.OnItemClickListener {
            override fun onItemClick(session: Session) {
                activity?.supportFragmentManager?.beginTransaction()?.replace(
                    R.id.display_root,
                    CurrentSessionFragment.newInstance(session),
                    CurrentSessionFragment.TAG
                )?.commit()
            }
        })
        statsRecyclerView.layoutManager = statsLayoutManager
        statsRecyclerView.adapter = statsAdapter
        return view
    }

    companion object {
        const val TAG = "event_stats_fragment"

        fun newInstance(sessions: List<Session>): EventStatsFragment {
            return EventStatsFragment(sessions)
        }
    }
}