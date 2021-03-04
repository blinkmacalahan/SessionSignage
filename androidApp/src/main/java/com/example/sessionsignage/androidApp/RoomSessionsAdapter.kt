package com.example.sessionsignage.androidApp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.Platform
import com.example.sessionsignage.shared.cache.Session


class RoomSessionsAdapter(private val sessions: List<Session>, private val listener: StatsAdapter.OnItemClickListener):
    RecyclerView.Adapter<RoomSessionsAdapter.RoomSessionsViewHolder>() {

    private val platform = Platform()
    private lateinit var tagLayoutManager: LinearLayoutManager

    class RoomSessionsViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val date: TextView = itemView.findViewById(R.id.session_date)
        val time: TextView = itemView.findViewById(R.id.session_time)
        val name: TextView = itemView.findViewById(R.id.session_title)
        val tagRecyclerView: RecyclerView = itemView.findViewById(R.id.session_tags_rv)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoomSessionsViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.room_session, parent, false)
        tagLayoutManager = LinearLayoutManager(parent.context, LinearLayoutManager.HORIZONTAL, false)
        return RoomSessionsViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: RoomSessionsViewHolder, position: Int) {
        val session = sessions[position]

        if (session.startTime.isNotBlank()) {
            holder.date.text = platform.formatDay(session.startTime)
            holder.time.text = platform.formatTime(session.startTime)
        }
        holder.name.text = session.name
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