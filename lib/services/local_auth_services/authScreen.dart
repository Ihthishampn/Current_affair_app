

import 'package:current_affairs/core/colors.dart';
import 'package:current_affairs/services/local_auth_services/local_authServices.dart';
import 'package:flutter/material.dart';

class AuthGateScreen extends StatefulWidget {
  final Widget child;
  const AuthGateScreen({super.key, required this.child});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen>
    with WidgetsBindingObserver {
  final LocalAuthService _authService = LocalAuthService();
  bool _isAuthenticated = false;
  bool _isAuthRequired = false;
  bool _isLoading = true;
  bool _isAuthenticating = false;
  bool _hasAuthenticatedThisSession = false; 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkAuthStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Only re-authenticate when app truly goes to background and comes back
    if (state == AppLifecycleState.paused) {
      // App went to background - mark that we need to re-auth next time
      if (_isAuthRequired && _hasAuthenticatedThisSession) {
        setState(() {
          _hasAuthenticatedThisSession = false;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      // App came back to foreground
      if (_isAuthRequired && !_hasAuthenticatedThisSession && !_isAuthenticating) {
        setState(() {
          _isAuthenticated = false;
        });
      }
    }
  }

  Future<void> _checkAuthStatus() async {
    final isEnabled = await _authService.isAuthEnabled();
    
    if (mounted) {
      setState(() {
        _isAuthRequired = isEnabled;
        _isLoading = false;
      });
    }

    if (_isAuthRequired) {
      await _authenticate();
    } else {
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
          _hasAuthenticatedThisSession = true;
        });
      }
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final result = await _authService.authenticate();
      if (mounted) {
        setState(() {
          _isAuthenticated = result;
          _isAuthenticating = false;
          if (result) {
            _hasAuthenticatedThisSession = true;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.bgcolor,
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF2196F3)),
        ),
      );
    }

    if (!_isAuthRequired || _isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                    ),
                  ),
                  child: const Icon(
                    Icons.lock_outline,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Authentication Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Please authenticate to access the app',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: _isAuthenticating ? null : _authenticate,
                  icon: _isAuthenticating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.fingerprint),
                  label: Text(_isAuthenticating ? 'Authenticating...' : 'Authenticate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}