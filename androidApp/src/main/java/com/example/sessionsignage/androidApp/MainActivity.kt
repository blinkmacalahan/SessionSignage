package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.example.sessionsignage.shared.Greeting

fun greet(): String {
    return Greeting().greeting()
}

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        actionBar?.hide()

        val title: TextView = findViewById(R.id.main_title)
        title.text = greet()

        val currentSessionButton: Button = findViewById(R.id.main_current_session_button)
        currentSessionButton.setOnClickListener { startDisplay(1) }
        val roomSessionButton: Button = findViewById(R.id.main_room_sessions_button)
        roomSessionButton.setOnClickListener { startDisplay(2) }
        val eventStatsButton: Button = findViewById(R.id.main_event_stats_button)
        eventStatsButton.setOnClickListener { startDisplay(3) }
    }

    private fun startDisplay(option: Int) {
        when (option) {
            1 -> {
                supportFragmentManager.beginTransaction().add(
                    R.id.main_view,
                    CurrentSessionFragment.newInstance(),
                    "currentSession"
                ).commit()
            }
            else -> {}
        }
    }
}
