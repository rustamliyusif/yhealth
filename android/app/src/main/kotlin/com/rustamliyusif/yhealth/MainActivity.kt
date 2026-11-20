package com.rustamliyusif.yhealth

import android.Manifest
import android.app.ActivityManager
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.Sensor
import android.hardware.SensorManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.core.content.ContextCompat
import androidx.core.content.FileProvider
import java.io.File
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val METHOD_CHANNEL = "com.rustamliyusif.yhealth/step_counter"
    private val EVENT_CHANNEL = "com.rustamliyusif.yhealth/step_counter_stream"
    private val HEALTH_CONNECT_CHANNEL = "com.rustamliyusif.yhealth/health_connect"
    private val SHARE_CHANNEL = "com.rustamliyusif.yhealth/share"

    private var stepEventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Schedule weekly report work
        WeeklyReportWorker.scheduleWeeklyReport(this)

        val sensorManager = getSystemService(Context.SENSOR_SERVICE) as? SensorManager

        // Health Connect channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, HEALTH_CONNECT_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkAvailability" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                        result.success("available")
                    } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                        val isInstalled = try {
                            packageManager.getPackageInfo("com.google.android.apps.healthdata", 0)
                            true
                        } catch (e: Exception) {
                            false
                        }
                        if (isInstalled) result.success("available") else result.success("not_installed")
                    } else {
                        result.success("unsupported")
                    }
                }
                "openHealthConnectSettings" -> {
                    try {
                        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            Intent("android.health.connect.action.HEALTH_HOME_SETTINGS")
                        } else {
                            Intent("androidx.health.ACTION_HEALTH_CONNECT_SETTINGS").apply {
                                setPackage("com.google.android.apps.healthdata")
                            }
                        }
                        if (intent.resolveActivity(packageManager) != null) {
                            startActivity(intent)
                            result.success(true)
                        } else {
                            val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=com.google.android.apps.healthdata"))
                            marketIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            if (marketIntent.resolveActivity(packageManager) != null) {
                                startActivity(marketIntent)
                                result.success(true)
                            } else {
                                result.success(false)
                            }
                        }
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                "readSleepSessions" -> {
                    // Safe stub returning empty list when permissions or hardware sleep records are not present
                    result.success(listOf<Map<String, Any?>>())
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SHARE_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "shareFile" -> {
                    val path = call.argument<String>("path")
                    val mimeType = call.argument<String>("mimeType") ?: "application/pdf"
                    val title = call.argument<String>("title") ?: ""
                    if (path == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val source = File(path)
                        val shareDir = File(cacheDir, "shared_reports").apply { mkdirs() }
                        val target = File(shareDir, source.name)
                        source.copyTo(target, overwrite = true)
                        val uri = FileProvider.getUriForFile(this, "$packageName.fileprovider", target)
                        val sendIntent = Intent(Intent.ACTION_SEND).apply {
                            type = mimeType
                            putExtra(Intent.EXTRA_STREAM, uri)
                            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                        }
                        startActivity(Intent.createChooser(sendIntent, title))
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                else -> result.notImplemented()
            }
        }

        // 1. MethodChannel for control, queries, and device diagnostics
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startStepService" -> {
                    val hasCounter = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null ||
                            packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER)
                    val hasDetector = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR) != null ||
                            packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR)

                    if (hasCounter || hasDetector) {
                        val intent = Intent(this, StepCounterService::class.java).apply {
                            action = StepCounterService.ACTION_START
                        }
                        ContextCompat.startForegroundService(this, intent)
                        result.success(true)
                    } else {
                        // Device has no hardware step counter or detector
                        result.success(false)
                    }
                }
                "stopStepService" -> {
                    val intent = Intent(this, StepCounterService::class.java).apply {
                        action = StepCounterService.ACTION_STOP
                    }
                    startService(intent)
                    result.success(true)
                }
                "getTodaySteps" -> {
                    val steps = StepCounterService.getSavedTodaySteps(this)
                    result.success(steps)
                }
                "getStepHistory" -> {
                    val history = StepCounterService.getSavedHistory(this)
                    result.success(history)
                }
                "isSensorAvailable" -> {
                    val hasCounter = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER) != null ||
                            packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER)
                    val hasDetector = sensorManager?.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR) != null ||
                            packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR)
                    result.success(hasCounter || hasDetector)
                }
                "getDeviceCompatibilityInfo" -> {
                    val info = getCompatibilityDiagnostics(sensorManager)
                    result.success(info)
                }
                "requestIgnoreBatteryOptimization" -> {
                    val requested = requestIgnoreBatteryOptimizations()
                    result.success(requested)
                }
                "openOemBatterySettings" -> {
                    val opened = openManufacturerBatterySettings()
                    result.success(opened)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        // 2. EventChannel for real-time step streaming while UI is open
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    stepEventSink = events
                    // Send initial current value immediately
                    val currentSteps = StepCounterService.getSavedTodaySteps(this@MainActivity)
                    events?.success(currentSteps)

                    // Hook into service listener
                    StepCounterService.stepUpdateListener = { steps ->
                        runOnUiThread {
                            stepEventSink?.success(steps)
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    stepEventSink = null
                    StepCounterService.stepUpdateListener = null
                }
            }
        )
    }

    private fun getCompatibilityDiagnostics(sm: SensorManager?): Map<String, Any?> {
        val stepCounterSensor = sm?.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)
        val stepDetectorSensor = sm?.getDefaultSensor(Sensor.TYPE_STEP_DETECTOR)
        val accelerometerSensor = sm?.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)

        val hasStepCounter = stepCounterSensor != null ||
                packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_COUNTER)
        val hasStepDetector = stepDetectorSensor != null ||
                packageManager.hasSystemFeature(PackageManager.FEATURE_SENSOR_STEP_DETECTOR)
        val hasAccelerometer = accelerometerSensor != null

        val isServiceRunning = isServiceRunning(StepCounterService::class.java)

        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
        val isIgnoringBattery = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            powerManager?.isIgnoringBatteryOptimizations(packageName) ?: false
        } else {
            true
        }

        val hasActivityRecognition = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ContextCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }

        val hasNotification = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            ContextCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED
        } else {
            true
        }

        val hasLocation = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED

        val activeSensorType = StepCounterService.getActiveSensorType(this)

        return mapOf(
            "manufacturer" to Build.MANUFACTURER,
            "model" to Build.MODEL,
            "brand" to Build.BRAND,
            "device" to Build.DEVICE,
            "androidVersion" to Build.VERSION.RELEASE,
            "sdkInt" to Build.VERSION.SDK_INT,
            "hasStepCounter" to hasStepCounter,
            "stepCounterName" to (stepCounterSensor?.name ?: "N/A"),
            "hasStepDetector" to hasStepDetector,
            "stepDetectorName" to (stepDetectorSensor?.name ?: "N/A"),
            "hasAccelerometer" to hasAccelerometer,
            "accelerometerName" to (accelerometerSensor?.name ?: "N/A"),
            "activeSensorType" to activeSensorType,
            "isStepServiceRunning" to isServiceRunning,
            "isIgnoringBatteryOptimizations" to isIgnoringBattery,
            "hasActivityRecognitionPermission" to hasActivityRecognition,
            "hasNotificationPermission" to hasNotification,
            "hasLocationPermission" to hasLocation
        )
    }

    private fun isServiceRunning(serviceClass: Class<*>): Boolean {
        val manager = getSystemService(Context.ACTIVITY_SERVICE) as? ActivityManager ?: return false
        @Suppress("DEPRECATION")
        for (service in manager.getRunningServices(Int.MAX_VALUE)) {
            if (serviceClass.name == service.service.className) {
                return true
            }
        }
        return false
    }

    private fun requestIgnoreBatteryOptimizations(): Boolean {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true
        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager ?: return false

        if (powerManager.isIgnoringBatteryOptimizations(packageName)) {
            return true
        }

        try {
            val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                data = Uri.parse("package:$packageName")
            }
            startActivity(intent)
            return true
        } catch (e: Exception) {
            try {
                val fallbackIntent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                startActivity(fallbackIntent)
                return true
            } catch (e2: Exception) {
                return false
            }
        }
    }

    /**
     * Attempts to navigate directly to manufacturer-specific power management / autostart settings.
     * Supports Xiaomi/Redmi/POCO (MIUI/HyperOS), Huawei (EMUI/HarmonyOS), Samsung (OneUI),
     * OnePlus/OPPO/Realme (ColorOS/OxygenOS), Vivo (FuntouchOS), and falls back to standard app settings.
     */
    private fun openManufacturerBatterySettings(): Boolean {
        val manufacturer = Build.MANUFACTURER.lowercase()
        val oemIntents = mutableListOf<Intent>()

        when {
            manufacturer.contains("xiaomi") || manufacturer.contains("redmi") || manufacturer.contains("poco") -> {
                // MIUI / HyperOS autostart and battery management
                oemIntents.add(Intent().setComponent(ComponentName("com.miui.powerkeeper", "com.miui.powerkeeper.ui.HiddenAppsConfigActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.miui.securitycenter", "com.miui.permcenter.autostart.AutoStartManagementActivity")))
                oemIntents.add(Intent("miui.intent.action.OP_AUTO_START").addCategory(Intent.CATEGORY_DEFAULT))
                oemIntents.add(Intent().setComponent(ComponentName("com.miui.securitycenter", "com.miui.securityscan.MainActivity")))
            }
            manufacturer.contains("huawei") || manufacturer.contains("honor") -> {
                // EMUI / MagicOS protected apps & startup manager
                oemIntents.add(Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.optimize.process.ProtectActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.startupmgr.ui.StartupNormalAppListActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.huawei.systemmanager", "com.huawei.systemmanager.appcontrol.activity.StartupAppControlActivity")))
            }
            manufacturer.contains("samsung") -> {
                // Samsung Device Care battery background limit
                oemIntents.add(Intent().setComponent(ComponentName("com.samsung.android.lool", "com.samsung.android.sm.ui.battery.BatteryActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.samsung.android.sm", "com.samsung.android.sm.ui.battery.BatteryActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.samsung.android.sm_device", "com.samsung.android.sm.ui.battery.BatteryActivity")))
            }
            manufacturer.contains("oneplus") || manufacturer.contains("oppo") || manufacturer.contains("realme") -> {
                // ColorOS / OxygenOS autostart manager
                oemIntents.add(Intent().setComponent(ComponentName("com.coloros.safecenter", "com.coloros.safecenter.permission.startup.StartupAppListActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.coloros.safecenter", "com.coloros.safecenter.startupapp.StartupAppListActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.oppo.safe", "com.oppo.safe.permission.startup.StartupAppListActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.oneplus.security", "com.oneplus.security.chainlaunch.view.ChainLaunchAppListActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.oplus.battery", "com.oplus.battery.BatteryMainActivity")))
            }
            manufacturer.contains("vivo") || manufacturer.contains("iqoo") -> {
                // Vivo / iQOO high background power consumption
                oemIntents.add(Intent().setComponent(ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.PurviewTabActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.vivo.permissionmanager", "com.vivo.permissionmanager.activity.SoftPermissionDetailActivity")))
                oemIntents.add(Intent().setComponent(ComponentName("com.iqoo.secure", "com.iqoo.secure.ui.phoneoptimize.AddWhiteListActivity")))
            }
            manufacturer.contains("transsion") || manufacturer.contains("infinix") || manufacturer.contains("tecno") || manufacturer.contains("itel") -> {
                // Transsion Phone Master autostart
                oemIntents.add(Intent().setComponent(ComponentName("com.transsion.phonemaster", "com.transsion.phonemaster.AutoStartActivity")))
            }
        }

        // Standard fallback: Application Details Settings page
        oemIntents.add(Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$packageName")
        })

        for (intent in oemIntents) {
            try {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                if (intent.resolveActivity(packageManager) != null) {
                    startActivity(intent)
                    return true
                }
            } catch (_: Exception) {
                // Try next intent in priority sequence
            }
        }

        return false
    }

    override fun onDestroy() {
        StepCounterService.stepUpdateListener = null
        super.onDestroy()
    }
}
