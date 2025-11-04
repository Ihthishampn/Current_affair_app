import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initNotification() async {
    if (_isInitialized) return;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await notificationPlugin.initialize(initSettings);
    _isInitialized = true;

    await notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission(); // safe request
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'all_week_channel_id',
        'All Week Notifications',
        channelDescription: 'Notifications for all weekdays',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
    );
  }

  /// One-time: Today only (if time passed, schedules for tomorrow)
  Future<void> todayOnly({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 1));

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Weekly repeat on a specific weekday (e.g., 'Monday')
  Future<void> repeatOnSpecificDay({
    required int id,
    required String title,
    required String body,
    required String scheduledDay,
    required int hour,
    required int minute,
  }) async {
    final dayMap = {
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    final dayInt = dayMap[scheduledDay] ?? DateTime.monday;
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    while (scheduled.weekday != dayInt) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 7));

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduled,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  /// Schedule notification for all 7 days (Mon–Sun) using idStart..idStart+6
  Future<void> repeatAllWeekDays({
    required int idStart,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final days = <String, int>{
      'Monday': DateTime.monday,
      'Tuesday': DateTime.tuesday,
      'Wednesday': DateTime.wednesday,
      'Thursday': DateTime.thursday,
      'Friday': DateTime.friday,
      'Saturday': DateTime.saturday,
      'Sunday': DateTime.sunday,
    };

    final now = tz.TZDateTime.now(tz.local);
    int idx = 0;

    for (final entry in days.entries) {
      tz.TZDateTime scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
      while (scheduled.weekday != entry.value) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      if (scheduled.isBefore(now)) scheduled = scheduled.add(const Duration(days: 7));

      await notificationPlugin.zonedSchedule(
        idStart + idx,
        '$title (${entry.key})',
        body,
        scheduled,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      idx++;
    }
  }

  Future<void> cancel(int id) async => await notificationPlugin.cancel(id);

  Future<void> cancelMultiple(List<int> ids) async {
    for (final id in ids) await notificationPlugin.cancel(id);
  }

  Future<void> cancelAll() async => await notificationPlugin.cancelAll();
}
