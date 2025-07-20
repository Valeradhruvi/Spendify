import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("About Spendify"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.account_balance_wallet_rounded, size: 80, color: Colors.tealAccent),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Spendify',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Version 1.0.0',
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'About the App',
              style: GoogleFonts.poppins(
                color: Colors.tealAccent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Spendify is a smart finance management app that helps you track your income, expenses, and savings. '
                  'Analyze your spending habits using visual charts, predict future expenses with ML models, and stay in control of your finances.',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Developed By',
              style: GoogleFonts.poppins(
                color: Colors.tealAccent,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Team Spendify\nGuided by: Prof. XYZ\nDarshan University',
              style: GoogleFonts.poppins(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Center(
              child: Text(
                '© 2025 Spendify. All rights reserved.',
                style: GoogleFonts.poppins(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
