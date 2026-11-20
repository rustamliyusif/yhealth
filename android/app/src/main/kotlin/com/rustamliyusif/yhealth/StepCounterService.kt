package com.rustamliyusif.yhealth

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.content.pm.ServiceInfo
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Build
import android.os.IBinder
import android.os.SystemClock
import androidx.core.app.NotificationCompat
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class StepCounterService : Service(), SensorEventListener {

    companion object {
        const val PREFS_NAME = "yhealth_step_prefs"
        const val KEY_TODAY_STEPS = "today_steps"
        const val KEY_LAST_SENSOR_VALUE = "last_sensor_value"
        const val KEY_LAST_TRACKING_DATE = "last_tracking_date"
        const val KEY_ACTIVE_SENSOR_TYPE = "active_sensor_type"
        const val KEY_LAST_UPTIME_MS = "last_uptime_ms"
        const val KEY_HISTORY_PREFIX = "history_"

        const val SENSOR_TYPE_STEP_COUNTER = "step_counter"
        const val SENSOR_TYPE_STEP_DETECTOR = "step_detector"
        const val SENSOR_TYPE_NONE = "none"

        const val CHANNEL_ID = "yhealth_step_counter_channel"
        const val NOTIFICATION_ID = 1001

        const val ACTION_START = "com.rustamliyusif.yhealth.action.START_STEP_SERVICE"
        const val ACTION_STOP = "com.rustamliyusif.yhealth.action.STOP_STEP_SERVICE"

        // Live update listener for the active Flutter engine
        var stepUpdateListener: ((Long) -> Unit)? = null

        fun getTodayDateString(): String {
            val sdf = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            return sdf.format(Date())
        }

        fun getSavedTodaySteps(context: Context): Long {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val savedDate = prefs.getString(KEY_LAST_TRACKING_DATE, "") ?: ""
            val todayStr = getTodayDateString()
            return if (savedDate == todayStr) {
                prefs.getLong(KEY_TODAY_STEPS, 0L)
            } else {
                0L
            }
        }

        fun getActiveSensorType(context: Context): String {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            return prefs.getString(KEY_ACTIVE_SENSOR_TYPE, SENSOR_TYPE_NONE) ?: SENSOR_TYPE_NONE
        }

        fun getSavedHistory(context: Context): Map<String, Long> {
            val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            val history = mutableMapOf<String, Long>()
            val all = prefs.all
            for ((key, value) in all) {
                if (key.startsWith(KEY_HISTORY_PREFIX) && value is Long) {
                    val dateKey = key.removePrefix(KEY_HISTORY_PREFIX)
                    history[dateKey] = value
                }
            }
            return history
        }
    }

    private var sensorManager: SensorManager? = null
    private var registeredSensor: Sensor? = null
    private var activeSensorType = SENSOR_TYPE_NONE
    private lateinit var prefs: SharedPreferences

    // Notification throttling to minimize SystemUI IPC while keeping live UI instantaneous
    private var lastNotificationSteps: Long = -1L
    private var lastNotificationUpdateTimeMs: Long = 0L

    override fun onCreate() {
        super.onCreate()
        prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager
        setupSensors()
        createNotificationChannel()
    }

    private fun setupSensors() {
        val sm = sensorManager ?: return

        // 1. Primary choice: Hardware TYPE_STEP_COUNTER (cumulative hardware counter)
        val stepCounter = sm.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        if (stepCounter != null) {
            registeredSensor = stepCounter
            activeSensorType = SENSOR_TYPE_STEP_COUNTER
            prefs.edit().putString(KEY_ACTIVE_SENSOR_TYPE, SENSOR_TYPE_STEP_COUNTER).apply()
            return
        }

        // 2. Secondary alternative: Hardware TYPE_STEP_DETECTOR (triggers 1 event per step)
        val stepDetector = sm.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR)
        if (stepDetector != null) {
            registeredSensor = stepDetector
            activeSensorType = SENSOR_TYPE_STEP_DETECTOR
            prefs.edit().putString(KEY_ACTIVE_SENSOR_TYPE, SENSOR_TYPE_STEP_DETECTOR).apply()
            return
        }

        // 3. No hardware pedometer sensor available
        registeredSensor = null
        activeSensorType = SENSOR_TYPE_NONE
        prefs.edit().putString(KEY_ACTIVE_SENSOR_TYPE, SENSOR_TYPE_NONE).apply()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopForeground(STOP_FOREGROUND_REMOVE)
            stopSelf()
            return START_NOT_STICKY
        }

        startForegroundNotification()
        registerSensorListener()

        // Service is sticky so Android OS can automatically restart it if killed under memory pressure
        return START_STICKY
    }

    private fun registerSensorListener() {
        val sensor = registeredSensor ?: return

        // Hardware FIFO batching (5 seconds batch latency):
        // Collects steps in low-power hardware sensor hub silicon while screen is off,
        // allowing the application processor (AP) to remain in deep sleep without missing steps.
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            sensorManager?.registerListener(
                this,
                sensor,
                SensorManager.SENSOR_DELAY_NORMAL,
                5_000_000 // 5 seconds batch latency
            )
        } else {
            sensorManager?.registerListener(this, sensor, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    private fun unregisterSensorListener() {
        sensorManager?.unregisterListener(this)
    }

    override fun onSensorChanged(event: SensorEvent?) {
        if (event == null) return

        when (event.sensor.type) {
            Sensor.TYPE_STEP_COUNTER -> {
                handleStepCounterEvent(event.values[0].toLong())
            }
            Sensor.TYPE_STEP_DETECTOR -> {
                if (event.values[0] == 1.0f) {
                    handleStepDetectorEvent()
                }
            }
        }
    }

    /**
     * Primary cumulative step processing with midnight reset, timezone and device reboot recovery.
     */
    private fun handleStepCounterEvent(rawSteps: Long) {
        val todayStr = getTodayDateString()
        val lastDate = prefs.getString(KEY_LAST_TRACKING_DATE, "") ?: ""
        var todaySteps = prefs.getLong(KEY_TODAY_STEPS, 0L)
        var lastSensorValue = prefs.getLong(KEY_LAST_SENSOR_VALUE, -1L)

        val currentUptime = SystemClock.elapsedRealtime()

        val editor = prefs.edit()
        editor.putLong(KEY_LAST_UPTIME_MS, currentUptime)

        if (lastDate != todayStr) {
            // Local midnight transition or timezone shift!
            // 1. Permanently archive previous date's steps into historical storage
            if (lastDate.isNotEmpty() && lastSensorValue >= 0L) {
                val pending = rawSteps - lastSensorValue
                if (pending in 1L..50000L) {
                    todaySteps += pending
                }
            }
            if (lastDate.isNotEmpty() && todaySteps > 0L) {
                editor.putLong(KEY_HISTORY_PREFIX + lastDate, todaySteps)
            }
            // 2. Start clean daily count for the new calendar day
            todaySteps = 0L
            lastSensorValue = rawSteps
            editor.putString(KEY_LAST_TRACKING_DATE, todayStr)
            editor.putLong(KEY_TODAY_STEPS, todaySteps)
            editor.putLong(KEY_LAST_SENSOR_VALUE, lastSensorValue)
            editor.apply()
            updateNotification(todaySteps, force = true)
        } else {
            // Same calendar date: compute delta
            if (lastSensorValue < 0L) {
                // Initial baseline established for today
                lastSensorValue = rawSteps
                editor.putLong(KEY_LAST_SENSOR_VALUE, lastSensorValue)
                editor.putString(KEY_LAST_TRACKING_DATE, todayStr)
                editor.apply()
            } else if (rawSteps < lastSensorValue) {
                // Device rebooted: hardware sensor counter restarted from 0
                // Treat rawSteps as the incremental steps walked since reboot
                val delta = rawSteps
                todaySteps += delta
                lastSensorValue = rawSteps
                editor.putLong(KEY_TODAY_STEPS, todaySteps)
                editor.putLong(KEY_LAST_SENSOR_VALUE, lastSensorValue)
                editor.apply()
            } else {
                val delta = rawSteps - lastSensorValue
                // Sanity filter against hardware glitch spikes
                if (delta in 1L..50000L) {
                    todaySteps += delta
                    lastSensorValue = rawSteps
                    editor.putLong(KEY_TODAY_STEPS, todaySteps)
                    editor.putLong(KEY_LAST_SENSOR_VALUE, lastSensorValue)
                    editor.apply()
                } else if (delta > 50000L) {
                    // Sensor counter wrap-around or anomaly: re-align baseline
                    lastSensorValue = rawSteps
                    editor.putLong(KEY_LAST_SENSOR_VALUE, lastSensorValue)
                    editor.apply()
                }
            }
            updateNotification(todaySteps, force = false)
        }

        // Live stream update to Flutter UI is always real-time
        stepUpdateListener?.invoke(todaySteps)
    }

    /**
     * Secondary step processing for devices supporting TYPE_STEP_DETECTOR instead of TYPE_STEP_COUNTER.
     */
    private fun handleStepDetectorEvent() {
        val todayStr = getTodayDateString()
        val lastDate = prefs.getString(KEY_LAST_TRACKING_DATE, "") ?: ""
        var todaySteps = prefs.getLong(KEY_TODAY_STEPS, 0L)

        val editor = prefs.edit()

        if (lastDate != todayStr) {
            // Midnight transition: archive previous date
            if (lastDate.isNotEmpty() && todaySteps > 0L) {
                editor.putLong(KEY_HISTORY_PREFIX + lastDate, todaySteps)
            }
            todaySteps = 1L
            editor.putString(KEY_LAST_TRACKING_DATE, todayStr)
            editor.putLong(KEY_TODAY_STEPS, todaySteps)
            editor.apply()
            updateNotification(todaySteps, force = true)
        } else {
            todaySteps += 1L
            editor.putLong(KEY_TODAY_STEPS, todaySteps)
            editor.apply()
            updateNotification(todaySteps, force = false)
        }

        stepUpdateListener?.invoke(todaySteps)
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // No-op for step counter & detector
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "YHealth Step Tracker",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Universal background step tracking"
                setShowBadge(false)
            }
            val manager = getSystemService(NotificationManager::class.java)
            manager?.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(steps: Long): Notification {
        val launchIntent = packageManager.getLaunchIntentForPackage(packageName)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val sensorSuffix = when (activeSensorType) {
            SENSOR_TYPE_STEP_COUNTER -> " • Sensor: Counter"
            SENSOR_TYPE_STEP_DETECTOR -> " • Sensor: Detector"
            else -> ""
        }

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("YHealth")
            .setContentText(String.format(Locale.getDefault(), "%,d addım izlənir%s", steps, sensorSuffix))
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .build()
    }

    private fun startForegroundNotification() {
        val todaySteps = getSavedTodaySteps(this)
        val notification = buildNotification(todaySteps)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_HEALTH
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun updateNotification(steps: Long, force: Boolean = false) {
        val now = System.currentTimeMillis()
        if (!force && steps == lastNotificationSteps) return
        if (!force && (steps - lastNotificationSteps < 10L) && (now - lastNotificationUpdateTimeMs < 3000L)) {
            return
        }
        lastNotificationSteps = steps
        lastNotificationUpdateTimeMs = now

        val manager = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
        manager?.notify(NOTIFICATION_ID, buildNotification(steps))
    }

    override fun onDestroy() {
        unregisterSensorListener()
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
