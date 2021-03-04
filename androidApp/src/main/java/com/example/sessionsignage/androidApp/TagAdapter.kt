package com.example.sessionsignage.androidApp

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.sessionEntities.Tag

class TagAdapter(private val tags: List<Tag>): RecyclerView.Adapter<TagAdapter.TagViewHolder>() {

    class TagViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val color: View = itemView.findViewById(R.id.tag_color)
        val name: TextView = itemView.findViewById(R.id.tag_name)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TagViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.session_tag, parent, false)
        return TagViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: TagViewHolder, position: Int) {
        val tag = tags[position]
        if (tag.color == null) {
            holder.color.visibility = View.INVISIBLE
        }
        holder.color.background.setTint(Color.parseColor(tag.color))
        holder.name.text = tag.name
    }

    override fun getItemCount(): Int {
        return tags.size
    }
}