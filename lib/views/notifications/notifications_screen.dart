import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/views/notifications/widgets/nitifucation_cards.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,

        elevation: 4,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Clear All',
            onPressed: () {},
            icon: const Icon(Icons.clear_all, size: 23),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return NotificationCard(
            title: 'New Update Available',
            message: 'Check out the latest news in Current Affairs.',
            time: 'Just now',
            onDelete: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notification deleted')),
              );
            },
          );
        },
      ),
    );
  }
}
