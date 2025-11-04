import 'package:current_affairs/models/tasks/tasks_model.dart';
import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskSetWidget extends StatefulWidget {
  const TaskSetWidget({super.key, required});

  @override
  State<TaskSetWidget> createState() => _TaskSetWidgetState();
}

class _TaskSetWidgetState extends State<TaskSetWidget> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormatter = DateFormat('hh:mm a');

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskPrvider>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Create New Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Title'),
            ),
            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dateButton(context),
                const SizedBox(width: 10),
                _timeButton(context, true),
                const SizedBox(width: 10),
                _timeButton(context, false),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                const Text(
                  'Important',
                  style: TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                Switch(
                  value: taskProvider.isImportant,
                  activeColor: Colors.redAccent,
                  onChanged: (v) => taskProvider.toggleImportant(v),
                ),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: contentController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration('Details'),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (titleController.text.trim().isEmpty ||
                        contentController.text.trim().isEmpty ||
                        startTime == null ||
                        endTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    final startDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      startTime!.hour,
                      startTime!.minute,
                    );
                    final endDateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      endTime!.hour,
                      endTime!.minute,
                    );

                    final model = TasksModel(
                      title: titleController.text.trim(),
                      day: _dateFormatter.format(selectedDate),
                      starttime: _timeFormatter.format(startDateTime),
                      endtime: _timeFormatter.format(endDateTime),
                      content: contentController.text.trim(),
                      important: taskProvider.isImportant,
                      completed: false,
                    );

                    taskProvider.addTask(model);
                    Navigator.pop(context);
                    titleController.clear();
                    contentController.clear();
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    labelStyle: const TextStyle(color: Colors.white70),
    filled: true,
    fillColor: Colors.white.withOpacity(0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide.none,
    ),
  );

  Widget _dateButton(BuildContext context) => Expanded(
    child: TextButton.icon(
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2023),
          lastDate: DateTime(2030),
          builder: (context, child) => Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.blueAccent,
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
        if (picked != null) setState(() => selectedDate = picked);
      },
      icon: const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
      label: Text(
        selectedDate.day == DateTime.now().day
            ? 'Today'
            : _dateFormatter.format(selectedDate),
        style: const TextStyle(color: Colors.white70),
      ),
    ),
  );

  Widget _timeButton(BuildContext context, bool isStart) => Expanded(
    child: TextButton.icon(
      onPressed: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          setState(() {
            if (isStart)
              startTime = picked;
            else
              endTime = picked;
          });
        }
      },
      icon: Icon(
        isStart ? Icons.access_time : Icons.timer_off,
        color: Colors.white70,
        size: 18,
      ),
      label: Text(
        isStart
            ? (startTime == null
                  ? 'Start'
                  : _timeFormatter.format(
                      DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        startTime!.hour,
                        startTime!.minute,
                      ),
                    ))
            : (endTime == null
                  ? 'End'
                  : _timeFormatter.format(
                      DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        endTime!.hour,
                        endTime!.minute,
                      ),
                    )),
        style: const TextStyle(color: Colors.white70),
      ),
    ),
  );
}
