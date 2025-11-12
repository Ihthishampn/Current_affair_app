import 'package:current_affairs/services/notifications/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:current_affairs/services/reminder_hive/reminder_hive_services.dart';

class ReminderContainer extends StatelessWidget {
  final int id;
  final String title;
  final String day;
  final String time;
  final Color color;
  final VoidCallback onDelete;

  const ReminderContainer({
    super.key,
    required this.id,
    required this.color,
    required this.day,
    required this.time,
    required this.title,
    required this.onDelete,
  });

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.grey[900],
        title: Row(
          children: const [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.redAccent,
              size: 28,
            ),
            SizedBox(width: 10),
            Text(
              'Delete Reminder',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete "$title"?',
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.grey[400]),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              await NotificationServices().cancel(id);
              await ReminderHiveService().deleteReminderByKey(id);
              onDelete(); 

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Reminder "$title" deleted.'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.alarm, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                Text(
                  day,
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showDeleteDialog(context),
            child: const Icon(Icons.delete, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
