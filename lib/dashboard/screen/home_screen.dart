import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:spendify/functions/database_fucntions.dart';
import 'package:spendify/transaction/add_transaction.dart';
import 'package:spendify/transaction/transaction_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String uid = '101'; // Replace with dynamic user ID if needed

  void _showEditTransactionDialog({
    required String docId,
    required Map<String, dynamic> data,
  }) {
    final titleController = TextEditingController(text: data['title'] ?? '');
    final amountController = TextEditingController(text: data['amount'].toString());
    final noteController = TextEditingController(text: data['note'] ?? '');
    final categoryController = TextEditingController(text: data['category'] ?? '');
    final paymentMethodController = TextEditingController(text: data['paymentMethod'] ?? '');

    String selectedType = data['type'] ?? 'Expense';
    DateTime selectedDate = (data['date'] is Timestamp)
        ? (data['date'] as Timestamp).toDate()
        : DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: const Color(0xFF222244),
          elevation: 16,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.fromLTRB(24, 22, 24, 8),
          title: Row(
            children: [
              const Icon(Icons.edit_note, color: Color(0xFF00ADB5)),
              const SizedBox(width: 8),
              const Text(
                "Edit Transaction",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _DialogField(
                  icon: Icons.title,
                  controller: titleController,
                  label: "Title",
                  hint: "Transaction title",
                ),
                const SizedBox(height: 12),
                _DialogField(
                  icon: Icons.attach_money,
                  controller: amountController,
                  label: "Amount",
                  hint: "₹0.00",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                _DialogField(
                  icon: Icons.category,
                  controller: categoryController,
                  label: "Category",
                  hint: "Category",
                ),
                const SizedBox(height: 12),
                _DialogField(
                  icon: Icons.account_balance_wallet,
                  controller: paymentMethodController,
                  label: "Payment Method",
                  hint: "e.g. Cash, Card",
                ),
                const SizedBox(height: 12),
                _DialogField(
                  icon: Icons.sticky_note_2_outlined,
                  controller: noteController,
                  label: "Note",
                  hint: "Optional note",
                  maxLines: 2,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.date_range, color: Colors.white70, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "${selectedDate.year.toString().padLeft(4, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_calendar, color: Color(0xFF00ADB5)),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                          builder: (context, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                  primary: Color(0xFF00ADB5),
                                  onPrimary: Colors.white,
                                  surface: Color(0xFF222244)
                              ),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) setState(() => selectedDate = picked);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                // This goes inside your AlertDialog's content (e.g., in the Column)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Type:", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
                    Row(
                      children: [
                        Flexible(
                          child: RadioListTile<String>(
                            value: 'Income',
                            groupValue: selectedType,
                            onChanged: (val) {
                              if (val != null) setState(() => selectedType = val);
                            },
                            title: const Text(
                              "Income",
                              style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                            ),
                            activeColor: Colors.greenAccent,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                        Flexible(
                          child: RadioListTile<String>(
                            value: 'Expense',
                            groupValue: selectedType,
                            onChanged: (val) {
                              if (val != null) setState(() => selectedType = val);
                            },
                            title: const Text(
                              "Expense",
                              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                            ),
                            activeColor: Colors.redAccent,
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00ADB5),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 1,
              ),
              onPressed: () async {
                // Optional: Input validation for empty title or invalid amount
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Title cannot be empty'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }
                if (double.tryParse(amountController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                  return;
                }

                try {
                  await updateTransaction(
                    uid,
                    docId,
                    {
                      "title": titleController.text.trim(),
                      "amount": double.tryParse(amountController.text) ?? 0.0,
                      "note": noteController.text.trim(),
                      "category": categoryController.text.trim(),
                      "paymentMethod": paymentMethodController.text.trim(),
                      "date": selectedDate,
                      "type": selectedType,
                    },
                  );
                  Navigator.pop(context); // Close the dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Transaction updated!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Handles [cloud_firestore/not-found] or any other update error
                  print(e);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Update failed: $e'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },

              label: const Text("Save", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }




  void _navigateAndAddTransaction() async {
    final newTransaction = await Navigator.push<Transactions>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );

    if (newTransaction != null) {
      setState(() {}); // Rebuilds StreamBuilder
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
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {})
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome Back!",
                style:
                GoogleFonts.poppins(color: Colors.white70, fontSize: 15)),
            Text("Your Expense Overview",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            /// 👇 Total Income from users collection & Expenses from transactions
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .snapshots(),
              builder: (context, userSnapshot) {
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return const CircularProgressIndicator();
                }

                final userData =
                userSnapshot.data!.data() as Map<String, dynamic>;
                var income = (userData['income'] ?? 0);
                 var expense = (userData['spending'] ?? 0);

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .collection('transaction')
                      .snapshots(),
                  builder: (context, txSnapshot) {
                    if (!txSnapshot.hasData) {
                      return const CircularProgressIndicator();
                    }


                    for (var doc in txSnapshot.data!.docs) {
                      final tx = doc.data() as Map<String, dynamic>;
                      final amount =
                          int.tryParse(tx['amount'].toString()) ?? 0;
                      final type = tx['type'] ?? 'Expense';

                      if (type == 'Expense') {
                        expense += amount;
                      }
                    }

                    final balance = income - expense;

                    return Column(
                      children: [
                        _buildCard(
                          icon: Icons.account_balance_wallet,
                          label: 'Total Balance',
                          amount: '₹${balance.toStringAsFixed(2)}',
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniCard(
                                'Income',
                                '₹${income.toStringAsFixed(2)}',
                                Icons.arrow_downward,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildMiniCard(
                                'Expenses',
                                '₹${expense.toStringAsFixed(2)}',
                                Icons.arrow_upward,
                                Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            Text("Recent Transactions",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            /// 👇 Recent Transactions List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc('101') // replace with dynamic uid if needed
                    .collection('transaction')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: Text("No transactions yet",
                            style: GoogleFonts.poppins(color: Colors.white54)));
                  }

                  final transactions = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final doc = transactions[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final txTitle = data['title'] ?? '';
                      final txType = data['type'] ?? 'Expense';
                      final txCategory = data['category'] ?? '';
                      final txPayment = data['paymentMethod'] ?? '';
                      final txDate = (data['date'] as Timestamp).toDate();

                      final icon = txType == 'Expense'
                          ? Icons.remove
                          : Icons.add;
                      final color = txType == 'Expense'
                          ? Colors.redAccent
                          : Colors.green;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: color.withOpacity(0.2),
                          child: Icon(icon, color: color),
                        ),
                        title: Text(txTitle,
                            style: GoogleFonts.poppins(color: Colors.white)),
                        subtitle: Text(
                          '$txCategory • $txPayment • ${txDate.toLocal().toString().split(" ")[0]}',
                          style: GoogleFonts.poppins(
                              color: Colors.white70, fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white70, size: 20),
                              onPressed: () {
                                _showEditTransactionDialog(docId: doc.id, data: data);
                              }
                              ,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: const Color(0xFF23233A),
                                      elevation: 16,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                                      contentPadding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
                                      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                                      title: Row(
                                        children: [
                                          const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 30),
                                          const SizedBox(width: 12),
                                          const Text(
                                            "Delete Transaction",
                                            style: TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 19,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.fromLTRB(8.0,18,8,18),
                                        child: Text(
                                          "Are you sure you want to delete this transaction?",
                                          style: const TextStyle(color: Colors.white70, fontSize: 15),
                                        ),
                                      ),


                                      actions: [
                                        TextButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          icon: const Icon(Icons.close, color: Colors.white54),
                                          label: const Text("Cancel", style: TextStyle(color: Colors.white54)),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white70,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () async {
                                            await deleteTransaction('101', doc.id);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Transaction deleted'),
                                                backgroundColor: Colors.redAccent,
                                              ),
                                            );
                                          },
                                          icon: const Icon(Icons.delete_forever, color: Colors.white),
                                          label: const Text("Delete", style: TextStyle(fontWeight: FontWeight.bold)),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            elevation: 2,
                                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },

                            ),

                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildCard({
    required IconData icon,
    required String label,
    required String amount,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF162447),
        borderRadius: BorderRadius.circular(18),
      ),
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
                    fontSize: 20)),
          ]),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildMiniCard(
      String title,
      String amount,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF162447),
        borderRadius: BorderRadius.circular(16),
      ),
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

class _DialogField extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final int maxLines;
  const _DialogField({
    required this.icon,
    required this.controller,
    required this.label,
    this.hint = '',
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Color(0xFF00ADB5)),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(color: Colors.white70),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00ADB5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF00ADB5), width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
