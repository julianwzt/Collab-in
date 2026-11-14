import 'package:flutter/material.dart';
import 'package:collabin/core/common/app_navigator.dart';
import 'package:collabin/core/common/shared_code.dart';
import 'package:collabin/feature/auth/login/login_screen.dart';

class AuthSessionManager {
  AuthSessionManager._();

  static final AuthSessionManager instance = AuthSessionManager._();

  final SharedCode _sharedCode = SharedCode();
  bool _isLoggingOut = false;

  Future<void> forceLogout() async {
    if (_isLoggingOut) {
      return;
    }

    _isLoggingOut = true;
    try {
      await _sharedCode.clearAuthSession();
      final navigator = appNavigatorKey.currentState;
      if (navigator == null) {
        return;
      }

      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } finally {
      _isLoggingOut = false;
    }
  }
}

