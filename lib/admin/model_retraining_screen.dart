import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ModelRetrainingScreen extends StatelessWidget {
  const ModelRetrainingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "🤖 Model Retraining Panel",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Trigger model updates to improve predictions using newly collected user data."
                  " This action will initiate model training in the background.",
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add retraining logic or API trigger here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Model retraining initiated!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                icon: const Icon(Icons.model_training),
                label: const Text("Retrain Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.white24),
            const SizedBox(height: 20),
            Text(
              "🕒 Last Retrained",
              style: GoogleFonts.poppins(color: Colors.white70, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "10 July 2025 - 4:15 PM",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
