package com.example.sessionsignage.androidApp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.cache.Session

class StatsAdapter(private val sessions: List<Session>, private val listener: OnItemClickListener):
    RecyclerView.Adapter<StatsAdapter.StatsViewHolder>() {

    interface OnItemClickListener {
        fun onItemClick(session: Session)
    }

    private lateinit var tagLayoutManager: LinearLayoutManager

    class StatsViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val date: TextView = itemView.findViewById(R.id.stat_session_date)
        val name: TextView = itemView.findViewById(R.id.stat_session_name)
        val location: TextView = itemView.findViewById(R.id.stat_session_location)
        val openCount: TextView = itemView.findViewById(R.id.stat_open_count)
        val checkedCount: TextView = itemView.findViewById(R.id.stat_checked_in_count)
        val reservedCount: TextView = itemView.findViewById(R.id.stat_reserved_count)
        val tagRecyclerView: RecyclerView = itemView.findViewById(R.id.stats_tags_rv)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): StatsViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.stat, parent, false)
        tagLayoutManager = LinearLayoutManager(parent.context, LinearLayoutManager.HORIZONTAL, false)
        return StatsViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: StatsViewHolder, position: Int) {
        val session = sessions[position]

        holder.date.text = Platform().formatSessionTime(session.startTime, session.endTime)
        holder.name.text = session.name
        holder.location.text = session.location
        holder.openCount.text = session.seatingInfo.open.toString()
        holder.checkedCount.text = session.seatingInfo.checkedIn.toString()
        holder.reservedCount.text = session.seatingInfo.reserved.toString()

        holder.tagRecyclerView.layoutManager = tagLayoutManager
        val tagAdapter = TagAdapter(session.tags)
        holder.tagRecyclerView.adapter = tagAdapter

        holder.itemView.setOnClickListener {
            listener.onItemClick(session)
        }
    }

    override fun getItemCount(): Int {
        return sessions.size
    }
}