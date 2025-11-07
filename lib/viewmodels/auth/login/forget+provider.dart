// // viewmodels/auth/forget_password_provider.dart
// import 'package:current_affairs/services/auth/forget_pass_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ForgetPasswordProvider extends ChangeNotifier {
//   final ForgetPasswordService _service = ForgetPasswordService();

//   bool _isLoading = false;
//   bool _isSuccess = false;
//   String _error = '';
//   String _email = '';

//   bool get isLoading => _isLoading;
//   bool get isSuccess => _isSuccess;
//   String get error => _error;
//   String get email => _email;

//   Future<void> sendResetEmail(String email) async {
//     if (_isLoading) return;

//     _isLoading = true;
//     _error = '';
//     _isSuccess = false;
//     _email = email.trim();
//     notifyListeners();

//     try {
//       // Validate email format
//       if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_email)) {
//         _error = 'Please enter a valid email address';
//         _isLoading = false;
//         notifyListeners();
//         return;
//       }

//       await _service.sendPasswordResetEmail(_email);
//       _isSuccess = true;
//       _error = '';
//     } on FirebaseAuthException catch (e) {
//       _isSuccess = false;
//       switch (e.code) {
//         case 'user-not-found':
//           _error = 'No account found with this email address. Please check your email or create a new account.';
//           break;
//         case 'invalid-email':
//           _error = 'Please enter a valid email address (e.g., yourname@example.com).';
//           break;
//         case 'network-request-failed':
//           _error = 'Unable to connect to our servers. Please check your internet connection.';
//           break;
//         case 'too-many-requests':
//           _error = 'We\'ve received too many requests. Please wait a few minutes and try again.';
//           break;
//         default:
//           _error = 'We\'re having trouble sending the reset email. Please try again later.';
//       }
//     } catch (e) {
//       _isSuccess = false;
//       _error = 'Something went wrong. Please check your connection and try again.';
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }

//   void resetState() {
//     _isLoading = false;
//     _isSuccess = false;
//     _error = '';
//     notifyListeners();
//   }
// }