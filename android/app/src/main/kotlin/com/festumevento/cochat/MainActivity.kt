package com.festumevento.cochat

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import com.hiennv.flutter_callkit_incoming.CallkitConstants
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var initialCallData: HashMap<String, Any?>? = null
    private var helloWorldChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        createCallNotificationChannel()
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleIntent(intent)
    }

    private fun createCallNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val notificationManager =
                getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return

            val soundUri =
                Uri.parse("android.resource://" + packageName + "/" + R.raw.ringtone_default)
            val audioAttributes = AudioAttributes.Builder()
                .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                .setUsage(AudioAttributes.USAGE_NOTIFICATION_RINGTONE)
                .build()

            val channelIds = listOf(
                "callkit_incoming_channel_id",
                "incoming_call_channel_id",
                "ChatNest Incoming Calls"
            )

            for (channelId in channelIds) {
                try {
                    notificationManager.deleteNotificationChannel(channelId)
                } catch (_: Exception) {}

                val channel = NotificationChannel(
                    channelId,
                    "Incoming Calls",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Incoming call notifications"
                    setSound(null, null)
                    enableVibration(true)
                    vibrationPattern = longArrayOf(0, 1000, 500, 1000, 500, 1000)
                    lockscreenVisibility = Notification.VISIBILITY_PUBLIC
                    setBypassDnd(true)
                }
                notificationManager.createNotificationChannel(channel)
            }
        }
    }

    private fun handleIntent(intent: Intent?) {
        if (intent != null && intent.action == "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT") {
            val extras = intent.extras
            if (extras != null) {
                val callData = fromBundle(extras)
                initialCallData = callData
                helloWorldChannel?.invokeMethod("CALL_ACCEPTED_INTENT", callData)
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        helloWorldChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "HelloWorld")

        helloWorldChannel?.setMethodCallHandler { call, result ->
            if (call.method == "getInitialAcceptedCall") {
                val data = initialCallData
                initialCallData = null
                result.success(data)
            } else {
                result.notImplemented()
            }
        }

        if (initialCallData != null) {
            helloWorldChannel?.invokeMethod("CALL_ACCEPTED_INTENT", initialCallData)
        }

        val ringtoneChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "custom.ringtone/set")
        ringtoneChannel.setMethodCallHandler { call, result ->
            if (call.method == "setRingtone") {
                val uriString = call.argument<String>("uri")
                if (uriString != null) {
                    setRingtone(Uri.parse(uriString))
                    result.success("Ringtone set successfully")
                } else {
                    result.error("UNAVAILABLE", "Ringtone URI not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    @Suppress("DEPRECATION", "UNCHECKED_CAST")
    private fun fromBundle(bundle: Bundle): HashMap<String, Any?> {
        val extraCallkitData = bundle.getBundle("EXTRA_CALLKIT_CALL_DATA") ?: bundle
        val extra = extraCallkitData.getSerializable(CallkitConstants.EXTRA_CALLKIT_EXTRA)
            as? HashMap<String, Any?>
        if (extra != null && extra.isNotEmpty()) {
            return extra
        }
        val map = HashMap<String, Any?>()
        for (key in extraCallkitData.keySet()) {
            map[key] = extraCallkitData.get(key)
        }
        return map
    }

    private fun setRingtone(uri: Uri) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (Settings.System.canWrite(this)) {
                RingtoneManager.setActualDefaultRingtoneUri(
                    this,
                    RingtoneManager.TYPE_RINGTONE,
                    uri
                )
            } else {
                startActivity(Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS))
            }
        } else {
            RingtoneManager.setActualDefaultRingtoneUri(
                this,
                RingtoneManager.TYPE_RINGTONE,
                uri
            )
        }
    }
}

