class Transactions {
  final String title;
  final String amount;
  final String category;
  final DateTime date;
  final String note;
  final String type;
  final String paymentMethod;

  Transactions({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    required this.note,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'note': note,
      'paymentMethod': paymentMethod,
    };
  }
}
