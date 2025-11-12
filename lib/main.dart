
import 'package:current_affairs/core/colors.dart';
  import 'package:current_affairs/firebase_options.dart';
  import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
  import 'package:current_affairs/models/reminder/reminder_model.dart';
  import 'package:current_affairs/models/tasks/tasks_model.dart';
  import 'package:current_affairs/routes/routes.dart';
  import 'package:current_affairs/services/notifications/notification_services.dart';
import 'package:current_affairs/viewmodels/affair/affair_provider.dart';
  import 'package:current_affairs/viewmodels/auth/login/login_provider.dart';
  import 'package:current_affairs/viewmodels/auth/signin/sign_in_provider.dart';
import 'package:current_affairs/viewmodels/bookmark/bookmark_provider.dart';
  import 'package:current_affairs/viewmodels/navigationPrvider/navProvider.dart';
import 'package:current_affairs/viewmodels/noti/noti_provider.dart';
  import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
  import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:current_affairs/views/authCheckSreen/authCheckScreen.dart';
  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
  import 'package:hive_flutter/hive_flutter.dart';
  import 'package:provider/provider.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await NotificationServices().initNotification();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Hive.initFlutter();

    Hive.registerAdapter(TasksModelAdapter());
    Hive.registerAdapter(ReminderModelAdapter());
    Hive.registerAdapter(OwnaddqusAdapter());
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Navprovider()),
          ChangeNotifierProvider(create: (context) => TaskPrvider()),
          ChangeNotifierProvider(create: (context) => OwnAddQusProvider()),
          ChangeNotifierProvider(create: (context) => SignInProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => NotiProvider()),
          ChangeNotifierProvider(create: (context) => AffairProvider()),
          ChangeNotifierProvider(create: (context) => BookmarkProvider()),
          // ChangeNotifierProvider(create: (context) => ForgetPasswordProvider()),
        ],
        child: MaterialApp(
          theme: ThemeData(
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            scaffoldBackgroundColor: AppColors.bgcolor,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.bgcolor,
              titleTextStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          debugShowCheckedModeBanner: false,
      home: const AuthCheckScreen(), 


          routes: AppRoutes.routes,
        ),
      );
    }
  }




