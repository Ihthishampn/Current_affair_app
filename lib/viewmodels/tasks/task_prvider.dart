import 'package:current_affairs/models/tasks/tasks_model.dart';
import 'package:current_affairs/services/tasks/Task_hive_services/task_hive_services.dart';
import 'package:flutter/material.dart';

class TaskPrvider extends ChangeNotifier {
  final TaskHiveServices taskHiveServices = TaskHiveServices();
  List<TasksModel> taskLists = [];
  bool isLoading = false;
  String error = 'some error occured';
  bool isImportant = false;

  TaskPrvider() {
    getTask();
  }

  void toggleImportant(bool value) {
    isImportant = value;
    notifyListeners();
  }

  Future<void> getTask() async {
    isLoading = true;
    notifyListeners();
    try {
      taskLists.clear();
      final task = await taskHiveServices.getHiveTaskValues();
      // new first nnnnnnnnnnnn
      taskLists.addAll(task.reversed); 
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(TasksModel model) async {
    try {
      await taskHiveServices.addTaskToHive(model);
      await getTask(); // refresh after adding
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> toggleCompleted(bool val, int index) async {
    final task = taskLists[index];
    task.completed = val;
     // directly update Hive record

    await task.save();
    
    notifyListeners();
  }

  void delete() async {
    await taskHiveServices.deleteAllToHive();
    getTask();
  }

Future<void> deleteTask(int index) async {
  final box = await taskHiveServices.tasksBox;
  final key = box.keyAt(index); 
  await taskHiveServices.deleteToHive(key);

  taskLists.removeAt(index);
  notifyListeners();
}

}
