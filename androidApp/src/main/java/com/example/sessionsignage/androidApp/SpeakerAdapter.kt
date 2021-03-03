package com.example.sessionsignage.androidApp

import android.graphics.BitmapFactory
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.shared.sessionEntities.Speaker
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.async
import java.net.URL


class SpeakerAdapter(private val speakers: List<Speaker>): RecyclerView.Adapter<SpeakerAdapter.SpeakerViewHolder>() {

    class SpeakerViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
        val image: ImageView = itemView.findViewById(R.id.speaker_image)
        val name: TextView = itemView.findViewById(R.id.speaker_name)
        val company: TextView = itemView.findViewById(R.id.speaker_company)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): SpeakerViewHolder {
        val itemView = LayoutInflater.from(parent.context).inflate(R.layout.speaker, parent, false)
        return SpeakerViewHolder(itemView)
    }

    override fun onBindViewHolder(holder: SpeakerViewHolder, position: Int) {
        val speaker = speakers[position]
        val url = URL(speaker.img)
        val data = CoroutineScope(Dispatchers.Main).launch {
            val bitmap = async(Dispatchers.IO) {
                BitmapFactory.decodeStream(url.openConnection().getInputStream())
            }
            holder.image.setImageBitmap(bitmap.await())
        }
        holder.name.text = speaker.name
        holder.company.text = speaker.company
    }

    override fun getItemCount(): Int {
        return speakers.size
    }
}