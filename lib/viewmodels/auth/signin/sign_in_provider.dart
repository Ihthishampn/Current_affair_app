import 'package:current_affairs/services/auth/sign_up_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class SignInProvider extends ChangeNotifier {
  final SignUpServices _services = SignUpServices();

  bool isLoading = false;
  bool success = false;
  String error = '';

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    isLoading = true;
    success = false;
    error = '';
    notifyListeners();

    try {
      await _services.signUp(name: name, email: email, password: password);
      success = true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          error = 'This email is already registered.';
          break;
        case 'weak-password':
          error = 'The password is too weak.';
          break;
        case 'invalid-email':
          error = 'Invalid email address.';
          break;
        case 'operation-not-allowed':
          error = 'Email/password accounts are not enabled.';
          break;
        case 'network-request-failed':
          error = 'Network error. Check your connection.';
          break;
        case 'too-many-requests':
          error = 'Too many attempts. Try again later.';
          break;
        default:
          error = 'Authentication failed. Please try again.';
          success = false;
      }
    } catch (e) {
      error = 'An unexpected error occurred. Please try again.';
      success = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Resend verification email
  Future<void> resendVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }
}
