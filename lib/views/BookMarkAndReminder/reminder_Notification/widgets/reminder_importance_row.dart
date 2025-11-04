import 'package:flutter/material.dart';

class ReminderImportanceRow extends StatelessWidget {
  final String importance;
  final Function(String) onImportanceChanged;
  final VoidCallback onSetReminder;

  const ReminderImportanceRow({
    super.key,
    required this.importance,
    required this.onImportanceChanged,
    required this.onSetReminder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          dropdownColor: Colors.black,
          style: const TextStyle(color: Colors.white),
          value: importance,
          items: const [
            DropdownMenuItem(value: 'Important', child: Text('Important')),
            DropdownMenuItem(value: 'Normal', child: Text('Normal')),
            DropdownMenuItem(
              value: 'Less Important',
              child: Text('Less Important'),
            ),
          ],
          onChanged: (val) => onImportanceChanged(val!),
        ),
      ],
    );
  }
}
