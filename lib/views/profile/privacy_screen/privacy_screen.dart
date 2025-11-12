import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Your privacy is important to us. We never collect personal data unless you provide it voluntarily. "
              "We only collect minimal usage data to improve app functionality and your experience.",
              style: TextStyle(fontSize: 17, height: 1.5),
            ),

            const SizedBox(height: 20),
            _sectionTitle("Data Usage"),
            _bullet("Usage data to improve the app experience"),
            _bullet("Device information for compatibility and performance"),
            _bullet(
              "Quiz attempts and bookmarks to enhance personalized learning",
            ),

            const SizedBox(height: 20),
            _sectionTitle("Permissions"),
            _bullet("Notifications to remind you about tasks, and updates"),
            _bullet("Storage access only if you save content offline"),
            _bullet("Camera or microphone: not used in this app"),

            const SizedBox(height: 20),
            _sectionTitle("Sharing Data"),
            _bullet("We do not share your personal data with any third party"),
            _bullet("Anonymous analytics may be collected to improve features"),

            const SizedBox(height: 20),
            _sectionTitle("Premium Features"),
            _bullet(
              "Premium subscription allows advanced features like frequent question refresh, exclusive quizzes, and ad-free experience",
            ),
            _bullet("All core learning features remain free for everyone"),

            const SizedBox(height: 20),
            _sectionTitle("Data Retention"),
            _bullet(
              "We keep usage data only as long as needed to provide the app services",
            ),
            _bullet("No personal data is retained without your consent"),

            const SizedBox(height: 20),
            _sectionTitle("User Rights"),
            _bullet(
              "You can contact us to request deletion of your personal data",
            ),
            _bullet("You can opt-out of notifications anytime"),

            const SizedBox(height: 20),
            _sectionTitle("Children"),
            const Text(
              "This app is intended for users above 13 years old. We do not knowingly collect personal data from children.",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),

            const SizedBox(height: 20),
            _sectionTitle("Updates to this Policy"),
            const Text(
              "We may update this privacy policy occasionally. "
              "Users will be notified in-app when major changes occur.",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),

            const SizedBox(height: 20),
            _sectionTitle("Contact"),
            const Text(
              "For questions or concerns regarding privacy, contact: ihthisham.dev@gmail.com",
              style: TextStyle(fontSize: 15, height: 1.4),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
