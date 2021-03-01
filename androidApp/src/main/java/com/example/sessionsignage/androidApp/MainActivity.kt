package com.example.sessionsignage.androidApp

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import com.example.sessionsignage.androidApp.DisplayActivity.Companion.DISPLAY_OPTION

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val currentSessionButton: Button = findViewById(R.id.main_current_session_button)
        currentSessionButton.setOnClickListener { startDisplay(1) }
        val roomSessionButton: Button = findViewById(R.id.main_room_sessions_button)
        roomSessionButton.setOnClickListener { startDisplay(2) }
        val eventStatsButton: Button = findViewById(R.id.main_event_stats_button)
        eventStatsButton.setOnClickListener { startDisplay(3) }
    }

    private fun startDisplay(option: Int) {
        val intent = Intent(this, DisplayActivity::class.java)
        intent.putExtra(DISPLAY_OPTION, option)
        startActivity(intent)
    }
}
