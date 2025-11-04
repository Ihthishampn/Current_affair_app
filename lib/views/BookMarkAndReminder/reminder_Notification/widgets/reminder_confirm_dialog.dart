import 'package:flutter/material.dart';

Future<bool?> showReminderConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: const [
          Icon(Icons.notifications_active, color: Colors.blueAccent, size: 26),
          SizedBox(width: 10),
          Text(
            "Set Reminder",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: const Text(
        "Do you want to set this reminder?",
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey[400],
          ),
          child: const Text("Cancel"),
        ),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          icon: const Icon(Icons.check, color: Colors.white),
          label: const Text(
            "Confirm",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );
}