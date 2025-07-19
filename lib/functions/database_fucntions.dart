import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

createData(String collName, docName, username, email, password) async {
  await FirebaseFirestore.instance
      .collection(collName)
      .doc(docName)
      .set(
      {'username': username,'email':email, 'password': password , 'income' : '0' , 'spending' : '0' , 'status' : 'active' , 'theme' : 'dark' , 'photoUrl' : ''});

  print('Database Updated');
}

updateData(String collName, docName, field, var newFieldValue) async {
  await FirebaseFirestore.instance
      .collection(collName)
      .doc(docName)
      .update({field: newFieldValue});
  print('Fields Updated');
}

deleteData(String collName, docName) async {
  await FirebaseFirestore.instance.collection(collName).doc(docName).delete();
  print('Document Deleted');
}