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

import android.app.KeyguardManager
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    private var initialCallData: HashMap<String, Any?>? = null
    private var helloWorldChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
            val keyguardManager = getSystemService(Context.KEYGUARD_SERVICE) as? KeyguardManager
            keyguardManager?.requestDismissKeyguard(this, null)
        } else {
            @Suppress("DEPRECATION")
            window.addFlags(
                WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED or
                WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD or
                WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON or
                WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON
            )
        }
        createCallNotificationChannel()
        handleIntent(intent)
    }

    override fun onAttachedToWindow() {
        super.onAttachedToWindow()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
            setShowWhenLocked(true)
            setTurnScreenOn(true)
        }
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

            // Unconditionally delete legacy channels that had sounds attached to eliminate double ringing
            val legacyChannelIds = listOf(
                "callkit_incoming_channel_id",
                "incoming_call_channel_id",
                "ChatNest Incoming Calls",
                "callkit_incoming_channel_id_v2"
            )
            for (legacyId in legacyChannelIds) {
                try {
                    notificationManager.deleteNotificationChannel(legacyId)
                } catch (_: Exception) {}
            }

            val channelIds = listOf(
                "callkit_incoming_channel_id",
                "incoming_call_channel_id",
                "ChatNest Incoming Calls"
            )

            for (channelId in channelIds) {
                val channel = NotificationChannel(
                    channelId,
                    "Incoming Calls",
                    NotificationManager.IMPORTANCE_HIGH
                ).apply {
                    description = "Incoming call notifications"
                    setSound(null, null) // FlutterCallkitIncoming plays ringtone directly via MediaPlayer; channel sound must be null to prevent double ringing
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
        if (intent != null) {
            val extras = intent.extras
            if (extras != null) {
                val callData = fromBundle(extras)
                if (intent.action == "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT") {
                    initialCallData = callData
                    helloWorldChannel?.invokeMethod("CALL_ACCEPTED_INTENT", callData)
                } else if (intent.action == "com.hiennv.flutter_callkit_incoming.ACTION_CALL_DECLINE" ||
                           intent.action == "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ENDED") {
                    helloWorldChannel?.invokeMethod("CALL_DECLINED_INTENT", callData)
                }
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

