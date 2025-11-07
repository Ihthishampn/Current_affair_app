import 'package:current_affairs/views/auth/login/widgets/foreget_screen.dart';
import 'package:flutter/material.dart';

class ForgetpassButton extends StatelessWidget {
  const ForgetpassButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const ForgetPasswordScreen
                                    (),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );},
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
        ),
        child: Text(
          'Forgot Password?',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
