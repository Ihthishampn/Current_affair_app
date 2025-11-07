import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Future<String> _getVersion() async {
    final info = await PackageInfo.fromPlatform();
    return "Version ${info.version}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder(
          future: _getVersion(),
          builder: (context, snap) {
            final version = snap.data ?? '';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),

                  const Text(
                    "This app for preparing them for future who need "
                    "daily updated current affairs and focused practice questions "
                    "with revision , bookmarking support and set reminders on time.",
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    "Core Features",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("• current affairs "),
                  const Text("• Learn and revise with structured Q&A"),
                  const Text("• Bookmark questions for quick revision"),
                  const Text("• Create and add your own questions"),
                  const Text(
                    "• Quiz mode (use own questions or Book Mark questions)",
                  ),
                  const Text("• Set study reminders to stay consistent"),
                  const Text("• Offline reading support"),
                  const Text("• Secure app lock feature"),
                  const Text("• Mark upcoming tasks to avoid missing topics"),

                  const SizedBox(height: 28),
                  const Text(
                    "Premium Feature",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "• Refresh Current Affairs: Access latest and instant updates "
                    "for users who want more frequent and extended coverage.",
                    style: TextStyle(height: 1.4),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    "Note: Premium subscription unlocks all advanced features and full access.",
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                  ),

                  const SizedBox(height: 28),
                  const Text(
                    "Contact & Support",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("For feedback or issues:"),
                  const Text(
                    "Use the 'Send Message/Request Feature' option in your profile page",
                  ),

                  const SizedBox(height: 28),
                  Center(
                    child: Text(version, style: const TextStyle(fontSize: 14)),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: const Text(
                      "Developed by Ihthisham",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
