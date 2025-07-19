import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// createData(String collName, docName, username, email, password) async {
//   await FirebaseFirestore.instance
//       .collection(collName)
//       .doc(docName)
//       .set(
//       {'username': username,'email':email, 'password': password , 'income' : '0' , 'spending' : '0' , 'status' : 'active' , 'theme' : 'dark' , 'photoUrl' : ''});
//
//   print('Database Updated');
// }
//
// updateData(String collName, docName, field, var newFieldValue) async {
//   await FirebaseFirestore.instance
//       .collection(collName)
//       .doc(docName)
//       .update({field: newFieldValue});
//   print('Fields Updated');
// }
//
// deleteData(String collName, docName) async {
//   await FirebaseFirestore.instance.collection(collName).doc(docName).delete();
//   print('Document Deleted');
// }

Future<void> createData(String collName, String docName, String username, String email, String password) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).set({
    'username': username,
    'email': email,
    'password': password,
    'income': '0',
    'spending': '0',
    'status': 'active',
    'theme': 'dark',
    'photoUrl': ''
  });
  print('Database Updated');
}

Future<void> updateData(String collName, String docName, String field, dynamic newFieldValue) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).update({field: newFieldValue});
  print('Fields Updated');
}

Future<void> deleteData(String collName, String docName) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).delete();
  print('Document Deleted');
}

Future<void> createTransactionData({
  required String userId,
  required String title,
  required String amount,
  required String category,
  required DateTime date,
  required String type,
  required String note,
  required String paymentMethod,
}) async {
  FirebaseFirestore.instance
      .collection('users')
      .doc('101')
      .collection('transaction').add({
    'title': title,
    'amount': double.tryParse(amount) ?? 0.0,
    'category': category,
    'date': date,
    'type': type,
    'note': note,
    'paymentMethod': paymentMethod,
    'timestamp': FieldValue.serverTimestamp(),
  });

  print("::::::::::::::::: Success :::::::::::::::::::");
}

Future<void> updateTransaction(String userId, String docId, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('transaction')
      .doc(docId)
      .update(data);
}



Future<void> deleteTransaction(String userId, String transactionId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('transaction')
      .doc(transactionId)
      .delete();
  print('Transaction Deleted');
}
