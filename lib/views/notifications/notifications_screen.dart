import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/viewmodels/noti/noti_provider.dart';
import 'package:current_affairs/views/notifications/widgets/nitifucation_cards.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final pro = Provider.of<NotiProvider>(context, listen: false);
      pro.markAllRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.bgcolor,
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
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: const Color(0xFF1A1D1F),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 22,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Clear All Notifications?",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "This action cannot be undone.",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () async {
                                  await Provider.of<NotiProvider>(
                                    context,
                                    listen: false,
                                  ).clearAllNoti();
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Clear",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },

            icon: const Icon(Icons.clear_all, size: 23),
          ),
        ],
      ),
      body: Consumer<NotiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.notiLists.isEmpty) {
            return const Center(child: Text('No Notifications..'));
          }
          if (provider.message.isNotEmpty) {
            return Center(child: Text(provider.message));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.notiLists.length,
            itemBuilder: (context, index) {
              final data = provider.notiLists.reversed.toList()[index];
              return NotificationCard(
                title: data.title,
                time: (data.time).toDate(),
              );
            },
          );
        },
      ),
    );
  }
}
