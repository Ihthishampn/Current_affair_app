import 'package:current_affairs/models/tasks/tasks_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TaskHiveServices {
  Future<Box<TasksModel>> get tasksBox => Hive.openBox<TasksModel>('TaskBox');

  Future<void> addTaskToHive(TasksModel model) async {
    final box = await tasksBox;
    await box.add(model);
  }

  Future<void> editToHive(TasksModel model, int key) async {
    final box = await tasksBox;
    await box.put(key, model);
  }

Future<void> deleteToHive(dynamic key) async {
  final box = await tasksBox;
  await box.delete(key);
}


  Future<void> deleteAllToHive() async {
    final box = await tasksBox;
    await box.clear();
  }

  Future<List<TasksModel>> getHiveTaskValues() async {
    final box = await tasksBox;
    return box.values.toList();
  }

Future<void> updateCompleted(bool val, int key) async {
  final box = await tasksBox;
  final task = box.get(key);
  if (task != null) {
    final updatedTask = TasksModel(
      title: task.title,
      day: task.day,
      starttime: task.starttime,
      endtime: task.endtime,
      content: task.content,
      important: task.important,
      completed: val,
    );
    await box.put(key, updatedTask);
  }
}




}
