import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addTransaction(Transactions transaction) async {
    final User? user = _auth.currentUser;

    if (user == null) throw Exception("User not logged in");

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('transactions')
        .add(transaction.toMap());
  }
}
