

import 'dart:async';

import 'package:current_affairs/core/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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