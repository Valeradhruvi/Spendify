import 'package:flutter/material.dart';
import 'package:spendify/admin/admin_feedback_screen.dart';
import 'package:spendify/admin/model_retraining_screen.dart';
import 'package:spendify/admin/report_modartion_screen.dart';
import 'package:spendify/admin/user_managment_screen.dart' show UserManagementScreen;


class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _adminScreens = [
    const UserManagementScreen(),
    const ReportModerationScreen(),
    const FeedbackDashboardScreen(),
    const ModelRetrainingScreen(),
  ];

  final List<String> _titles = [
    'User Management',
    'Report Moderation',
    'Feedback Dashboard',
    'Model Retraining'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xFF1B1B2F),
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
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
                icon: Icon(Icons.report_gmailerrorred, color: Colors.white),
                selectedIcon: Icon(Icons.report_gmailerrorred, color: Colors.tealAccent),
                label: Text('Reports'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.feedback, color: Colors.white),
                selectedIcon: Icon(Icons.feedback, color: Colors.tealAccent),
                label: Text('Feedback'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.model_training, color: Colors.white),
                selectedIcon: Icon(Icons.model_training, color: Colors.tealAccent),
                label: Text('Retrain'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1, color: Colors.white24),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xFF00ADB5),
                title: Text(_titles[_selectedIndex]),
              ),
              backgroundColor: const Color(0xFF1B1B2F),
              body: _adminScreens[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}
