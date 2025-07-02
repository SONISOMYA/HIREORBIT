import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hireorbit/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    _initApp();
  }

  Future<void> _initApp() async {
    await Provider.of<AuthProvider>(context, listen: false).loadToken();
    final token = Provider.of<AuthProvider>(context, listen: false).token;

    await Future.delayed(const Duration(seconds: 2));

    if (token != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1F5),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'HireOrbit',
            style: GoogleFonts.nunito(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.deepPurple,
            ),
          ),
        ),
      ),
    );
  }
}