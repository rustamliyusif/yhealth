package com.rustamliyusif.yhealth

import android.content.Context

object FlutterPrefs {
    private const val NAME = "FlutterSharedPreferences"
    private const val DOUBLE_PREFIX = "VGhpcyBpcyB0aGUgcHJlZml4IGZvciBEb3VibGUu"

    private fun raw(context: Context, key: String): Any? =
        context.getSharedPreferences(NAME, Context.MODE_PRIVATE).all["flutter.$key"]

    fun long(context: Context, key: String): Long? = when (val v = raw(context, key)) {
        is Long -> v
        is Int -> v.toLong()
        is String -> v.toLongOrNull()
        else -> null
    }

    fun double(context: Context, key: String): Double? = when (val v = raw(context, key)) {
        is Double -> v
        is Float -> v.toDouble()
        is Long -> v.toDouble()
        is Int -> v.toDouble()
        is String -> v.removePrefix(DOUBLE_PREFIX).toDoubleOrNull()
        else -> null
    }

    fun bool(context: Context, key: String): Boolean? = raw(context, key) as? Boolean

    fun string(context: Context, key: String): String? = raw(context, key) as? String

    fun isAzerbaijani(context: Context): Boolean = (string(context, "language_code") ?: "az") == "az"
}
