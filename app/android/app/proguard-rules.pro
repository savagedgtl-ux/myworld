# Keep rules for plugins using reflection
-keep class com.revenuecat.purchases.** { *; }
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Room / WorkManager: generated *_Impl databases are loaded by reflection.
# Without these, R8 strips androidx.work.impl.WorkDatabase_Impl and the app
# crashes at startup in androidx.startup.InitializationProvider.
-keep class * extends androidx.room.RoomDatabase { <init>(); }
-keep class androidx.work.impl.WorkDatabase_Impl { *; }
-keep class androidx.work.** { *; }
-dontwarn androidx.work.**
