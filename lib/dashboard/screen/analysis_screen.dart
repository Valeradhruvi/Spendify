// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:spendify/transaction/add_transaction.dart';
//
// class Transaction {
//   final String title;
//   final double amount;
//   final String category;
//   final DateTime date;
//   final String paymentMethod;
//   final String type;
//
//   Transaction({
//     required this.title,
//     required this.amount,
//     required this.category,
//     required this.date,
//     required this.paymentMethod,
//     required this.type,
//   });
// }
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<Transaction> transactions = [];
//
//   void _addTransaction(Transaction tx) {
//     setState(() {
//       transactions.insert(0, tx);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1B1B2F),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF00ADB5),
//         title: const Text("Dashboard"),
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => AddTransactionScreen(
//                     // isAccountActive: true,
//                     onTransactionSaved: _addTransaction,
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text("Welcome Back!",
//                 style: GoogleFonts.poppins(
//                   color: Colors.white70,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w400,
//                 )),
//             Text("Your Expense Overview",
//                 style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                 )),
//             const SizedBox(height: 30),
//             _buildCard(context,
//                 icon: Icons.account_balance_wallet,
//                 label: 'Total Balance',
//                 amount: '₹12,500'),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildMiniCard(
//                       context, 'Income', '₹8,000', Icons.arrow_downward, Colors.green),
//                 ),
//                 const SizedBox(width: 10),
//                 Expanded(
//                   child: _buildMiniCard(context, 'Expenses', '₹5,000',
//                       Icons.arrow_upward, Colors.redAccent),
//                 )
//               ],
//             ),
//             const SizedBox(height: 30),
//             Text("Recent Transactions",
//                 style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 18)),
//             const SizedBox(height: 10),
//             ...transactions.map((tx) => _buildTransactionTile(
//               tx.title,
//               "${tx.type == 'Expense' ? '-' : '+'} ₹${tx.amount.toStringAsFixed(2)}",
//               DateFormat('dd MMM').format(tx.date),
//               Icons.category,
//               tx.type == 'Expense' ? Colors.redAccent : Colors.green,
//             ))
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard(BuildContext context,
//       {required IconData icon,
//         required String label,
//         required String amount}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: const Color(0xFF162447),
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.white, size: 30),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(label,
//                   style:
//                   GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
//               Text(amount,
//                   style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold)),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMiniCard(BuildContext context, String title, String value,
//       IconData icon, Color iconColor) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: const Color(0xFF162447),
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, color: iconColor),
//           const SizedBox(height: 10),
//           Text(title,
//               style:
//               GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
//           Text(value,
//               style: GoogleFonts.poppins(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18))
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTransactionTile(String title, String amount, String date,
//       IconData icon, Color iconColor) {
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//       leading: CircleAvatar(
//         backgroundColor: iconColor.withOpacity(0.2),
//         child: Icon(icon, color: iconColor),
//       ),
//       title: Text(title, style: GoogleFonts.poppins(color: Colors.white)),
//       subtitle:
//       Text(date, style: GoogleFonts.poppins(color: Colors.white70)),
//       trailing: Text(amount,
//           style: GoogleFonts.poppins(
//               color:
//               amount.contains('-') ? Colors.redAccent : Colors.green,
//               fontWeight: FontWeight.bold)),
//     );
//   }
// }
//
// // AddTransactionScreen is already implemented in your previous code with form and callback logic.