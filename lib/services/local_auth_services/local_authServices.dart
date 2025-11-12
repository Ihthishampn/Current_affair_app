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

  //  if biometric is available on device
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable || isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  //  available biometric types
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






