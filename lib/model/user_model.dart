class UserProfile {
  final String username;
  final String email;
  final bool isActive;
  final double income;
  final double spending;
  final int totalTransactions;

  UserProfile({
    required this.username,
    required this.email,
    required this.isActive,
    required this.income,
    required this.spending,
    required this.totalTransactions,
  });
}