// LoginButton.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/noti_model_firebase_login/noti_loigin_firebase_model.dart';
import 'package:current_affairs/viewmodels/auth/login/login_provider.dart';
import 'package:current_affairs/views/authCheckSreen/authCheckScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginButton extends StatelessWidget {
  final TextEditingController emailc;
  final TextEditingController passc;
  const LoginButton({super.key, required this.emailc, required this.passc});

  void _showSuccessMessage(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Welcome! Signing you in...'),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 5),
        action: message.contains('verify') || message.contains('Verify')
            ? SnackBarAction(
                label: 'Resend Email',
                textColor: Colors.white,
                onPressed: () => _resendVerification(context),
              )
            : null,
      ),
    );
  }

  void _showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue.shade600,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _resendVerification(BuildContext context) async {
    final provider = Provider.of<LoginProvider>(context, listen: false);
    await provider.resendVerification();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Verification email sent! Please check your inbox.'),
        backgroundColor: Colors.green.shade600,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        return ElevatedButton(
          onPressed: provider.isLoading
              ? null
              : () async {
                  final email = emailc.text.trim();
                  final pass = passc.text.trim();

                  // Basic validation with friendly messages
                  if (email.isEmpty || pass.isEmpty) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showInfoMessage(
                        context, 'Please fill in both email and password fields to continue.');
                    return;
                  }

                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showInfoMessage(context,
                        'Please enter a valid email address (e.g., yourname@example.com).');
                    return;
                  }

                  if (pass.length < 6) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showInfoMessage(context,
                        'Password should be at least 6 characters long for your security.');
                    return;
                  }

                  // Show loading indicator
                  _showInfoMessage(context, 'Signing you in...');

                  // Perform login
                  await provider.loginHandle(email: email, pass: pass,model: NotiLoiginFirebaseModel(title: 'Welcome,You’re Logged In', isRead: false, time: Timestamp.now()));

                  // Check result AFTER login completes
                  if (provider.success) {
                    // Success - email is verified
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showSuccessMessage(context);
                    
                    // Navigate after a short delay
                    Future.delayed(const Duration(milliseconds: 200), () {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(        
                          MaterialPageRoute(builder: (_) => const AuthCheckScreen()),
                        );
                      }
                    });
                  } else if (provider.error.isNotEmpty) {
                    // Error occurred (including unverified email)
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    _showErrorMessage(context, provider.error);
                    provider.clearError();
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
          ),
          child: provider.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    letterSpacing: 0.5,
                  ),
                ),
        );
      },
    );
  }
}