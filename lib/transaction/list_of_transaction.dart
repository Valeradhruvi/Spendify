import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TransactionListScreen extends StatelessWidget {
  final List<Map<String, dynamic>> transactions = [
    {
      'title': 'Groceries',
      'amount': 1200,
      'category': 'Food',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'paymentMethod': 'Card'
    },
    {
      'title': 'Uber Ride',
      'amount': 350,
      'category': 'Transport',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'paymentMethod': 'UPI'
    },
    {
      'title': 'Netflix',
      'amount': 499,
      'category': 'Subscription',
      'date': DateTime.now().subtract(const Duration(days: 5)),
      'paymentMethod': 'Card'
    },
  ];

  TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text('💵 Transactions'),
      ),
      body: transactions.isEmpty
          ? Center(
        child: Text(
          "No transactions available",
          style: GoogleFonts.poppins(color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final tx = transactions[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF162447),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long, color: Colors.white70, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tx['title'],
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${tx['category']} • ${tx['paymentMethod']}",
                        style: GoogleFonts.poppins(color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('dd MMM yyyy').format(tx['date']),
                        style: GoogleFonts.poppins(color: Colors.white38, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "- ₹${tx['amount']}",
                      style: GoogleFonts.poppins(color: Colors.redAccent, fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                          onPressed: () {
                            // Navigate to Edit
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            // Delete Logic
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}