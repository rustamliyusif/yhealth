package com.rustamliyusif.yhealth

import android.util.Log
import androidx.work.Configuration
import io.flutter.app.FlutterApplication

class YHealthApplication : FlutterApplication(), Configuration.Provider {

    override val workManagerConfiguration: Configuration
        get() = Configuration.Builder()
            .setMinimumLoggingLevel(Log.INFO)
            .build()
}
