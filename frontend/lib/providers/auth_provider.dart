import 'package:flutter/material.dart';
import 'package:hireorbit/core/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  String? token;

  Future<bool> login(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(username, password);
      if (result != null) {
        token = result;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt', token!);

        return true;
      } else {
        return false;
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String username, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final success = await _authService.register(username, password);
      return success;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt');
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('jwt');
    notifyListeners();
  }
}
