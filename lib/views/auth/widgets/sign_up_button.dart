import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:current_affairs/models/noti_model_firebase_login/noti_loigin_firebase_model.dart';
import 'package:current_affairs/viewmodels/auth/signin/sign_in_provider.dart';
import 'package:current_affairs/views/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpButton extends StatelessWidget {
  final TextEditingController namec;
  final TextEditingController passc;
  final TextEditingController emailc;

  const SignUpButton({
    super.key,
    required this.namec,
    required this.passc,
    required this.emailc,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final name = namec.text.trim();
        final email = emailc.text.trim();
        final pass = passc.text.trim();
        final provider = Provider.of<SignInProvider>(context, listen: false);

        if (name.isEmpty || email.isEmpty || pass.isEmpty) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('All fields are required')));
          return;
        }

        await provider.signUp(
          name: name,
          email: email,
          password: pass,
          model: NotiLoiginFirebaseModel(
            title: 'Your account was created successfully',
            isRead: false,
            time: Timestamp.now(),
          ),
        );

        if (provider.success) {
          namec.clear();
          emailc.clear();
          passc.clear();

          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Signup complete! A verification email has been sent. '
                'Check your inbox or spam folder to activate your account.',
              ),
              duration: Duration(seconds: 7),
            ),
          );

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(provider.error)));
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.deepPurpleAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      child: Consumer<SignInProvider>(
        builder: (context, value, child) => value.isLoading
            ? const CircularProgressIndicator()
            : const Text(
                'Sign Up',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
