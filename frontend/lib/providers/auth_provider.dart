import 'package:flutter/material.dart';
import 'package:hireorbit/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? token;
  String? loggedInEmail;

  Future<bool> login(String username, String password, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      if (result != null) {
        token = result;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token!);

        /// ✅ fetch email
        loggedInEmail = await _authService.fetchEmail(token!);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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

  Future<void> logout() async {
    token = null;
    loggedInEmail = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt');

    if (token != null) {
      loggedInEmail = await _authService.fetchEmail(token!);
    }

    notifyListeners();
  }
}
