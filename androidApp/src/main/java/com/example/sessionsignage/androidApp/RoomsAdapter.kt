package com.example.sessionsignage.androidApp

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView


class RoomsAdapter(private val rooms: List<String>, private val listener: OnRoomClickListener):
    RecyclerView.Adapter<RoomsAdapter.RoomsViewHolder>() {

    interface OnRoomClickListener {
        fun onRoomClick(room: String)
    }

    class RoomsViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val name: TextView = itemView.findViewById(R.id.room_name)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RoomsViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.room_item, parent, false)
        return RoomsViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: RoomsViewHolder, position: Int) {
        val room = rooms[position]
        holder.name.text = room
        holder.itemView.setOnClickListener {
            listener.onRoomClick(room)
        }
    }

    override fun getItemCount(): Int {
        return rooms.size
    }
}