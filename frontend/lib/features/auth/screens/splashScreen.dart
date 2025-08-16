import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hireorbit/providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Animation setup
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    // Initialize app after build completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initApp();
    });
  }

  Future<void> _initApp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Load token from SharedPreferences
      await authProvider.loadToken();
      final token = authProvider.token;
      print('Loaded token: $token'); // Debug

      // Keep splash screen visible for 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      // Navigate based on token
      if (token != null && token.isNotEmpty) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      // On error, navigate to login screen
      print('Error during splash init: $e');
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
