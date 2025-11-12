import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/auth/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpServices {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final signUpData = SignUpModel(
        email: email,
        name: name,
        time: Timestamp.now(),
      );

      await _firebaseFirestore
          .collection('Users')
          .doc(uid)
          .set(signUpData.toFirebase());

      await userCredential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuth Error: $e');
      rethrow;
    } catch (e) {
      print('Unexpected Error: $e');
      rethrow;
    }
  }
}
