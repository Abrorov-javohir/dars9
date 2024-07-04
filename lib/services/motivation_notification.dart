import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzl;
import 'dart:io';

class MotivationNotification {
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _localNotification
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _localNotification
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const androidInit = AndroidInitializationSettings('heart');
    final initSettings = InitializationSettings(
      android: androidInit,
    );

    await _localNotification.initialize(initSettings);
  }

  static void scheduleDailyNotification(
      {required int id, required String title, required String body}) async {
    await _localNotification.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOf(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'daily_motivation_channel', 'Daily Motivation',
            channelShowBadge: true,
            importance: Importance.high,
            priority: Priority.high),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOf() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, now.hour, now.minute + 1); // 1 minute from now

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(minutes: 1));
    }
    return scheduledDate;
  }
}
