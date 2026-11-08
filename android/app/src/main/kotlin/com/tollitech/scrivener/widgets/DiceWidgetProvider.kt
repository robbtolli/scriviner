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
import es.antonborri.home_widget.HomeWidgetProvider

class DiceWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            updateWidget(context, appWidgetManager, widgetId)
        }
    }

    companion object {
        fun updateWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            widgetId: Int
        ) {
            val uri = Uri.parse("scrivener://dice")
            val intent = Intent(context, MainActivity::class.java).apply {
                action = HomeWidgetLaunchIntent.HOME_WIDGET_LAUNCH_ACTION
                data = uri
                putExtra("widget_uri", uri.toString())
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                        Intent.FLAG_ACTIVITY_CLEAR_TOP or
                        Intent.FLAG_ACTIVITY_SINGLE_TOP
            }

            var pendingFlags = PendingIntent.FLAG_UPDATE_CURRENT
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                pendingFlags = pendingFlags or PendingIntent.FLAG_IMMUTABLE
            }

            val requestCode = 10000 + widgetId
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

            val views = RemoteViews(context.packageName, R.layout.dice_widget).apply {
                setOnClickPendingIntent(R.id.dice_widget_container, launchIntent)
                setOnClickPendingIntent(R.id.widget_dice_icon, launchIntent)
                setOnClickPendingIntent(R.id.widget_dice_label, launchIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
