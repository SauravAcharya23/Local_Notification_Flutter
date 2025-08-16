# 📲 Local Notification – Flutter

A new Flutter project integrating  push notifications.

---

## 🚀 Getting Started

After creating your Flutter application, follow these steps to configure Notifications for Android:

---

## 🔧 Android Setup

### 1. Enable Desugaring

In `android/app/build.gradle.kts`, enable desugaring in the `compileOptions` block:

```kotlin

ndkVersion = "27.0.12077973"

android {
    compileOptions {
        // Required for Firebase Notifications
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

```
### 2. Add Dependencies
In the dependencies block of the same file `(android/app/build.gradle.kts)`, add:

```kotlin
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation("androidx.multidex:multidex:2.0.1")
}
```

### 3. Notification Permission (Android 13+)
In `android/app/src/main/AndroidManifest.xml`, add the following permission:

```XML
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
```
Inside `application` add:
```XML
<!-- Add this receiver -->
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### 4. Package

Add package using `flutter pub add package_name` Or simply copy paste below package:
```
flutter_local_notifications: ^19.4.0
timezone: ^0.10.1
flutter_timezone: ^4.1.1
```

### 5. Initialize Notification

Initialize Notification in `main()` function:
```
import 'package:timezone/data/latest.dart' as tz;

// Initialize notification services
WidgetsFlutterBinding.ensureInitialized();
NotificationService().initNotification();
tz.initializeTimeZones();
```

Add all dart files in to your `lib` folder