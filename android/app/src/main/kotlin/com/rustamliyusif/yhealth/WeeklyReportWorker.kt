package com.rustamliyusif.yhealth

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.work.Constraints
import androidx.work.CoroutineWorker
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import java.util.Calendar
import java.util.concurrent.TimeUnit

class WeeklyReportWorker(
    private val context: Context,
    workerParams: WorkerParameters
) : CoroutineWorker(context, workerParams) {

    override suspend fun doWork(): Result {
        try {
            showWeeklyReportNotification()
            return Result.success()
        } catch (e: Exception) {
            return Result.retry()
        }
    }

    private fun showWeeklyReportNotification() {
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        val channelId = "yhealth_weekly_reports"
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Weekly Reports",
                NotificationManager.IMPORTANCE_DEFAULT
            ).apply {
                description = "Notifies when your weekly health and sleep summary is ready."
            }
            notificationManager.createNotificationChannel(channel)
        }

        val intent = Intent(context, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            putExtra("route", "weekly_reports")
        }

        val pendingIntent = PendingIntent.getActivity(
            context,
            2026,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val notification = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle("YHealth Weekly Report Ready")
            .setContentText("Your weekly activity, step, and sleep summary is ready. Tap to view!")
            .setStyle(
                NotificationCompat.BigTextStyle()
                    .bigText("Your comprehensive health and sleep report for the past week is now available. Tap to review your progress, daily breakdown, and trends.")
            )
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        notificationManager.notify(1002, notification)
    }

    companion object {
        private const val WORK_NAME = "yhealth_weekly_report_work"

        fun scheduleWeeklyReport(context: Context) {
            try {
                val initialDelayMinutes = calculateInitialDelayMinutesToMondayMorning()

                val constraints = Constraints.Builder()
                    .setRequiresBatteryNotLow(false)
                    .build()

                val workRequest = PeriodicWorkRequestBuilder<WeeklyReportWorker>(7, TimeUnit.DAYS)
                    .setInitialDelay(initialDelayMinutes, TimeUnit.MINUTES)
                    .setConstraints(constraints)
                    .build()

                WorkManager.getInstance(context).enqueueUniquePeriodicWork(
                    WORK_NAME,
                    ExistingPeriodicWorkPolicy.KEEP,
                    workRequest
                )
            } catch (e: Exception) {
                android.util.Log.e("WeeklyReportWorker", "Could not enqueue weekly report worker: ${e.message}", e)
            }
        }

        private fun calculateInitialDelayMinutesToMondayMorning(): Long {
            val now = Calendar.getInstance()
            val target = Calendar.getInstance().apply {
                set(Calendar.HOUR_OF_DAY, 9)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)

                // Target Monday
                set(Calendar.DAY_OF_WEEK, Calendar.MONDAY)

                // If Monday 9:00 AM this week has already passed, schedule for next Monday
                if (timeInMillis <= now.timeInMillis) {
                    add(Calendar.WEEK_OF_YEAR, 1)
                }
            }

            val diffMillis = target.timeInMillis - now.timeInMillis
            return TimeUnit.MILLISECONDS.toMinutes(diffMillis).coerceAtLeast(1)
        }
    }
}
