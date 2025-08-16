import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        // onDidReceiveLocalNotification:
        //     (int id, String? title, String? body, String? payload) async {}
          );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  Future scheduleNotification(
      {int? id,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return notificationsPlugin.zonedSchedule(
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        (id ?? scheduledNotificationDateTime.millisecondsSinceEpoch) % 2147483647,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        // androidAllowWhileIdle: true,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.absoluteTime
            );
  }
}


// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationService _instance = NotificationService._internal();
//   factory NotificationService() => _instance;
//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initializeNotification() async {
//     // Initialize timezone
//     await _configureLocalTimezone();

//     // Android initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // iOS initialization
//     const DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings(
//           requestAlertPermission: true,
//           requestBadgePermission: true,
//           requestSoundPermission: true,
//           // onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
//         );

//     // Combined settings
//     const InitializationSettings initializationSettings =
//         InitializationSettings(
//           android: initializationSettingsAndroid,
//           iOS: initializationSettingsIOS,
//         );

//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
//     );

//     // Create notification channel for Android
//     await _createNotificationChannel();
//   }

//   static void _onDidReceiveLocalNotification(
//     int id,
//     String? title,
//     String? body,
//     String? payload,
//   ) {
//     print('Notification received: $title, $body');
//   }

//   static void _onDidReceiveNotificationResponse(
//     NotificationResponse notificationResponse,
//   ) {
//     print('Notification tapped: ${notificationResponse.payload}');
//   }

//   Future<void> _configureLocalTimezone() async {
//     tz.initializeTimeZones();
//     String timeZoneName = await FlutterTimezone.getLocalTimezone();
//     if (timeZoneName == "Asia/Katmandu") {
//       timeZoneName = "Asia/Kathmandu";
//     }
//     tz.setLocalLocation(tz.getLocation(timeZoneName));
//   }

//   Future<void> _createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'your_channel_id', // Same as in scheduleNotification
//       'your_channel_name',
//       description: 'your_channel_description',
//       importance: Importance.high,
//       playSound: true,
//       showBadge: true,
//     );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin
//         >()
//         ?.createNotificationChannel(channel);
//   }

//   Future<void> scheduleNotification(
//   int id,
//   String title,
//   String body,
//   DateTime scheduledTime,
// ) async {
//   try {
//     // Ensure timezone is initialized
//     await _configureLocalTimezone();
    
//     // Convert to local timezone
//     final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
//       scheduledTime,
//       tz.local,
//     );

//     // Debug print the times
//     print('Current time: ${tz.TZDateTime.now(tz.local)}');
//     print('Scheduled time: $scheduledDate');
//     print('Difference: ${scheduledDate.difference(tz.TZDateTime.now(tz.local))}');

//     // Check if time is in past (with 1 second buffer)
//     if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)))) {
//       print('Cannot schedule notification in the past');
//       return;
//     }

//     // Create notification payload
//     final payload = 'scheduled_$id';

//     // Schedule the notification
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDate,
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'your_channel_id',
//           'your_channel_name',
//           channelDescription: 'your_channel_description',
//           importance: Importance.max,
//           priority: Priority.high,
//           playSound: true,
//           enableVibration: true,
//           timeoutAfter: 3600000, // 1 hour timeout
//           visibility: NotificationVisibility.public,
//           autoCancel: true,
//           ongoing: false,
//           styleInformation: BigTextStyleInformation(body),
//         ),
//         iOS: DarwinNotificationDetails(
//           sound: 'default',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//       // uiLocalNotificationDateInterpretation: 
//       //     UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//       payload: payload,
//     );

//     print('✅ Successfully scheduled notification for $scheduledDate');
//   } catch (e, stack) {
//     print('❌ Error scheduling notification: $e');
//     print(stack);
//   }
// }

//   // Future<void> scheduleNotification(
//   //   int id,
//   //   String title,
//   //   String body,
//   //   DateTime scheduledTime,
//   // ) async {
//   //   final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
//   //     scheduledTime,
//   //     tz.local,
//   //   );

//   //   // Check if the scheduled time is in the past
//   //   if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//   //     print('Cannot schedule notification in the past');
//   //     return;
//   //   }

