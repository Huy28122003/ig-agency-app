package com.anhtran.agency

import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Đọc flavor từ resource theo productFlavor hiện tại
        val raw = try {
            getString(R.string.app_flavor)
        } catch (_: Throwable) {
            "unknown"
        }
        val flavor = normalizeFlavor(raw)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "flavor")
            .setMethodCallHandler { call, result ->
                if (call.method == "getFlavor") result.success(flavor)
                else result.notImplemented()
            }
    }

    private fun normalizeFlavor(v: String): String {
        val x = v.lowercase()
        return when {
            x == "development" || x.contains("dev") -> "development"
            x == "staging" || x.contains("stag") || x.contains("stg") -> "staging"
            x == "production" || x.contains("prod") || x.contains("pro") -> "production"
            else -> "dev"
        }
    }
}
