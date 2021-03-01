package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment


class EventStatsFragment: Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View? {
        return super.onCreateView(inflater, container, savedInstanceState)
    }

    companion object {
        const val TAG = "event_stats_fragment"

        fun newInstance(): EventStatsFragment {
            return EventStatsFragment()
        }
    }
}