import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1B1B2F), Color(0xFF162447)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon or Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(color: Colors.white30, width: 2),
              ),
              child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 50),
            ).animate().scale(duration: 1000.ms).fadeIn(),

            const SizedBox(height: 30),

            Text(
              "Finance Optimizer",
              style: GoogleFonts.poppins(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 10),

            Text(
              "Your AI-powered budget buddy",
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white70,
              ),
            ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 50),

            const CircularProgressIndicator(color: Color(0xFF00ADB5))
                .animate()
                .fadeIn(delay: 1000.ms),
          ],
        ),
      ),
    );
  }
}