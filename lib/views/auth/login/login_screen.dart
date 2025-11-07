import 'package:current_affairs/views/auth/login/widgets/forgetPass_button.dart';
import 'package:current_affairs/views/auth/login/widgets/login_button.dart';
import 'package:current_affairs/views/auth/login/widgets/newHereRow.dart';
import 'package:current_affairs/views/auth/login/widgets/passwoed_textField_custom.dart';
import 'package:current_affairs/views/auth/login/widgets/textField_custom.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    passController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;
    final double horizontalPadding = isSmallScreen ? 24 : size.width * 0.23;
    final double verticalSpacing = size.height * 0.02;

    return Scaffold(
      backgroundColor: const Color.fromARGB(
        255,
        42,
        42,
        42,
      ), // Instagram-like solid black background
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome message
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 28 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Login to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: verticalSpacing * 2),

              // Form container
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Dark card color
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // email
                    TextfieldCustomEmail(email: emailController,),
                    SizedBox(height: verticalSpacing),
                    // password
                    PasswordTextfieldCustom(pass: passController,),
                    SizedBox(height: verticalSpacing * 0.7),
                    // forget pass button
                    ForgetpassButton(),
                    SizedBox(height: verticalSpacing),
                    // login
                    LoginButton(emailc: emailController, passc: passController),
                    SizedBox(height: verticalSpacing * 1.2),
                  ],
                ),
              ),
              SizedBox(height: verticalSpacing * 1.4),
              //new here row
              Newhererow(),
              SizedBox(height: verticalSpacing),
            ],
          ),
        ),
      ),
    );
  }
}
