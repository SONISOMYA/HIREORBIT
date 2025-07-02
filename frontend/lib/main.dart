import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hireorbit/core/services/job_service.dart';
import 'package:hireorbit/providers/job_provider.dart';
import 'package:hireorbit/providers/auth_provider.dart';
import 'package:hireorbit/routes/app_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved JWT if any
  final prefs = await SharedPreferences.getInstance();
  final savedToken = prefs.getString('jwt');

  runApp(MyApp(savedToken: savedToken));
}

class MyApp extends StatelessWidget {
  final String? savedToken;

  const MyApp({super.key, this.savedToken});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..token = savedToken,
        ),
        ChangeNotifierProvider(
          create: (_) => JobProvider(
            service: JobService(jwt: savedToken ?? ''),
            jwt: savedToken ?? '',
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HireOrbit',
        theme: _buildAppTheme(),
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: '/splash', // ✅ ALWAYS start at splash!
      ),
    );
  }

  ThemeData _buildAppTheme() {
    final base = ThemeData.light(useMaterial3: true);

    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF5E35B1),
      ),
      scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      textTheme: GoogleFonts.nunitoTextTheme(),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5E35B1),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }
}
