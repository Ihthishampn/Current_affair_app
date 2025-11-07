import 'package:current_affairs/views/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class OldAccRow extends StatelessWidget {
  const OldAccRow({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    TextButton(
                      onPressed: () {
 Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const LoginScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );},
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
  }
}