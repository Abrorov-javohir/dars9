import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzl;

class PomodoroNotificationService {
  final FlutterLocalNotificationsPlugin _localNotification =
      FlutterLocalNotificationsPlugin();

  PomodoroNotificationService() {
    tzl.initializeTimeZones();
  }

  Future<void> schedulePomodoroReminder() async {
    const androidDetails = AndroidNotificationDetails(
      'pomodoro_channel',
      'Pomodoro Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotification.zonedSchedule(
      0,
      'Pomodoro Reminder',
      'Time to take a break!',
      _nextInstanceOfTwoHours(),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfTwoHours() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now.add(Duration(seconds: 5));
    return scheduledDate;
  }

  Future<void> repeatPomodoroReminder() async {
    await schedulePomodoroReminder();
    Future.delayed(Duration(seconds: 5), repeatPomodoroReminder);
  }
}
