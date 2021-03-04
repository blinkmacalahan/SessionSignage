package com.example.sessionsignage.androidApp

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.sessionsignage.androidApp.DisplayActivity.Companion.DISPLAY_OPTION
import com.example.sessionsignage.androidApp.DisplayActivity.Companion.SELECTED_ROOM
import com.example.sessionsignage.shared.SessionSignageSDK
import com.example.sessionsignage.shared.cache.DatabaseDriverFactory
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class MainActivity : AppCompatActivity() {

    private lateinit var sdk: SessionSignageSDK

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        var selectedRoom = ""
        val roomLayoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)

        val currentSessionButton: Button = findViewById(R.id.main_current_session_button)
        currentSessionButton.setOnClickListener { startDisplay(1, selectedRoom) }
        val roomSessionButton: Button = findViewById(R.id.main_room_sessions_button)
        roomSessionButton.setOnClickListener { startDisplay(2, selectedRoom) }
        val eventStatsButton: Button = findViewById(R.id.main_event_stats_button)
        eventStatsButton.setOnClickListener { startDisplay(3, selectedRoom) }
        val selectedRoomTextView: TextView = findViewById(R.id.selected_room)
        val roomsRecyclerView: RecyclerView = findViewById(R.id.rooms_list_rv)
        lifecycleScope.launchWhenCreated {
            sdk = SessionSignageSDK(DatabaseDriverFactory(this@MainActivity))
            val rooms = sdk.getAllRooms()
            withContext(Dispatchers.Main) {
                val roomsAdapter = RoomsAdapter(rooms, object : RoomsAdapter.OnRoomClickListener {
                    override fun onRoomClick(room: String) {
                        selectedRoom = room
                        selectedRoomTextView.text = selectedRoom
                    }
                })
                roomsRecyclerView.layoutManager = roomLayoutManager
                roomsRecyclerView.adapter = roomsAdapter
            }
        }
    }

    private fun startDisplay(option: Int, room: String) {
        val intent = Intent(this, DisplayActivity::class.java)
        intent.putExtra(DISPLAY_OPTION, option)
        intent.putExtra(SELECTED_ROOM, room)
        startActivity(intent)
    }
}
