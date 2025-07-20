import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserManagementScreen extends StatelessWidget {
  final String adminId;

  const UserManagementScreen({Key? key, required this.adminId}) : super(key: key);

  Future<List<String>> fetchAllowedUserIds() async {
    final doc = await FirebaseFirestore.instance.collection('admin').doc(adminId).get();
    final data = doc.data();
    if (data == null) return [];
    final ids = (data['userID'] as List<dynamic>? ?? []).map((e) => e.toString()).toList();
    return List<String>.from(ids);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchAllowedUserIds(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final allowedUserIds = snapshot.data!;
        if (allowedUserIds.isEmpty) {
          return Center(
            child: Text(
              "No assigned users.",
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 18),
            ),
          );
        }

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where(FieldPath.documentId, whereIn: allowedUserIds)
              .snapshots(),
          builder: (context, userSnap) {
            if (!userSnap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final docs = userSnap.data!.docs;
            if (docs.isEmpty) {
              return Center(
                child: Text(
                  "No users to display.",
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                ),
              );
            }
            return Container(
              color: const Color(0xFF1B1B2F),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final data = docs[index].data() as Map<String, dynamic>? ?? {};
                  final status = data['status'];

                  IconData statusIcon;
                  Color iconColor;
                  bool isActive;
                  if (status == 'active' || status == true) {
                    statusIcon = Icons.check_circle;
                    iconColor = Colors.green;
                    isActive = true;
                  } else if (status == 'inactive' || status == false) {
                    statusIcon = Icons.block;
                    iconColor = Colors.redAccent;
                    isActive = false;
                  } else {
                    statusIcon = Icons.help_outline;
                    iconColor = Colors.grey;
                    isActive = false;
                  }

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
                        data['username'] ?? 'Unknown',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                      subtitle: Text(
                        data['email'] ?? 'No email',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          statusIcon,
                          color: iconColor,
                          size: 26,
                        ),
                        tooltip: isActive ? 'Ban User' : 'Unban User',
                        onPressed: () async {
                          final action = isActive ? 'ban' : 'unban';
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: const Color(0xFF22223b),
                              title: Text(
                                isActive ? 'Ban User?' : 'Unban User?',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              content: Text(
                                "Are you sure you want to $action this user?",
                                style: GoogleFonts.poppins(color: Colors.white70),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(
                                    "Cancel",
                                    style: GoogleFonts.poppins(color: Colors.grey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(
                                    "Okay",
                                    style: GoogleFonts.poppins(color: Colors.tealAccent),
                                  ),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(docs[index].id)
                                .update({'status': isActive ? 'inactive' : 'active'});
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
