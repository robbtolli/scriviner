package com.tollitech.scrivener

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.os.Bundle
import com.tollitech.scrivener.widgets.CharacterWidgetProvider
import com.tollitech.scrivener.widgets.DiceWidgetProvider
import es.antonborri.home_widget.HomeWidgetPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private var widgetLaunchChannel: MethodChannel? = null
    private var pendingLaunchUri: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        extractLaunchUri(intent)?.let { uri ->
            pendingLaunchUri = uri
        }
        refreshHomeWidgets()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "com.tollitech.scrivener/widget_launch"
        )
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialLaunchUri" -> {
                    val uri = pendingLaunchUri ?: extractLaunchUri(intent)
                    pendingLaunchUri = null
                    intent?.data = null
                    intent?.removeExtra("widget_uri")
                    result.success(uri)
                }
                else -> result.notImplemented()
            }
        }
        widgetLaunchChannel = channel
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        extractLaunchUri(intent)?.let { uri ->
            val channel = widgetLaunchChannel
            if (channel != null) {
                channel.invokeMethod("onWidgetLaunch", uri)
                intent.data = null
                intent.removeExtra("widget_uri")
            } else {
                pendingLaunchUri = uri
            }
        }
    }

    private fun extractLaunchUri(intent: Intent?): String? {
        if (intent == null) return null
        val extraUri = intent.getStringExtra("widget_uri")
        if (!extraUri.isNullOrEmpty()) return extraUri
        val dataUri = intent.dataString
        if (!dataUri.isNullOrEmpty() && dataUri.startsWith("scrivener://")) {
            return dataUri
        }
        return null
    }

    private fun refreshHomeWidgets() {
        try {
            val ctx = applicationContext
            val manager = AppWidgetManager.getInstance(ctx)

            val diceIds = manager.getAppWidgetIds(
                ComponentName(ctx, DiceWidgetProvider::class.java)
            )
            diceIds.forEach { id ->
                DiceWidgetProvider.updateWidget(ctx, manager, id)
            }

            val widgetData = HomeWidgetPlugin.getData(ctx)
            val charIds = manager.getAppWidgetIds(
                ComponentName(ctx, CharacterWidgetProvider::class.java)
            )
            charIds.forEach { id ->
                CharacterWidgetProvider.updateWidget(ctx, manager, id, widgetData)
            }
        } catch (_: Exception) {
        }
    }
}
