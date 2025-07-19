import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImportSummaryScreen extends StatelessWidget {
  final int totalParsed;
  final int recordsAdded;
  final int recordsSkipped;
  final int incomeCount;
  final int expenseCount;

  const ImportSummaryScreen({
    super.key,
    required this.totalParsed,
    required this.recordsAdded,
    required this.recordsSkipped,
    required this.incomeCount,
    required this.expenseCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Import Summary"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Icon(Icons.check_circle, color: Colors.greenAccent, size: 60),
            const SizedBox(height: 12),
            Text(
              "Import Completed!",
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            _buildSummaryTile("Total Rows Parsed", totalParsed, Icons.insert_drive_file, Colors.blueAccent),
            _buildSummaryTile("Records Added", recordsAdded, Icons.check, Colors.green),
            _buildSummaryTile("Records Skipped", recordsSkipped, Icons.cancel, Colors.redAccent),
            const SizedBox(height: 15),
            Divider(color: Colors.white30),
            _buildSummaryTile("Income Transactions", incomeCount, Icons.arrow_downward, Colors.green),
            _buildSummaryTile("Expense Transactions", expenseCount, Icons.arrow_upward, Colors.redAccent),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADB5),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.home),
              label: const Text("Back to Home"),
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst); // go to home
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String label, int value, IconData icon, Color iconColor) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(label, style: GoogleFonts.poppins(color: Colors.white)),
      trailing: Text(
        "$value",
        style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
      ),
    );
  }
}