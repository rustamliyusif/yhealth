# ProGuard / R8 configuration for YHealth

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# AndroidX Startup
-keep class androidx.startup.** { *; }

# AndroidX Room
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
    *;
}
-keep class androidx.room.** { *; }
-keepclassmembers class * extends androidx.room.RoomDatabase {
    *;
}

# AndroidX WorkManager & WorkDatabase
-keep class androidx.work.** { *; }
-keep class androidx.work.impl.WorkDatabase { *; }
-keep class androidx.work.impl.WorkDatabase_Impl {
    public <init>();
    *;
}
-keep interface androidx.work.impl.model.* { *; }
-keep class androidx.work.impl.model.*_Impl {
    public <init>(...);
    *;
}
-keep class com.example.yhealth.WeeklyReportWorker {
    public <init>(android.content.Context, androidx.work.WorkerParameters);
    *;
}
-keep class com.example.yhealth.YHealthApplication {
    public <init>();
    *;
}

# Suppress harmless warnings from Room / WorkManager internals
-dontwarn androidx.work.impl.**
-dontwarn androidx.room.**
-dontwarn androidx.startup.**

# Suppress missing Play Core warnings referenced by Flutter engine
-dontwarn com.google.android.play.core.**
