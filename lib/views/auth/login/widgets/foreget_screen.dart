import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailC = TextEditingController();
  bool isLoading = false;

  void showMsg(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

 Future<void> resetPassword() async {
  final email = emailC.text.trim();

  if (email.isEmpty) {
    showMsg("Enter your email.");
    return;
  }

  // confirmation dialog
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      title: const Text("Confirm Reset", style: TextStyle(color: Colors.white)),
      content: Text(
        "We will send a password reset link to:\n\n$email\n\nMake sure you have signed up with this email in this app.\nAlso check SPAM/Inbox after sending.",
        style: const TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Send", style: TextStyle(color: Colors.greenAccent)),
        ),
      ],
    ),
  );

  if (confirm != true) return;

  setState(() => isLoading = true);

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showMsg("Reset link sent. Check Inbox or SPAM.", success: true);
    emailC.clear();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        showMsg("This email is not registered.");
        break;
      case 'invalid-email':
        showMsg("Invalid email format.");
        break;
      default:
        showMsg("Failed. Try again.");
    }
  } finally {
    setState(() => isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Reset Password",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter your email and we'll send you a reset link.",
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 25),

            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: emailC,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email Address",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.mail_rounded, color: Colors.white),
                filled: true,
                fillColor: Colors.white.withOpacity(0.08),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.deepPurpleAccent,
                    width: 2,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : resetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            "Send Reset Link",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 15),

const Text(
  "Note: After sending, check Inbox or Spam folder.\nEmail comes from Firebase system mail.",
  textAlign: TextAlign.center,
  style: TextStyle(
    color: Colors.white38,
    fontSize: 13,
  ),
),

          ],
        ),
      ),
    );
  }
}
