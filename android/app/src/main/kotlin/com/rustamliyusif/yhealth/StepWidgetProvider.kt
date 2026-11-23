package com.rustamliyusif.yhealth

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews
import java.text.NumberFormat
import java.util.Locale

class StepWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        render(context, appWidgetManager, appWidgetIds)
    }

    companion object {
        private const val FLUTTER_PREFS = "FlutterSharedPreferences"
        private const val DEFAULT_GOAL = 8000L

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, StepWidgetProvider::class.java))
            if (ids.isNotEmpty()) {
                render(context, manager, ids)
            }
        }

        private fun readGoal(context: Context): Long {
            val prefs = context.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            val raw = prefs.all["flutter.goal_steps"]
            val goal = when (raw) {
                is Long -> raw
                is Int -> raw.toLong()
                is String -> raw.toLongOrNull()
                else -> null
            }
            return if (goal != null && goal > 0) goal else DEFAULT_GOAL
        }

        private fun isAzerbaijani(context: Context): Boolean {
            val prefs = context.getSharedPreferences(FLUTTER_PREFS, Context.MODE_PRIVATE)
            return (prefs.getString("flutter.language_code", "az") ?: "az") == "az"
        }

        private fun format(value: Long): String {
            val nf = NumberFormat.getIntegerInstance(Locale.FRANCE)
            return nf.format(value).replace(' ', ' ').replace(' ', ' ')
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val steps = StepCounterService.getSavedTodaySteps(context)
            val goal = readGoal(context)
            val az = isAzerbaijani(context)
            val percent = ((steps * 100) / goal).coerceIn(0, 100).toInt()
            val remaining = (goal - steps).coerceAtLeast(0)

            val status = when {
                remaining == 0L -> if (az) "Hədəfə çatdın 🎉" else "Goal reached 🎉"
                az -> "${format(remaining)} addım qalıb"
                else -> "${format(remaining)} steps to go"
            }

            val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val pendingIntent = PendingIntent.getActivity(
                context,
                1,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            for (id in ids) {
                val views = RemoteViews(context.packageName, R.layout.step_widget)
                views.setProgressBar(R.id.widget_progress, 100, percent, false)
                views.setTextViewText(R.id.widget_steps, format(steps))
                views.setTextViewText(R.id.widget_goal, "/ ${format(goal)}")
                views.setTextViewText(R.id.widget_status, status)
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                manager.updateAppWidget(id, views)
            }
        }
    }
}
