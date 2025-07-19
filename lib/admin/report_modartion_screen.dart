import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportModerationScreen extends StatelessWidget {
  const ReportModerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> reports = [
      {
        'title': 'Spam Report',
        'description': 'User reported suspicious income entry',
        'date': '2025-07-15',
      },
      {
        'title': 'Corrupt Upload',
        'description': 'AI report contains invalid data format',
        'date': '2025-07-14',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final report = reports[index];
          return Card(
            color: const Color(0xFF162447),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.warning_amber_rounded, color: Colors.amber),
              title: Text(
                report['title'] ?? '',
                style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report['description'] ?? '',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${report['date']}',
                    style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                onPressed: () {
                  // Implement delete logic
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
