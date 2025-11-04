import 'package:flutter/material.dart';

class Savedandaddquscustumwidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color1;
  final Color color2;
  final Color shadowColor;
  final  GestureTapCallback onTap;
  const Savedandaddquscustumwidget({
    super.key,
      required this.onTap,
    required this.title,
    required this.icon,
    required this.color1,
    required this.color2,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(icon, color: Colors.white, size: 26),
          ],
        ),
      ),
    );
  }
}
