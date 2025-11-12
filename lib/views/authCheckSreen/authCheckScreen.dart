
import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/entry/entry.dart';
import 'package:current_affairs/services/local_auth_services/authScreen.dart';
import 'package:current_affairs/services/local_auth_services/local_authServices.dart';
import 'package:current_affairs/views/auth/login/login_screen.dart';
import 'package:current_affairs/views/authCheckSreen/email_verification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheckScreen extends StatelessWidget {
  const AuthCheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.bgcolor,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF2196F3)),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }

        final user = snapshot.data!;
        
        if (!user.emailVerified) {
          return EmailVerificationScreen(user: user);
        }

        return AuthGateScreen(
          child: const EntryScreen(),
        );
      },
    );
  }
}

