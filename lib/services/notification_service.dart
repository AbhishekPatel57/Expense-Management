// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

//   Future<void> init() async {
//     const android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     final settings = InitializationSettings(android: android);
//     await _plugin.initialize(settings);
//   }

//   Future<void> scheduleDailyReminder() async {
//     await _plugin.zonedSchedule(
//       0,
//       'Daily Expense Reminder',
//       'Don’t forget to add today’s expenses!',
//       _nextInstanceOfTime(20),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'daily_reminder_channel',
//           'Daily Reminder',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       matchDateTimeComponents: DateTimeComponents.time,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   tz.TZDateTime _nextInstanceOfTime(int hour) {
//     final now = tz.TZDateTime.now(tz.local);
//     final scheduledTime = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
//     return scheduledTime.isBefore(now) ? scheduledTime.add(Duration(days: 1)) : scheduledTime;
//   }
// }
