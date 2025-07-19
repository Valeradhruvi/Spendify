class Transaction {
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod;
  final String type; // 'Income' or 'Expense'
  final String? note;

  Transaction({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    required this.type,
    this.note,
  });
}
