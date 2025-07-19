import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Help Center"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.support_agent, size: 70, color: Colors.tealAccent),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'How can we help you?',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),

            _sectionTitle("📌 Frequently Asked Questions"),
            _faqItem("How to add a transaction?", "Tap on the '+' icon on the Home screen and fill out the form."),
            _faqItem("How to edit or delete a transaction?", "Go to Home, swipe left on the transaction, and select edit or delete."),
            _faqItem("Can I export my data?", "Yes, go to Profile > Export Expenditures to generate a PDF report."),

            const SizedBox(height: 30),
            _sectionTitle("📞 Contact Us"),
            _infoRow(Icons.email, "support@spendify.com"),
            _infoRow(Icons.phone, "+91 98765 43210"),
            _infoRow(Icons.location_on, "Darshan University, Rajkot"),

            const SizedBox(height: 30),
            _sectionTitle("⚙️ Troubleshooting"),
            _faqItem("App not responding?", "Try restarting the app or clearing the app cache."),
            _faqItem("Still facing issues?", "Email us or use the Report Issue option below."),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                icon: const Icon(Icons.bug_report_outlined),
                label: const Text("Report an Issue"),
                onPressed: () {
                  // Implement navigation or form here
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: GoogleFonts.poppins(
      color: Colors.tealAccent,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  Widget _faqItem(String question, String answer) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            )),
        const SizedBox(height: 4),
        Text(answer,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 13,
            )),
      ],
    ),
  );

  Widget _infoRow(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.tealAccent, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(color: Colors.white70),
          ),
        ),
      ],
    ),
  );
}
