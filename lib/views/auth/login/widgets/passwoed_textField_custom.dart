import 'package:flutter/material.dart';

class PasswordTextfieldCustom extends StatelessWidget {
  final TextEditingController pass;
  const PasswordTextfieldCustom({ required this.pass, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: pass,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(color: Colors.white70),
        hintText: 'Enter your password',
        hintStyle: TextStyle(color: Colors.white38),
        prefixIcon: Icon(Icons.lock_outline, color: Colors.white70),
        suffixIcon: Icon(Icons.visibility_outlined, color: Colors.white38),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
