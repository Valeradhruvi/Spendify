import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/dashboard/screen/data/feedback_repository.dart';


class FeedbackDashboardScreen extends StatefulWidget {
  const FeedbackDashboardScreen({super.key});

  @override
  State<FeedbackDashboardScreen> createState() => _FeedbackDashboardScreenState();
}

class _FeedbackDashboardScreenState extends State<FeedbackDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final feedbacks = FeedbackRepository.feedbacks;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      body: feedbacks.isEmpty
          ? const Center(
          child: Text("No feedback submitted yet.",
              style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: feedbacks.length,
        itemBuilder: (context, index) {
          final feedback = feedbacks[index];
          final timestamp = feedback['timestamp'] as DateTime;
          final formattedTime =
              "${timestamp.day}/${timestamp.month}/${timestamp.year} - ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";

          return Card(
            color: const Color(0xFF162447),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.tealAccent),
                      const SizedBox(width: 8),
                      Text(
                        feedback['userId']?.toString() ?? 'N/A',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(Icons.star,
                          color: Colors.amberAccent, size: 20),
                      const SizedBox(width: 4),
                      Text('${feedback['rating']}/5',
                          style: GoogleFonts.poppins(
                              color: Colors.white70)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    feedback['message']?.toString() ?? '',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      formattedTime,
                      style: GoogleFonts.poppins(
                          color: Colors.white30, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
