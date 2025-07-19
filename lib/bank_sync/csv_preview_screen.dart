import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spendify/model/transaction_model.dart';

class CSVPreviewScreen extends StatelessWidget {
  final List<Transaction> parsedTransactions;
  final Function(List<Transaction>) onConfirmImport;

  const CSVPreviewScreen({
    super.key,
    required this.parsedTransactions,
    required this.onConfirmImport,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B2F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00ADB5),
        title: const Text('Preview Transactions'),
      ),
      body: Column(
        children: [
          Expanded(
            child: parsedTransactions.isEmpty
                ? Center(
              child: Text(
                'No transactions found',
                style: GoogleFonts.poppins(color: Colors.white54),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: parsedTransactions.length,
              itemBuilder: (context, index) {
                final tx = parsedTransactions[index];
                final icon = tx.type == 'Expense' ? Icons.remove : Icons.add;
                final color = tx.type == 'Expense' ? Colors.redAccent : Colors.green;

                return Card(
                  color: const Color(0xFF162447),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: color.withOpacity(0.2),
                      child: Icon(icon, color: color),
                    ),
                    title: Text(tx.title, style: GoogleFonts.poppins(color: Colors.white)),
                    subtitle: Text(
                      '${tx.category} • ${tx.paymentMethod} • ${tx.date.toLocal().toString().split(" ")[0]}',
                      style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                    ),
                    trailing: Text(
                      '₹${tx.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                          color: color, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00ADB5)),
                    onPressed: () {
                      onConfirmImport(parsedTransactions);
                      Navigator.pop(context); // You can navigate to summary screen here
                    },
                    child: const Text('Import'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}