import 'package:current_affairs/views/auth/widgets/old_acc_row.dart';
import 'package:current_affairs/views/auth/widgets/sign_up_button.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 600;
    final double horizontalPadding = isSmallScreen ? 24 : size.width * 0.23;
    final double verticalSpacing = size.height * 0.02;

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1C),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalSpacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome header
                Text(
                  'Welcome',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign Up to start learning current affairs',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: verticalSpacing * 2),

                // Form container
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        type: TextInputType.name,
                        controller: nameController,
                        label: 'Username',
                        hint: 'Enter your username',
                        icon: Icons.person_outline,
                      ),
                      SizedBox(height: verticalSpacing),
                      _buildTextField(
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.email_outlined,
                      ),
                      SizedBox(height: verticalSpacing),
                      _buildTextField(
                        type: TextInputType.visiblePassword,
                        controller: passController,
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.lock_outline,
                        obscureText: true,
                      ),
                      SizedBox(height: verticalSpacing * 1.2),
                      // sign up
                      SignUpButton(
                        emailc: emailController,
                        passc: passController,
                        namec: nameController,
                      ),
                      SizedBox(height: verticalSpacing),
                    ],
                  ),
                ),

                SizedBox(height: verticalSpacing * 1.5),
                // old acc login
                OldAccRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Reusable TextField builder
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType type,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      keyboardType: type,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepPurpleAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
