import 'package:flutter/material.dart';

class ReminderRepeatDropdown extends StatelessWidget {
  final String repeatMode;
  final Function(String) onChanged;

  static const List<String> repeatOptions = [
    'Today only',
    'Every Monday',
    'All Week (Mon–Sun)',
  ];

  const ReminderRepeatDropdown({
    super.key,
    required this.repeatMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Repeat Option:",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        DropdownButton<String>(
          dropdownColor: Colors.black,
          style: const TextStyle(color: Colors.white),
          value: repeatMode,
          items: repeatOptions
              .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
              .toList(),
          onChanged: (val) => onChanged(val!),
        ),
      ],
    );
  }
}