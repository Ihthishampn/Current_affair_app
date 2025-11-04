import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/routes/routes.dart';
import 'package:current_affairs/views/Affairs/widgets/header_refresh_widgets.dart';
import 'package:current_affairs/views/Affairs/widgets/qus_card.dart';
import 'package:current_affairs/views/notifications/notifications_screen.dart';
import 'package:flutter/material.dart';

class AffairScreen extends StatelessWidget {
  const AffairScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        title: Text('Current Affairs'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  reverseTransitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (_, animation, __) {
                    return const NotificationsScreen();
                  },
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(
                      // small fade helps hide any flash
                      opacity: animation,
                      child: SlideTransition(
                        position:
                            Tween(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            },
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // header refresh widgets
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 10,
              ),
              child: HeaderRefreshWidgets(),
            ),

            //---------------------------
            const SizedBox(height: 12),

            // headin explore
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Explore Questians',
                  style: TextStyle(fontSize: 17),
                ),
              ),
            ),

            //---------------------------------
            const SizedBox(height: 12),

            const Divider(indent: 30, endIndent: 30, thickness: 0.2),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              itemBuilder: (context, index) => const QuestionCard(
                category: 'History',
                question: 'Who was the first President of India?',
                answer: 'Dr. Rajendra Prasad',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
