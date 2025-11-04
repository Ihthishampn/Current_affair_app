import 'package:current_affairs/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:local_auth_android/local_auth_android.dart';

class LocalAuthService {
  static final LocalAuthService _instance = LocalAuthService._internal();
  factory LocalAuthService() => _instance;
  LocalAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();
  static const String _authEnabledKey = 'app_lock_enabled';

  // Check if biometric is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable || isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate user
  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Authentication Required',
            cancelButton: 'Cancel',
          ),
         
        ],
      );
    } on PlatformException catch (e) {
      print('Authentication error: $e');
      return false;
    }
  }

  // Check if app lock is enabled
  Future<bool> isAuthEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_authEnabledKey) ?? false;
  }

  // Enable app lock
  Future<void> enableAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authEnabledKey, true);
  }

  // Disable app lock
  Future<void> disableAuth() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_authEnabledKey, false);
  }
}





// auth gate screen



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
  bool _hasAuthenticatedThisSession = false; // Track if authenticated in current session

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
        // Need to re-authenticate
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