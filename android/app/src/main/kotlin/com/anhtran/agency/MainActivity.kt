package com.anhtran.agency

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.android.FlutterFragmentActivity;

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        val flavor = try {
            val buildConfigClass = Class.forName("${this.packageName}.BuildConfig")
            val field = buildConfigClass.getField("FLAVOR")
            field.get(null) as String
        } catch (e: Exception) {
            "unknown"
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flavor")
            .setMethodCallHandler { call, result ->
                result.success(flavor)
            }
    }
}
