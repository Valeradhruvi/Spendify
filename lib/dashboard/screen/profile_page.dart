import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendify/dashboard/screen/edit_profile_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/about_us_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/feedback_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/help_center.dart';

import 'package:spendify/model/transaction_model.dart';
import 'package:spendify/user/auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Replace this with FirebaseAuth.instance.currentUser?.uid
  final String uid = '101';



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return const Center(child: CircularProgressIndicator());
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final userProfile = (
              username: userData['username'] ?? '',
              email: userData['email'] ?? '',
              isActive: userData['status'] == 'active',
              income: _asDouble(userData['income']),
              spending: _asDouble(userData['spending']),
              totalTransactions: userData['totalTransactions'] ?? 0,
              photoUrl: userData['photoUrl'],
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: userProfile.photoUrl != null &&
                            userProfile.photoUrl!.isNotEmpty
                            ? Image.network(
                          userProfile.photoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.black.withOpacity(0.7),
                          ),
                        )
                            : Icon(
                          Icons.person,
                          size: 100,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProfile.username,
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 20),
                      ),
                      Text(userProfile.email,
                          style:
                          GoogleFonts.poppins(color: Colors.white70)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 14),
                        decoration: BoxDecoration(
                          color: userProfile.isActive
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Account Status: ${userProfile.isActive ? "Active" : "Deactivated"}",
                          style: GoogleFonts.poppins(
                            color: userProfile.isActive
                                ? Colors.green
                                : Colors.redAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (userProfile.isActive)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfilePage(
                                  username: userProfile.username,
                                  email: userProfile.email,
                                  // To add image editing: pass photoUrl here and use it as the initial avatar.
                                ),
                              ),
                            );
                          },
                          child: const Text("Edit Profile",
                              style:
                              TextStyle(color: Color(0xFF00ADB5))),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                _buildSectionTitle("Spending & Income"),
                _buildTile(
                  "Total Income",
                  "₹${userProfile.income.toStringAsFixed(2)}",
                  Icons.arrow_downward,
                  Colors.green,
                ),
                _buildTile(
                  "Total Spending",
                  "₹${userProfile.spending.toStringAsFixed(2)}",
                  Icons.arrow_upward,
                  Colors.redAccent,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('transaction')
                      .snapshots(),
                  builder: (context, txSnapshot) {
                    final count = txSnapshot.hasData
                        ? txSnapshot.data!.docs.length
                        : 0;
                    return _buildTile("Total Transactions", "$count",
                        Icons.receipt_long, Colors.blueAccent);
                  },
                ),
                const SizedBox(height: 20),

                _buildSectionTitle("Preferences"),
                _buildTile(
                    "Theme", "Dark", Icons.dark_mode, Colors.amber),

                // Transaction Stream/PDF Export
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('transaction')
                      .orderBy('date', descending: true)
                      .snapshots(),
                  builder: (context, txSnapshot) {
                    final transactions = txSnapshot.data?.docs ?? [];
                    final txList = transactions.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Transactions(
                        title: data['title'] ?? '',
                        amount: data['amount'].toString(),
                        category: data['category'] ?? '',
                        date: (data['date'] as Timestamp).toDate(),
                        paymentMethod: data['paymentMethod'] ?? '',
                        type: data['type'] ?? '',
                        note: data['note'] ?? '',
                      );
                    }).toList();
                    return _buildTile(
                      "Export Expenditures (PDF)",
                      "",
                      Icons.picture_as_pdf,
                      Colors.tealAccent,
                      onTap: txList.isEmpty
                          ? null
                          : () => exportTransactionsAsPdf(txList),
                    );
                  },
                ),
                const SizedBox(height: 20),

                _buildSectionTitle("Support"),
                _buildTile("Feedback", "", Icons.feedback_outlined,
                    Colors.white70, onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FeedbackScreen()));
                    }),
                _buildTile("Help Center", "", Icons.help_outline,
                    Colors.white70, onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HelpCenterScreen()));
                    }),
                _buildTile("About This App", "", Icons.info_outline,
                    Colors.white70, onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AboutAppScreen()));
                    }),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                    onPressed: () {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: const Text(
                            "Logout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // deep purple/dark navy
                            ),
                          ),
                          content: const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 10),
                            child: Text(
                              "Are you sure you want to logout?",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          actions: [
                            CupertinoDialogAction(
                              isDestructiveAction: true,
                              child: const Text("YES"),
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              },
                            ),
                            CupertinoDialogAction(
                              isDefaultAction: true,
                              child: const Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Section title, bold and styled
  Widget _buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.poppins(
        color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
  );

  // List tile for profile sections
  Widget _buildTile(String title, String subtitle, IconData icon,
      Color iconColor,
      {VoidCallback? onTap}) =>
      ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
        subtitle: subtitle.isNotEmpty
            ? Text(subtitle,
            style: GoogleFonts.poppins(color: Colors.white70))
            : null,
        trailing: onTap != null
            ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24)
            : null,
        onTap: onTap,
      );

  Future<void> exportTransactionsAsPdf(List<Transactions> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text(
            'Expenditure Report',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Date', 'Title', 'Category', 'Amount'],
            data: transactions.map((tx) {
              return [
                "${tx.date.day.toString().padLeft(2, '0')}/${tx.date.month.toString().padLeft(2, '0')}/${tx.date.year}",
                tx.title ?? '',
                tx.category ?? '',
                'Rs. ${tx.amount.toString()}',
              ];
            }).toList(),
            headerStyle:
            pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellPadding:
            const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.center,
              3: pw.Alignment.centerRight,
            },
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

// Helper for safe double numeric conversion
double _asDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is int) return val.toDouble();
  if (val is double) return val;
  return double.tryParse(val.toString()) ?? 0.0;
}
