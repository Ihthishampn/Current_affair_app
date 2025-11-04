import 'package:current_affairs/viewmodels/navigationPrvider/navProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Navprovider>(
        builder: (context, value, child) => value.widgets[value.currentIndex],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(color: Colors.black),
        child: GNav(
          selectedIndex: Provider.of<Navprovider>(
            context,
            listen: false,
          ).currentIndex,
          onTabChange: (value) => Provider.of<Navprovider>(
            context,
            listen: false,
          ).changeIndexNavigation(value),
          color: const Color.fromARGB(255, 165, 164, 164),
          activeColor: Color.fromARGB(255, 255, 255, 255),
          rippleColor: Color.fromARGB(255, 36, 36, 37),
          tabBorderRadius: 10,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          tabs: const [
            GButton(
              key: Key('Affairs'),
              icon: Icons.newspaper,
              text: 'Affairs',
            ),
            GButton(
              key: Key('Book Mark'),

              icon: Icons.download_rounded,
              text: 'Book Mark',
            ),
            GButton(
              key: Key('Task'),

              icon: Icons.task,
              text: 'Task Manager',
            ),
            GButton(key: Key('Profile'), icon: Icons.settings, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
