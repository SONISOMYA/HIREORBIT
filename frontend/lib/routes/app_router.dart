import 'package:flutter/material.dart';
import 'package:hireorbit/features/auth/screens/home_screen.dart';
import 'package:hireorbit/features/auth/screens/login_screen.dart';
import 'package:hireorbit/features/auth/screens/signUpScreen.dart';
import 'package:hireorbit/features/auth/screens/splashScreen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/':
      default:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
    }
  }
}
