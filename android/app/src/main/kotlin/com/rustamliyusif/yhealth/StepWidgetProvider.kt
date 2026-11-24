package com.rustamliyusif.yhealth

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import java.text.NumberFormat
import java.util.Locale

class StepWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        render(context, appWidgetManager, appWidgetIds)
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        render(context, appWidgetManager, intArrayOf(appWidgetId))
    }

    companion object {
        private const val WIDE_MIN_WIDTH_DP = 200

        fun updateAll(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(ComponentName(context, StepWidgetProvider::class.java))
            if (ids.isNotEmpty()) {
                render(context, manager, ids)
            }
        }

        fun format(value: Long): String {
            val nf = NumberFormat.getIntegerInstance(Locale.FRANCE)
            return nf.format(value).replace(' ', ' ').replace(' ', ' ')
        }

        private fun isWide(manager: AppWidgetManager, id: Int): Boolean {
            val minWidth = manager.getAppWidgetOptions(id).getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
            return minWidth == 0 || minWidth >= WIDE_MIN_WIDTH_DP
        }

        private fun render(context: Context, manager: AppWidgetManager, ids: IntArray) {
            val steps = StepCounterService.getSavedTodaySteps(context)
            val goal = FlutterPrefs.long(context, "goal_steps")?.takeIf { it > 0 } ?: 8000L
            val height = FlutterPrefs.double(context, "user_height")?.takeIf { it > 0 } ?: 175.0
            val weight = FlutterPrefs.double(context, "user_weight")?.takeIf { it > 0 } ?: 70.0
            val az = FlutterPrefs.isAzerbaijani(context)

            val percent = ((steps * 100) / goal).coerceIn(0, 100).toInt()
            val remaining = (goal - steps).coerceAtLeast(0)
            val distanceKm = steps * (height * 0.414 / 100.0) / 1000.0
            val calories = Math.round(steps * 0.042 * (weight / 70.0).coerceIn(0.7, 1.5))
            val activeMinutes = Math.round(steps / 100.0)

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
                val wide = isWide(manager, id)
                val views = RemoteViews(
                    context.packageName,
                    if (wide) R.layout.step_widget_wide else R.layout.step_widget
                )
                views.setProgressBar(R.id.widget_progress, 100, percent, false)
                views.setTextViewText(R.id.widget_steps, format(steps))
                views.setTextViewText(R.id.widget_goal, "/ ${format(goal)}")
                views.setTextViewText(R.id.widget_status, status)
                if (wide) {
                    views.setTextViewText(R.id.widget_distance, String.format(Locale.US, "%.2f", distanceKm))
                    views.setTextViewText(R.id.widget_distance_unit, "km")
                    views.setTextViewText(R.id.widget_calories, format(calories))
                    views.setTextViewText(R.id.widget_calories_unit, "kcal")
                    views.setTextViewText(R.id.widget_active, format(activeMinutes))
                    views.setTextViewText(R.id.widget_active_unit, if (az) "dəq aktiv" else "min active")
                }
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)
                manager.updateAppWidget(id, views)
            }
        }
    }
}
