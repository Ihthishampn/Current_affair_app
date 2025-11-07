import 'package:current_affairs/services/local_auth_services/local_authServices.dart';
import 'package:current_affairs/views/profile/aboutApp/about_app_screen.dart';
import 'package:current_affairs/views/profile/privacy_screen/privacy_screen.dart';
import 'package:flutter/material.dart';
import 'package:current_affairs/core/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreens extends StatefulWidget {
  const ProfileScreens({super.key});

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens> {
  final LocalAuthService _authService = LocalAuthService();
  bool _isAuthEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final isEnabled = await _authService.isAuthEnabled();
    final isAvailable = await _authService.isBiometricAvailable();
    setState(() {
      _isAuthEnabled = isEnabled;
      _isBiometricAvailable = isAvailable;
      _isLoading = false;
    });
  }

  Future<void> _toggleAuth(bool value) async {
    if (value) {
      // Enabling auth - authenticate first
      final authenticated = await _authService.authenticate();
      if (authenticated) {
        await _authService.enableAuth();
        setState(() {
          _isAuthEnabled = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App lock enabled successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Disabling auth - authenticate first to confirm
      final authenticated = await _authService.authenticate();
      if (authenticated) {
        await _authService.disableAuth();
        setState(() {
          _isAuthEnabled = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('App lock disabled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Authentication failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _sendEmail() async {
    final String email = 'ihthishampno19@gmail.com';
    final String subject = 'Feature Request / Message';
    final String body = 'Hi Ihthisham,\n\nI would like to suggest...';

    final Uri emailLaunchUri = Uri.parse(
      'mailto:$email?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      final canLaunch = await canLaunchUrl(emailLaunchUri);
      if (canLaunch) {
        final launched = await launchUrl(
          emailLaunchUri,
          mode: LaunchMode.externalApplication,
        );

        if (!launched && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open email app'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No email app found. Please install an email app.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const primary1 = Color(0xFF2196F3);
    const primary2 = Color(0xFF64B5F6);

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        backgroundColor: AppColors.bgcolor,
        surfaceTintColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primary1))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Header
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          shape: BoxShape.rectangle,
                          gradient: LinearGradient(
                            colors: [primary1, primary2],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height:
                              MediaQuery.of(context).size.height *
                              0.10, // 25% of screen height
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/generated-image__1_-removebg-preview.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ihthisham Pno',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ihthisham@example.com',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  // App Lock Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.lock_outline, color: primary1),
                      title: const Text(
                        'App Lock',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      subtitle: Text(
                        _isBiometricAvailable
                            ? 'Use biometric or PIN to secure app'
                            : 'Biometric not available on device',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      trailing: Switch(
                        value: _isAuthEnabled,
                        onChanged: _isBiometricAvailable ? _toggleAuth : null,
                        activeColor: primary1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Send Message
                  _buildTile(
                    Icons.message_outlined,
                    'Send Message / Request Feature',
                    onTap: _sendEmail,
                  ),
                  const SizedBox(height: 16),

                  // About & Privacy (with gradient background)
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primary1, primary2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: primary2.withOpacity(0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const AboutAppScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },

                          Icons.info_outline,
                          'About App',
                          showDivider: true,
                          isInsideColoredCard: true,
                        ),
                        _buildTile(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) =>
                                    const PrivacyScreen(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },

                          Icons.privacy_tip_outlined,
                          'Privacy Policy',
                          isInsideColoredCard: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upgrade Section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primary1, primary2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: primary2.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upgrade to Premium',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Unlock all features and updates.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primary1,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Upgrade'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // helper for tile
  Widget _buildTile(
    IconData icon,
    String title, {
    bool showDivider = false,
    bool isInsideColoredCard = false,
    VoidCallback? onTap,
  }) {
    const primary = Color(0xFF2196F3);
    final tile = ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isInsideColoredCard ? Colors.white : primary),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: isInsideColoredCard ? Colors.white : Colors.white,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: isInsideColoredCard ? Colors.white70 : Colors.white70,
      ),
    );

    return Column(
      children: [
        tile,
        if (showDivider)
          Divider(
            height: 0,
            color: Colors.white.withOpacity(0.3),
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
