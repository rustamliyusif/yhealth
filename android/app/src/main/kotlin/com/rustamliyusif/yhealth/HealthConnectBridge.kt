package com.rustamliyusif.yhealth

import android.content.Context
import android.content.Intent
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.PermissionController
import androidx.health.connect.client.permission.HealthPermission
import androidx.health.connect.client.records.HydrationRecord
import androidx.health.connect.client.records.SleepSessionRecord
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.records.metadata.Device
import androidx.health.connect.client.records.metadata.Metadata
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import androidx.health.connect.client.units.Volume
import java.time.Instant
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.ZoneId
import java.time.format.DateTimeFormatter

object HealthConnectBridge {
    private const val PROVIDER = "com.google.android.apps.healthdata"

    val PERMISSIONS = setOf(
        HealthPermission.getReadPermission(SleepSessionRecord::class),
        HealthPermission.getReadPermission(WeightRecord::class),
        HealthPermission.getWritePermission(StepsRecord::class),
        HealthPermission.getWritePermission(HydrationRecord::class),
    )

    fun status(context: Context): String =
        when (HealthConnectClient.getSdkStatus(context, PROVIDER)) {
            HealthConnectClient.SDK_AVAILABLE -> "available"
            HealthConnectClient.SDK_UNAVAILABLE_PROVIDER_UPDATE_REQUIRED -> "not_installed"
            else -> "unsupported"
        }

    private fun client(context: Context) = HealthConnectClient.getOrCreate(context)

    suspend fun grantedCount(context: Context): Int {
        val granted = client(context).permissionController.getGrantedPermissions()
        return PERMISSIONS.count { it in granted }
    }

    fun permissionIntent(context: Context): Intent =
        PermissionController.createRequestPermissionResultContract().createIntent(context, PERMISSIONS)

    fun parsePermissionResult(resultCode: Int, data: Intent?): Int =
        PermissionController.createRequestPermissionResultContract().parseResult(resultCode, data).size

    private val zone: ZoneId get() = ZoneId.systemDefault()
    private val isoLocal = DateTimeFormatter.ISO_LOCAL_DATE_TIME

    private fun local(instant: Instant): LocalDateTime = LocalDateTime.ofInstant(instant, zone)

    suspend fun readSleep(context: Context, startMs: Long, endMs: Long): List<Map<String, Any?>> {
        val response = client(context).readRecords(
            ReadRecordsRequest(
                recordType = SleepSessionRecord::class,
                timeRangeFilter = TimeRangeFilter.between(Instant.ofEpochMilli(startMs), Instant.ofEpochMilli(endMs))
            )
        )
        return response.records.map { r ->
            fun stageMinutes(vararg types: Int): Int = r.stages
                .filter { it.stage in types }
                .sumOf { java.time.Duration.between(it.startTime, it.endTime).toMinutes().toInt() }

            val light = stageMinutes(SleepSessionRecord.STAGE_TYPE_LIGHT)
            val deep = stageMinutes(SleepSessionRecord.STAGE_TYPE_DEEP)
            val rem = stageMinutes(SleepSessionRecord.STAGE_TYPE_REM)
            val awake = stageMinutes(
                SleepSessionRecord.STAGE_TYPE_AWAKE,
                SleepSessionRecord.STAGE_TYPE_AWAKE_IN_BED,
                SleepSessionRecord.STAGE_TYPE_OUT_OF_BED
            )
            val total = java.time.Duration.between(r.startTime, r.endTime).toMinutes().toInt()
            val asleep = if (awake in 1 until total) total - awake else total
            val hasStages = light + deep + rem > 0
            val bed = local(r.startTime)
            val wake = local(r.endTime)
            mapOf(
                "id" to "hc_${r.metadata.id}",
                "date" to wake.toLocalDate().toString(),
                "bedtime" to bed.format(isoLocal),
                "wakeTime" to wake.format(isoLocal),
                "durationMinutes" to asleep,
                "source" to "health_connect",
                "efficiencyPercent" to if (total > 0) (asleep * 100 / total).coerceIn(50, 100) else 85,
                "notes" to null,
                "hasStages" to hasStages,
                "lightSleepMinutes" to if (hasStages) light else null,
                "deepSleepMinutes" to if (hasStages) deep else null,
                "remSleepMinutes" to if (hasStages) rem else null,
                "awakeMinutes" to if (hasStages) awake else null,
            )
        }
    }

    suspend fun readWeights(context: Context, startMs: Long, endMs: Long): List<Map<String, Any?>> {
        val response = client(context).readRecords(
            ReadRecordsRequest(
                recordType = WeightRecord::class,
                timeRangeFilter = TimeRangeFilter.between(Instant.ofEpochMilli(startMs), Instant.ofEpochMilli(endMs))
            )
        )
        return response.records
            .filter { it.metadata.dataOrigin.packageName != context.packageName }
            .map {
                mapOf(
                    "id" to "hc_${it.metadata.id}",
                    "timeMs" to it.time.toEpochMilli(),
                    "kg" to it.weight.inKilograms,
                )
            }
    }

    private fun dayBounds(date: String): Pair<Instant, Instant>? {
        val day = try {
            LocalDate.parse(date)
        } catch (_: Exception) {
            return null
        }
        val start = day.atStartOfDay(zone).toInstant()
        val endOfDay = day.plusDays(1).atStartOfDay(zone).toInstant().minusSeconds(1)
        val now = Instant.now()
        val end = if (endOfDay.isAfter(now)) now else endOfDay
        if (!end.isAfter(start)) return null
        return start to end
    }

    suspend fun writeSteps(context: Context, days: Map<String, Long>): Int {
        val version = System.currentTimeMillis()
        val records = days.mapNotNull { (date, steps) ->
            if (steps <= 0) return@mapNotNull null
            val (start, end) = dayBounds(date) ?: return@mapNotNull null
            StepsRecord(
                startTime = start,
                startZoneOffset = zone.rules.getOffset(start),
                endTime = end,
                endZoneOffset = zone.rules.getOffset(end),
                count = steps.coerceAtMost(1_000_000L),
                metadata = Metadata.autoRecorded(
                    device = Device(type = Device.TYPE_PHONE),
                    clientRecordId = "yhealth-steps-$date",
                    clientRecordVersion = version,
                ),
            )
        }
        if (records.isNotEmpty()) client(context).insertRecords(records)
        return records.size
    }

    suspend fun writeHydration(context: Context, days: Map<String, Long>): Int {
        val version = System.currentTimeMillis()
        val records = days.mapNotNull { (date, ml) ->
            if (ml <= 0) return@mapNotNull null
            val (start, end) = dayBounds(date) ?: return@mapNotNull null
            HydrationRecord(
                startTime = start,
                startZoneOffset = zone.rules.getOffset(start),
                endTime = end,
                endZoneOffset = zone.rules.getOffset(end),
                volume = Volume.milliliters(ml.toDouble()),
                metadata = Metadata.manualEntry(
                    clientRecordId = "yhealth-water-$date",
                    clientRecordVersion = version,
                ),
            )
        }
        if (records.isNotEmpty()) client(context).insertRecords(records)
        return records.size
    }
}
