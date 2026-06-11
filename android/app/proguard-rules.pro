# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# flutter_secure_storage uses Android Keystore + reflection on Tink keysets.
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-keep class androidx.security.crypto.** { *; }
-keep class com.google.crypto.tink.** { *; }
-dontwarn com.google.crypto.tink.**

# Dio + OkHttp / Conscrypt safety
-dontwarn okhttp3.**
-dontwarn okio.**
-dontwarn org.conscrypt.**

# Keep Hive type adapters reachable via reflection (defensive)
-keep class **.HiveAdapter { *; }

# Kotlin reflection + coroutines
-dontwarn kotlin.reflect.jvm.internal.**
-keepclassmembers class kotlinx.coroutines.** { volatile <fields>; }

# Annotations
-keepattributes *Annotation*, InnerClasses, Signature, EnclosingMethod
