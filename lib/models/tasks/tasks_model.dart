import 'package:hive_flutter/hive_flutter.dart';
part 'tasks_model.g.dart';

@HiveType(typeId: 0)
class TasksModel extends HiveObject {
  @HiveField(0)
  final String title;
  @HiveField(1)
  final String day;
  @HiveField(2)
  final String starttime;
  @HiveField(3)
  final String endtime;
  @HiveField(4)
  bool important;
  @HiveField(5)
  final String content;
  @HiveField(6)
  bool completed;

  TasksModel({
    required this.title,
    required this.day,
    required this.starttime,
    required this.endtime,
    required this.content,
    required this.important,
    required this.completed,
  });

  TasksModel copyWith({
    String? title,
    String? day,
    String? starttime,
    String? endtime,
    String? content,
    bool? important,
    bool? completed,
  }) {
    return TasksModel(
      title: title ?? this.title,
      day: day ?? this.day,
      starttime: starttime ?? this.starttime,
      endtime: endtime ?? this.endtime,
      content: content ?? this.content,
      important: important ?? this.important,
      completed: completed ?? this.completed,
    );
  }
}
