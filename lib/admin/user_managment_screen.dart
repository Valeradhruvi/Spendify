import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> users = [
      {'name': 'Dharvi', 'email': 'dharvi@example.com', 'status': true},
      {'name': 'Ravi', 'email': 'ravi@example.com', 'status': true},
      {'name': 'Priya', 'email': 'priya@example.com', 'status': false},
    ];

    return Container(
      color: const Color(0xFF1B1B2F),
      child: ListView.builder(
        itemCount: users.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final user = users[index];
          final bool isActive = user['status'] ?? false;
          final statusColor = isActive ? Colors.green : Colors.redAccent;

          return Card(
            color: const Color(0xFF162447),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.tealAccent.withOpacity(0.3),
                child: const Icon(Icons.person, color: Colors.tealAccent),
              ),
              title: Text(
                user['name'] ?? 'Unknown',
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              subtitle: Text(
                user['email'] ?? 'No email',
                style: GoogleFonts.poppins(color: Colors.white70),
              ),
              trailing: IconButton(
                icon: Icon(
                  isActive ? Icons.block : Icons.check_circle,
                  color: isActive ? Colors.red : Colors.green,
                ),
                tooltip: isActive ? 'Deactivate' : 'Activate',
                onPressed: () {
                  // Toggle user status logic
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
