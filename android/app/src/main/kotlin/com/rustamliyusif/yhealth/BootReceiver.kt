package com.rustamliyusif.yhealth

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import androidx.core.content.ContextCompat

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val action = intent.action
        if (action == Intent.ACTION_BOOT_COMPLETED ||
            action == "android.intent.action.QUICKBOOT_POWERON" ||
            action == "com.htc.intent.action.QUICKBOOT_POWERON" ||
            action == Intent.ACTION_MY_PACKAGE_REPLACED
        ) {
            val sm = context.getSystemService(Context.SENSOR_SERVICE) as? SensorManager
            val hasCounter = sm?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null ||
                    context.packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER)
            val hasDetector = sm?.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR) != null ||
                    context.packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR)

            if (hasCounter || hasDetector) {
                val serviceIntent = Intent(context, StepCounterService::class.java).apply {
                    this.action = StepCounterService.ACTION_START
                }
                ContextCompat.startForegroundService(context, serviceIntent)
            }

            // Schedule weekly reports on reboot
            WeeklyReportWorker.scheduleWeeklyReport(context)
        }
    }
}
