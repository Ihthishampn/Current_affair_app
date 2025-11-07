import 'package:current_affairs/entry/entry.dart';
import 'package:current_affairs/views/Affairs/affairs_screen.dart';
import 'package:current_affairs/views/BookMarkAndReminder/saveOwnQus/saved_qus_screen.dart';
import 'package:current_affairs/views/auth/login/login_screen.dart';
import 'package:current_affairs/views/auth/signUp/sign_screen.dart';
import 'package:current_affairs/views/notifications/notifications_screen.dart';
import 'package:current_affairs/views/profile/aboutApp/about_app_screen.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String home = 'Home';
  static const String login = 'Login';
  static const String sign = 'Sign';
  static const String entry = 'Entry';
  static const String notification = 'notification';
  static const String savedOwnQus = 'savedOwnQus';
  static const String aboutApp = 'aboutApp';
  static const String signUp = 'signUp';
  static const String loginScreen = 'loginScreen';

  static Map<String, WidgetBuilder> routes = {
    home: (context) => AffairScreen(),
    login: (context) => LoginScreen(),
    sign: (context) => SignUpScreen(),
    entry: (context) => EntryScreen(),
    notification: (context) => NotificationsScreen(),
    savedOwnQus: (context) => SavedQusScreen(),
    aboutApp: (context) => AboutAppScreen(),
    signUp: (context) => SignUpScreen(),
    loginScreen: (context) => LoginScreen(),
  };
}
