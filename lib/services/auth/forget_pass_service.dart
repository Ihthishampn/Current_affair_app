// // services/auth/forget_password_service.dart
// import 'package:firebase_auth/firebase_auth.dart';

// class ForgetPasswordService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<String?> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email.trim());
//       return null; // success → no message
//     } on FirebaseAuthException catch (e) {
//       switch (e.code) {
//         case 'invalid-email':
//           return 'Enter a valid email address.';
//         case 'user-not-found':
//           return 'No account exists with this email.';
//         case 'network-request-failed':
//           return 'No internet connection.';
//         default:
//           return 'Failed to send reset link. Try again.';
//       }
//     } catch (_) {
//       return 'Something went wrong. Try again.';
//     }
//   }

//   Future<bool> isValidEmail(String email) async {
//     try {
//       final signInMethods =
//           await _auth.fetchSignInMethodsForEmail(email.trim());
//       return signInMethods.isNotEmpty;
//     } on FirebaseAuthException catch (e) {
//       // Don't swallow all errors blindly.
//       if (e.code == 'invalid-email') return false;
//       rethrow; // Real unexpected error → let caller handle
//     }
//   }
// }
