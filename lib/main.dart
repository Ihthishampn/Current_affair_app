  import 'dart:async';

import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/entry/entry.dart';
  import 'package:current_affairs/firebase_options.dart';
  import 'package:current_affairs/models/ownAddQus/ownAddQus.dart';
  import 'package:current_affairs/models/reminder/reminder_model.dart';
  import 'package:current_affairs/models/tasks/tasks_model.dart';
  import 'package:current_affairs/routes/routes.dart';
  import 'package:current_affairs/services/local_auth_services/local_authServices.dart';
  import 'package:current_affairs/services/notifications/notification_services.dart';
  import 'package:current_affairs/viewmodels/auth/login/forget+provider.dart';
  import 'package:current_affairs/viewmodels/auth/login/login_provider.dart';
  import 'package:current_affairs/viewmodels/auth/signin/sign_in_provider.dart';
  import 'package:current_affairs/viewmodels/navigationPrvider/navProvider.dart';
  import 'package:current_affairs/viewmodels/own_add_qus/own_add_qus_provider.dart';
  import 'package:current_affairs/viewmodels/tasks/task_prvider.dart';
import 'package:current_affairs/views/auth/login/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          ChangeNotifierProvider(create: (context) => SignInProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
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
      home: const AuthCheckScreen(), // Start here instead


          // entry
          routes: AppRoutes.routes,
        ),
      );
    }
  }





class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show loading while checking auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.bgcolor,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)),
            ),
          );
        }

        // If user is not logged in → Show Login Screen
        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        // User is logged in - check email verification
        final user = snapshot.data!;
        
        if (!user.emailVerified) {
          // Email NOT verified → Show verification screen
          return EmailVerificationScreen(user: user);
        }

        // User is logged in AND email verified → Check biometric lock
        return AuthGateScreen(
          child: const EntryScreen(),
        );
      },
    );
  }
}



class EmailVerificationScreen extends StatefulWidget {
  final User user;
  const EmailVerificationScreen({super.key, required this.user});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isResendingEmail = false;
  bool _isCheckingVerification = false;
  Timer? _timer;
  int _countdown = 0;

  @override
  void initState() {
    super.initState();
    // Auto-check verification status every 3 seconds
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkEmailVerified();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    if (_isCheckingVerification) return;

    setState(() {
      _isCheckingVerification = true;
    });

    try {
      await widget.user.reload();
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null && user.emailVerified) {
        // Email is verified! The StreamBuilder will automatically redirect
        _timer?.cancel();
      }
    } catch (e) {
      // Handle error silently for auto-check
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingVerification = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_countdown > 0 || _isResendingEmail) return;

    setState(() {
      _isResendingEmail = true;
    });

    try {
      await widget.user.sendEmailVerification();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Verification email sent! Check your inbox.'),
            backgroundColor: Colors.green.shade600,
            duration: const Duration(seconds: 4),
          ),
        );

        // Start 60-second countdown
        setState(() {
          _countdown = 60;
        });

        Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_countdown > 0) {
            setState(() {
              _countdown--;
            });
          } else {
            timer.cancel();
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending email: ${e.toString()}'),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResendingEmail = false;
        });
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // StreamBuilder will automatically redirect to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bgcolor,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white70),
            label: const Text(
              'Logout',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Email icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                const Text(
                  'Verify Your Email',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                // Email address
                Text(
                  widget.user.email ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Description
                const Text(
                  'We\'ve sent a verification email to your address. Please check your inbox and spam folder, then click the verification link.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Auto-checking indicator
                if (_isCheckingVerification)
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Checking verification status...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),

                // Resend email button
                ElevatedButton.icon(
                  onPressed: _countdown > 0 || _isResendingEmail
                      ? null
                      : _resendVerificationEmail,
                  icon: _isResendingEmail
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.email),
                  label: Text(
                    _countdown > 0
                        ? 'Resend in ${_countdown}s'
                        : _isResendingEmail
                            ? 'Sending...'
                            : 'Resend Verification Email',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Manual check button
                OutlinedButton.icon(
                  onPressed: _isCheckingVerification ? null : _checkEmailVerified,
                  icon: const Icon(Icons.refresh),
                  label: const Text('I\'ve Verified, Check Now'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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