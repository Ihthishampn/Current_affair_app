import 'package:current_affairs/models/reminder/reminder_model.dart';
import 'package:current_affairs/services/reminder_hive/reminder_hive_services.dart';
import 'package:current_affairs/services/notifications/notification_services.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_confirm_dialog.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_content_field.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_importance_row.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_repeat_dropDown.dart';
import 'package:current_affairs/views/BookMarkAndReminder/reminder_Notification/widgets/reminder_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class SelectReminder extends StatefulWidget {
  final VoidCallback? onReminderAdded;
  const SelectReminder({super.key, this.onReminderAdded});

  @override
  State<SelectReminder> createState() => _SelectReminderState();
}

class _SelectReminderState extends State<SelectReminder>
    with SingleTickerProviderStateMixin {
  TimeOfDay? selectTime;
  final TextEditingController contentController = TextEditingController();
  String importance = 'Normal';
  String repeatMode = 'Today only';
  final NotificationServices notificationServices = NotificationServices();
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;



  @override
  void initState() {
    super.initState();
    notificationServices.initNotification();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    contentController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _showConfirmDialog() async {
    final confirmed = await showReminderConfirmDialog(context);
    if (confirmed == true) await _scheduleReminder();
  }

  Future<void> _scheduleReminder() async {
    if (selectTime == null || contentController.text.trim().isEmpty) {
      _showSnackBar('Please select time and content', isError: true);
      return;
    }

    var granted = await notificationServices.notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    if (!(granted ?? false)) {
      _showSnackBar("Notification permission required!", isError: true);
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _scheduleNotification(id);
    await _saveReminder(id);

    final formattedTime =
        DateFormat('hh:mm a').format(DateTime(0, 0, 0, selectTime!.hour, selectTime!.minute));

    _showSnackBar('Reminder set for $repeatMode at $formattedTime', isError: false);
    _resetForm();
    widget.onReminderAdded?.call();
  }

  Future<void> _scheduleNotification(int id) async {
    final title = "Reminder ($importance priority)";
    final body = contentController.text.trim();

    if (repeatMode == 'Every Monday') {
      await notificationServices.repeatOnSpecificDay(
        id: id,
        title: title,
        body: body,
        scheduledDay: 'Monday',
        hour: selectTime!.hour,
        minute: selectTime!.minute,
      );
    } else if (repeatMode == 'All Week (Mon–Sun)') {
      await notificationServices.repeatAllWeekDays(
        idStart: id,
        title: title,
        body: body,
        hour: selectTime!.hour,
        minute: selectTime!.minute,
      );
    } else {
      await notificationServices.todayOnly(
        id: id,
        title: title,
        body: body,
        hour: selectTime!.hour,
        minute: selectTime!.minute,
      );
    }
  }

  Future<void> _saveReminder(int id) async {
    final formattedTime =
        DateFormat('hh:mm a').format(DateTime(0, 0, 0, selectTime!.hour, selectTime!.minute));

    final reminder = ReminderModel(
      content: contentController.text.trim(),
      importance: importance,
      time: formattedTime,
      days: [repeatMode],
      notificationIds: [id],
    );

    await ReminderHiveService().addReminder(reminder);
  }

  void _resetForm() {
    setState(() {
      selectTime = null;
      contentController.clear();
      importance = 'Normal';
      repeatMode = 'Today only';
    });
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 15))),
          ],
        ),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.notifications_active_rounded,
                        color: Color(0xFF8B5CF6), size: 28),
                    SizedBox(width: 10),
                    Text(
                      "Set Reminder",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ReminderTimePicker(
                  selectedTime: selectTime,
                  onTimeSelected: (time) => setState(() => selectTime = time),
                ),
                const SizedBox(height: 20),
                ReminderRepeatDropdown(
                  repeatMode: repeatMode,
                  onChanged: (mode) => setState(() => repeatMode = mode),
                ),
                const SizedBox(height: 20),
                ReminderContentField(controller: contentController),
                const SizedBox(height: 20),
                ReminderImportanceRow(
                  importance: importance,
                  onImportanceChanged: (imp) =>
                      setState(() => importance = imp),
                  onSetReminder: _showConfirmDialog,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _showConfirmDialog,
                    icon: const Icon(Icons.alarm_add_rounded, size: 22),
                    label: const Text(
                      "Set Reminder",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B5CF6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 28),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
