import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/firebase_options.dart';
import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
import 'package:current_affairs/models/reminder/reminder_model.dart';
import 'package:current_affairs/models/tasks/tasks_model.dart';
import 'package:current_affairs/routes/routes.dart';
import 'package:current_affairs/services/local_auth_services/local_authServices.dart';
import 'package:current_affairs/services/notifications/notification_services.dart';
import 'package:current_affairs/viewmodels/navigationPrvider/navProvider.dart';
import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init noti
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
        builder: (context, child) {
          return AuthGateScreen(
            child: child ?? const SizedBox(),
          );
        },
        initialRoute: AppRoutes.entry,
        routes: AppRoutes.routes,
      ),
    );
  }
}