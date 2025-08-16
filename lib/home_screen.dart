import 'package:flutter/material.dart';
import 'package:flutter_local_notification/notification_service.dart';

DateTime scheduleTime = DateTime.now();

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [DatePickerTxt(), ScheduleBtn()],
        ),
      ),
    );
  }
}

class DatePickerTxt extends StatefulWidget {
  const DatePickerTxt({super.key});

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (pickedTime != null) {
        setState(() {
          scheduleTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        _selectDateTime();
        // DatePicker.showDateTimePicker(
        //   context,
        //   showTitleActions: true,
        //   onChanged: (date) => scheduleTime = date,
        //   onConfirm: (date) {},
        // );
      },
      child: const Text(
        'Select Date Time',
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}

class ScheduleBtn extends StatelessWidget {
  const ScheduleBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Schedule notifications'),
      onPressed: () {
        debugPrint('Notification Scheduled for $scheduleTime');
        final now = DateTime.now();
        // Schedule multiple notifications with proper unique IDs
        NotificationService().scheduleNotification(
          title: 'First Notification',
          body: 'Scheduled at ${now.add(Duration(minutes: 1))}',
          scheduledNotificationDateTime: now.add(Duration(minutes: 1)),
        );

        NotificationService().scheduleNotification(
          title: 'Second Notification',
          body: 'Scheduled at ${now.add(Duration(minutes: 2))}',
          scheduledNotificationDateTime: now.add(Duration(minutes: 2)),
        );

        NotificationService().scheduleNotification(
          title: 'Third Notification',
          body: 'Scheduled at ${now.add(Duration(minutes: 3))}',
          scheduledNotificationDateTime: now.add(Duration(minutes: 3)),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'notification_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final NotificationService _notificationService = NotificationService();
//   DateTime? _selectedDateTime;

//   @override
//   void initState() {
//     super.initState();
//     _initNotifications();
//     // await _notificationService.initializeNotification();
//     // await _notificationService.requestIOSPermissions();
//     // await _notificationService.requestAndroidPermissions();

//     // Test if notifications work immediately
//     // await _notificationService.showTestNotification();
//   }

//   // Future<void> _initNotifications() async {
//   //   await _notificationService.initializeNotification();
//   //   await _notificationService.requestIOSPermissions();
//   //   await _notificationService.requestAndroidPermissions();

//   //   // Test if notifications work immediately
//   //   // await _notificationService.showTestNotification();
//   //   final testTime = DateTime.now().add(Duration(seconds: 5));
//   //   await _notificationService.scheduleNotification(
//   //     1,
//   //     'Test Scheduled',
//   //     'This should appear soon',
//   //     testTime,
//   //   );
//   // }

//   Future<void> _initNotifications() async {
//     await _notificationService.initializeNotification();
//     await _notificationService.requestIOSPermissions();
//     await _notificationService.requestAndroidPermissions();

//     // Test immediate notification first
//     // await _notificationService.showTestNotification();

//     // Then test scheduled notification
//     final testTime = DateTime.now().add(const Duration(seconds: 10));
//     print('Testing scheduled notification for $testTime');

//     await _notificationService.scheduleNotification(
//       1,
//       'Test Scheduled',
//       'This should appear in 10 seconds',
//       testTime,
//     );

//     // Also schedule one for 1 minute in future
//     final futureTime = DateTime.now().add(const Duration(minutes: 1));
//     await _notificationService.scheduleNotification(
//       2,
//       'Future Notification',
//       'This should appear in 1 minute',
//       futureTime,
//     );
//   }

//   Future<void> _selectDateTime() async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null) {
//       final TimeOfDay? pickedTime = await showTimePicker(
//         // ignore: use_build_context_synchronously
//         context: context,
//         initialTime: TimeOfDay.fromDateTime(DateTime.now()),
//       );

//       if (pickedTime != null) {
//         setState(() {
//           _selectedDateTime = DateTime(
//             pickedDate.year,
//             pickedDate.month,
//             pickedDate.day,
//             pickedTime.hour,
//             pickedTime.minute,
//           );
//         });
//       }
//     }
//   }

//   void _scheduleNotification() {
//     if (_selectedDateTime != null) {
//       _notificationService.scheduleNotification(
//         0,
//         'Scheduled Notification',
//         'This is a notification scheduled for a specific time.',
//         _selectedDateTime!,
//       );
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Notification scheduled for $_selectedDateTime'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Flutter Local Notifications')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Select a Date and Time for the Notification:'),
//             const SizedBox(height: 20),
//             Text(
//               _selectedDateTime == null
//                   ? 'No date and time selected'
//                   : '${_selectedDateTime!.toLocal()}'.split('.')[0],
//               style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectDateTime,
//               child: const Text('Select Date & Time'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _selectedDateTime != null
//                   ? _scheduleNotification
//                   : null,
//               child: const Text('Schedule Notification'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
