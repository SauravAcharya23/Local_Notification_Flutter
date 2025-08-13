import 'package:flutter/material.dart';
import 'notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NotificationService _notificationService = NotificationService();
  DateTime? _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _notificationService.initializeNotification();
    _notificationService.requestIOSPermissions();
  }

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
          _selectedDateTime = DateTime(
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

  void _scheduleNotification() {
    if (_selectedDateTime != null) {
      _notificationService.scheduleNotification(
        0,
        'Scheduled Notification',
        'This is a notification scheduled for a specific time.',
        _selectedDateTime!,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification scheduled for $_selectedDateTime'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Local Notifications'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Select a Date and Time for the Notification:',
            ),
            const SizedBox(height: 20),
            Text(
              _selectedDateTime == null
                  ? 'No date and time selected'
                  : '${_selectedDateTime!.toLocal()}'.split('.')[0],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDateTime,
              child: const Text('Select Date & Time'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedDateTime != null ? _scheduleNotification : null,
              child: const Text('Schedule Notification'),
            ),
          ],
        ),
      ),
    );
  }
}