import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {
      "title": "Payment Successful",
      "subtitle": "₹500 paid for groceries",
      "time": "Just now"
    },
    {
      "title": "New Income Added",
      "subtitle": "₹8,000 salary credited",
      "time": "Today, 10:00 AM"
    },
    {
      "title": "Electricity Bill Paid",
      "subtitle": "₹900 debited from UPI",
      "time": "Yesterday"
    },
    {
      "title": "Budget Limit Reached",
      "subtitle": "You've reached 90% of your monthly budget",
      "time": "2 days ago"
    },
  ];

  NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: notifications.isEmpty
          ? Center(
        child: Text(
          "No notifications yet",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            color: const Color(0xFF162447),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              leading: const Icon(Icons.notifications, color: Color(0xFF00ADB5)),
              title: Text(
                item["title"] ?? '',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["subtitle"] ?? '',
                    style: GoogleFonts.poppins(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item["time"] ?? '',
                    style: GoogleFonts.poppins(
                      color: Colors.white38,
                      fontSize: 12,
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