//   //   await flutterLocalNotificationsPlugin.zonedSchedule(
//   //     id,
//   //     title,
//   //     body,
//   //     scheduledDate,
//   //     const NotificationDetails(
//   //       android: AndroidNotificationDetails(
//   //         'your_channel_id', // Must match channel ID
//   //         'your_channel_name',
//   //         channelDescription: 'your_channel_description',
//   //         importance: Importance.max,
//   //         priority: Priority.high,
//   //         playSound: true,
//   //         enableVibration: true,
//   //       ),
//   //       iOS: DarwinNotificationDetails(
//   //         sound: 'default',
//   //         presentAlert: true,
//   //         presentBadge: true,
//   //         presentSound: true,
//   //       ),
//   //     ),
//   //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //     // uiLocalNotificationDateInterpretation:
//   //     //     UILocalNotificationDateInterpretation.absoluteTime,
//   //     matchDateTimeComponents: DateTimeComponents.time,
//   //   );

//   //   print('Notification scheduled for $scheduledDate');
//   // }

//   Future<void> requestIOSPermissions() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//           IOSFlutterLocalNotificationsPlugin
//         >()
//         ?.requestPermissions(alert: true, badge: true, sound: true);
//   }

//   Future<bool> requestAndroidPermissions() async {
//     if (await flutterLocalNotificationsPlugin
//             .resolvePlatformSpecificImplementation<
//                 AndroidFlutterLocalNotificationsPlugin>()
//             ?.areNotificationsEnabled() ??
//         false) {
//       return true;
//     }

//     final bool? result = await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
//     return result ?? false;
//   }

//   Future<void> showTestNotification() async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       channelDescription: 'your_channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );

//     const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'Test Notification',
//       'This is a test notification',
//       const NotificationDetails(
//         android: androidDetails,
//         iOS: iosDetails,
//       ),
//     );
//   }
  

// }

// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_timezone/flutter_timezone.dart';
// // import 'package:timezone/data/latest.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;

// // class NotificationService {
// //   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// //       FlutterLocalNotificationsPlugin();

// //   Future<void> initializeNotification() async {
// //     // const AndroidInitializationSettings initializationSettingsAndroid =
// //     //     AndroidInitializationSettings('app_icon');
// //     const AndroidInitializationSettings initializationSettingsAndroid =
// //         AndroidInitializationSettings('@mipmap/ic_launcher');

// //     const DarwinInitializationSettings initializationSettingsIOS =
// //         DarwinInitializationSettings(
// //           requestAlertPermission: false,
// //           requestBadgePermission: false,
// //           requestSoundPermission: false,
// //         );

// //     const InitializationSettings initializationSettings =
// //         InitializationSettings(
// //           android: initializationSettingsAndroid,
// //           iOS: initializationSettingsIOS,
// //         );

// //     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// //   }

// //   Future<void> _configureLocalTimezone() async {
// //     tz.initializeTimeZones();
// //     String timeZoneName = await FlutterTimezone.getLocalTimezone();
// //     // Fix for incorrect "Katmandu" spelling
// //     if (timeZoneName == "Asia/Katmandu") {
// //       timeZoneName = "Asia/Kathmandu";
// //     }
// //     tz.setLocalLocation(tz.getLocation(timeZoneName));
// //   }

// //   Future<void> scheduleNotification(
// //     int id,
// //     String title,
// //     String body,
// //     DateTime scheduledTime,
// //   ) async {
// //     await _configureLocalTimezone();
// //     await flutterLocalNotificationsPlugin.zonedSchedule(
// //       id,
// //       title,
// //       body,
// //       tz.TZDateTime.from(scheduledTime, tz.local),
// //       const NotificationDetails(
// //         android: AndroidNotificationDetails(
// //           'your_channel_id',
// //           'your_channel_name',
// //           channelDescription: 'your_channel_description',
// //           importance: Importance.max,
// //           priority: Priority.high,
// //         ),
// //         iOS: DarwinNotificationDetails(),
// //       ),
// //       // New parameter for Android
// //       androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
// //       // This is now handled within DarwinNotificationDetails for iOS
// //       matchDateTimeComponents: DateTimeComponents.time
// //       // uiLocalNotificationDateInterpretation:
// //       //     UILocalNotificationDateInterpretation.absoluteTime,
// //     );
// //   }

// //   Future<void> requestIOSPermissions() async {
// //     await flutterLocalNotificationsPlugin
// //         .resolvePlatformSpecificImplementation<
// //           IOSFlutterLocalNotificationsPlugin
// //         >()
// //         ?.requestPermissions(alert: true, badge: true, sound: true);
// //   }
// // }
