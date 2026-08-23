package com.festumevento.cochat

import android.content.Intent
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
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val helloWorldChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "HelloWorld")
        val appOpenedIntent = intent

        if (
            appOpenedIntent != null &&
            appOpenedIntent.action == "com.hiennv.flutter_callkit_incoming.ACTION_CALL_ACCEPT"
        ) {
            val extras = appOpenedIntent.extras
            if (extras != null) {
                helloWorldChannel.invokeMethod("CALL_ACCEPTED_INTENT", fromBundle(extras))
            }
        } else {
            helloWorldChannel.invokeMethod("CHAT_ACCEPTED_INTENT", null)
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
        val extraCallkitData = bundle.getBundle("EXTRA_CALLKIT_CALL_DATA") ?: return HashMap()
        return extraCallkitData.getSerializable(CallkitConstants.EXTRA_CALLKIT_EXTRA)
            as? HashMap<String, Any?>
            ?: HashMap()
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
