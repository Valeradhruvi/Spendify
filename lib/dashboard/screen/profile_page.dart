import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:spendify/dashboard/screen/profileScreens/about_us_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/feedback_screen.dart';
import 'package:spendify/dashboard/screen/profileScreens/help_center.dart';
import 'package:spendify/model/user_model.dart';
import 'package:spendify/model/transaction_model.dart';
import 'package:spendify/user/auth/login_screen.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final UserProfile user = UserProfile(
    username: 'Dharvi',
    email: 'dh@gmail.com',
    isActive: true,
    income: 100000,
    spending: 5000,
    totalTransactions: 3,
  );

  final List<Transaction> transactions = [
    Transaction(
      title: "Groceries",
      amount: 250,
      category: "Food",
      date: DateTime.now(),
      paymentMethod: "Cash",
      type: "Expense",
      note: "Milk and Bread",
    ),
    Transaction(
      title: "Salary",
      amount: 50000,
      category: "Income",
      date: DateTime.now().subtract(const Duration(days: 5)),
      paymentMethod: "Bank",
      type: "Income",
      note: "Monthly salary",
    ),
    Transaction(
      title: "Electricity Bill",
      amount: 1000,
      category: "Utilities",
      date: DateTime.now().subtract(const Duration(days: 3)),
      paymentMethod: "UPI",
      type: "Expense",
      note: "July bill",
    ),
  ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    // backgroundImage: AssetImage('assets/images/default_user.png'),
                  ),
                  const SizedBox(height: 10),
                  Text(user.username, style: GoogleFonts.poppins(color: Colors.white, fontSize: 20)),
                  Text(user.email, style: GoogleFonts.poppins(color: Colors.white70)),
                  const SizedBox(height: 10),

                  // Highlighted Account Status
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      color: user.isActive ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Account Status: ${user.isActive ? "Active" : "Deactivated"}",
                      style: GoogleFonts.poppins(
                        color: user.isActive ? Colors.green : Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (user.isActive)
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/editprofile');
                      },
                      child: const Text("Edit Profile", style: TextStyle(color: Color(0xFF00ADB5))),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildSectionTitle("Spending & Income"),
            _buildTile("Total Income", "₹${user.income}", Icons.arrow_downward, Colors.green),
            _buildTile("Total Spending", "₹${user.spending}", Icons.arrow_upward, Colors.redAccent),
            _buildTile("Total Transactions", "${user.totalTransactions}", Icons.receipt_long, Colors.blueAccent),

            const SizedBox(height: 20),
            _buildSectionTitle("Preferences"),
            _buildTile("Theme", "Dark", Icons.dark_mode, Colors.amber),

            _buildTile("Export Expenditures (PDF)", "", Icons.picture_as_pdf, Colors.tealAccent,
                onTap: () => exportTransactionsAsPdf(transactions)),

            const SizedBox(height: 20),
            _buildSectionTitle("Support"),
            _buildTile("Feedback", "", Icons.feedback_outlined, Colors.white70,onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const FeedbackScreen()),);
            }),
            _buildTile("Help Center", "", Icons.help_outline, Colors.white70,onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HelpCenterScreen()),);
            }),
            _buildTile("About This App", "", Icons.info_outline, Colors.white70, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const AboutAppScreen()),);
            },),

            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()),);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
  );

  Widget _buildTile(String title, String subtitle, IconData icon, Color iconColor, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: GoogleFonts.poppins(color: Colors.white70)) : null,
      trailing: onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white24) : null,
      onTap: onTap,
    );
  }

  Future<void> exportTransactionsAsPdf(List<Transaction> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          pw.Text('Expenditure Report', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: ['Date', 'Title', 'Category', 'Amount'],
            data: transactions.map((tx) {
              return [
                "${tx.date.day}/${tx.date.month}/${tx.date.year}",
                tx.title,
                tx.category,
                '${tx.amount.toStringAsFixed(2)}'
              ];
            }).toList(),
            headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellPadding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 4),
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