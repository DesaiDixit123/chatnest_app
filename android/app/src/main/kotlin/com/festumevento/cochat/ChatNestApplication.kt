package com.festumevento.cochat

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.os.Build
import io.flutter.app.FlutterApplication

class ChatNestApplication : FlutterApplication() {

    override fun onCreate() {
        super.onCreate()
        setupCallNotificationChannels()
    }

    private fun setupCallNotificationChannels() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return

            // Unconditionally delete legacy channels to purge any cached channel sound in Android OS
            val legacyChannelIds = listOf(
                "callkit_incoming_channel_id",
                "incoming_call_channel_id",
                "ChatNest Incoming Calls",
                "callkit_incoming_channel_id_v2"
            )

            for (channelId in legacyChannelIds) {
                try {
                    notificationManager.deleteNotificationChannel(channelId)
                } catch (_: Exception) {}
            }

            val channel = NotificationChannel(
                "callkit_incoming_channel_id",
                "Incoming Calls",
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = "Incoming call notifications"
                setSound(null, null) // Explicitly silent channel so flutter_callkit_incoming's MediaPlayer is the sole ringtone owner
                enableVibration(true)
                vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500, 1000)
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                setBypassDnd(true)
            }
            notificationManager.createNotificationChannel(channel)
        }
    }
}
