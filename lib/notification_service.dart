import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),

    );

    await _plugin.initialize(settings);
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> scheduleDailyAtHour(int hour) async {
    final now = tz.TZDateTime.now(tz.local);

    final scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    await _plugin.zonedSchedule(
      0,
      'POP',
      'Un grain pour aujourd’hui',
      scheduled.isBefore(now)
          ? scheduled.add(const Duration(days: 1))
          : scheduled,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'pop_daily',
          'POP quotidien',
          importance: Importance.low,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
