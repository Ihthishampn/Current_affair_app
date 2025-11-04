import 'package:flutter/material.dart';

class ReminderTimePicker extends StatelessWidget {
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay?) onTimeSelected;

  const ReminderTimePicker({
    super.key,
    required this.selectedTime,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Select Time:",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
       ElevatedButton.icon(
  onPressed: () async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    onTimeSelected(time);
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.orangeAccent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12), 
    ),
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  ),
  icon: const Icon(Icons.access_time, color: Colors.white),
  label: Text(
    selectedTime == null ? "Pick Time" : selectedTime!.format(context),
    style: const TextStyle(color: Colors.white),
  ),
)

      ],
    );
  }
}