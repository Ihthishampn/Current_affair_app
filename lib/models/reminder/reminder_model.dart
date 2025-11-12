import 'package:hive/hive.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 1)
class ReminderModel extends HiveObject {
  @HiveField(0)
  final String content;

  @HiveField(1)
  final String importance;

  @HiveField(2)
  final String time;

  @HiveField(3)
  final List<String> days;

  @HiveField(4)
  final List<int> notificationIds;

  int? hiveKey; // runtime key, so its not stored in Hive  (ith shredhikannam)

  ReminderModel({
    required this.content,
    required this.importance,
    required this.time,
    required this.days,
    required this.notificationIds,
    this.hiveKey,
  });
}
