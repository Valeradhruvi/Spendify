import 'package:firebase_auth/firebase_auth.dart';
int global_user_id=100;

// lib/helpers/user_helper.dart



class UserHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static String? get userId => _auth.currentUser?.uid;
}
