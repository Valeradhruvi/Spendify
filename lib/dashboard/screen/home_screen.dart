import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spendify/transaction/add_transaction.dart';
import 'package:spendify/model/transaction_model.dart';

class HomeScreen extends StatefulWidget {

   const HomeScreen({super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];

  void _navigateAndAddTransaction() async {
    final newTransaction = await Navigator.push<Transaction>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (newTransaction != null) {
      setState(() {
        transactions.insert(0, newTransaction);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text("Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {
            Navigator.pushNamed(context, '/notificationscreen');
          }),
          IconButton(icon: const Icon(Icons.upload_file), onPressed: () {
            Navigator.pushNamed(context, '/banksyncscreen');
          }),
          IconButton(icon: const Icon(Icons.admin_panel_settings), onPressed: () {
            Navigator.pushNamed(context, '/admindashboard');
          })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateAndAddTransaction,
        backgroundColor: const Color(0xFF00ADB5),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back!",
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 20)),
            Text("Your Expense Overview",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildCard(
                icon: Icons.account_balance_wallet,
                label: 'Total Balance',
                amount: '₹12,500'),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                    child: _buildMiniCard(
                        'Income', '₹8,000', Icons.arrow_downward, Colors.green)),
                const SizedBox(width: 10),
                Expanded(
                    child: _buildMiniCard('Expenses', '₹5,000',
                        Icons.arrow_upward, Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 30),
            Text("Recent Transactions",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Expanded(
              child: transactions.isEmpty
                  ? Center(
                  child: Text("No transactions yet",
                      style: GoogleFonts.poppins(color: Colors.white54)))
                  : ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final icon = tx.type == 'Expense'
                      ? Icons.remove
                      : Icons.add;
                  final color = tx.type == 'Expense'
                      ? Colors.redAccent
                      : Colors.green;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(tx.title, style: GoogleFonts.poppins(color: Colors.white)),
                    subtitle: Text(
                      '${tx.category} • ${tx.paymentMethod} • ${tx.date.toLocal().toString().split(" ")[0]}',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                          onPressed: () async {
                            final updatedTx = await Navigator.push<Transaction>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionScreen(transaction: tx),
                              ),
                            );
                            if (updatedTx != null) {
                              setState(() {
                                transactions[index] = updatedTx;
                              });
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF1B1B2F),
                                  title: const Text("Delete Transaction", style: TextStyle(color: Colors.white)),
                                  content: const Text("Are you sure you want to delete this transaction?", style: TextStyle(color: Colors.white70)),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                    TextButton(
                                      child: const Text("Yes", style: TextStyle(color: Colors.redAccent)),
                                      onPressed: () {
                                        setState(() {
                                          transactions.removeAt(index);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required IconData icon,
        required String label,
        required String amount}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: const Color(0xFF162447),
          borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
            Text(amount,
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20))
          ])
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildMiniCard(
      String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF162447),
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(title,
              style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
          Text(amount,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
