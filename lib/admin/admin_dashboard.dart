import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spendify/admin/model_retraining_screen.dart';
import 'package:spendify/admin/report_modartion_screen.dart';
import 'package:spendify/admin/user_managment_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  final String adminDocId = 'A01'; // Use the correct docID from your 'admin' collection.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xFF1B1B2F),
            selectedIndex: _selectedIndex,
            onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
            labelType: NavigationRailLabelType.all,
            selectedLabelTextStyle: const TextStyle(color: Colors.tealAccent),
            unselectedLabelTextStyle: const TextStyle(color: Colors.white70),
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.admin_panel_settings, color: Colors.tealAccent, size: 30),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.people, color: Colors.white),
                selectedIcon: Icon(Icons.people, color: Colors.tealAccent),
                label: Text('Users'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback_outlined, color: Colors.white),
                selectedIcon: Icon(Icons.feedback_rounded, color: Colors.tealAccent),
                label: Text('Feedback'),
              ),

            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
          Expanded(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance.collection('admin').doc(adminDocId).get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.data!.exists) {
                  return const Center(child: Text("Admin not found", style: TextStyle(color: Colors.white)));
                }
                final List<String> allowedUserIds =
                (snapshot.data!.get('userID') as List<dynamic>? ?? [])
                    .map((e) => e.toString())
                    .toList();

                final List<Widget> _adminScreens = [
                  UserManagementScreen(adminId: adminDocId),
                  const FeedbackDashboardScreen(),

                ];
                final List<String> _titles = [
                  'User Management',
                  'Report Moderation',
                  'Model Retraining',
                ];

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: const Color(0xFF00ADB5),
                    title: Text(_titles[_selectedIndex]),
                  ),
                  backgroundColor: const Color(0xFF1B1B2F),
                  body: _adminScreens[_selectedIndex],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
