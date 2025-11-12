import 'package:current_affairs/models/noti_model_firebase_login/noti_loigin_firebase_model.dart';
import 'package:current_affairs/services/auth/login_services.dart';
import 'package:current_affairs/services/login_firebase_notification.dart/login_firebase_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final LoginServices _loginServices = LoginServices();
  final LoginFirebaseNotificationServices _loginFirebaseNotificationServices =
      LoginFirebaseNotificationServices();

  bool isLoading = false;
  bool success = false;
  String error = '';

  Future<void> loginHandle({
    required NotiLoiginFirebaseModel model,
    required String email,
    required String pass,
  }) async {
    if (isLoading) return;

    isLoading = true;
    error = '';
    success = false;
    notifyListeners();

    try {
      final userCredential = await _loginServices.login(
        email: email,
        pass: pass,
      );

      final user = userCredential.user;

      if (user == null) {
        success = false;
        error = 'Login failed. Try again.';
      } else {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null && updatedUser.emailVerified) {
          success = true;
          error = '';

          // noti
          await _loginFirebaseNotificationServices.loginNotificationAdd(model);
        } else {
          await FirebaseAuth.instance.signOut();
          success = false;
          error =
              'Please verify your email before logging in. Check your inbox or spam folder.';
        }
      }
    } on FirebaseAuthException catch (e) {
      success = false;

      if (e.code == 'invalid-credential' || e.code == 'wrong-password') {
        error =
            'Email or password is incorrect. If you are new, please sign up.';
      } else {
        switch (e.code) {
          case 'invalid-email':
            error = 'Enter a valid email address.';
            break;
          case 'user-disabled':
            error = 'This account is disabled.';
            break;
          case 'user-not-found':
            error = 'No account found with this email. Please sign up.';
            break;
          case 'too-many-requests':
            error = 'Too many attempts. Please wait and try again.';
            break;
          case 'network-request-failed':
            error = 'Network error. Check your connection.';
            break;
          default:
            error = 'Login failed: ${e.message ?? 'Try again.'}';
        }
      }
    } catch (e) {
      success = false;
      error = 'Unexpected error. Try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
      } catch (e) {
        error = 'Could not send verification email.';
        notifyListeners();
      }
    }
  }

  void clearError() {
    error = '';
    notifyListeners();
  }
}
