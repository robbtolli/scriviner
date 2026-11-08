package com.tollitech.scrivener.widgets

import android.app.ActivityOptions
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.widget.RemoteViews
import com.tollitech.scrivener.MainActivity
import com.tollitech.scrivener.R
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetPlugin
import es.antonborri.home_widget.HomeWidgetProvider

class CharacterWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId, widgetData)
        }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        super.onDeleted(context, appWidgetIds)
        val widgetData = HomeWidgetPlugin.getData(context)
        val editor = widgetData.edit()
        appWidgetIds.forEach { widgetId ->
            editor.remove("character_widget_${widgetId}_id")
        }
        editor.apply()
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int,
            widgetData: SharedPreferences
        ) {
            val charId = widgetData.getString("character_widget_${widgetId}_id", null)
            val views = RemoteViews(context.packageName, R.layout.character_widget)

            val targetUri = if (charId == null) {
                views.setTextViewText(R.id.widget_character_name, "Select Hero")
                views.setTextViewText(R.id.widget_character_class, "Tap to configure")
                views.setTextViewText(R.id.widget_character_hp, "-- / --")
                views.setProgressBar(R.id.widget_hp_progress, 100, 0, false)
                views.setTextViewText(R.id.widget_action_hint, "CONFIGURE")
                Uri.parse("scrivener://home")
            } else {
                val name = widgetData.getString("character_${charId}_name", "Hero") ?: "Hero"
                val classLevel = widgetData.getString("character_${charId}_class_level", "Adventurer") ?: "Adventurer"
                val currentHp = widgetData.getInt("character_${charId}_current_hp", 10)
                val maxHp = widgetData.getInt("character_${charId}_max_hp", 10).coerceAtLeast(1)

                views.setTextViewText(R.id.widget_character_name, name)
                views.setTextViewText(R.id.widget_character_class, classLevel)
                views.setTextViewText(R.id.widget_character_hp, "$currentHp / $maxHp")
                views.setProgressBar(R.id.widget_hp_progress, maxHp, currentHp.coerceAtLeast(0), false)
                views.setTextViewText(R.id.widget_action_hint, "OPEN ›")
                Uri.parse("scrivener://character?id=$charId")
            }

            val intent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = targetUri
                putExtra("widget_uri", targetUri.toString())
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            var pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                pendingFlags = pendingFlags or PendingIntent.FLAG_IMMUTABLE
            }

            val requestCode = 20000 + widgetId
            val launchIntent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                val options = ActivityOptions.makeBasic()
                if (Build.VERSION.SDK_INT >= 35) {
                    options.setPendingIntentCreatorBackgroundActivityStartMode(
                        ActivityOptions.MODE_BACKGROUND_ACTIVITY_START_ALLOWED
                    )
                } else {
                    options.pendingIntentBackgroundActivityStartMode =
                        ActivityOptions.MODE_BACKGROUND_ACTIVITY_START_ALLOWED
                }
                PendingIntent.getActivity(
                    context,
                    requestCode,
                    intent,
                    pendingFlags,
                    options.toBundle()
                )
            } else {
                PendingIntent.getActivity(context, requestCode, intent, pendingFlags)
            }

            views.setOnClickPendingIntent(R.id.character_widget_container, launchIntent)
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
