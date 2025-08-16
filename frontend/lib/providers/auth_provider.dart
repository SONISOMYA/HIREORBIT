import 'package:flutter/material.dart';
import 'package:hireorbit/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? token;
  String? email;

  /// Login function
  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      if (result != null) {
        token = result;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token!);

        email = await _authService.fetchEmail(token!);
        return true;
      } else {
        return false;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Register function
  Future<bool> register(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      return await _authService.register(username, password);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    token = null;
    email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    notifyListeners();
  }

  /// Load token on app start
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt');

    if (token != null) {
      email = await _authService.fetchEmail(token!);
    }

    notifyListeners();
  }
}