import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tzl;
import 'dart:io';

class LocalNotifictionSerivce {
  static final _localNotifcation = FlutterLocalNotificationsPlugin();
  static bool notificationEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      notificationEnabled = await _localNotifcation
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              ) ??
          false;
      await _localNotifcation
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplements =
          _localNotifcation.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? grantedNotficationsPermissions =
          await androidImplements?.requestNotificationsPermission();
      final bool? grantedScheduleNotficationsPermissions =
          await androidImplements?.requestExactAlarmsPermission();

      notificationEnabled = grantedNotficationsPermissions ?? false;
      notificationEnabled = grantedScheduleNotficationsPermissions ?? false;
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();

    tzl.initializeTimeZones();
    tz.setLocalLocation(
      tz.getLocation(currentTimeZone),
    );
    const androidInit =
        AndroidInitializationSettings("heart"); // Use the correct icon name
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );
    final notificationInit =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await _localNotifcation.initialize(notificationInit);
  }

  static void showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      actions: [
        AndroidNotificationAction(
          'id_1',
          'Action1',
        ),
        AndroidNotificationAction(
          'id_2',
          'Action2',
        ),
        AndroidNotificationAction(
          'id_3',
          'Action3',
        ),
      ],
    );

    const iosDetails =
        DarwinNotificationDetails(categoryIdentifier: 'demoCategory');

    const notificationDetails = NotificationDetails(
      iOS: iosDetails,
      android: androidDetails,
    );
    await _localNotifcation.show(
        0,
        'Birinchi Notification',
        'Salom sizga\$100000 pul tushdi,Sms kodni ayting!',
        notificationDetails);
  }

  // Other methods...
}
