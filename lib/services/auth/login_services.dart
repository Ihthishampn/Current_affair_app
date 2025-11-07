// services/auth/login_services.dart
import 'package:firebase_auth/firebase_auth.dart';

class LoginServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> login({required String email, required String pass}) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Optional: Add method to check current user verification status
  Future<bool> isEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }
}