import 'package:current_affairs/models/reminder/reminder_model.dart';
import 'package:current_affairs/services/notifications/notification_services.dart';
import 'package:current_affairs/services/reminder_hive/reminder_hive_services.dart';
import 'package:current_affairs/views/BookMarkAndReminder/bookMark/book_mark_qus.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/saved_qus_screen.dart';
import 'package:flutter/material.dart';
import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_container.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/widgets/savedAndAddQusCustumWidget.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/select_reminder.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with TickerProviderStateMixin {
  List<ReminderModel> reminders = [];
  late AnimationController _headerAnimController;
  late Animation<double> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();
    _loadReminders();
    _headerAnimController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _headerSlideAnimation = CurvedAnimation(
      parent: _headerAnimController,
      curve: Curves.easeOutCubic,
    );
    _headerAnimController.forward();
  }

  @override
  void dispose() {
    _headerAnimController.dispose();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    final box = await ReminderHiveService().getBox();
    reminders = [];

    for (int i = 0; i < box.length; i++) {
      final reminder = box.getAt(i);
      if (reminder != null) {
        reminder.hiveKey = box.keyAt(i);
        reminders.add(reminder);
      }
    }

    reminders = reminders.reversed.toList();
    setState(() {});
  }

  Color _getColor(String importance) {
    switch (importance) {
      case 'Important':
        return const Color(0xFFEF4444);
      case 'Less Important':
        return const Color(0xFFFBBF24);
      default:
        return const Color(0xFF10B981);
    }
  }

  Future<void> _clearAllReminders() async {
    if (reminders.isEmpty) {
      _showMessage(context, "No reminders to clear", isError: true);
      return;
    }
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2A2A2A), Color(0xFF1F1F1F)],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEF4444).withOpacity(0.2),
                blurRadius: 40,
              ),
            ],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.delete_forever_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Clear All Reminders?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'This action cannot be undone. All your reminders will be permanently deleted.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFEF4444).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          await ReminderHiveService().clearAllReminders();
                          await NotificationServices().cancelAll();
                          setState(() => reminders.clear());
                          Navigator.pop(context);
                          _showMessage(
                            context,
                            "All reminders cleared",
                            isError: false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessage(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError
                  ? Icons.error_outline_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError
            ? const Color(0xFFEF4444)
            : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        elevation: 0,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          ).createShader(bounds),
          child: const Text(
            'Book Mark & Reminder',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _headerSlideAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.3),
                  end: Offset.zero,
                ).animate(_headerSlideAnimation),
                child: Column(
                  children: [
                    Savedandaddquscustumwidget(
                      onTap: () { Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const BookMarkQus(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) => child,
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );},
                      title: "Book Mark",
                      icon: Icons.bookmark_rounded,
                      color1: const Color(0xFF2196F3),
                      color2: const Color(0xFF64B5F6),
                      shadowColor: const Color(0xFF2196F3).withOpacity(0.3),
                    ),
                    Savedandaddquscustumwidget(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SavedQusScreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) => child,
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      title: "Add Your Own Question",
                      icon: Icons.add_circle_outline_rounded,
                      color1: const Color(0xFF43A047),
                      color2: const Color(0xFF81C784),
                      shadowColor: const Color(0xFF43A047).withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
            SelectReminder(onReminderAdded: _loadReminders),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.15),
                      const Color(0xFF8B5CF6).withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.alarm_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "My Reminders",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFEF4444).withOpacity(0.2),
                            const Color(0xFFDC2626).withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.3),
                        ),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _clearAllReminders,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  Icons.delete_sweep_rounded,
                                  size: 20,
                                  color: Color(0xFFEF4444),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Clear',
                                  style: TextStyle(
                                    color: Color(0xFFEF4444),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (reminders.isEmpty)
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A2A2A).withOpacity(0.5),
                      const Color(0xFF1F1F1F).withOpacity(0.5),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6366F1).withOpacity(0.2),
                            const Color(0xFF8B5CF6).withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: Icon(
                        Icons.notifications_off_outlined,
                        size: 48,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "No reminders yet",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your first reminder above",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: reminders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final reminder = entry.value;
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 400 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(opacity: value, child: child),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReminderContainer(
                          onDelete: _loadReminders,
                          id: reminder.hiveKey!,
                          day: reminder.days.toString(),
                          color: _getColor(reminder.importance),
                          time: reminder.time,
                          title: reminder.content,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
