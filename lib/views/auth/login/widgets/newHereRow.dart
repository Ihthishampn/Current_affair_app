import 'package:current_affairs/views/auth/signUp/sign_screen.dart';
import 'package:flutter/material.dart';

class Newhererow extends StatelessWidget {
  const Newhererow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'New here? ',
          style: TextStyle(
            color: const Color.fromARGB(255, 236, 237, 237).withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const SignUpScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
          ),
          child: Text(
            'Sign up',
            style: TextStyle(
              color: Colors.deepPurpleAccent,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
