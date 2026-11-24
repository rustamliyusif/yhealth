package com.rustamliyusif.yhealth

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import org.json.JSONObject
import java.util.Calendar

class ReminderManager(private val context: Context) {

    companion object {
        private const val CHANNEL_ID = "yhealth_reminders"
        private const val WATER_ID = 2001
        private const val MOVE_ID = 2002
        private const val GOAL_ID = 2003
        private const val TEST_ID = 2004

        private const val STATE_PREFS = "yhealth_reminder_state"
        private const val KEY_LAST_WATER = "last_water_ms"
        private const val KEY_LAST_MOVE = "last_move_ms"
        private const val KEY_GOAL_NUDGE_DATE = "goal_nudge_date"

        private const val HOUR_MS = 60 * 60 * 1000L
        private const val WATER_INTERVAL_MS = 2 * HOUR_MS
        private const val MOVE_INTERVAL_MS = 90 * 60 * 1000L
        private const val INACTIVE_WINDOW_MS = HOUR_MS
        private const val INACTIVE_STEP_THRESHOLD = 250L
        private const val GOAL_NUDGE_MAX_REMAINING = 4000L

        fun isQuiet(minuteOfDay: Int, quietStart: Int, quietEnd: Int): Boolean {
            if (quietStart == quietEnd) return false
            return if (quietStart > quietEnd) {
                minuteOfDay >= quietStart || minuteOfDay < quietEnd
            } else {
                minuteOfDay in quietStart until quietEnd
            }
        }

        fun activeFraction(minuteOfDay: Int, quietStart: Int, quietEnd: Int): Double {
            val total = ((quietStart - quietEnd) + 1440) % 1440
            if (total == 0) return minuteOfDay / 1440.0
            val elapsed = ((minuteOfDay - quietEnd) + 1440) % 1440
            return (elapsed.toDouble() / total).coerceIn(0.0, 1.0)
        }

        fun sendTest(context: Context) {
            val az = FlutterPrefs.isAzerbaijani(context)
            ReminderManager(context).notify(
                TEST_ID,
                "YHealth",
                if (az) "Xatırlatmalar işləyir ✅" else "Reminders are working ✅"
            )
        }
    }

    private val samples = ArrayDeque<Pair<Long, Long>>()
    private val state = context.getSharedPreferences(STATE_PREFS, Context.MODE_PRIVATE)

    init {
        createChannel()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val az = FlutterPrefs.isAzerbaijani(context)
            val channel = NotificationChannel(
                CHANNEL_ID,
                if (az) "Xatırlatmalar" else "Reminders",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            context.getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
        }
    }

    private fun notify(id: Int, title: String, text: String) {
        val manager = NotificationManagerCompat.from(context)
        if (!manager.areNotificationsEnabled()) return
        val launchIntent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context,
            id,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        val notification = NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle(title)
            .setContentText(text)
            .setStyle(NotificationCompat.BigTextStyle().bigText(text))
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setCategory(NotificationCompat.CATEGORY_REMINDER)
            .build()
        try {
            manager.notify(id, notification)
        } catch (_: SecurityException) {
        }
    }

    private fun todayWaterMl(): Long {
        val raw = FlutterPrefs.string(context, "water_log") ?: return 0
        return try {
            JSONObject(raw).optLong(StepCounterService.getTodayDateString(), 0)
        } catch (_: Exception) {
            0
        }
    }

    private fun waterGoalMl(): Long {
        FlutterPrefs.long(context, "goal_water_ml")?.takeIf { it > 0 }?.let { return it }
        val weight = FlutterPrefs.double(context, "user_weight")?.takeIf { it > 0 } ?: 70.0
        val ml = Math.round(weight * 33 / 50.0) * 50
        return ml.coerceIn(1500, 4500)
    }

    fun check(todaySteps: Long, nowMs: Long = System.currentTimeMillis()) {
        samples.addLast(nowMs to todaySteps)
        while (samples.size > 1 && nowMs - samples[1].first >= INACTIVE_WINDOW_MS) {
            samples.removeFirst()
        }

        val cal = Calendar.getInstance().apply { timeInMillis = nowMs }
        val minute = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)
        val quietStart = (FlutterPrefs.long(context, "quiet_start") ?: 1320L).toInt()
        val quietEnd = (FlutterPrefs.long(context, "quiet_end") ?: 480L).toInt()
        if (isQuiet(minute, quietStart, quietEnd)) return

        val az = FlutterPrefs.isAzerbaijani(context)
        val fraction = activeFraction(minute, quietStart, quietEnd)

        if (FlutterPrefs.bool(context, "reminder_water") != false) {
            checkWater(nowMs, fraction, az)
        }
        if (FlutterPrefs.bool(context, "reminder_move") != false) {
            checkMove(nowMs, todaySteps, fraction, minute, quietStart, az)
        }
    }

    private fun checkWater(nowMs: Long, fraction: Double, az: Boolean) {
        if (nowMs - state.getLong(KEY_LAST_WATER, 0) < WATER_INTERVAL_MS) return
        if (fraction < 0.1) return
        val goal = waterGoalMl()
        val drunk = todayWaterMl()
        if (drunk >= goal) return
        val expected = (goal * fraction).toLong()
        if (drunk > expected - 250) return

        state.edit().putLong(KEY_LAST_WATER, nowMs).apply()
        notify(
            WATER_ID,
            if (az) "Su içmək vaxtıdır 💧" else "Time for some water 💧",
            if (az) "Bu gün $drunk / $goal ml. Bir stəkan su iç."
            else "Today $drunk / $goal ml. Have a glass of water."
        )
    }

    private fun checkMove(
        nowMs: Long,
        todaySteps: Long,
        fraction: Double,
        minute: Int,
        quietStart: Int,
        az: Boolean
    ) {
        val goal = FlutterPrefs.long(context, "goal_steps")?.takeIf { it > 0 } ?: 8000L
        if (todaySteps >= goal) return
        val remaining = goal - todaySteps

        val minutesToQuiet = ((quietStart - minute) + 1440) % 1440
        val today = StepCounterService.getTodayDateString()
        if (minutesToQuiet in 1..120 &&
            remaining <= GOAL_NUDGE_MAX_REMAINING &&
            state.getString(KEY_GOAL_NUDGE_DATE, "") != today
        ) {
            state.edit().putString(KEY_GOAL_NUDGE_DATE, today).putLong(KEY_LAST_MOVE, nowMs).apply()
            val r = StepWidgetProvider.format(remaining)
            notify(
                GOAL_ID,
                if (az) "Hədəfə az qalıb 🎯" else "Almost at your goal 🎯",
                if (az) "Cəmi $r addım qalıb. Qısa bir axşam gəzintisi kifayətdir."
                else "Only $r steps to go. A short evening walk will do it."
            )
            return
        }

        if (fraction < 0.1) return
        if (nowMs - state.getLong(KEY_LAST_MOVE, 0) < MOVE_INTERVAL_MS) return
        val oldest = samples.firstOrNull() ?: return
        if (nowMs - oldest.first < INACTIVE_WINDOW_MS - 60_000L) return
        val walked = todaySteps - oldest.second
        if (walked < 0 || walked >= INACTIVE_STEP_THRESHOLD) return

        state.edit().putLong(KEY_LAST_MOVE, nowMs).apply()
        notify(
            MOVE_ID,
            if (az) "Bir az hərəkət edək 🚶" else "Time to move 🚶",
            if (az) "Son 1 saatda $walked addım atmısan. 5 dəqiqəlik gəzinti yaxşı olar."
            else "Only $walked steps in the last hour. A 5-minute walk would help."
        )
    }
}
