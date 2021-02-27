package com.example.sessionsignage.androidApp

import android.os.Bundle
import android.widget.Button
import android.widget.FrameLayout
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        actionBar?.hide()

        val currentSessionButton: Button = findViewById(R.id.main_current_session_button)
        currentSessionButton.setOnClickListener { startDisplay(1) }
        val roomSessionButton: Button = findViewById(R.id.main_room_sessions_button)
        roomSessionButton.setOnClickListener { startDisplay(2) }
        val eventStatsButton: Button = findViewById(R.id.main_event_stats_button)
        eventStatsButton.setOnClickListener { startDisplay(3) }
    }

    override fun onBackPressed() {
        val frameLayout = findViewById<FrameLayout>(R.id.main_frame_view)
        supportFragmentManager.popBackStack()
    }

    private fun startDisplay(option: Int) {
        val frameLayout = findViewById<FrameLayout>(R.id.main_frame_view)
        when (option) {
            1 -> {
                frameLayout.removeAllViewsInLayout()
                supportFragmentManager.beginTransaction().replace(
                    R.id.main_frame_view,
                    CurrentSessionFragment.newInstance(),
                    "currentSession"
                ).commit()
            }
            else -> {}
        }
    }
}
