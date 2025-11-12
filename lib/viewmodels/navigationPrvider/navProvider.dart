import 'package:current_affairs/views/Affairs/affairs_screen.dart';
import 'package:current_affairs/views/profile/profile_screens.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saved_screen.dart';
import 'package:current_affairs/views/task/task_screen.dart';
import 'package:flutter/material.dart';

class Navprovider extends ChangeNotifier {
  int currentIndex = 0;
  List<Widget> widgets = [AffairScreen(), SavedScreen(),TaskManagerScreen(),ProfileScreens()];

  void changeIndexNavigation(int index) {
    currentIndex = index;
    notifyListeners();
  }
}
