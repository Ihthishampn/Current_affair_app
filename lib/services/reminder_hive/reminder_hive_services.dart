import 'package:hive/hive.dart';
import 'package:current_affairs/models/reminder/reminder_model.dart';
import 'package:current_affairs/services/notifications/notification_services.dart';

class ReminderHiveService {
  static const String _boxName = 'reminders';

  Future<Box<ReminderModel>> _openBox() async {
    return await Hive.openBox<ReminderModel>(_boxName);
  }

  Future<void> addReminder(ReminderModel reminder) async {
    final box = await _openBox();
    await box.add(reminder);
  }
Future<void> deleteReminderByKey(int key) async {
  final box = await Hive.openBox<ReminderModel>('reminders');
  final reminder = box.get(key);
  if (reminder != null) {
    final notificationService = NotificationServices();
    await notificationService.initNotification();
    await notificationService.cancelMultiple(reminder.notificationIds);
    await box.delete(key);
  }
}
Future<Box<ReminderModel>> getBox() async {
  return await Hive.openBox<ReminderModel>('reminders');
}


  Future<List<ReminderModel>> getReminders() async {
    final box = await _openBox();
    return box.values.toList();
  }

  Future<void> deleteReminderAt(int index) async {
    final box = await _openBox();
    final reminder = box.getAt(index);
    if (reminder != null) {
      // cancel scheduled notifications
      final notificationService = NotificationServices();
      // ensure notification plugin is initialized before cancelling
      await notificationService.initNotification();
      await notificationService.cancelMultiple(reminder.notificationIds);
      await box.deleteAt(index);
    }
  }

  Future<void> clearAllReminders() async {
    final box = await _openBox();
    final notificationService = NotificationServices();
    await notificationService.initNotification();

    for (final r in box.values) {
      await notificationService.cancelMultiple(r.notificationIds);
    }
    await box.clear();
  }
}
