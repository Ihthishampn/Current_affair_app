import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:current_affairs/views/task/widgets/delete_all_button.dart';
import 'package:current_affairs/views/task/widgets/task_input_field.dart';
import 'package:current_affairs/views/task/widgets/task_item.dart';
import 'package:current_affairs/views/task/widgets/task_set_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  String filter = 'All'; 

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskPrvider>(context);

    final tasks = filter == 'All'
        ? provider.taskLists
        : filter == 'Completed'
        ? provider.taskLists.where((task) => task.completed).toList()
        : provider.taskLists.where((task) => !task.completed).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          'Task Manager',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: DeleteAllButton(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white12, width: 1),
              ),
              padding: const EdgeInsets.all(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterButton('All', filter == 'All'),
                  _filterButton('Completed', filter == 'Completed'),
                  _filterButton('Pending', filter == 'Pending'),
                ],
              ),
            ),
          ),

          // Input field
          TaskInputField(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.all(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const TaskSetWidget(),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 10),

          // Task list
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks found.',
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return TaskItemWidget(task: task, index: index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filterButton(String text, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 110),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: selected
            ? Colors.blueAccent.withOpacity(0.25)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
      child: TextButton(
        onPressed: () => setState(() => filter = text),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
